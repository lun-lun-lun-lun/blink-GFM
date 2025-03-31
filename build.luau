--!strict
--!optimize 2

local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

-- Try to load Version module
local success, Version = pcall(function()
    return dofile(fs.join(process.cwd, "src", "Version.luau"))
end)

if not success then
    error("Failed to load Version module: " .. tostring(Version))
end

local function createDistribution()
    print("Starting distribution creation...")
    
    -- Create dist directory
    print("Creating dist directory...")
    local success, err = pcall(function()
        fs.createDirectory("dist")
    end)
    if not success then
        error("Failed to create dist directory: " .. tostring(err))
    end
    
    -- Create version-specific directory
    print("Creating version directory...")
    local versionDir = fs.join("dist", "blink-gfm-" .. Version.VERSION)
    success, err = pcall(function()
        fs.createDirectory(versionDir)
    end)
    if not success then
        error("Failed to create version directory: " .. tostring(err))
    end
    
    -- Copy source files
    print("Copying source files...")
    success, err = pcall(function()
        fs.copy("src", fs.join(versionDir, "src"))
    end)
    if not success then
        error("Failed to copy source files: " .. tostring(err))
    end
    
    -- Create init.luau
    print("Creating init.luau...")
    local initContent = [[
--!strict
--!optimize 2

local Version = require("./src/Version")
local Generator = require("./src/Generator")

return {
    Version = Version,
    Generator = Generator,
}
]]
    success, err = pcall(function()
        fs.writeFile(fs.join(versionDir, "init.luau"), initContent)
    end)
    if not success then
        error("Failed to create init.luau: " .. tostring(err))
    end
    
    -- Create README
    print("Creating README.md...")
    local readmeContent = [[
# Blink Girlfriend Mode

A network communication library for Roblox games with additional security features.

## Version
]] .. Version.VERSION .. [[

## Installation

### Using Rokit
```toml
[tools]
blink-gfm = "yourusername/blink-gfm@]] .. Version.VERSION .. [["
```

### Using Aftman
```toml
[tools]
blink-gfm = "yourusername/blink-gfm@]] .. Version.VERSION .. [["
```

## Usage

```lua
local Blink = require("blink-gfm")

-- Your code here
```
]]
    success, err = pcall(function()
        fs.writeFile(fs.join(versionDir, "README.md"), readmeContent)
    end)
    if not success then
        error("Failed to create README.md: " .. tostring(err))
    end
    
    -- Create LICENSE
    print("Copying LICENSE...")
    success, err = pcall(function()
        fs.copy("LICENSE", fs.join(versionDir, "LICENSE"))
    end)
    if not success then
        error("Failed to copy LICENSE: " .. tostring(err))
    end
    
    print("Created distribution in " .. versionDir)
end

createDistribution() 