#!/bin/bash

cd ..
copy Buildtools\src\lovebrew.toml %cd%
"%programfiles%/7-Zip/7z.exe" a -tZip game.zip game/*.*
"%programfiles%/7-Zip/7z.exe" a -tZip game.zip lovebrew.toml

# cd game
# "%programfiles%/7-Zip/7z.exe" a -tZip game.zip *.*

curl -X POST -o "output.zip" "https://bundle.lovebrew.org/compile?title=LoveVNEngine&description=a%%20random%%20love%%20vn%%20engine&version=2.0.0&author=wewewer123&targets=ctr,hac,cafe"

pause

del game.zip
del lovebrew.toml
del output.zip