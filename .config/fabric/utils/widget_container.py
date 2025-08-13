from typing import Iterable

from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.eventbox import EventBox
from fabric.widgets.widget import Widget


class BaseWidget(Widget):
    """A base widget class that can be extended for custom widgets."""

    """A widget that can be toggled on and off."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def toggle(self):
        """Toggle the visibility of the bar."""
        if self.is_visible():
            self.hide()
        else:
            self.show()

    def set_has_class(self, class_name: str | Iterable[str], condition: bool):
        if condition:
            self.add_style_class(class_name)
        else:
            self.remove_style_class(class_name)


class EventBoxWidget(EventBox, BaseWidget):
    """A container for box widgets."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.config = {}

        self.box = Box(style_classes="panel-box")
        self.add(self.box)


class ButtonWidget(Button, BaseWidget):
    """A container for button widgets. Only used for new widgets that are used on bar"""

    def __init__(self, **kwargs):
        super().__init__(
            style_classes="panel-button",
            **kwargs,
        )

        self.config = {}

        self.box = Box(style_classes="box")
        self.add(self.box)
