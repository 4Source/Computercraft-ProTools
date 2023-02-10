-- ProTools by 4Source 
-- ExcavatePro  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/UmUvXfqs
-- Installation: Run installer below for full installation. 
-- Installer: 'pastebin run wHmS4pNS'
-- Usage: (program name) <program mode>
-- Features: 

----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Constants -----------
-- Program Version (MAJOR.MINOR.PATCH-PRERELEASE)
P_VERSION = "0.1.0"
-- Name of self
local THIS = "ExcavatePro"

pro_util = pro_util or require("ProTools.Utilities.proUtilities")
state_manager = state_manager or require("ProTools.Utilities.stateManager")
move_util = move_util or require("ProTools.Utilities.moveUtilities")
mine_util = mine_util or require("ProTools.Utilities.mineUtilities")
ui_util = ui_util or require("ProTools.Utilities.uiUtil")
log = log or require("ProTools.Utilities.logger")
	
local unloaded = 0
local collected = 0

local goTo -- Filled in further down (function)
local refuel -- Filled in further down
 
local function unload( _bKeepOneFuelStack )
	log.info("Unloading items...", THIS)
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount > 0 then
			turtle.select(n)			
			local bDrop = true
			if _bKeepOneFuelStack and turtle.refuel(0) then
				bDrop = false
				_bKeepOneFuelStack = false
			end			
			if bDrop then
				turtle.drop()
				unloaded = unloaded + nCount
			end
		end
	end
	collected = 0
	turtle.select(1)
end

local function returnSupplies()
    state_manager.setProgress()
	state_manager.saveState()


	log.info("Returning to surface...", THIS)
	goTo( 0,0,0,0,-1 )
	
	local fuelNeeded = 2*(x+y+z) + 1
	if not refuel( fuelNeeded ) then
		unload( true )
		log.info("Waiting for fuel", THIS)
		while not refuel( fuelNeeded ) do
			os.pullEvent( "turtle_inventory" )
		end
	else
		unload( true )	
	end
	
	log.info("Resuming mining...", THIS)
	goTo( state_manager.state.progress.pos_x, state_manager.state.progress.pos_y, state_manager.state.progress.pos_z, state_manager.state.progress.dir_x, state_manager.state.progress.dir_z )
end

local function collect()	
	local bFull = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if nTotalItems > collected then
		collected = nTotalItems
		if math.fmod(collected + unloaded, 50) == 0 then
			log.info("Mined "..(collected + unloaded).." items.", THIS)
		end
	end
	
	if bFull then
		log.warn("No empty slots left.", THIS)
		return false
	end
	return true
end

function refuel( ammount )
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
	
	local needed = ammount or (state_manager.state.current.pos_x + state_manager.state.current.pos_z + state_manager.state.current.pos_y + 2)
	if turtle.getFuelLevel() < needed then
		local fueled = false
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
						turtle.refuel(1)
					end
					if turtle.getFuelLevel() >= needed then
						turtle.select(1)
						return true
					end
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	return true
end

function goTo( x, y, z, xd, zd )
	while state_manager.state.current.pos_y < y do
		if move_util.up() then
			-- do nothing
		-- elseif turtle.digUp() or turtle.attackUp() then
		-- 	collect()
		else
			sleep( 0.5 )
		end
	end

	if state_manager.state.current.pos_x > x then
		while state_manager.state.current.dir_x ~= -1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_x > x do
			if move_util.forward() then
                -- do nothing
			-- elseif turtle.dig() or turtle.attack() then
			-- 	collect()
			else
				sleep( 0.5 )
			end
		end
	elseif state_manager.state.current.pos_x < x then
		while state_manager.state.current.dir_x ~= 1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_x < x do
			if move_util.forward() then
                -- do nothing
			-- elseif turtle.dig() or turtle.attack() then
			-- 	collect()
			else
				sleep( 0.5 )
			end
		end
	end
	
	if state_manager.state.current.pos_z > z then
		while state_manager.state.current.dir_z ~= -1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_z > z do
			if move_util.forward() then
                -- do nothing
			-- elseif turtle.dig() or turtle.attack() then
			-- 	collect()
			else
				sleep( 0.5 )
			end
		end
	elseif state_manager.state.current.pos_z < z then
		while state_manager.state.current.dir_z ~= 1 do
			move_util.turnLeft()
		end
		while state_manager.state.current.pos_z < z do
			if move_util.forward() then
                -- do nothing
			-- elseif turtle.dig() or turtle.attack() then
			-- 	collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while state_manager.state.current.pos_y > y do
		if move_util.down() then
            -- do nothing
		-- elseif turtle.digDown() or turtle.attackDown() then
		-- 	collect()
		else
			sleep( 0.5 )
		end
	end
	
	while state_manager.state.current.dir_z ~= zd or state_manager.state.current.dir_x ~= xd do
		if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
			move_util.turnRight()
		else
			move_util.turnLeft()
		end
		--move_util.turnLeft()
	end
