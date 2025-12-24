# Package
version       = "0.1.1-alpha"
author        = "m33mt33n"
description   = "A library with CLI exposing functionality to blink Android screen."
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["wink"]
skipDirs      = @["misc"]
installExt    = @["nim"]

# Dependencies
requires "nim >= 1.6.0"
requires "clapfn >= 1.0.0"  # https://github.com/oliversandli/clapfn
