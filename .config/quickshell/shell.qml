//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/bar"
import "./modules/onScreenDisplay"


Scope {
  property bool enableBar: true
  property bool enableOnScreenDisplayVolume: true

  LazyLoader { active: enableBar; component: Bar {} }
  LazyLoader { active: enableOnScreenDisplayVolume; component: OnScreenDisplayVolume {} }
}
