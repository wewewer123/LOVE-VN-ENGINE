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
    --"Cozy-Character.png 10 ",
    --"Cozy-Character.png 11 ",
    --"Cozy-Character.png 12 ",
    --"Cozy-Character.png 13 ",
    --"Cozy-Character.png 14 ",
    --"Cozy-Character.png 15 ",
    "Cozy-Character.png 25 ",
    "nothing 43 ",
    "Cozy-Character.png 44 ",
    "nothing 63 ",
    "Cozy-Character.png 64 ",
    "nothing 146 ",
    "Cozy-Character.png 147 ",
    "nothing 105 ",
    "Cozy-Character.png 106 ",
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