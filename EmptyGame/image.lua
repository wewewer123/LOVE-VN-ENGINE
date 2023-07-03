ImageContainerDS = 
{
    "",
}
ImageContainerPC = 
{
    "",
}
if love.system.getOS() ~= "Horizon" then
    ImageContainer = ImageContainerPC
else
    ImageContainer = ImageContainerDS
end
return ImageContainer