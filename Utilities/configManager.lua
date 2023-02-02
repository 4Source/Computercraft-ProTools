-- ProTools by 4Source 
-- Config Manager 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/SkTYkVhV
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'local config_manager = require("ProTools.Utilities.configManager")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------
local file_manager = require("ProTools.Utilities.fileManager") 

----------- Variables -----------
local config_path, config_file_name = "/ProTools/ExcavatePro", "/config"

----------- Functions -----------
-- Inizialisation
local function init()
    -- Make sure we have the directory 
    if not fs.exists(config_path..config_file_name) then 
        if not fs.exists(config_path) then 
            fs.makeDir(config_path)
        end 
    end

end 

-- 
local function addCategory(category, configs)
    local exists, data = file_manager.loadJSON(config_path..config_file_name)
    if exists then 
        for i = 1, #data.CATEGORYS do
            if data.CATEGORYS[i].CATEGORY == category then 
                data.CATEGORYS[i] = configs
                file_manager.saveJSON(config_path..config_file_name, data)
                return 
            end
        end
        data.CATEGORYS = {}
        table.insert(data.CATEGORYS, configs)
        file_manager.saveJSON(config_path..config_file_name, data)
        return
    end 
end 

local function searchCategory(category)
    local exists, data = file_manager.loadJSON(config_path..config_file_name)
    if exists then 
        for i = 1, #data.CATEGORYS do
            if data.CATEGORYS[i].CATEGORY == category then 
                return data.CATEGORYS[i]
            end
        end
    end 
end 

----------- Run -----------
init()

----------- Return -----------
return{
    addCategory = addCategory,
    searchCategory = searchCategory
}