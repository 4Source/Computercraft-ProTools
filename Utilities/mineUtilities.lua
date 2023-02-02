-- ProTools by 4Source 
-- Mine Utilities  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/gba5abkG
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'local mine_util = require("ProTools.Utilities.mineUtilities")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------
local log = require("ProTools.Utilities.logger")
 
----------- Variables -----------
-- Name of self
local THIS = "mine_util" 

----------- Functions -----------
----- Move Functions -----
-- Turtle turn left
function turnLeft()
    local done_turtle_turn_left = turtle.turnLeft()
    -- if not done_turtle_turn_left then return false, "Turtle failed to turn left." end
    if not done_turtle_turn_left then 
        print("Turtle failed to turn left.")
        return false, "Turtle failed to turn left."
    end
 
    state.dir_x, state.dir_z = -state.dir_z, state.dir_x
    saveState()
    print("turnLeft")
    return true
end
 
-- Turtle turn rigth
function turnRight()
    local done_turtle_turn_right = turtle.turnRight()
    -- if not done_turtle_turn_right then return false, "Turtle failed to turn right." end
    if not done_turtle_turn_right then 
        print("Turtle failed to turn right.")
        return false, "Turtle failed to turn right."
    end
 
    state.dir_x, state.dir_z = state.dir_z, -state.dir_x
    saveState()
    print("turnRight")
    return true
end 
 
-- Turtle move up. Returns false if failed.
function up()
    local done_turtle_up = turtle.up()
    -- if not done_turtle_up then return false, "Turtle failed to move up." end
    if not done_turtle_up then
        print("Turtle failed to move up.")
        return false, "Turtle failed to move up."
    end
 
    state.pos_y = state.pos_y + 1
    saveState()
    print("up")
    return true
end
 
-- Turtle move down. Returns false if failed.  
function down()
    local done_turtle_down = turtle.down()
    -- if not done_turtle_down then return false, "Turtle failed to move down." end
    if not done_turtle_down then 
        print("Turtle failed to move down.")
        return false, "Turtle failed to move down."
    end
 
    state.pos_y = state.pos_y - 1
    saveState()
    print("down")
    return true
end
 
-- Turtle move forward. Returns false if failed.  
function forward()
    local done_turtle_forward = turtle.forward()
    -- if not done_turtle_forward then return false, "Turtle failed to move forward." end
    if not done_turtle_forward then 
        print("Turtle failed to move forward.")
        return false, "Turtle failed to move forward."
    end
 
    state.pos_x = state.pos_x + state.dir_x
    state.pos_z = state.pos_z + state.dir_z
    saveState()
    print("forward")
    return true
end  

----- Digging Functions -----
-- Return false if there is no possibly way to move 
function digForward()
    print("digForward")
    turtle.dig()
    
    local done_forward, msg = forward()
    if not done_forward then return false, msg end
    
    state.last_x = state.pos_x 
    state.last_z = state.pos_z 
    saveState()
 
    -- turtle.digUp()
    -- turtle.digDown()
 
    -- checkItems()
    print("end digForward")
    return true
end 
 
-- Return false if there is no possibly way to move 
function digDown()
    print("digDown")
    turtle.digDown()
    
    local done_down, msg = down()
    if not done_down then return false, msg end
    
    state.last_y = state.pos_y 
    saveState()
 
    print("end digDown")
    return true
end  

----------- Run -----------

----------- Return -----------
return{
    
}
