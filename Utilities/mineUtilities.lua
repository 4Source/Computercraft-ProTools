-- ProTools by 4Source 
-- Mine Utilities  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/gba5abkG
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'mine_util = mine_util or require("ProTools.Utilities.mineUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
mine_util = {}

----------- Require -----------
log = log or require("ProTools.Utilities.logger")
 
----------- Variables -----------
-- Name of self
local THIS = "mine_util" 

----------- Functions -----------
----- Digging Functions -----
-- Return false if there is no possibly way to move 
function mine_util.forward()
    local done_turtle_forward
    local detect_turtle_forward = turtle.detect() 
    if detect_turtle_forward then 
        done_turtle_forward = turtle.dig()
    else
        done_turtle_forward = true
    end

    if not done_turtle_forward then 
        log.verbose("Turtle failed to dig forward.", THIS)
        sleep( 0.5 )
        return false
    end
    
    if (state_manager.state.progress.dir_x == 1 or state_manager.state.progress.dir_x == -1) 
    and state_manager.state.progress.dir_z == 0 then
        state_manager.setProgress()
        state_manager.state.progress.pos_x = state_manager.state.progress.pos_x + state_manager.state.progress.dir_x
        state_manager.saveState()
        log.debug(pro_util.varToString(state_manager.state.progress.pos_x, "state.progress.pos_x"), THIS) 

    elseif(state_manager.state.progress.dir_z == 1 or state_manager.state.progress.dir_z == -1) 
    and state_manager.state.progress.dir_x == 0 then
        state_manager.setProgress()
        state_manager.state.progress.pos_z = state_manager.state.progress.pos_z + state_manager.state.progress.dir_z
        state_manager.saveState()
        log.debug(pro_util.varToString(state_manager.state.progress.pos_z, "state.progress.pos_z"), THIS) 
    else
        log.error("Invalid digging state by dig forward. Out of sync!", THIS)
        state_manager.state.error = true
        state_manager.saveState()
        return false
    end
    

    log.verbose("Turtle successfully dig forward.", THIS)
    return true
end 
 
-- Return false if there is no possibly way to move 
function mine_util.down()
    local done_turtle_down
    local detect_turtle_down = turtle.detectDown() 
    if detect_turtle_down then 
        done_turtle_down = turtle.digDown()
    else
        done_turtle_down = true
    end
    
    if not done_turtle_down then 
        log.verbose("Turtle failed to dig down.", THIS)
        sleep( 0.5 )
        return false
    end
    
    state_manager.setProgress()
    state_manager.state.progress.pos_y = state_manager.state.progress.pos_y - 1
    state_manager.saveState()
    log.debug(pro_util.varToString(state_manager.state.progress.pos_y, "state.progress.pos_y"), THIS)

    log.verbose("Turtle successfully dig down.", THIS)
    return true
end 

-- Return false if there is no possibly way to move 
function mine_util.up()
    local done_turtle_up
    local detect_turtle_up = turtle.detectUp() 
    if detect_turtle_up then 
        done_turtle_up = turtle.digUp()
    else
        done_turtle_up = true
    end
    
    if not done_turtle_up then 
        log.verbose("Turtle failed to dig up.", THIS)
        sleep( 0.5 )
        return false
    end
    
    state_manager.setProgress()
    state_manager.state.progress.pos_y = state_manager.state.progress.pos_y + 1
    state_manager.saveState()
    log.debug(pro_util.varToString(state_manager.state.progress.pos_y, "state.progress.pos_y"), THIS)

    log.verbose("Turtle successfully dig up.", THIS)
    return true
end  

----------- Run -----------

----------- Return -----------
return mine_util
