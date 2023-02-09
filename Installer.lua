-- ProTools by 4Source 
-- Installer  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/wHmS4pNS
-- Install: 'pastebin run wHmS4pNS'
-- Update: 'pastebin run wHmS4pNS update'
-- Reinstall: 'pastebin run wHmS4pNS reinstall'
-- Deinstall: 'pastebin run wHmS4pNS deinstall'
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  
 
P_VERSION = "0.1.0"
UTIL_PATH = "/ProTools/Utilities"

-- Modules for the Executables
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
    },
    {
        name = "moveUtilities",
        path = UTIL_PATH,
        paste_code = "ck1uNLfV"
    },
    {
        name = "mineUtilities",
        path = UTIL_PATH,
        paste_code = "gba5abkG"
    }
}

-- List of Executable Programms
program_list = {
    {
        name = "ExcavatePro",
        path = "",
        paste_code = "UmUvXfqs"
    }
}

-- List of Executable Programms
default_config_list = {
    {   
        name = "config",
        path = "/ProTools/ExcavatePro",
        paste_code = "W6KuhCeR",
        program = "ExcavatePro"
    }
}

-- Files they are user specific 
ufile_list = {
    {   
        name = "state",
        path = "/ProTools"
    },
    {   
        name = "log",
        path = "/ProTools"
    },
    {   
        name = "config",
        path = "/ProTools/ExcavatePro"
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

local is_install 
local is_update  
local is_deinstall
local is_reset

buildView()
print("running...")

----- User inputs -----
-- Check for input arguments 
local tArgs = { ... }

-- Update all Programs or Specified ones. Don't Change configs, state or log files
if #tArgs >= 1 and tArgs[1] == "update" then 
    is_install = true
    is_update = true
    is_deinstall = false

    -- for loop thrue args to see wich program should be updated

-- Deinstall everything and remove all files and Install everything
elseif #tArgs == 1 and tArgs[1] == "reinstall" then 
    is_install = true
    is_update = false
    is_deinstall = true

-- Deinstall everything and remove all files
elseif #tArgs == 1 and tArgs[1] == "deinstall" then 
    is_install = false
    is_update = false
    is_deinstall = true

-- Install everything 
elseif #tArgs == 0 then
    is_install = true
    is_update = false
    is_deinstall = false

-- Reset config to default
elseif #tArgs > 1 and tArgs[1] == "reset" then 
    is_install = false
    is_update = false
    is_deinstall = false
    is_reset = true

    if not (#tArgs == 2 and tArgs[2] == "all") then
        local conf = {}

        for i=2, #tArgs do 
            local match 
            for key, value in pairs(default_config_list) do
                if tArgs[i] == value.program then 
                    match = true
                    table.insert(conf, value)
                end
            end
            if not match then 
                print("Invalid argument at "..i)
                return
            end
        end

        default_config_list = conf
    end
else 
    buildView()
    print("Invalid Arguments! Try Again.\n\nINSTALLATION:\npastebin run wHmS4pNS\nUPDATE:\npastebin run wHmS4pNS update\nREINSTALLATION:\npastebin run wHmS4pNS reinstall\nDEINSTALLATION:\npastebin run wHmS4pNS deinstall")
    return 
end

----- Delete Files -----
if is_deinstall then 
    for key, value in pairs(module_list) do
        if removeFile(value.path.."/"..value.name, true) then 
            remove_success = remove_success + 1
        end
        remove_total = remove_total + 1
    end
    for key, value in pairs(program_list) do
        if removeFile(value.path.."/"..value.name, true) then 
            remove_success = remove_success + 1
        end
        remove_total = remove_total + 1
    end
    for key, value in pairs(ufile_list) do
        if removeFile(value.path.."/"..value.name, true) then 
            remove_success = remove_success + 1
        end
        remove_total = remove_total + 1
    end
end

----- Modules ----- 
if is_install then
    for key, value in pairs(module_list) do
        ensurePath(value.path)
        if downloadFile(value.path.."/"..value.name, value.paste_code, is_update) then
            install_module_success = install_module_success + 1
            download_success= download_success + 1
        end 
        install_module_total= install_module_total + 1
        download_total= download_total + 1
    end
end

----- Programs ----- 
if is_install then
    for key, value in pairs(program_list) do
        ensurePath(value.path)
        if downloadFile(value.path.."/"..value.name, value.paste_code, is_update) then
            install_program_success = install_program_success + 1
            download_success = download_success + 1
        end 
        install_program_total= install_program_total + 1
        download_total= download_total + 1
    end
end

----- Default Config ----- 
if (is_install and not is_update) or is_reset then
    for key, value in pairs(default_config_list) do
        ensurePath(value.path)
        if downloadFile(value.path.."/"..value.name, value.paste_code, true) then
            download_config_success = download_config_success + 1
            download_success = download_success + 1
        end 
        download_config_total= download_config_total + 1
        download_total= download_total + 1
    end
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
