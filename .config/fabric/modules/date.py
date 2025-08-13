import time

from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow as Window


class DateWidget(Window):
    def __init__(self):
        super().__init__(
            layer="bottom",
            anchor="bottom",
            # margin="300px 200px 0px 0px",
            visible=True,
            all_visible=True,
        )

        self.day_label = Label(
            name="day-label",
            style_classes=["date"],
        )

        self.date_label = Label(
            name="date-label",
            label="August 08, 2025"
        )

        self.date_box = Box(
            name="date-container",
            spacing=10,
            orientation="vertical",
            children=[self.day_label, self.date_label],
        )

        self.add(self.date_box)
        self.update_date()

    def update_date(self, *args):
        self.day_label.set_text(" ".join(time.strftime("%A")))
        self.date_label.set_text(time.strftime("%d %B %Y"))
        return True
