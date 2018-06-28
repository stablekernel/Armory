# Forge

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58c1aa3ea2fb9101008e4185&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58c1aa3ea2fb9101008e4185/build/latest?branch=master) [![codecov](https://codecov.io/gh/stablekernel/Forge/branch/master/graph/badge.svg?token=dfPWbG1xnL)](https://codecov.io/gh/stablekernel/Forge)

Forge is a Swift iOS framework for interacting with HTTP services.

## Links

[Quick Start](quickstart.md)

[API Reference](documentation/index.md)

## Installation

### Git submodule
Forge can be added as a dependency of a project as a git submodule.
`git submodule add git@github.com:stablekernel/Forge.git`

This leaves the option of using the source files directly or embedding as a framework.

- Source files directly
  - Create a group for Forge
  - Drag the source files from Forge/Forge into the group
  - [stablekernel/striker](https://github.com/stablekernel/striker) has a script for creating a project with Forge source files already included.

- Embedded framework
  - Drag Forge.xcodeproj into your project
  - Add Forge.framework to your project as an embedded binary

Using an embedded framework gets a little tricky when the parent project uses any configurations other than `Debug` and `Release`. If your project needs more configurations, install the source files directly.
