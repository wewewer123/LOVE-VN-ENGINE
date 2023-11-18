ImageContainerDS = 
{
    "Cozy-Intro.jpg.t3x 1 ",
    "Cozy-Background.jpg.t3x 2 ",
}
ImageContainerPC = 
{
    "Cozy-Intro.jpg 1 ",
    "Cozy-Background.jpg 2 ",
    --"Cozy-Video.ogv 2 ",
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