end

local function excavate()
    while not state_manager.state.finished and not state_manager.state.error do
        log.debug(pro_util.varToString(state_manager.state.finished, "state.finished"), THIS)
		while (state_manager.state.current.pos_x + state_manager.state.current.dir_x) <= (state_manager.state.size_x - 1) 
		and (state_manager.state.current.pos_x + state_manager.state.current.dir_x) >= 0 do
			log.verbose("Do X Row.", THIS)
			while (state_manager.state.current.pos_z + state_manager.state.current.dir_z) <= (state_manager.state.size_z - 1) 
			and (state_manager.state.current.pos_z + state_manager.state.current.dir_z) >= 0 do
				log.verbose("Do Z Row.", THIS)
				if not mine_util.forward() then 
					log.warn("Can't dig forward!", THIS)
					state_manager.state.error = true
					state_manager.setProgress()
					state_manager.saveState()
				    return 
				end
				if not move_util.forward() then
					log.warn("Can't move forward!", THIS)
					state_manager.state.error = true
					state_manager.setProgress()
					state_manager.saveState()
				    return 
			    end
			end

			if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
				move_util.turnRight()
			else
				move_util.turnLeft()
			end

			if (state_manager.state.current.pos_x + state_manager.state.current.dir_x) <= (state_manager.state.size_x - 1) 
			and (state_manager.state.current.pos_x + state_manager.state.current.dir_x) >= 0 then
				log.verbose("Change X Row.", THIS)
				if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
					if not mine_util.forward() then 
						log.warn("Can't dig forward!", THIS)
						state_manager.state.error = true
						state_manager.setProgress()
						state_manager.saveState()
						return 
					end
					if not move_util.forward() then
						log.warn("Can't move forward!", THIS)
						state_manager.state.error = true
						state_manager.setProgress()
						state_manager.saveState()
						return 
					end
					move_util.turnRight()
				else
					if not mine_util.forward() then 
						log.warn("Can't dig forward!", THIS)
						state_manager.state.error = true
						state_manager.setProgress()
						state_manager.saveState()
						return 
					end
					if not move_util.forward() then
						log.warn("Can't move forward!", THIS)
						state_manager.state.error = true
						state_manager.setProgress()
						state_manager.saveState()
						return 
					end
					move_util.turnLeft()
				end
			end
		end

        if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
			move_util.turnRight()
		else
			move_util.turnLeft()
		end

		if state_manager.state.size_y == true
		or state_manager.state.current.pos_y > (state_manager.state.size_y + 1) then
			if not mine_util.down() then 
				log.warn("Can't dig down!", THIS)
				if state_manager.state.size_y == true then 
					state_manager.state.finished = true
				else
					state_manager.state.error = true
				end
				state_manager.setProgress()
				state_manager.saveState()
				return 
			end
			if not move_util.down() then
				log.warn("Can't move down!", THIS)
				state_manager.state.error = true
				state_manager.setProgress()
				state_manager.saveState()
				
				return 
			end
		else
			state_manager.setProgress()
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
    if not refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	goTo( 0,0,0,0,-1 )
	unload( false )
	goTo( 0,0,0,0,1 )
	state_manager.log()

	log.verbose("Mined "..(collected + unloaded).." items total.", THIS, true) 
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
    if not refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Return to last progress
	log.verbose("Resuming mining...", THIS, true)
	goTo( state_manager.state.progress.pos_x, state_manager.state.progress.pos_y, state_manager.state.progress.pos_z, state_manager.state.progress.dir_x, state_manager.state.progress.dir_z )
	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	goTo( 0,0,0,0,-1 )
	unload( false )
	goTo( 0,0,0,0,1 )
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
	state_manager.saveState()
	state_manager.log()
    
    -- Excavate
    if not refuel() then
		log.warn("Out of Fuel", THIS)
		return
	end

	-- Return to last progress
	log.verbose("Resuming mining...", THIS, true)
	goTo( state_manager.state.progress.pos_x, state_manager.state.progress.pos_y, state_manager.state.progress.pos_z, state_manager.state.progress.dir_x, state_manager.state.progress.dir_z )
	-- Excavateing 
	log.verbose("Excavating...", THIS, true) 
	excavate()
	state_manager.log()

	log.verbose("Returning to surface...", THIS, true)

	-- Return to where we started
	goTo( 0,0,0,0,-1 )
	unload( false )
	goTo( 0,0,0,0,1 )
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