# LÖVE VN ENGINE

 Simple LÖVE vn for on the 3DS, Switch, web, iOS, pc (and hopefully more in the future).
 This version was a [submition](https://itch.io/jam/cozy-fall-jam-2023/rate/2304227) to the [Cozy Fall Jam 2023 🍂](https://itch.io/jam/cozy-fall-jam-2023)

## Features

- Simple Image/Music/Text vn engine.
- No programming knowledge required to use.
- No external image scaling required.
- MultiThreaded music loading for the smoothest usage possible.
- Support for the 3DS, Switch, website, iOS and pc.

## Installing

- 3DS: To install on the 3DS put LOVEpotion.3dsx (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0.0, but should work on all newer release versions) into the "/3ds/LovePotion" folder on the sd card of the 3DS (if the LovePotion folder doesn't exist create it) and copy the "game" folder in there.

- switch: To install on the switch put LOVEpotion.nro (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0.0, but should work on all newer release versions) into the "/switch/LovePotion" folder on the sd card of the switch (if the LovePotion folder doesn't exist create it) and copy the "game" folder in there.

- iOS: To install on iOS you will need a mac with XCode and you will need to build using instructions you can find [here](https://github.com/love2d/love#iOS). Once you have that set up you have to zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love. Then you can import that file into the iOS application (I will try to make this easier in the future).

- pc: To install on pc all you have to do is install love from [here](https://github.com/love2d/love/releases) (right now version 11 is the latest which works fine, version 12 should work too when that releases, however any other versions have not been tested).

## Running

- 3DS: To run the vn on the 3DS simply startup LovePotion from the homebrew launcher.

- Switch: To run the vn on the Switch simply startup LovePotion from the homebrew launcher (doesn't work in tablet mode).

- web: Go to [this website](http://easydoor.mine.bz/server/LoveVN/) (if it's online) (some browsers don't work idk why)

- iOS: To run the vn on iOS simply run the .love file that you imported into the app.

- pc: To run the vn on pc simply drag the game folder or the game .love file onto the exe.

## Fix before merge with main

- 1: fix music and video so you don't have to change scripts between diffrent system builds
- 2: character auto scale with screen
- 2.1: custom textboxes/ui
- 2.2: animations
- 3: fixing name input on mobile/console(especially 3ds) (kinda done alr)

## Future plans

- Add a sfx system
- Add outlines to the choice buttons for touchscreens.
- Make it easier to create t3x files.
- Make a github action to build a github pages for web build.
- Fix allignment issues between scripts. (namely image.lua/character.lua being one higher compared to script.lua)
- Automate conversion from renpy to this.
- More devices!!!

## Creating custom story

To make your own story copy the "EmptyGame" and rename it to "game" and copy over main.lua and MusicThreading.lua from the original "game" folder.

If you want to add a new image just add ""(imagename.extention) (LineNumber) "," to image.lua. (the 3DS needs .t3x files for textures)

If you want to add a new character just add ""(characterimagename.extention) (LineNumber) "," to character.lua. (the 3DS needs .t3x files for textures)

In the script.lua file if you want to add a question type the question followed by " qqq " and then after that the text it should go to if the awnser is no, or the linenumber for if the awnser is no. After that you add " yyy " followed by what yes means and " nnn " followed by what no means (watch out with the yes and no meaning size, as if you make it too large it will display incorrectly on the 3DS).
If you want to move from one chunk of text to another type " ggg " followed by the exact text from the line you want it to move to, or the linenumber of the text you want to move to.
If you want to add a name speaking the text, type "(name) .name." where (name) is the name you want to have show up.
If you type "123quit123" anywhere in a line the program will exit *without* showing that line.

If you want to add custom music just add ""(musicname.extention) (LineNumber) "," to music.lua. (only mp3 files are officially supported)

## Building

- Unviersal: If you want to make a .love file that can run on all supported systems all you have to do is zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love.

- 3DS: I'm still working out the specifics for building on the 3ds.

- Switch: I'm still working out the specifics for building on the switch.

- web(automatic): double click BuildTools/BuildServer.bat (don't run as administrator). (make sure you have node.js and 7z installed for this)
- web(manual): Create an universal build, call it game.love and place it in the "LOVE-VN-ENGINE" folder, then open cmd in that same folder and then run "npm i love.js" followed by "npx love.js -m 20000000 -c --title LoveVN game.love Buildtools\build\web". (make sure you have node.js installed for this)
- web(jam): [used this](https://schellingb.github.io/LoveWebBuilder/package)

- iOS: On iOS it isn't easily possible to build an executable.

- pc: If you want to build for pc please follow the instructions you can find [here](https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable).
