# LÖVE VN ENGINE

 Simple LÖVE vn for on the 3DS, iOS, pc (and hopefully more in the future).

# Installing

- 3DS: To install on the 3DS put LOVEpotion.3dsx (which you can get from [here](https://github.com/lovebrew/lovepotion/releases) this version was tested on 3.0 Pre-Release 4, but should work on all 3.0/2.0 versions) into the "/3ds/LovePotion" folder on the sd card of the 3DS (if the LovePotion folder doesn't exist create it) and copy the "game" folder in there.

- iOS: To install on iOS you will need a mac with XCode and you will need to build using instructions you can find [here](https://github.com/love2d/love#iOS). Once you have that set up you have to zip all the files in the "game" folder to a .zip file (in a way so thayt main.lua is on the top layer), and rename that .zip file to .love. Then you can import that file into the iOS application (I will try to make this easier in the future).

- pc: To install on pc all you have to do is install love from [here](https://github.com/love2d/love/releases) (right now version 11 is the latest which works fine, version 12 should work too when that releases, however any other versions have not been tested).

# Running

- 3DS: To run the vn on the 3DS simply startup LovePotion from the homebrew launcher.

- iOS: To run the vn on iOS simply run the .love file that you imported into the app.

- pc: To run the vn on pc simply drag the game folder or the game .love file onto the exe.

# Creating custom story

To make your own story copy the "EmptyGame" and rename it to "game" and copy over main.lua from the original "game" folder.

If you want to add a new image just add ""(imagename.extention) (LineNumber) "," to image.lua. (the ds needs .t3x files for textures)

In the script.lua file if you want to add a question type " qqq " after it and then after that exactly put the text it should go to if the awnser is no. If you want to move from one chuck of text to another type " ggg " followed by the exact text from the line you want it to move to. if you type "123quit123" anywhere in a line the program will exit *without* showing that line.

# Future plans

- Add custom questions.

- Make music work better/more flexibly.

- Optimize the " qqq " and " ggg " (maybe be giving exact line number as option).

- Make it easier to create t3x files.

- Automate conversion from renpy to this.

- More devices!!!

# Building

- Unviersal: If you want to make a .love file that can run on all supported systems all you have to do is zip all the files in the "game" folder to a .zip file (in a way so thayt main.lua is on the top layer), and rename that .zip file to .love.

- pc: If you want to build for pc please follow the instructions you can find [here](https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable).

- iOS: On iOS it isn't easily possible to build an executable.

- 3DS: On the 3DS I haven't quite figured out how to build propperly.