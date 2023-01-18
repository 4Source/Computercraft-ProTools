-- ProTools by 4Source 
-- Installer  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/wHmS4pNS
-- Installation: pastebin run wHmS4pNS

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
    if fs.exist(path) then 
        local sure 
        while sure == nil do 
            sure = ensureOverride(path)
        end
        if sure then 
            fs.delete(path)
            return true
        else 
            return false
        end
    else 
        return false
    end
end

function updateProgram(name, pasteCode)
    removeProgram(name)

    shell.execute("pastebin", "get "..pasteCode.." "..path)
end 


----------- RUN -----------
-- ExcavatePro Installation
updateProgram("ExcavatePro", "UmUvXfqs")