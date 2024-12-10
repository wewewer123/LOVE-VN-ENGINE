#!/bin/bash

# Ensure Node.js is installed
if ! command -v node &> /dev/null
then
    echo "Node.js is required but not installed. Please install Node.js and try again."
    exit 1
fi

# Ensure the required parameters are provided
if [ -z "$1" ]; then
    echo "Error: Please provide the game folder path as the first parameter."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Error: Please provide the game title as the second parameter."
    exit 1
fi

# Assign parameters
game_folder="$1"
game_title="$2"
ram_amount=16777216  # Default RAM value (16MB)

if [ ! -z "$3" ]; then
    ram_amount=$(( $3 * 1048576 ))  # Convert MB to bytes
fi

# Step 1: Ensure the game folder exists
if [ ! -d "$game_folder" ]; then
    echo "Error: The specified game folder \"$game_folder\" does not exist."
    exit 1
fi

# Step 2: Zip the game folder contents (without the enclosing folder)
echo "Creating game.love from $game_folder..."
zip -r game.love "$game_folder"/*

if [ ! -f "game.love" ]; then
    echo "Error: Failed to create game.love. Exiting."
    exit 1
fi

# Step 3: Install love.js if not already installed
echo "Installing love.js if necessary..."
npm list love.js &>/dev/null || npm install love.js

# Step 4: Use love.js to build the HTML game
echo "Building HTML game with love.js..."
npx love.js -t "$game_title" -m "$ram_amount" game.love output

if [ ! -d "output" ]; then
    echo "Error: Failed to build the HTML game. Exiting."
    exit 1
fi

# Step 5: Download coi-serviceworker.js into the output folder
echo "Downloading coi-serviceworker.js..."
curl -o output/coi-serviceworker.js https://raw.githubusercontent.com/gzuidhof/coi-serviceworker/refs/heads/master/coi-serviceworker.js

if [ ! -f "output/coi-serviceworker.js" ]; then
    echo "Error: Failed to download coi-serviceworker.js. Exiting."
    exit 1
fi

# Step 6: Modify the HTML file to include the service worker
echo "Modifying HTML file to include the service worker..."
html_file="output/index.html"

# Add the <script> tag before the closing </body> tag
sed -i '/<\/body>/i <script src="coi-serviceworker.js"></script>' "$html_file"

# Step 7: Start a self-hosted server
echo "Starting local server..."
cat << EOF > server.js
const http = require('http');
const fs = require('fs');
const path = require('path');
const PORT = 8080;

http.createServer((req, res) => {
    let filePath = '.' + (req.url === '/' ? '/output/index.html' : req.url);
    let extname = path.extname(filePath);
    let contentType = {
        '.html': 'text/html',
        '.js': 'text/javascript',
        '.css': 'text/css'
    }[extname] || 'application/octet-stream';

    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(err.code === 'ENOENT' ? 404 : 500);
            res.end();
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
}).listen(PORT, () => console.log('Server running at http://localhost:' + PORT));
EOF

# Start the server
node server.js

# Clean up by deleting the server.js after the server starts
rm server.js

echo "Game is now being served at http://localhost:8080"
