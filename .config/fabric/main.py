import setproctitle
from fabric import Application
from fabric.utils import get_relative_path, monitor_file

from config.data import APP_NAME, SHOW_CORNERS
from modules.bar import StatusBar
from modules.corners import Corners
from modules.date import DateWidget


def bar_border():
    return f"border-bottom: {'1' if SHOW_CORNERS else '0'}px solid alpha(var(--outline), 0.6);"


if __name__ == "__main__":
    setproctitle.setproctitle(APP_NAME)

    bar = StatusBar()
    date = DateWidget()
    corners = Corners()
    corners.set_visible(SHOW_CORNERS)
    app = Application(f"{APP_NAME}", bar, corners, date)

    def set_css(*_) -> None:
        app.set_stylesheet_from_file(
            get_relative_path("main.css"),
            # exposed_functions={
            #     "bar-border": bar_border,
            # },
        )

    style_monitor = monitor_file(get_relative_path("main.css"), set_css)
    other_style_monitor = monitor_file(get_relative_path("styles/"), set_css)

    app.set_css = set_css

    app.set_css()

    app.run()
