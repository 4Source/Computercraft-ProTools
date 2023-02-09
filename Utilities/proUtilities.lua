-- ProTools by 4Source 
-- Pro Utilities 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/nnMQE7U9
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'pro_util = pro_util or require("ProTools.Utilities.proUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
pro_util = {}

----------- Require -----------
 
----------- Variables -----------
-- Name of self
local THIS = "pro_util"

----------- Functions -----------
-- Split Sting 
function pro_util.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end 

-- Returns formated sting with variable name, type and value 
function pro_util.varToString(var, var_name, opts)
    local v_name = var_name or "" 
    local v_type = type(var) or ""
    local v_value

    if v_type == "boolean" then
        v_value = textutils.serialise(var) or ""
    elseif v_type == "table" then
        v_value = textutils.serialise(var, opts) or ""
    elseif v_type == "nil" then
        v_value = textutils.serialise(var) or ""
    else
        v_value = var or ""
    end

    return v_name.."("..v_type.."): "..v_value
end 

----------- Run -----------

----------- Return -----------
return pro_util