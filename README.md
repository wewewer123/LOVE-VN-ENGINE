# LÖVE VN ENGINE

 Simple LÖVE vn for on the 3DS, iOS, pc (and hopefully more in the future).

# Features

- Simple Image/Music/Text vn engine.
- No programming knowledge required to use.
- MultiThreaded music loading for the smoothest usage possible.
- Support for the 3DS, iOS and pc.

# Installing

- 3DS: To install on the 3DS put LOVEpotion.3dsx (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0 Pre-Release 4, but should work on all 3.0/2.0 versions) into the "/3ds/LovePotion" folder on the sd card of the 3DS (if the LovePotion folder doesn't exist create it) and copy the "game" folder in there.

- iOS: To install on iOS you will need a mac with XCode and you will need to build using instructions you can find [here](https://github.com/love2d/love#iOS). Once you have that set up you have to zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love. Then you can import that file into the iOS application (I will try to make this easier in the future).

- pc: To install on pc all you have to do is install love from [here](https://github.com/love2d/love/releases) (right now version 11 is the latest which works fine, version 12 should work too when that releases, however any other versions have not been tested).

# Running

- 3DS: To run the vn on the 3DS simply startup LovePotion from the homebrew launcher.

- iOS: To run the vn on iOS simply run the .love file that you imported into the app.

- pc: To run the vn on pc simply drag the game folder or the game .love file onto the exe.

# Future plans

- Character sprite support.
- Part transparent text background.
- Make it easier to create t3x files.
- Automate conversion from renpy to this.
- More devices!!!

# Creating custom story

To make your own story copy the "EmptyGame" and rename it to "game" and copy over main.lua and MusicThreading.lua from the original "game" folder.

If you want to add a new image just add ""(imagename.extention) (LineNumber) "," to image.lua. (the 3DS needs .t3x files for textures)

In the script.lua file if you want to add a question type " qqq " after it and then after that exactly put the text it should go to if the awnser is no, or the linenumber for if the awnser is no. After that you add " yyy " followed by the yes prompt and " nnn " followed by the no prompt (watch out with the prompt size, as if you make it too large it will display incorrectly on the 3DS).
If you want to move from one chunk of text to another type " ggg " followed by the exact text from the line you want it to move to, or the linenumber of the text you want to move to.
If you type "123quit123" anywhere in a line the program will exit *without* showing that line.

If you want to add custom music just add ""(musicname.extention) (LineNumber) "," to music.lua. (only mp3 files are officially supported)

# Building

- Unviersal: If you want to make a .love file that can run on all supported systems all you have to do is zip all the files in the "game" folder to a .zip file (in a way so that main.lua is on the top layer), and rename that .zip file to .love.

- pc: If you want to build for pc please follow the instructions you can find [here](https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable).

- iOS: On iOS it isn't easily possible to build an executable.

- 3DS: On the 3DS I haven't quite figured out how to build properly.
