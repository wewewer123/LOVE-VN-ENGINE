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
    "sylvie green normal.png.t3x 6 ",
    "sylvie green smile.png.t3x 10 ",
    "nothing 15 ",
    "sylvie green smile.png.t3x 19 ",
    "sylvie green surprised.png.t3x 22 ",
    "sylvie green smile.png.t3x 24 ",
    "sylvie green surprised.png.t3x 25 ",
    "sylvie green smile.png.t3x 30 ",
    "sylvie green normal.png.t3x 43 ",
    "nothing 48 ",
    "sylvie blue normal.png.t3x 53 ",
    "sylvie blue smile.png.t3x 55 ",
    "sylvie blue surprised.png.t3x 57 ",
    "sylvie blue smile.png.t3x 59 ",
    "sylvie blue giggle.png.t3x 62 ",
    "sylvie blue normal.png.t3x 63 ",
    "sylvie blue giggle.png.t3x 67 ",
    "nothing 68 ",
    "nothing 76 ",
}
SecondaryCharacterContainerPC = 
{
    "sylvie green normal.png 6 ",
    "sylvie green smile.png 10 ",
    "nothing 15 ",
    "sylvie green smile.png 19 ",
    "sylvie green surprised.png 22 ",
    "sylvie green smile.png 24 ",
    "sylvie green surprised.png 25 ",
    "sylvie green smile.png 30 ",
    "sylvie green normal.png 43 ",
    "nothing 48 ",
    "sylvie blue normal.png 53 ",
    "sylvie blue smile.png 55 ",
    "sylvie blue surprised.png 57 ",
    "sylvie blue smile.png 59 ",
    "sylvie blue giggle.png 62 ",
    "sylvie blue normal.png 63 ",
    "sylvie blue giggle.png 67 ",
    "nothing 68 ",
    "nothing 76 ",
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