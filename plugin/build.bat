@echo Off

copy ".\src\Error.rbxmx" ".\bundle\Error.rbxmx"
copy ".\src\Widget.rbxmx" ".\bundle\Widget.rbxmx"
copy "..\build\.darklua.json" ".\.darklua.json"

darklua process "./src/init.server.luau" "./bundle/init.server.lua"
rojo build bundle.project.json --output "%LocalAppData%\Roblox\Plugins\Blink.rbxmx"