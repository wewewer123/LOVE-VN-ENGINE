cd ..
npm i love.js
cd game
del /f game.love
"%programfiles%/7-Zip/7z.exe" a -tZip game.love *.*
cd ..
npx love.js.cmd -m 50000000 -c --title LoveVN game\game.love Buildtools\build\web