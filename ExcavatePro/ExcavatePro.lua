-- ProTools by 4Source 
-- ExcavatePro  
-- Version: v0.1.0-alpha.1
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/UmUvXfqs
-- Installation: Run installer below for full installation. 
-- Installer: 'pastebin run wHmS4pNS'
-- Usage: ExcavatePro <program mode>
-- Program modes: 	'start' to run the setup and start to excavate
--					'restart' to continue an allready started program with turtle placed at start
-- 					'continue' to continue an allready started program at current positon. For auto restart feature.
-- Features: 	- Highly configurable
-- 				- AUTO Restart when turtle get unloaded 
-- 				- Configurable Logging 

----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Constants -----------
-- Program Version (MAJOR.MINOR.PATCH-PRERELEASE)
P_VERSION = "0.1.0-alpha"
-- Name of self
local THIS = "ExcavatePro"

pro_util = pro_util or require("ProTools.Utilities.proUtilities")
state_manager = state_manager or require("ProTools.Utilities.stateManager")
move_util = move_util or require("ProTools.Utilities.moveUtilities")
mine_util = mine_util or require("ProTools.Utilities.mineUtilities")
ui_util = ui_util or require("ProTools.Utilities.uiUtil")
fuel_manager = fuel_manager or require("ProTools.Utilities.fuelManager")
inv_manager = inv_manager or require("ProTools.Utilities.inventoryManager")
log = log or require("ProTools.Utilities.logger")

local function excavate()
	-- Repeat till finished or an error occurred 
    while not state_manager.state.finished and not state_manager.state.error do
        log.debug({pro_util.varToString(state_manager.state.finished, "state.finished"), pro_util.varToString(state_manager.state.error, "state.error")}, THIS)
		-- Repeat while in X Range
		while (state_manager.state.current.pos_x + state_manager.state.current.dir_x) <= (state_manager.state.size_x - 1) 
		and (state_manager.state.current.pos_x + state_manager.state.current.dir_x) >= 0 do
			log.verbose("Do X Row.", THIS)
			-- Repeat while in Z Range
			while (state_manager.state.current.pos_z + state_manager.state.current.dir_z) <= (state_manager.state.size_z - 1) 
			and (state_manager.state.current.pos_z + state_manager.state.current.dir_z) >= 0 do
				log.verbose("Do Z Row.", THIS)
				-- Check Inventory is full
				log.verbose("Check can collect.", THIS)
				if not inv_manager.collect() then
					log.info("Returning supplies.", THIS)
					state_manager.setProgress()
					state_manager.saveState()
					inv_manager.returnSupplies()
				end
				-- Try dig forward
				log.verbose("Check can dig forward.", THIS)
				if not mine_util.forward() then 
					log.warn("Can't dig forward!", THIS)
					state_manager.state.error = true
					state_manager.saveState()
				    return 
				end
				-- Try move forward
				log.verbose("Check can move forward.", THIS)
				if not move_util.forward() then
					log.warn("Can't move forward!", THIS)
					state_manager.state.error = true
					state_manager.saveState()
				    return 
			    end
			end

			-- Turn left or right depending on the X row
			if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
				move_util.turnRight()
			else
				move_util.turnLeft()
			end

			-- Go to next row in X
			if (state_manager.state.current.pos_x + state_manager.state.current.dir_x) <= (state_manager.state.size_x - 1) 
			and (state_manager.state.current.pos_x + state_manager.state.current.dir_x) >= 0 then
				log.verbose("Change X Row.", THIS)
				-- Check Inventory is full
				log.verbose("Check can collect.", THIS)
				if not inv_manager.collect() then
					log.info("Returning supplies.", THIS)
					state_manager.setProgress()
					state_manager.saveState()
					inv_manager.returnSupplies()
				end
				-- Try dig forward
				log.verbose("Check can dig forward.", THIS)
				if not mine_util.forward() then 
					log.warn("Can't dig forward!", THIS)
					state_manager.state.error = true
					state_manager.saveState()
					return 
				end
				-- Try move forward
				log.verbose("Check can move forward.", THIS)
				if not move_util.forward() then
					log.warn("Can't move forward!", THIS)
					state_manager.state.error = true
					state_manager.saveState()
					return 
				end

				-- Turn left or right depending on the X row
				if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
					move_util.turnLeft()
				else
					move_util.turnRight()
				end
			end
		end

		-- Turn left or right depending on the X row
        if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
			move_util.turnRight()
		else
			move_util.turnLeft()
		end

		if state_manager.state.size_y == true
		or state_manager.state.current.pos_y > (state_manager.state.size_y + 1) then
			-- Check Inventory is full
			log.verbose("Check can collect.", THIS)
			if not inv_manager.collect() then
				log.info("Returning supplies.", THIS)
				state_manager.setProgress()
				state_manager.saveState()
				inv_manager.returnSupplies()
			end
			-- Try dig down
			log.verbose("Check can dig down.", THIS)
			if not mine_util.down() then 
				log.warn("Can't dig down!", THIS)
				if state_manager.state.size_y == true then 
					state_manager.state.finished = true
				else
					state_manager.state.error = true
				end
				state_manager.saveState()
				return 
			end
			-- Try move down
			log.verbose("Check can move down.", THIS)
			if not move_util.down() then
				log.warn("Can't move down!", THIS)
				state_manager.state.error = true
				state_manager.saveState()
				
				return 
			end
		else
			state_manager.state.finished = true
			state_manager.saveState()
		end
    end 
end 

