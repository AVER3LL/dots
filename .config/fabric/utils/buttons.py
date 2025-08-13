from fabric.widgets.button import Button

from utils.widget_utils import setup_cursor_hover

from .widget_container import BaseWidget


class HoverButton(Button, BaseWidget):
    """A container for button with hover effects."""

    def __init__(self, **kwargs):
        super().__init__(
            **kwargs,
        )

        setup_cursor_hover(self)
