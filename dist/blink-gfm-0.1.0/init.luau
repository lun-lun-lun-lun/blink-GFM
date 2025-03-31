--!strict
--!optimize 2

local Version = require("./src/Version")
local Generator = require("./src/Generator")

return {
    Version = Version,
    Generator = Generator,
}
