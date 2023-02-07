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
UTIL_PATH = "/ProTools/Utilities"

module_list = {
    {   
        name = "proUtilities",
        path = UTIL_PATH,
        paste_code = "nnMQE7U9"
    },
    {
        name = "logger",
        path = UTIL_PATH,
        paste_code = "c7evHdJg"
    },
    {
        name = "stateManager",
        path = UTIL_PATH,
        paste_code = "fkVjJJME"
    },
    {
        name = "configManager",
        path = UTIL_PATH,
        paste_code = "SkTYkVhV"
    },
    {
        name = "fileUtilities",
        path = UTIL_PATH,
        paste_code = "8nBVnDHu"
    },
    {
        name = "uiUtil",
        path = UTIL_PATH,
        paste_code = "iLvyjQYn"
    }
}

program_list = {
    {
        name = "ExcavatePro",
        path = "",
        paste_code = "UmUvXfqs"
    }
}

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

function removeFile(path, force, not_clean_empty)
    if fs.exists(path) then 
        local sure 
        if force then 
            sure = true
        end

        while sure == nil do 
            sure = ensure("Are you sure you want to remove "..path.."?")
        end
        if sure then 
            fs.delete(path)

            if not not_clean_empty then
                local parant_dir = fs.getDir(path)
                local files = fs.list(parant_dir)
                while #files == 0 do 
                    fs.delete(parant_dir)
                    parant_dir = fs.getDir(parant_dir)
                    files = fs.list(parant_dir)
                end
            end
            return true
        else 
            print("Canceled...")
            return false
        end
    else 
        return true
    end
end

function downloadFile(path, paste_code, force)
    local success
    if fs.exists(path) then 
        local sure 
        if force then 
            sure = true
        end

        while sure == nil do 
            sure = ensure("Are you sure you want to update "..path.."?")
        end
        if sure then 
            fs.delete(path)
            success = shell.run("pastebin", "get", paste_code, path)
            print("Update Successful.")
        else 
            success = false
            print("Update Canceled.") 
        end
    else 
        success = shell.run("pastebin", "get", paste_code, path)
        print("Download Successful.")
    end
    return success
end 

----------- RUN -----------
local download_success = 0
local download_total = 0
local install_module_success = 0
local install_module_total = 0
local install_program_success = 0
local install_program_total = 0
local download_config_success = 0
local download_config_total = 0
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
        download_config_success = download_config_success + 1
        download_success= download_success + 1
    end 
    download_config_total = download_config_total + 1
    download_total= download_total + 1
end

----- File System -----
-- Ensure Utilities path exist
ensurePath(UTIL_PATH)
-- Ensure ExcavatePro Config path exist
ensurePath("/ProTools/ExcavatePro")  

----- Install Modules ----- 
for key, value in pairs(module_list) do
    if downloadFile(value.path.."/"..value.name, value.paste_code, is_update) then
        install_module_success = install_module_success + 1
        download_success= download_success + 1
    end 
    install_module_total= install_module_total + 1
    download_total= download_total + 1
end

----- Install Programs ----- 
for key, value in pairs(program_list) do
    if downloadFile(value.path.."/"..value.name, value.paste_code, is_update) then
        install_program_success = install_program_success + 1
        download_success = download_success + 1
    end 
    install_program_total= install_program_total + 1
    download_total= download_total + 1
end


----- Finished ----- 
term.clear()
term.setCursorPos(1, 1)

buildView()
if remove_success ~= remove_total then 
    print("Something went wrong by removing files.")
elseif download_success ~= download_total then
    print("Something went wrong by downloading files.")
else
    print("Successfully completed.")
end
if remove_total > 0 then
    print("Removed: ("..remove_success.."/"..remove_total..")")
end
if download_total > 0 then 
    print("Downloaded: ("..download_success.."/"..download_total..")")
end 

if install_module_total > 0 or install_program_total > 0 or download_config_total > 0 then 
    print("--------------------")
end

if install_module_total > 0 then 
    print("\t\t\tModules: ("..install_module_success.."/"..install_module_total..")")
end 

if install_program_total > 0 then 
    print("\t\tPrograms: ("..install_program_success.."/"..install_program_total..")")
end 

if download_config_total > 0 then 
    print("\t\t\t\tConfig: ("..download_config_success.."/"..download_config_total..")")
end 
