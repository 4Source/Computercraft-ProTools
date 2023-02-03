-- ProTools by 4Source 
-- File Utilities 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/8nBVnDHu
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'file_util = file_util or require("ProTools.Utilities.fileUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
file_util = {}

----------- Require -----------
pro_util = pro_util or require("ProTools.Utilities.proUtilities")
ui_util = ui_util or require("ProTools.Utilities.uiUtil")
log = log or require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "file_util"
 

----------- Functions -----------
-- Make sure we have the directory  
function file_util.ensurePath(path)
    if not fs.exists(path) then 
        fs.makeDir(path)
    end 
end

-- Create/Open JSON file and safe data
function file_util.saveJSON( file_path, data_in )
    local file = io.open(file_path,"w")
    if not file then return false end 
    if file:write(textutils.serializeJSON(data_in)) then 
        return file:close()
    else 
        return false
    end
end
 
-- Load JSON file if exists and return Data
function file_util.loadJSON( file_path )
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
function file_util.saveFile( file_path, data_in )
    local file = io.open(file_path,"w")
    if not file then return false end 
    if file:write(textutils.serialize(data_in)) then 
        return file:close()
    else 
        return false
    end
end

-- Load file if exists and return Data 
function file_util.loadFile( file_path )
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
function file_util.appendFile(file_path, data_in)
    local file = io.open(file_path,"a")
    if not file then return false end 
    if file:write(textutils.serialize(data_in).."\n") then 
        return file:close()
    else 
        return false
    end
end

-- Delete File
function file_util.removeFile(path, force)
    if fs.exists(path) then 
        local sure = force

        while sure == nil do 
            sure = ui_util.ensure("Are you sure you want to remove "..path.."?")
        end
        if sure then 
            fs.delete(path)
            log.info("Delete "..path.." Successful.")
            return true
        else 
            log.info("Delete "..path.."canceled...", THIS)
            return false
        end
    else 
        return true
    end
end

-- Download File from pastbin
function file_util.downloadFile(path, pasteCode, force)
    local success
    if fs.exists(path) then 
        local sure = force

        while sure == nil do 
            sure = ui_util.ensure("Are you sure you want to update "..path.."?")
        end
        if sure then 
            fs.delete(path)
            success = shell.run("pastebin", "get", pasteCode, path)
            log.info("Update "..path.." Successful.")
        else 
            success = false
            log.info("Update "..path.." canceled...", THIS)
        end
    else 
        success = shell.run("pastebin", "get", pasteCode, path)
        log.info("Download "..path.." Successful.")
    end
    return success
end 

-- Check Version compatibility
-- Conditions: match(MAJOR and MINOR)
function file_util.versionCompatible(v1, v2) 
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
return file_util