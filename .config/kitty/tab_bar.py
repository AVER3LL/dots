# pyright: reportMissingImports=false
import datetime
import os

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
)

# Global timer for updating the time
timer_id = None
REFRESH_TIME = 60  # Update every minute since we only show HH:MM

# Colors
opts = get_options()
text_fg = as_rgb(int(opts.foreground))
text_bg = as_rgb(int(opts.background))


def _get_username():
    """Get the current username"""
    return os.getenv("USER", os.getenv("USERNAME", "user"))


def _get_tab_info_list():
    """Get tab information with styling details"""
    boss = get_boss()
    tab_manager = boss.active_tab_manager
    if not tab_manager:
        return []

    tab_info = []
    active_tab_id = tab_manager.active_tab.id if tab_manager.active_tab else None

    for tab in tab_manager.tabs:
        # Get the tab title, strip whitespace
        title = tab.title.strip()
        if not title:
            continue

        # Extract program name from various title formats
        program_name = _extract_program_name(title)
        if not program_name:
            continue

        # Check if this is the active tab
        is_active = tab.id == active_tab_id

        # Check if window is maximized
        is_maximized = _is_window_maximized(tab)

        tab_info.append(
            {
                "display_name": program_name,
                "is_active": is_active,
                "is_maximized": is_maximized,
            }
        )

    return tab_info


def _is_window_maximized(tab):
    """Check if there are splits and one window is maximized (stack layout focus)"""
    try:
        if not tab.active_window:
            return False

        # Get the number of windows in this tab
        windows = list(tab.windows)
        num_windows = len(windows)

        # Only show maximized icon if there are multiple windows (splits exist)
        if num_windows <= 1:
            return False

        # Check if the layout is 'stack' (which shows one window maximized over others)
        layout_name = (
            tab.current_layout.name if hasattr(tab, "current_layout") else None
        )

        # In stack layout, one window is "maximized" over the others
        if layout_name == "stack":
            return True

        # For other layouts with multiple windows, we could check if one window
        # takes up significantly more space than others, but this is complex
        # For now, we'll be conservative and only show for stack layout
        return False

    except Exception:
        return False


def _extract_program_name(title):
    """Extract just the program name from tab title"""
    # Handle common patterns:
    # "~/Documents/hello - fish" -> "fish"
    # "vim: filename" -> "vim"
    # "/path/to/file - nano" -> "nano"
    # "firefox" -> "firefox"

    # If title contains " - ", the program is likely after the dash
    if " - " in title:
        program = title.split(" - ")[-1].strip()
        if program:
            return program

    # If title contains ": ", the program is likely before the colon
    if ": " in title:
        program = title.split(": ")[0].strip()
        if program:
            return program

    # If title starts with a path, try to get the last part
    if title.startswith(("/", "~")):
        # Look for common shell indicators
        parts = title.split()
        for part in reversed(parts):
            # Common terminal programs
            if part in ["fish", "bash", "zsh", "sh", "tcsh", "csh"]:
                return part
            # Other common programs
            if not part.startswith(("/", "~")) and part not in ["-"]:
                return part

    # For simple cases, just return the first word
    first_word = title.split()[0] if title.split() else title

    # Remove common path prefixes
    if "/" in first_word:
        first_word = first_word.split("/")[-1]

    return first_word if first_word else "shell"


def _draw_left_status(screen: Screen):
    """Draw username on the left"""
    username = _get_username()
    left_text = f" {username} "

    screen.cursor.fg = text_fg
    screen.cursor.bg = text_bg
    screen.draw(left_text)
    return len(left_text)


def _draw_center_status(screen: Screen, left_length: int, right_length: int):
    """Draw all tab names in the center, separated by •"""
    boss = get_boss()
    tab_manager = boss.active_tab_manager
    if not tab_manager:
        return

    # Get tab info with styling info
    tab_info = _get_tab_info_list()
    if not tab_info:
        return

    # Calculate available space for center content
    available_space = screen.columns - left_length - right_length

    # Calculate total length needed (including separators)
    total_length = sum(len(info["display_name"]) for info in tab_info)
    total_length += len(" • ") * (len(tab_info) - 1)  # separators

    # Truncate if necessary
    if total_length > available_space - 2:  # -2 for padding
        # Simple truncation - could be made smarter
        available_for_names = available_space - 5 - (len(" • ") * (len(tab_info) - 1))
        if available_for_names > 0:
            # Truncate the longest names first
            while total_length > available_space - 2 and tab_info:
                # Remove last tab if still too long
                tab_info = tab_info[:-1]
                total_length = sum(len(info["display_name"]) for info in tab_info)
                total_length += (
                    len(" • ") * (len(tab_info) - 1) if len(tab_info) > 1 else 0
                )

    if not tab_info:
        return

    # Calculate padding to center the text
    actual_length = sum(len(info["display_name"]) for info in tab_info)
    actual_length += len(" • ") * (len(tab_info) - 1) if len(tab_info) > 1 else 0
    padding = max(0, (available_space - actual_length) // 2)

    # Move cursor to center position
    screen.cursor.x = left_length + padding

    # Draw each tab name with appropriate styling
    for i, info in enumerate(tab_info):
        if i > 0:
            # Draw separator
            screen.cursor.fg = text_fg
            screen.cursor.bg = text_bg
            screen.cursor.bold = False
            screen.draw(" • ")

        # Set styling for this tab
        if info["is_active"]:
            screen.cursor.fg = as_rgb(0x0066FF)  # Blue for active tab
            screen.cursor.bold = True
        else:
            screen.cursor.fg = text_fg  # Normal color for inactive tabs
            screen.cursor.bold = False

        screen.cursor.bg = text_bg

        # Draw the program name
        display_name = info["display_name"]
        if info["is_maximized"]:
            screen.draw("󰊓 " + display_name)
        else:
            screen.draw(display_name)


def _draw_right_status(screen: Screen):
    """Draw current time on the right side in HH:MM format"""
    now = datetime.datetime.now()
    time_str = now.strftime(" %H:%M ")

    # Position cursor at the right edge minus our content length
    screen.cursor.x = screen.columns - len(time_str)

    screen.cursor.fg = text_fg
    screen.cursor.bg = text_bg
    screen.draw(time_str)

    return len(time_str)


def _redraw_tab_bar(timer_id):
    """Force redraw of tab bar to update time"""
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Main function called by Kitty to draw each tab"""
    global timer_id

    # Set up timer for updating time (only once)
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    # Only draw our custom status bar on the last tab to avoid duplication
    if is_last:
        # Reset any formatting
        draw_attributed_string(Formatter.reset, screen)

        # Clear the entire tab bar line
        screen.cursor.x = 0
        screen.cursor.fg = text_fg
        screen.cursor.bg = text_bg
        screen.draw(" " * screen.columns)

        # Reset cursor to beginning
        screen.cursor.x = 0

        # Draw left status (username) and get its length
        left_length = _draw_left_status(screen)

        # Draw right status (time) and get its length
        right_length = _draw_right_status(screen)

        # Draw center status (tab names)
        _draw_center_status(screen, left_length, right_length)

        # Set cursor to end
        screen.cursor.x = screen.columns

    return screen.cursor.x
