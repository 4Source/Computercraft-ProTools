-- ProTools by 4Source 
-- Move Utilities 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/ck1uNLfV 
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'move_util = move_util or require("ProTools.Utilities.moveUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
move_util = {}
 
----------- Require -----------
state_manager = state_manager or require("ProTools.Utilities.stateManager")
pro_util = pro_util or require("ProTools.Utilities.proUtilities")
log = log or require("ProTools.Utilities.logger")
 
----------- Variables -----------
-- Name of self
local THIS = "move_util"
 
----------- Functions ----------- 
-- Turtle turn left
function move_util.turnLeft()
    local done_turtle_turn_left = turtle.turnLeft()

    if not done_turtle_turn_left then 
        log.verbose("Turtle failed to turn left.", THIS)
        return false 
    end
    
    state_manager.state.current.dir_x, state_manager.state.current.dir_z = -state_manager.state.current.dir_z, state_manager.state.current.dir_x
    log.debug(pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x"), THIS)
    log.debug(pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), THIS) 
    state_manager.saveState()

    log.verbose("Turtle successfully turned left.", THIS)
    return true
end 

-- Turtle turn rigth
function move_util.turnRight()
    local done_turtle_turn_right = turtle.turnRight()
    
    if not done_turtle_turn_right then 
        log.verbose("Turtle failed to turn right.", THIS)
        return false
    end
    
    state_manager.state.current.dir_x, state_manager.state.current.dir_z = state_manager.state.current.dir_z, -state_manager.state.current.dir_x
    log.debug(pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x"), THIS)
    log.debug(pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), THIS)  
    state_manager.saveState()

    log.verbose("Turtle successfully turned right.", THIS)
    return true
end  

-- Turtle move up. Returns false if failed.
function move_util.up()
    local done_turtle_up = turtle.up()
    
    if not done_turtle_up then
        log.verbose("Turtle failed to move up.", THIS)
        return false
    end
    
    state_manager.state.current.pos_y = state_manager.state.current.pos_y + 1
    log.debug(pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"), THIS) 
    state_manager.saveState()

    log.verbose("Turtle successfully moved up.", THIS)
    return true
end 

-- Turtle move down. Returns false if failed.  
function move_util.down()
    local done_turtle_down = turtle.down()
    
    if not done_turtle_down then 
        log.verbose("Turtle failed to move down.", THIS)
        return false
    end
    
    state_manager.state.current.pos_y = state_manager.state.current.pos_y - 1
    log.debug(pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"), THIS)
    state_manager.saveState()

    log.verbose("Turtle successfully moved down.", THIS)
    return true
end 

-- Turtle move forward. Returns false if failed.  
function move_util.forward()
    local done_turtle_forward = turtle.forward()
    
    if not done_turtle_forward then 
        log.verbose("Turtle failed to move forward.", THIS)
        return false
    end
    
    state_manager.state.current.pos_x = state_manager.state.current.pos_x + state_manager.state.current.dir_x
    state_manager.state.current.pos_z = state_manager.state.current.pos_z + state_manager.state.current.dir_z
    log.debug(pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), THIS) 
    log.debug(pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"), THIS) 
    state_manager.saveState()

    log.verbose("Turtle successfully moved forward.", THIS)
    return true
end

----------- Run -----------
 
----------- Return -----------
return move_util