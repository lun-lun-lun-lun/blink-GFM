# Build script for Blink Girlfriend Mode

# Ensure we're in the right directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Get version from Version.luau
$versionContent = Get-Content "src/Version.luau" -Raw
$version = [regex]::Match($versionContent, 'VERSION = "([^"]+)"').Groups[1].Value

# Create distribution directory
$distPath = "dist/blink-gfm-$version"
New-Item -ItemType Directory -Force -Path $distPath | Out-Null
New-Item -ItemType Directory -Force -Path "$distPath/src" | Out-Null

# Copy source files
Copy-Item -Path "src/*" -Destination "$distPath/src" -Recurse -Force

# Create init.luau
$initContent = @"
--!strict
--!optimize 2

local Version = require("./src/Version")
local Generator = require("./src/Generator")

return {
    Version = Version,
    Generator = Generator,
}
"@
Set-Content -Path "$distPath/init.luau" -Value $initContent

# Create README.md
$readmeContent = @"
# Blink Girlfriend Mode

A network communication library for Roblox games with additional security features.

## Version
$version

## Installation

### Using Rokit
```toml
[tools]
blink-gfm = "yourusername/blink-gfm@$version"
```

### Using Aftman
```toml
[tools]
blink-gfm = "yourusername/blink-gfm@$version"
```

## Usage

```lua
local Blink = require("blink-gfm")

-- Your code here
```
"@
Set-Content -Path "$distPath/README.md" -Value $readmeContent

# Copy LICENSE
Copy-Item -Path "LICENSE" -Destination "$distPath/LICENSE" -Force

# Create zip archive
$zipPath = "dist/blink-gfm-$version.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath
}
Compress-Archive -Path $distPath -DestinationPath $zipPath -Force

Write-Host "Build complete! Distribution created at $zipPath" 