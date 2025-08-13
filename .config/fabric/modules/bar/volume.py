import gi
from fabric.utils import cooldown
from fabric.widgets.box import Box
from fabric.widgets.circularprogressbar import CircularProgressBar
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
from fabric.widgets.revealer import Revealer

from services import audio_service
from utils.icons import text_icons
from utils.widget_container import EventBoxWidget
from utils.widget_utils import get_audio_icon_name, nerd_font_icon

gi.require_version("Gtk", "3.0")
from gi.repository import Gdk, GLib


class VolumeWidget(EventBoxWidget):
    """A widget that displays and controls the volume"""

    def __init__(self, **kwargs):
        super().__init__(
            name="volume",
            events=[
                "scroll",
                "smooth-scroll",
                "enter-notify-event",
                "leave-notify-event",
                "button-press-event",
            ],
            **kwargs,
        )

        self.audio = audio_service

        self.hover_timeout_id = None
        self.show_timeout_id = None
        self.is_hovered = False  # Track hover state explicitly

        self.volume_box = Box(orientation="horizontal", spacing=0)
        self.volume_box.get_style_context().add_class("volume-container")

        self.progress_bar = CircularProgressBar(
            style_classes="overlay-progress-bar",
            pie=True,
            size=24,
        )

        self.icon = nerd_font_icon(
            icon=text_icons["volume"]["medium"],
            props={"style_classes": "panel-font-icon overlay-icon"},
        )

        self.volume_label = Label(style_classes="volume-text")
        self.revealer = Revealer(
            child=self.volume_label,
            transition_type="slide-left",
            transition_duration=300,
        )
        self.volume_box.add(self.revealer)

        # Create an event box to handle scroll events for volume control
        overlay = Overlay(child=self.progress_bar, overlays=self.icon, name="overlay")
        self.volume_box.add(overlay)

        self.box.add(self.volume_box)

        # Connect the audio service to update the progress bar on volume change
        self.audio.connect("notify::speaker", self.on_speaker_changed)

        # Connect the event box to handle scroll events
        self.connect("scroll-event", self.on_scroll)

        # Connect the event box to handle click event
        self.connect("button-press-event", self.on_click)

        # Show on hover and set timeout
        self.connect("enter-notify-event", self.on_hover)
        self.connect("leave-notify-event", self.on_leave)

    def show_label_and_class(self):
        """Shows the label and adds the hovered class."""
        if self.is_hovered:  # Only show if still hovered
            self.volume_box.get_style_context().add_class("hovered")
            self.revealer.set_reveal_child(True)
        self.show_timeout_id = None
        return False

    def on_hover(self, widget, event):
        """Set the label to visible after a delay."""
        if event.detail == Gdk.NotifyType.INFERIOR:
            return

        self.is_hovered = True

        # Cancel any pending hide operation
        if self.hover_timeout_id:
            GLib.source_remove(self.hover_timeout_id)
            self.hover_timeout_id = None

        # If already showing or about to show, don't create another timeout
        if self.revealer.get_reveal_child():
            return

        if self.show_timeout_id:
            return

        self.show_timeout_id = GLib.timeout_add(150, self.show_label_and_class)

    def on_leave(self, widget, event):
        """Hide the label after 500ms."""
        if event.detail == Gdk.NotifyType.INFERIOR:
            return

        self.is_hovered = False

        # Cancel any pending show operation
        if self.show_timeout_id:
            GLib.source_remove(self.show_timeout_id)
            self.show_timeout_id = None

        # If not visible or already hiding, don't create another timeout
        if not self.revealer.get_reveal_child():
            return

        if self.hover_timeout_id:
            return

        self.hover_timeout_id = GLib.timeout_add(500, self.hide_label)

    def hide_label(self):
        """Hide the label and remove the hovered class"""
        if not self.is_hovered:  # Only hide if not hovered
            self.revealer.set_reveal_child(False)
            self.volume_box.get_style_context().remove_class("hovered")
        self.hover_timeout_id = None
        return False

    def on_external_volume_change(self, *args):
        """Shows the volume widget temporarily on external volume changes."""
        if self.is_hovered:
            return

        # Cancel any pending hide operation
        if self.hover_timeout_id:
            GLib.source_remove(self.hover_timeout_id)
            self.hover_timeout_id = None

        # Show the label and add the class
        self.volume_box.get_style_context().add_class("hovered")
        self.revealer.set_reveal_child(True)

        # Set a timeout to hide the label
        self.hover_timeout_id = GLib.timeout_add(1200, self.hide_label)

    @cooldown(0.1)
    def on_scroll(self, widget, event):
        # Adjust the volume based on the scroll direction
        val_y = event.delta_y
        if val_y > 0:
            self.audio.speaker.volume += self.config.get("step_size", 5)
        else:
            self.audio.speaker.volume -= self.config.get("step_size", 5)

    def on_click(self, widget, event):
        """Handle click events to toggle mute"""
        if event.button == 1:
            self.toggle_mute()
        return True

    def on_speaker_changed(self, *_):
        """Update the progress bar value based on the speaker volume"""
        if not self.audio.speaker:
            return

        self.set_tooltip_text(self.audio.speaker.description)
        self.audio.speaker.connect("changed", self.update_volume)
        self.audio.speaker.connect("notify::volume", self.on_external_volume_change)
        self.audio.speaker.connect("notify::muted", self.on_external_volume_change)
        self.update_volume()

    def toggle_mute(self, *_):
        """Mute and unmute the speaker"""
        current_stream = self.audio.speaker
        if current_stream:
            current_stream.muted = not current_stream.muted

    def update_volume(self, *_):
        """Update the volume percentage and icon"""
        if not self.audio.speaker:
            return

        volume = round(self.audio.speaker.volume)
        is_muted = self.audio.speaker.muted

        # Update progress bar
        self.progress_bar.set_value(volume / 100)

        # Update volume label
        self.volume_label.set_text(f"{volume}%".rjust(4))

        # Update icon based on volume and mute state
        icon_info = get_audio_icon_name(volume, is_muted)
        self.icon.set_text(icon_info["text_icon"])

    def cleanup(self):
        """Clean up timeouts when widget is destroyed"""
        if self.hover_timeout_id:
            GLib.source_remove(self.hover_timeout_id)
            self.hover_timeout_id = None
        if self.show_timeout_id:
            GLib.source_remove(self.show_timeout_id)
            self.show_timeout_id = None
