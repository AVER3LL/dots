"""
Enhanced System Tray Icon Handling

This module provides enhanced icon loading capabilities for system tray items,
including fallback mechanisms for file paths and common icon locations.
"""

import os

from fabric.system_tray.widgets import SystemTray, SystemTrayItem
from gi.repository import GdkPixbuf, Gtk


def patched_do_update_properties(self, *_):
    # Try default GTK theme first
    icon_name = self._item.icon_name
    attention_icon_name = self._item.attention_icon_name

    if self._item.status == "NeedsAttention" and attention_icon_name:
        preferred_icon_name = attention_icon_name
    else:
        preferred_icon_name = icon_name

    # Try to load from default GTK theme
    if preferred_icon_name:
        try:
            default_theme = Gtk.IconTheme.get_default()
            if default_theme.has_icon(preferred_icon_name):
                pixbuf = default_theme.load_icon(
                    preferred_icon_name, self._icon_size, Gtk.IconLookupFlags.FORCE_SIZE
                )
                if pixbuf:
                    self._image.set_from_pixbuf(pixbuf)
                    # Set tooltip
                    tooltip = self._item.tooltip
                    self.set_tooltip_markup(
                        tooltip.description or tooltip.title or self._item.title.title()
                        if self._item.title
                        else "Unknown"
                    )
                    return
        except:
            pass

        # Enhanced fallback handling for file paths
        if preferred_icon_name and self._try_load_icon_from_path(preferred_icon_name):
            return

    # Fallback to original implementation
    _original_do_update_properties(self, *_)


def _try_load_icon_from_path(self, icon_path):
    try:
        # Check if it's a file path and handle it directly
        if os.path.isabs(icon_path) or "/" in icon_path:
            # Try to load as SVG from the original path if it exists
            if os.path.exists(icon_path):
                if icon_path.lower().endswith(".svg"):
                    # Load SVG directly
                    pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(
                        icon_path, self._icon_size, self._icon_size
                    )
                    if pixbuf:
                        self._image.set_from_pixbuf(pixbuf)
                        self._set_tooltip()
                        return True
                else:
                    # Load other image formats
                    pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(
                        icon_path, self._icon_size, self._icon_size
                    )
                    if pixbuf:
                        self._image.set_from_pixbuf(pixbuf)
                        self._set_tooltip()
                        return True

            # If it's a file path, try to extract just the filename for theme lookup
            filename = os.path.basename(icon_path)
            if filename:
                # Remove extension for theme lookup
                name_without_ext = os.path.splitext(filename)[0]
                default_theme = Gtk.IconTheme.get_default()

                # Try filename without extension
                if default_theme.has_icon(name_without_ext):
                    pixbuf = default_theme.load_icon(
                        name_without_ext,
                        self._icon_size,
                        Gtk.IconLookupFlags.FORCE_SIZE,
                    )
                    if pixbuf:
                        self._image.set_from_pixbuf(pixbuf)
                        self._set_tooltip()
                        return True

                # Try full filename
                if default_theme.has_icon(filename):
                    pixbuf = default_theme.load_icon(
                        filename, self._icon_size, Gtk.IconLookupFlags.FORCE_SIZE
                    )
                    if pixbuf:
                        self._image.set_from_pixbuf(pixbuf)
                        self._set_tooltip()
                        return True

            # If it looks like a file path but doesn't exist, try common icon locations
            if os.path.isabs(icon_path):
                common_icon_dirs = [
                    "/usr/share/icons",
                    "/usr/share/pixmaps",
                    "/usr/local/share/icons",
                    "/usr/local/share/pixmaps",
                    os.path.expanduser("~/.local/share/icons"),
                    os.path.expanduser("~/.icons"),
                ]

                filename = os.path.basename(icon_path)
                for icon_dir in common_icon_dirs:
                    potential_path = os.path.join(icon_dir, filename)
                    if os.path.exists(potential_path):
                        try:
                            pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(
                                potential_path, self._icon_size, self._icon_size
                            )
                            if pixbuf:
                                self._image.set_from_pixbuf(pixbuf)
                                self._set_tooltip()
                                return True
                        except:
                            continue

    except Exception:
        pass

    return False


def _set_tooltip(self):
    tooltip = self._item.tooltip
    self.set_tooltip_markup(
        tooltip.description or tooltip.title or self._item.title.title()
        if self._item.title
        else "Unknown"
    )


_patch_applied = False


def apply_enhanced_system_tray():
    global _patch_applied
    if _patch_applied:
        return

    # --- Store original methods ---
    global _original_do_update_properties, _original_item_init, _original_on_item_added
    _original_do_update_properties = SystemTrayItem.do_update_properties
    _original_item_init = SystemTrayItem.__init__
    _original_on_item_added = SystemTray.on_item_added

    # --- Create patched methods ---

    def on_item_changed(self, item):
        """Handles status changes to show/hide the item."""
        self.do_update_properties()  # Update icon and tooltip first
        if item.status == "Passive":
            self.set_visible(False)
        else:
            self.set_visible(True)

    def patched_item_init(self, item, icon_size, **kwargs):
        """Patched __init__ for SystemTrayItem."""
        _original_item_init(self, item, icon_size, **kwargs)
        self._item.connect("removed", self.destroy)
        self._item.connect("changed", self.on_item_changed)
        # Set initial visibility
        self.on_item_changed(self._item)

    def patched_on_item_added(self, service, identifier):
        """Patched on_item_added for SystemTray to prevent duplicates."""
        # Check if a widget for this item already exists
        for child in self.get_children():
            if hasattr(child, "_item") and child._item.identifier == identifier:
                return
        # If not, call the original method to add it
        _original_on_item_added(self, service, identifier)

    # --- Apply patches ---

    # Attach helper methods
    SystemTrayItem._try_load_icon_from_path = _try_load_icon_from_path
    SystemTrayItem._set_tooltip = _set_tooltip
    SystemTrayItem.on_item_changed = on_item_changed

    # Replace original methods with patched versions
    SystemTrayItem.do_update_properties = patched_do_update_properties
    SystemTrayItem.__init__ = patched_item_init
    SystemTray.on_item_added = patched_on_item_added

    _patch_applied = True


# Store reference to original method to prevent garbage collection
_original_do_update_properties = None
_original_item_init = None
_original_on_item_added = None

