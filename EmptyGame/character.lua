CharacterContainerDS = 
{
    "",
}
CharacterContainerPC = 
{
    "",
}
SecondaryCharacterContainerDS = 
{
    "",
}
SecondaryCharacterContainerPC = 
{
    "s",
}
if love.system.getOS() == "Horizon" then
	if love.system.getModel() == "RED" or love.system.getModel() == "CTR" or love.system.getModel() == "SPR" or love.system.getModel() == "KTR" or love.system.getModel() == "FTR" or love.system.getModel() == "JAN" then --Any of the supported ds models
        CharacterContainer = CharacterContainerDS
        SecondaryCharacterContainer = SecondaryCharacterContainerDS
    else
        CharacterContainer = CharacterContainerPC
        SecondaryCharacterContainer = SecondaryCharacterContainerPC
    end
else
    CharacterContainer = CharacterContainerPC
    SecondaryCharacterContainer = SecondaryCharacterContainerPC
end
return CharacterContainer