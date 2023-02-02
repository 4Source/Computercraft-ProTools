-- ProTools by 4Source 
-- File Manager 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/8nBVnDHu
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'local file_manager = require("ProTools.Utilities.fileManager")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------
local pro_util = require("ProTools.Utilities.proUtilities")
local log = require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "file_manager"
 

----------- Functions -----------
-- Create/Open JSON file and safe data
local function saveJSON( file_path, data_in )
    local file = io.open(file_path,"w")
    if not file then return false end 
    if file:write(textutils.serializeJSON(data_in)) then 
        return file:close()
    else 
        return false
    end
end
 
-- Load JSON file if exists and return Data
local function loadJSON( file_path )
    -- Get file, if exists
    local file = io.open(file_path,"r")
    local data = {}
    if not file then return false
    else 
        data = textutils.unserializeJSON(file:read("*a"))
        file:close()
    end
    return true, data
end 

-- Create/Open file and safe data
local function saveFile( file_path, data_in )
    local file = io.open(file_path,"w")
    if not file then return false end 
    if file:write(textutils.serialize(data_in)) then 
        return file:close()
    else 
        return false
    end
end

-- Load file if exists and return Data 
local function loadFile( file_path )
    -- Get file, if exists
    local file = io.open(file_path,"r")
    local data = {}
    if not file then return false
    else 
        data = textutils.unserialize(file:read("*a"))
        file:close()
    end
    return true, data
end 

-- Append to existing file or create new one
local function appendFile(file_path, data_in)
    local file = io.open(file_path,"a")
    if not file then return false end 
    if file:write(textutils.serialize(data_in).."\n") then 
        return file:close()
    else 
        return false
    end
end
 
-- Check Version compatibility
-- Conditions: match(MAJOR and MINOR)
local function versionCompatible(v1, v2) 
    if v1 ~= v2 then 
        local v1_labels = pro_util.split(v1, ".")
        local v2_labels = pro_util.split(v2, ".")
        if v1_labels[1] ~= v2_labels[1] or v1_labels[2] ~= v2_labels[2] then 
            return false 
        end
    end 
    return true 
end

----------- Run -----------

----------- Return -----------
return{
    saveJSON = saveJSON,
    loadJSON = loadJSON,
    saveFile = saveFile,
    loadFile = loadFile,
    appendFile = appendFile,
    versionCompatible = versionCompatible
}