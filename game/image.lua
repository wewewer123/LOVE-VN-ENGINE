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
    "CalibrationScreen.jpg 1 ",
    "CalibrationScreen.jpg 7 "
}
if love.system.getOS() == "Windows" then
    ImageContainer = ImageContainerPC
else
    ImageContainer = ImageContainerDS
end
return ImageContainer