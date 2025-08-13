from utils.button_toggle import CommandSwitcher


class HyprIdleWidget(CommandSwitcher):
    """A widget to control the hypridle command."""

    def __init__(self, **kwargs):
        # Set the command to hypridle
        self.command = "hypridle"

        super().__init__(
            command=self.command,
            enabled_icon="",
            disabled_icon="󱑂",
            label=False,
            tooltip=True,
            name="hypridle",
            **kwargs,
        )
