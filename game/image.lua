ImageContainerDS = 
{
    "bg_lecturehall.jpg.t3x 1 ",
    "bg_uni.jpg.t3x 5 ",
    "bg_meadow.jpg.t3x 14 ",
    "black.png.t3x 48 ",
    "bg_club.jpg.t3x 49 ",
    "black.png.t3x 68 ",
    "black.png.t3x 76 ",
}
ImageContainerPC = 
{
    "bg_lecturehall.jpg 1 ",
    "bg_uni.jpg 5 ",
    "bg_meadow.jpg 14 ",
    "black.png 48 ",
    "bg_club.jpg 49 ",
    "black.png 68 ",
    "black.png 76 ",
}
if love.system.getOS() ~= "N3DSXL" and love.system.getOS() ~= "3DSXL" and love.system.getOS() ~= "3DS" and love.system.getOS() ~= "N2DSXL" and love.system.getOS() ~= "2DSXL" and love.system.getOS() ~= "2DS" then
    ImageContainer = ImageContainerPC
else
    ImageContainer = ImageContainerDS
end
return ImageContainer