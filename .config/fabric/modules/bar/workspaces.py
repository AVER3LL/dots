from fabric.hyprland.widgets import (
    WorkspaceButton,
    Workspaces,
)
from fabric.widgets.box import Box


class MyWorkspaces(Box):
    def workspace_factory(self, workspace_id: int) -> WorkspaceButton | None:
        # NOTE: When workspace_id < 0, we are on a special workspace
        return (
            None
            if workspace_id < 0
            else WorkspaceButton(
                h_expand=False,
                v_expand=False,
                h_align="center",
                v_align="center",
                id=workspace_id,
                label=str(workspace_id),
            )
        )

    def __init__(self):
        self.workspaces = Workspaces(
            name="workspaces",
            invert_scroll=True,
            empty_scroll=True,
            v_align="fill",
            orientation="h",
            spacing=5,
            buttons=[self.workspace_factory(i) for i in range(1, 7)],
            buttons_factory=self.workspace_factory,
        )

        super().__init__(
            name="workspaces-container",
            children=[self.workspaces],
        )
