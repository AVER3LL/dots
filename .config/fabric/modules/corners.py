from fabric.widgets.box import Box
from fabric.widgets.shapes import Corner, CornerOrientation
from fabric.widgets.wayland import WaylandWindow as Window


class MyCorner(Box):
    def __init__(self, corner: CornerOrientation, **kwargs):
        super().__init__(
            name="corner-container",
            children=Corner(
                name="corner",
                orientation=corner,
                h_expand=False,
                v_expand=False,
                h_align="center",
                v_align="center",
                size=20,
                **kwargs,
            ),
        )


class Corners(Window):
    def __init__(self):
        super().__init__(
            name="corners",
            layer="top",
            anchor="top bottom left right",
            exclusivity="auto",
            pass_through=True,
            visible=False,
            all_visible=False,
            margin="0px",
        )

        self.all_corners: Box = Box(
            name="all-corners",
            orientation="v",
            h_expand=True,
            v_expand=True,
            h_align="fill",
            v_align="fill",
            children=[
                Box(
                    name="top-corners",
                    orientation="h",
                    h_align="fill",
                    children=[
                        MyCorner(CornerOrientation.TOP_LEFT),
                        Box(h_expand=True),
                        MyCorner(CornerOrientation.TOP_RIGHT),
                    ],
                ),
                Box(v_expand=True),
                Box(
                    name="bottom-corners",
                    orientation="h",
                    h_align="fill",
                    children=[
                        MyCorner(
                            CornerOrientation.BOTTOM_LEFT,
                            style_classes="bottom",
                        ),
                        Box(h_expand=True),
                        MyCorner(
                            CornerOrientation.BOTTOM_RIGHT,
                            style_classes="bottom",
                        ),
                    ],
                ),
            ],
        )

        self.add(self.all_corners)

        self.show_all()
