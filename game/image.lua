ImageContainerDS = 
{
    "bg_lecturehall.jpg.t3x 1 ",
    "bg_uni.jpg.t3x 5 ",
    "bg_meadow.jpg.t3x 15 ",
    "black.png.t3x 48 ",
    "bg_club.jpg.t3x 49 ",
    "black.png.t3x 68 ",
    "black.png.t3x 76 ",
}
ImageContainerPC = 
{
    "bg_lecturehall.jpg 1 ",
    "bg_uni.jpg 5 ",
    "bg_meadow.jpg 15 ",
    "black.png 48 ",
    "bg_club.jpg 49 ",
    "black.png 68 ",
    "black.png 76 ",
}
if love.system.getOS() == "Horizon" then
	if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
        ImageContainer = ImageContainerDS
    else
        ImageContainer = ImageContainerPC
    end
else
    ImageContainer = ImageContainerPC
end
return ImageContainer