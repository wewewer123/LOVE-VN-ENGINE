# 3DS VN
 Simple LÖVE vn for on the 3DS


# Installing
To install put LOVEpotion.3dsx into the "/3ds/LovePotion" folder on the sd card of the 3DS (if the LovePotion folder doesn't exist create it) and copy the "game" folder in there.


# Running
To run the vn simply startup LovePotion from the homebrew launcher.


# Creating custom story

To make your own story create a new "game" folder and copy main.lua into that folder. Then 2 new files called "image.lua" and "script.lua". 

In the "image.lua" file put "ImageContainerDS = {}" and "ImageContainerPC = {}" where if you want to add a new image just put in ""(imagename.extention) (LineNumber) ",". (the ds needs .t3x files for textures)

In the "script.lua" file "putScriptContainer = { "text1", "text2", etc }". If you want to add a question type " qqq " after it and then after that exactly put the text it should go to if the awnser is no. If you want to move from one chuck of text to another type " ggg " followed by the exact text from the line you want it to move to.


# Future plans

- Add custom questions.

- Optimize the " qqq " and " ggg " (maybe be giving exact line number as option).

- Make it easier to create t3x files.

- Automate conversion from renpy to this.


# Building
Building is currently not possible, I haven't gotten it to compile porperly yet.