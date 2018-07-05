# Armory

Armory is a testing framework for iOS written in Swift

## Installation

### Git submodule

Armory can be added as a dependency of a project as a git submodule:

`git submodule add git@github.com:stablekernel/Armory.git`

This leaves the option of using the source files directly or embedding as a framework.

###### Source files directly
* Create a group for Armory
* Drag the source files from Armory/Armory into the group

###### Embedded framework  
* Drag Armory.xcodeproj into your project
* Add Armory.framework to your project as an embedded binary

Using an embedded framework gets a little tricky when the parent project uses any configurations other than `Debug` and `Release`. If your project needs more configuration, install the source files directly. 