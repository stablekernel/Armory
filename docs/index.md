# Armory

Armory is a testing framework for iOS written in Swift

## Installation

1) Add Armory as a git submodule for your project:

`git submodule add git@github.com:stablekernel/Armory.git`

2) Create a group for Armory

![Armory_Group](img/1_Armory_Folder.png)

3) Drag the source files from Armory/Armory into the group

![Armory_Files](img/2_Armory_Files.png)

4) Add the files to your test target

![Armory_Target](img/3_Xcode_Import.png)

5) Make sure your test class conforms to `ArmoryTestable`

![Armory_Testable](img/4_Final_Test.png)