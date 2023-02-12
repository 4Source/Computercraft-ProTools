-- ProTools by 4Source 
-- UI Utilities  
-- Version: v0.1.0-alpha
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/iLvyjQYn 
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'ui_util = ui_util or require("ProTools.Utilities.uiUtil")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
ui_util = {}

----------- Require -----------
pro_util = pro_util or require("ProTools.Utilities.proUtilities")
log = log or require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "ui_util"
 

----------- Functions -----------
-- Make sure the player wants to do it 
function ui_util.ensure(question)
    log.verbose(question.." (y/n): ", THIS, true)
    local input = io.read()
    if input == "y" then
        return true
    elseif input == "n" then 
        return false
    else
        return nil
    end
end 

-- Get Input from UI
function ui_util.requestInput(input_text, helper_text)
    if not input_text then return false end
 
    -- Setup UI 
    term.clear()
    term.setCursorPos(1, 1)
    io.write(input_text)
    log.verbose(input_text, THIS, false)
    
    if helper_text then 
        c_pos_x, c_pos_y = term.getCursorPos()
        print("")
        print("")
        log.verbose(helper_text, THIS, true)
        term.setCursorPos(c_pos_x, c_pos_y)
    end
    
    -- Get Input from UI
    input = io.read()
 
    -- Clear UI
    term.clear()
    term.setCursorPos(1, 1)
    
    -- Return args
    return pro_util.split(input)
end 

-- Wait for any key press
local function anykey()

end 

----------- Return -----------
return ui_util