----------- Modes -----------
-- Start mode
function start()
	log.init()
    
	local size_x 
	local size_z 
	local size_y 

	-- Get Excavate Size Z from User input
	while not size_z or size_z <= 0 do 
		-- Request Z <size> (<offset>)
		tArgs = ui_util.requestInput("Excavate Z Size: ", "The Number of Blocks in front of the Turtle, including the Block where the Turtle stands.")

		if #tArgs == 1 then 
			size_z = tonumber(tArgs[1])
		end
	end

	-- Get Excavate Size X from User input
	while not size_x or size_x <= 0 do 
		-- Request X (<size>) (<offset>)
        tArgs = ui_util.requestInput("Excavate X Size: ", "(optional) The Number of Blocks to the right of the Turtle, including the Block where the Turtle stands. If 0 or not passed in the <Z Size> would be used.")
 
        if #tArgs == 1 then 
            size_x = tonumber(tArgs[1])
        else
            size_x = size_z
        end
	end
	
	-- Get Excavate Size Y from User input
	while not size_y or (type(size_y) == "number" and size_y > 0) do
		print("check y input")
		-- Request Y (<size>) (<offset>)
        tArgs = ui_util.requestInput("Excavate Y Size: ", "(optional) The Number of Blocks the Turtle should go down, including the Block where the Turtle stands. If not passed in depth is until we hit something we can't dig.")
 
        if #tArgs == 1 then 
            size_y = tonumber( tArgs[1] )
            size_y = size_y * -1
        elseif #tArgs == 0 then
            size_y = true
        end
	end

	-- Create new state 
	state_manager.createState()
	state_manager.state.size_x = size_x
	state_manager.state.size_z = size_z
	state_manager.state.size_y = size_y
	state_manager.state.finished = false
	state_manager.saveState()
	state_manager.log()
    
	if state_manager.state.finished then
		log.info("Program already finished.")
		return
	end
	if state_manager.state.error then
		log.fatal("Program has an error!")
		return
	end
    -- Excavate
    if not fuel_manager.refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = -1})
	inv_manager.unload( false )
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = 1})
	state_manager.log()

	log.verbose("Mined "..(inv_manager.collected + inv_manager.unloaded).." items total.", THIS, true) 
end
 
-- Restart Function
function restart()
   	-- Load state 
	state_manager.loadState()

	-- Check Verion/Program compatibility

	-- Check the State
	if state_manager.state.finished then
		log.info("Program already finished.", THIS)
		return
	end
	if state_manager.state.error then
		log.fatal("Program stoppt with an error!", THIS)
		return
	end
	state_manager.resetCurrent()
	state_manager.saveState()
	state_manager.log()
    
    -- Excavate
    if not fuel_manager.refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Return to last progress
	log.verbose("Resuming mining...", THIS, true)
	move_util.goTo(state_manager.state.progress)
	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = -1})
	inv_manager.unload( false )
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = 1})
	state_manager.log()

	log.verbose("Mined "..(collected + unloaded).." items total.", THIS, true) 
end
 
-- Continue Function
function continue()
    -- Load state 
	state_manager.loadState()

	-- get the configuration for the modes
    local config = config_manager.searchCategory("Modes")
    if not config then 
        log.error("No configuration for Modes found!", THIS)
        return 
    end

	if not config.bAUTO_RESTART then 
		log.info("Auto restart is turned off.", THIS)
		return
	end

	-- Check Verion/Program compatibility

	-- Check the State
	if state_manager.state.finished then
		log.info("Program already finished.", THIS)
		return
	end
	if state_manager.state.error then
		log.fatal("Program stoppt with an error!", THIS)
		return
	end
	state_manager.log()

	if not ui_util.countdown(config.CONTINUE_COUNTDOWN, "Terminate the Program if you don't want to Continue.") then 
		log.info("Continue program stopped.", THIS)
		return
	end

    -- Excavate
    if not fuel_manager.refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Return to last progress
	log.verbose("Resuming mining...", THIS, true)
	move_util.goTo(state_manager.state.progress)
	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = -1})
	inv_manager.unload( false )
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = 1})
	state_manager.log()

	log.verbose("Mined "..(collected + unloaded).." items total.", THIS, true) 
end

----------- Run -----------
-- Setup the Mode Settings
pro_util.setupModes()

-- Check for input arguments 
local tArgs = { ... }
if #tArgs < 1 then 
    log.verbose("Usage: "..shell.getRunningProgram().." <program mode>", THIS, true) 
    return
end 
                
-- Switch to selected program mode 
local pMode = tArgs[1]
-- Start: Request Player inputs and start digging 
if pMode == "start" then 
    if #tArgs > 1 then 
        log.verbose("Usage: "..shell.getRunningProgram().." start", THIS, true) 
        log.verbose("No extra Arguments allowed in this program mode.", THIS, true)
        return
    end 
 
    log.info("Starting...", THIS)
    start()
   
-- Restart: Restarts an old session with position of the Turtle manually placed to Start point 
elseif pMode == "restart" then 
    if #tArgs > 1 then 
        log.verbose("Usage: "..shell.getRunningProgram().." restart", THIS, true) 
        log.verbose("No extra Arguments allowed in this program mode.", THIS, true)
        return
    end 
 
    log.info("Restarting...", THIS)
    restart()
   
-- Continue: Turtle Stopped program restart at position where stopped 
elseif pMode == "continue" then
    if #tArgs > 1 then 
        log.verbose("Usage: "..shell.getRunningProgram().." continue", THIS, true) 
        log.verbose("No extra Arguments allowed in this program mode.", THIS, true)
        return
    end 
	
    log.info("Continue...", THIS)
	-- Countdown to exit
    continue()
    
-- Invalid     
else
    log.verbose("Usage: "..shell.getRunningProgram().." <program mode>", THIS, true)
    log.verbose("Valid <program mode> is required!", THIS, true)
    log.verbose("Modes: 'start', 'restart', 'setup', 'help'", THIS, true)    
    return
end