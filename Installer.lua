-- ProTools by 4Source 
-- Installer  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/wHmS4pNS
-- Install: 'pastebin run wHmS4pNS'
-- Update: 'pastebin run wHmS4pNS update'

----------- Helper functions -----------
function ensureOverride(program)
    print("Are you shoure you want to override "..program.."? (y/n): ")
    local input = io.read()
    if input == "y" then
        return true
    elseif input == "n" then 
        return false
    else
        return 
    end
end 

function removeProgram(path)
    if fs.exists(path) then 
        local sure 
        while sure == nil do 
            sure = ensureOverride(path)
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

function updateProgram(name, pasteCode)
	if removeProgram(name) then 
		shell.run("pastebin", "get", pasteCode, name)
        print("Update Success.")
        return
	end
    print("Update Failed.")
end 

function installProgram(name, pasteCode)
    if fs.exists(name) then 
        print("Programm "..name.." exist allready. Installion Failed!")
        print("To update programs use 'update' Argument.")
        return 
    end
    shell.run("pastebin", "get", pasteCode, name)
    print("Installation Success.")
end


----------- RUN -----------
-- Check for input arguments 
local tArgs = { ... }
if #tArgs == 1 then 
    if tArgs[1] == "update" then      
        -- ExcavatePro Update
        updateProgram("ExcavatePro", "UmUvXfqs")

    end
elseif #tArgs == 0 then
    -- ExcavatePro Installation
    installProgram("ExcavatePro", "UmUvXfqs")

else 
    print("Invalid Arguments")
end