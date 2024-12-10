@echo off
REM Check if Node.js is installed
node -v >nul 2>&1 || (
    echo Node.js is required but not installed. Please install Node.js and try again.
    exit /b
)

REM Ensure the required parameters are provided
if "%~1"=="" (
    echo Error: Please provide the game folder path as the first parameter.
    exit /b
)

if "%~2"=="" (
    echo Error: Please provide the game title as the second parameter.
    exit /b
)

REM Assign parameters
set "game_folder=%~1"
set "game_title=%~2"
set "ram_amount=16777216"  REM Default RAM value (16MB)

if not "%~3"=="" (
    set /a ram_amount=%~3*1048576  REM Convert MB to bytes
)

REM Step 1: Ensure the game folder exists
if not exist "%game_folder%" (
    echo Error: The specified game folder "%game_folder%" does not exist.
    exit /b
)

REM Step 2: Zip the game folder contents
echo Creating game.love from %game_folder%...
node -e "const fs = require('fs'), archiver = require('archiver'); const output = fs.createWriteStream('game.love'); const archive = archiver('zip', { zlib: { level: 9 } }); output.on('close', () => console.log('Zipping complete.')); archive.on('error', err => { console.error(err); process.exit(1); }); archive.pipe(output); fs.readdirSync('%game_folder%').forEach(file => archive.directory('%game_folder%/' + file, false)); archive.finalize();"

if not exist "game.love" (
    echo Error: Failed to create game.love. Exiting.
    exit /b
)

REM Step 3: Install love.js if not already installed
echo Installing love.js if necessary...
node -e "try { require('child_process').execSync('npm list love.js', { stdio: 'ignore' }); } catch { require('child_process').execSync('npm install love.js', { stdio: 'inherit' }); }"

REM Step 4: Use love.js to build the HTML game
echo Building HTML game with love.js...
node -e "const { execSync } = require('child_process'); execSync(`npx love.js -t \"%game_title%\" -m %ram_amount% game.love output`, { stdio: 'inherit' });"

if not exist "output" (
    echo Error: Failed to build the HTML game. Exiting.
    exit /b
)

REM Step 5: Download coi-serviceworker.js into the output folder
echo Downloading coi-serviceworker.js...
node -e "const https = require('https'), fs = require('fs'); https.get('https://raw.githubusercontent.com/gzuidhof/coi-serviceworker/refs/heads/master/coi-serviceworker.js', res => { if (res.statusCode === 200) { const file = fs.createWriteStream('output/coi-serviceworker.js'); res.pipe(file).on('finish', () => console.log('Download complete.')); } else { console.error('Failed to download coi-serviceworker.js.'); process.exit(1); } });"

if not exist "output/coi-serviceworker.js" (
    echo Error: Failed to download coi-serviceworker.js. Exiting.
    exit /b
)

REM Step 6: Modify the HTML file to include the service worker
echo Modifying HTML file to include the service worker...
node -e "const fs = require('fs'); const html = fs.readFileSync('output/index.html', 'utf8'); const updatedHtml = html.replace(/<\/body>/i, '<script src=\"coi-serviceworker.js\"></script>\n</body>'); fs.writeFileSync('output/index.html', updatedHtml); console.log('HTML modification complete.');"

REM Step 7: Start a self-hosted server
echo Starting local server...
echo const http = require('http'); const fs = require('fs'); const path = require('path'); const PORT = 8080; http.createServer((req, res) => { let filePath = '.' + (req.url === '/' ? '/output/index.html' : req.url); let extname = path.extname(filePath); let contentType = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css' }[extname] || 'application/octet-stream'; fs.readFile(filePath, (err, content) => { if (err) { res.writeHead(err.code === 'ENOENT' ? 404 : 500); res.end(); } else { res.writeHead(200, { 'Content-Type': contentType }); res.end(content, 'utf-8'); } }); }).listen(PORT, () => console.log(`Server running at http://localhost:${PORT}/`));" > server.js
start cmd /c "node server.js"
pause
