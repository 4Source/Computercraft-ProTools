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
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  
 
 P_VERSION = "0.1.0"

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

function buildView()
    term.clear()
    term.setCursorPos(1, 1)
    print("ProTools Installer v"..P_VERSION)
    print("")
end

-- Make sure we have the directory  
function ensurePath(path)
    if not fs.exists(path) then 
        fs.makeDir(path)
    end 
end

function removeFile(path, force)
    if fs.exists(path) then 
        local sure = force 

        while sure == nil do 
            sure = ensure("Are you sure you want to remove "..path.."?")
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
    local success
    if fs.exists(path) then 
        local sure = force

        while sure == nil do 
            sure = ensure("Are you sure you want to update "..path.."?")
        end
        if sure then 
            fs.delete(path)
            success = shell.run("pastebin", "get", pasteCode, path)
            print("Update Successful.")
        else 
            success = false
            print("Update Canceled.") 
        end
    else 
        success = shell.run("pastebin", "get", pasteCode, path)
        print("Download Successful.")
    end
    return success
end 

----------- RUN -----------
local install_success = 0
local install_total = 0
local remove_success = 0
local remove_total = 0
local is_update 
local clean_state 
local clean_log
local default_config_excavate_pro 

buildView()
print("running...")

----- User inputs -----
-- Check for input arguments 
local tArgs = { ... }
if #tArgs <= 1 and tArgs[1] == "update" then 
    if #tArgs == 1 then 
        is_update = tArgs[1] == "update"
    else
        -- for loop thrue args to see wich program should be updated
    end
elseif #tArgs == 0 then
    is_update = false 
    --default_config_excavate_pro = true
else 
    buildView()
    print("Invalid Arguments! Try Again.")
    return 
end

-- Ask if state should be reset
while clean_state == nil do 
    buildView()
    if not fs.exists("/ProTools/state") then 
        clean_state = false 
    else
        clean_state = ensure("Should the state be deleted?")
    end
end

-- Ask if log should be reset
while clean_log == nil do 
    buildView()
    if not fs.exists("/ProTools/log") then 
        clean_log = false 
    else
        clean_log = ensure("Should the log be deleted?")
    end
end

-- Ask if config should be reset
while default_config_excavate_pro == nil do 
    buildView()
    if not fs.exists("/ProTools/ExcavatePro/config") then 
        default_config_excavate_pro = true 
    else
        default_config_excavate_pro = ensure("Should the configuration for ExcavatePro be reset to default?")
    end
end

----- State -----
-- State Clean Up 
if clean_state then 
    -- Delete State File
    if removeFile("/ProTools/state", clean_state) then 
        remove_success = remove_success + 1
    end
    remove_total = remove_total + 1
end 

-- Log Clean Up 
if clean_log then 
    -- Delete State File
    if removeFile("/ProTools/log", clean_log) then 
        remove_success = remove_success + 1
    end
    remove_total = remove_total + 1
end 

----- Config ----- 
-- ExcavatePro Config Update
if default_config_excavate_pro then
    if downloadFile("/ProTools/ExcavatePro/config", "W6KuhCeR", default_config_excavate_pro) then 
        install_success = install_success + 1
    end 
    install_total = install_total+ 1
end

----- File System -----
-- Ensure Utilities path exist
ensurePath("/ProTools/Utilities")
-- Ensure ExcavatePro Config path exist
ensurePath("/ProTools/ExcavatePro")  


----- Utilities -----
-- proUtilities Install/Update 
if downloadFile("/ProTools/Utilities/proUtilities", "nnMQE7U9", is_update) then 
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- inventoryManager Install/Update
if downloadFile("/ProTools/Utilities/inventoryManager", "9RTF5CDF", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- fuelManager Install/Update
if downloadFile("/ProTools/Utilities/fuelManager", "dNEyanjZ", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- fileManager Install/Update
if downloadFile("/ProTools/Utilities/fileUtilities", "8nBVnDHu", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- uiUtil Install/Update
if downloadFile("/ProTools/Utilities/uiUtil", "iLvyjQYn", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- mineUtilities Install/Update
if downloadFile("/ProTools/Utilities/mineUtilities", "gba5abkG", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- stateManager Install/Update
if downloadFile("/ProTools/Utilities/stateManager", "fkVjJJME", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- configManager Install/Update
if downloadFile("/ProTools/Utilities/configManager", "SkTYkVhV", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

-- logger Install/Update
if downloadFile("/ProTools/Utilities/logger", "c7evHdJg", is_update) then
    install_success = install_success + 1
end 
install_total = install_total+ 1

----- Programs ----- 
-- ExcavatePro Update
if downloadFile("ExcavatePro", "UmUvXfqs", is_update) then
    install_success = install_success + 1
end 
install_total= install_total+ 1

-- Excavate Test 
if downloadFile("ExcavateTest", "VKXH5kjq", is_update) then 
    install_success = install_success + 1
end 
install_total= install_total+ 1
   

----- Finished ----- 
term.clear()
term.setCursorPos(1, 1)

buildView()
if remove_success ~= remove_total then 
    print("Something went wrong by removing files.")
elseif install_success ~= install_total then
    print("Something went wrong by downloading files.")
else
    print("Successfully completed.")
end
if remove_total > 0 then
    print("Removed: ("..remove_success.."/"..remove_total..")")
end
if install_total > 0 then 
    print("Downloaded: ("..install_success.."/"..install_total..")")
end 
