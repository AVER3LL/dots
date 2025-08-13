import gi
from fabric.utils import cooldown
from fabric.widgets.box import Box
from fabric.widgets.circularprogressbar import CircularProgressBar
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
from fabric.widgets.revealer import Revealer

import utils.functions as helpers
from services.brightness import BrightnessService
from utils.icons import text_icons
from utils.widget_container import EventBoxWidget
from utils.widget_utils import get_brightness_icon_name, nerd_font_icon

gi.require_version("Gtk", "3.0")
from gi.repository import Gdk, GLib


class BrightnessWidget(EventBoxWidget):
    """A widget that displays and controles the brightness"""

    def __init__(self, **kwargs):
        super().__init__(
            name="brightness",
            events=[
                "scroll",
                "smooth-scroll",
                "enter-notify-event",
                "leave-notify-event",
            ],
            **kwargs,
        )

        self.brightness = BrightnessService()

        self.hover_timeout_id = None
        self.show_timeout_id = None
        self.is_hovered = False  # Track hover state explicitly

        normalized_brightness = helpers.convert_to_percent(
            self.brightness.screen_brightness, self.brightness.max_screen
        )

        self.brigthness_box = Box(orientation="horizontal", spacing=0)
        self.brigthness_box.get_style_context().add_class("brightness-container")

        self.progress_bar = CircularProgressBar(
            style_classes="overlay-progress-bar",
            pie=True,
            size=24,
            value=normalized_brightness / 100,
        )

        self.icon = nerd_font_icon(
            icon=text_icons["brightness"]["medium"],
            props={"style_classes": "panel-font-icon overlay-icon"},
        )

        # Initialize with correct values being displayed
        self.icon.set_text(get_brightness_icon_name(normalized_brightness)["icon_text"])

        self.brightness_label = Label(
            label=f"{normalized_brightness}%", style_classes="brightness-text"
        )

        self.revealer = Revealer(
            child=self.brightness_label,
            transition_type="slide-left",
            transition_duration=300,
        )
        self.brigthness_box.add(self.revealer)

        overlay = Overlay(child=self.progress_bar, overlays=self.icon, name="overlay")
        self.brigthness_box.add(overlay)

        self.box.add(self.brigthness_box)

        # Connect the audio service to update the progress bar on brightness change
        self.brightness.connect("brightness_changed", self.on_brightness_changed)

        # Connect the audio service to update the progress bar on brightness change
        self.connect("scroll-event", self.on_scroll)

        # Show on hover and set timeout
        self.connect("enter-notify-event", self.on_hover)
        self.connect("leave-notify-event", self.on_leave)

    def show_label_and_class(self):
        """Shows the label and adds the hovered class"""
        if self.is_hovered:
            self.brigthness_box.get_style_context().add_class("hovered")
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

        # If not visible or already hiding dont create a timeout
        if not self.revealer.get_reveal_child():
            return

        if self.hover_timeout_id:
            return

        self.hover_timeout_id = GLib.timeout_add(500, self.hide_label)

    def hide_label(self):
        """Hide the label and remove the hovered class"""
        if not self.is_hovered:  # Only hide if not hovered
            self.revealer.set_reveal_child(False)
            self.brigthness_box.get_style_context().remove_class("hovered")
        self.hover_timeout_id = None
        return False

    @cooldown(0.1)
    def on_scroll(self, widget, event):
        # Adjust the volume based on the scroll direction
        val_y = event.delta_y

        if val_y > 0:
            self.brightness.screen_brightness += self.config.get("step_size", 100)
        else:
            self.brightness.screen_brightness -= self.config.get("step_size", 100)

    def on_brightness_changed(self, *_):
        normalized_brightness = helpers.convert_to_percent(
            self.brightness.screen_brightness,
            self.brightness.max_screen,
        )

        # Only cancel hover timeout if not currently hovered
        if self.hover_timeout_id and not self.is_hovered:
            GLib.source_remove(self.hover_timeout_id)
            self.hover_timeout_id = None

        self.brigthness_box.get_style_context().add_class("hovered")
        self.revealer.set_reveal_child(True)

        self.progress_bar.set_value(normalized_brightness / 100)
        self.brightness_label.set_text(f"{normalized_brightness}%".rjust(4))
        self.icon.set_text(get_brightness_icon_name(normalized_brightness)["icon_text"])
        self.set_tooltip_text(f"{normalized_brightness}%")

        # Only set hide timeout if not currently hovered
        if not self.is_hovered:
            self.hover_timeout_id = GLib.timeout_add(1200, self.hide_label)
