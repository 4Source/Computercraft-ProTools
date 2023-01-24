-- ProTools by 4Source 
-- Installer  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/wHmS4pNS
-- Install: 'pastebin run wHmS4pNS'
-- Update: 'pastebin run wHmS4pNS update'
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
------ boolean: starts with 'b'  (bIS_CONSTANTS_EXAMPEL) formulated as a statement
-- Variables: Lowercase and Underscores (variable_example)
-- Functions: Camelcase (functionExample)  
 

----------- Helper functions -----------
function ensure(question)
    print(question.." (y/n): ")
    local input = io.read()
    if input == "y" then
        return true
    elseif input == "n" then 
        return false
    else
        return nil
    end
end 

-- Make sure we have the directory  
function ensurePath(path)
    if not fs.exists(path) then 
        fs.makeDir(path)
    end 
end

function removeFile(path, force)
    if fs.exists(path) then 
        local sure 
        if force then 
            sure = true
        end
        while sure == nil do 
            sure = ensure("Are you shoure you want to remove "..path.."?")
        end
        if sure then 
            fs.delete(path)
            return true
        else 
            print("Canceled...")
            return false
        end
    else 
        return true
    end
end

function downloadFile(path, pasteCode, force)
    if fs.exists(path) then 
        local sure 
        if force then 
            sure = true
        end
        while sure == nil do 
            sure = ensure("Are you shoure you want to update "..path.."?")
        end
        if sure then 
            fs.delete(path)
            shell.run("pastebin", "get", pasteCode, path)
            print("Update Successful.")
        else 
            print("Update Canceled.") 
        end
    else 
        shell.run("pastebin", "get", pasteCode, path)
        print("Download Successful.")
    end
end 

----------- RUN -----------
local is_update 
local clean_state 
local default_config_excavate_pro 

----- User inputs -----
-- Check for input arguments 
local tArgs = { ... }
if #tArgs == 1 and tArgs[1] == "update" then 
    is_update = tArgs[1] == "update"
elseif #tArgs == 0 then
    is_update = false 
    default_config_excavate_pro = true
else 
    print("Invalid Arguments! Try Again.")
    return 
end

-- Ask if state should be reset
while clean_state == nil and not is_update do 
    clean_state = ensure("Should the state be deleted?")
end

-- Ask if config should be reset
while default_config_excavate_pro == nil and not is_update do 
    default_config_excavate_pro = ensure("Should the configuration for ExcavatePro be reset to default?")
end

----- State -----
-- State Clean Up 
if is_update or clean_state then 
    -- Delete State File
    removeFile("/ProTools/state", clean_state)  
end 

----- Config ----- 
-- ExcavatePro Config Update
if is_update or default_config_excavate_pro then
    downloadFile("/ProTools/ExcavatePro/config", "W6KuhCeR", default_config_excavate_pro) 
end

----- File System -----
-- Ensure Utilities path exist
ensurePath("/ProTools/Utilities")
-- Ensure ExcavatePro Config path exist
ensurePath("/ProTools/ExcavatePro")  


----- Utilities -----
-- proUtilities Install/Update 
downloadFile("/ProTools/Utilities/proUtilities", "nnMQE7U9", is_update)
-- inventoryManager Install/Update
downloadFile("/ProTools/Utilities/inventoryManager", "9RTF5CDF", is_update)
-- fuelManager Install/Update
downloadFile("/ProTools/Utilities/fuelManager", "dNEyanjZ", is_update)
-- fileManager Install/Update
downloadFile("/ProTools/Utilities/fileManager", "8nBVnDHu", is_update)
-- uiUtil Install/Update
downloadFile("/ProTools/Utilities/uiUtil", "iLvyjQYn", is_update)
-- mineUtilities Install/Update
downloadFile("/ProTools/Utilities/mineUtilities", "gba5abkG", is_update)
-- stateManager Install/Update
downloadFile("/ProTools/Utilities/stateManager", "fkVjJJME", is_update)
-- configManager Install/Update
downloadFile("/ProTools/Utilities/configManager", "SkTYkVhV", is_update)

----- Programs ----- 
-- ExcavatePro Update
downloadFile("ExcavatePro", "UmUvXfqs", is_update)
   
