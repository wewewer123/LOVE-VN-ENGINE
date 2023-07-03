ImageContainerDS = 
{
    "",
}
ImageContainerPC = 
{
    "",
}
if love.system.getOS() ~= "N3DSXL" and love.system.getOS() ~= "3DSXL" and love.system.getOS() ~= "3DS" and love.system.getOS() ~= "N2DSXL" and love.system.getOS() ~= "2DSXL" and love.system.getOS() ~= "2DS" then
    ImageContainer = ImageContainerPC
else
    ImageContainer = ImageContainerDS
end
return ImageContainer