-- ProTools by 4Source 
-- Pro Utilities 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/nnMQE7U9
-- Installation: Run installer below for full installation.
-- Installer: pastebin run wHmS4pNS
-- Require: 'local pro_util = require("ProTools.Utilities.proUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------

----------- Variables -----------
-- Name of self
local THIS = "pro_util"

----------- Functions -----------
-- Split Sting 
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end 

----------- Run -----------

----------- Return -----------
return{
   split = split 
}