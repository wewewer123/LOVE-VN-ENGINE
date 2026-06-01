# LÖVE VN ENGINE

 Simple LÖVE vn for on the 3DS, Switch, webGL, iOS, Windows, MacOS, Linux (and hopefully more in the future).

## Features

- Simple Image/Music/Text vn engine.
- No programming knowledge required to use.
- No external image scaling required.
- MultiThreaded music loading for the smoothest usage possible.
- Support for the 3DS, Switch, website, iOS and pc.

## Installing

- 3DS: To install on the 3DS put LOVEpotion.3dsx (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0.0, but should work on all newer release versions) into the "/3ds/LovePotion" folder on the sd card of the 3DS (if the LovePotion folder doesn't exist create it) and copy the "game" folder and it's contents to there.

- switch: To install on the switch put LOVEpotion.nro (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0.0, but should work on all newer release versions) into the "/switch/LovePotion" folder on the sd card of the switch (if the LovePotion folder doesn't exist create it) and copy the "game" folder and it's contents to there.

- iOS: To install on iOS you will need a mac with XCode and you will need to build using instructions you can find [here](https://github.com/love2d/love#iOS). Once you have that set up you have to zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love. Then you can import that file into the iOS application (I will try to make this easier in the future).

- Windows, MacOS and Linux: To install on pc all you have to do is install love from [here](https://github.com/love2d/love/releases) (right now version 12 is the preferred version, but since 11 is still the latest fully released version I will try to keep it compatible, however any other versions have not been tested).

## Running

- 3DS: To run the vn on the 3DS simply startup LovePotion from the homebrew launcher.

- Switch: To run the vn on the Switch simply startup LovePotion from the homebrew launcher (doesn't work in tablet mode).

- web: Go to [this Github Pages](https://wewewer123.github.io/LOVE-VN-ENGINE/)

- iOS: To run the vn on iOS simply run the .love file that you imported into the app.

- Windows, MacOS and Linux (precompiled executable): simply start the application how you're used to without any special arguments.

- Windows: To run the vn on pc simply drag the game folder or the game .love file onto the exe.

- MacOS and Linux: in terminal run `/path/to/Love.app /path/to/game(.love)`

## Issues

- 1: fix music and video so you don't have to change scripts between diffrent system builds (only an issue with web builds)
- 2: character doesn't auto scale with screen

## Future plans

- custom textboxes/ui
- animations (1/10th implemented but needs GREAT improvement)
- Make it easier to create t3x files.
- Automate conversion from renpy to this.
- More devices!!!

## Creating custom story

This is a sample of what a singular line could look like:
```{
        Label = "A quicker move system label", 
        !name = "Speaker", 
        !text = "Text that is spoken/thought by the Speaker", 
        bg = "The background image", 
        music = "Music.mp3/.ogg", 
        question = {"Option 1", "I picked option 1", "I'll say 2", "Label2", "I'll say line 3", 3}, 
        move = 0, (label, text or line number)
        char1 = "character1.png", 
        char2 = "character2.png",
        XSize = Image width (width of the image, only needs to be supplied when positions is used)
        YSize = Image height (height of the image, only needs to be supplied when positions is used)
        positions = {goto line, left most, right most, top most, bottom most}, (this is combined with the above two to add a point&click system)
        VarSet = {{"VariableName", "Value"}, {"VariableName2", "Value2"}},
        VarCheck = {{"VariableName", "Value", "GotoLabelIfTrue", "GotoLabelIfFalse"}, {"VariableName2", "Value2", "GotoLabelIfTrue2", "GotoLabelIfFalse2"}},
    },
```
Everything with an exclamationmark in front of it is required at every line.

## Building

- Unviersal: If you want to make a .love file that can run on all supported systems all you have to do is zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love.

- 3DS: I'm still working out the specifics for building on the 3ds, for now read [this](https://lovebrew.org/bundler/overview)

- Switch: I'm still working out the specifics for building on the switch, for now read [this](https://lovebrew.org/bundler/overview)

- web(automatic): open a cmd window in the root folder of this project, and then run `BuildTools/BuildServer.bat "game" "[name]" [MaxRam(MB)(optional)]` BuildTools/BuildServer.bat. (make sure you have node.js installed for this)

- iOS: On iOS it isn't easily possible to build an executable, still working on makeing it easier.

- Windows, MacOS and Linux: If you want to build for pc please follow the instructions you can find [here](https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable).
