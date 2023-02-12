-- ProTools by 4Source 
-- Mine Utilities  
-- Version: v0.1.0-alpha
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
state_manager = state_manager or require("ProTools.Utilities.stateManager")
log = log or require("ProTools.Utilities.logger")
 
----------- Variables -----------
-- Name of self
local THIS = "mine_util" 

----------- Functions -----------
----- Digging Functions -----
-- Return false if there is no possibly way to move 
function mine_util.forward()
    if turtle.detect() then 
        log.verbose("Turtle detected forward.", THIS)
        if not turtle.dig() then 
            log.verbose("Turtle failed to dig forward.", THIS)
            sleep( 0.5 )
            return false
        end        
    end

    state_manager.state.progress.pos_x = state_manager.state.current.pos_x + state_manager.state.current.dir_x
    state_manager.state.progress.pos_z = state_manager.state.current.pos_z + state_manager.state.current.dir_z
    state_manager.state.progress.dir_x, state_manager.state.progress.dir_z = state_manager.state.current.dir_x, state_manager.state.current.dir_z
    state_manager.saveState()
    
    log.debug({
        pro_util.varToString(state_manager.state.progress.pos_z, "state.progress.pos_z"),
        pro_util.varToString(state_manager.state.progress.pos_x, "state.progress.pos_x"), 
        pro_util.varToString(state_manager.state.progress.pos_y, "state.progress.pos_y"),
        pro_util.varToString(state_manager.state.progress.dir_z, "state.progress.dir_z"), 
        pro_util.varToString(state_manager.state.progress.dir_x, "state.progress.dir_x") 
    }, THIS) 

    if (state_manager.state.progress.dir_x == 1 or state_manager.state.progress.dir_x == -1) 
    and (state_manager.state.progress.dir_z == 1 or state_manager.state.progress.dir_z == -1) then
        state_manager.state.error = true
        state_manager.saveState()

        log.error("Invalid digging state by dig forward. Out of sync!", THIS)
        return false
    end    

    log.verbose("Turtle successfully dig forward.", THIS)
    return true
end 
 
-- Return false if there is no possibly way to move 
function mine_util.down()
    if turtle.detectDown() then 
        if not turtle.digDown() then 
            log.verbose("Turtle failed to dig down.", THIS)
            sleep( 0.5 )
            return false
        end
    end
    
    state_manager.state.progress.pos_y = state_manager.state.progress.pos_y - 1
    state_manager.state.progress.dir_x, state_manager.state.progress.dir_z = state_manager.state.current.dir_x, state_manager.state.current.dir_z
    state_manager.saveState()

    log.debug({
        pro_util.varToString(state_manager.state.progress.pos_z, "state.progress.pos_z"),
        pro_util.varToString(state_manager.state.progress.pos_x, "state.progress.pos_x"), 
        pro_util.varToString(state_manager.state.progress.pos_y, "state.progress.pos_y"),
        pro_util.varToString(state_manager.state.progress.dir_z, "state.progress.dir_z"), 
        pro_util.varToString(state_manager.state.progress.dir_x, "state.progress.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully dig down.", THIS)
    return true
end 

-- Return false if there is no possibly way to move 
function mine_util.up()
    if turtle.detectUp() then 
        if not turtle.digUp() then 
            log.verbose("Turtle failed to dig up.", THIS)
            sleep( 0.5 )
            return false
        end
    end
    
    state_manager.state.progress.pos_y = state_manager.state.progress.pos_y + 1
    state_manager.state.progress.dir_x, state_manager.state.progress.dir_z = state_manager.state.current.dir_x, state_manager.state.current.dir_z
    state_manager.saveState()

    log.debug({
        pro_util.varToString(state_manager.state.progress.pos_z, "state.progress.pos_z"),
        pro_util.varToString(state_manager.state.progress.pos_x, "state.progress.pos_x"), 
        pro_util.varToString(state_manager.state.progress.pos_y, "state.progress.pos_y"),
        pro_util.varToString(state_manager.state.progress.dir_z, "state.progress.dir_z"), 
        pro_util.varToString(state_manager.state.progress.dir_x, "state.progress.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully dig up.", THIS)
    return true
end  

----------- Return -----------
return mine_util
