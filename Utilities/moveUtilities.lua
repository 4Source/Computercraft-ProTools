-- ProTools by 4Source 
-- Move Utilities 
-- Version: v0.1.0-alpha.1
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
    if not turtle.turnLeft() then 
        log.verbose("Turtle failed to turn left.", THIS)
        sleep( 0.5 )
        return false 
    end
    
    state_manager.state.current.dir_x, state_manager.state.current.dir_z = -state_manager.state.current.dir_z, state_manager.state.current.dir_x
    state_manager.saveState()

    log.debug({
        pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"),
        pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), 
        pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"),
        pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), 
        pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully turned left.", THIS)
    return true
end 

-- Turtle turn rigth
function move_util.turnRight()
    if not turtle.turnRight() then 
        log.verbose("Turtle failed to turn right.", THIS)
        sleep( 0.5 )
        return false
    end
    
    state_manager.state.current.dir_x, state_manager.state.current.dir_z = state_manager.state.current.dir_z, -state_manager.state.current.dir_x
    state_manager.saveState()

    log.debug({
        pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"),
        pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), 
        pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"),
        pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), 
        pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully turned right.", THIS)
    return true
end  

-- Turtle move up. Returns false if failed.
function move_util.up()
    if not turtle.up() then
        log.verbose("Turtle failed to move up.", THIS)
        sleep( 0.5 )
        return false
    end
    
    state_manager.state.current.pos_y = state_manager.state.current.pos_y + 1
    state_manager.saveState()

    log.debug({
        pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"),
        pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), 
        pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"),
        pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), 
        pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully moved up.", THIS)
    return true
end 

-- Turtle move down. Returns false if failed.  
function move_util.down()
    if not turtle.down() then 
        log.verbose("Turtle failed to move down.", THIS)
        sleep( 0.5 )
        return false
    end
    
    state_manager.state.current.pos_y = state_manager.state.current.pos_y - 1
    state_manager.saveState()
    
    log.debug({
        pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"),
        pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), 
        pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"),
        pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), 
        pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x") 
    }, THIS) 
    log.verbose("Turtle successfully moved down.", THIS)
    return true
end 

-- Turtle move forward. Returns false if failed.  
function move_util.forward()
    if not turtle.forward() then 
        log.verbose("Turtle failed to move forward.", THIS)
        sleep( 0.5 )
        return false
    end

    state_manager.state.current.pos_x = state_manager.state.current.pos_x + state_manager.state.current.dir_x
    state_manager.state.current.pos_z = state_manager.state.current.pos_z + state_manager.state.current.dir_z
    state_manager.saveState()
    
    log.debug({
        pro_util.varToString(state_manager.state.current.pos_z, "state.current.pos_z"),
        pro_util.varToString(state_manager.state.current.pos_x, "state.current.pos_x"), 
        pro_util.varToString(state_manager.state.current.pos_y, "state.current.pos_y"),
        pro_util.varToString(state_manager.state.current.dir_z, "state.current.dir_z"), 
        pro_util.varToString(state_manager.state.current.dir_x, "state.current.dir_x") 
    }, THIS) 

    if (state_manager.state.current.dir_x == 1 or state_manager.state.current.dir_x == -1) 
    and (state_manager.state.current.dir_z == 1 or state_manager.state.current.dir_z == -1) then
        state_manager.state.error = true
        state_manager.saveState()

        log.error("Invalid movement state by moving forward. Out of sync!", THIS)
        return false
    end

    log.verbose("Turtle successfully moved forward.", THIS)
    return true
end

function move_util.goTo( position )
	while state_manager.state.current.pos_y < position.pos_y do
        log.debug("Go up.", THIS)
		if not move_util.up() then
			sleep( 0.5 )
		end
	end

	if state_manager.state.current.pos_x > position.pos_x then
		while state_manager.state.current.dir_x ~= -1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_x > position.pos_x do
            log.debug("Go -X.", THIS)
			if not move_util.forward() then
				sleep( 0.5 )
			end
		end
    end

    if state_manager.state.current.pos_z > position.pos_z then
		while state_manager.state.current.dir_z ~= -1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_z > position.pos_z do
            log.debug("Go -Z.", THIS)
			if not move_util.forward() then
				sleep( 0.5 )
			end
		end
	end

    if state_manager.state.current.pos_z < position.pos_z then
		while state_manager.state.current.dir_z ~= 1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_z < position.pos_z do
            log.debug("Go +Z.", THIS)
			if not move_util.forward() then
				sleep( 0.5 )
			end
		end	
	end

	if state_manager.state.current.pos_x < position.pos_x then
		while state_manager.state.current.dir_x ~= 1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_x < position.pos_x do
            log.debug("Go +X.", THIS)
			if not move_util.forward() then
				sleep( 0.5 )
			end
		end
	end
	
	while state_manager.state.current.pos_y > position.pos_y do
        log.debug("Go down.", THIS)
		if not move_util.down() then
			sleep( 0.5 )
		end
	end
	
	while state_manager.state.current.dir_z ~= position.dir_z or state_manager.state.current.dir_x ~= position.dir_x do
		if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
			move_util.turnRight()
		else
			move_util.turnLeft()
		end
	end
end
 
----------- Return -----------
return move_util