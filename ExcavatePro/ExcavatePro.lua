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

state_manager = state_manager or require("ProTools.Utilities.stateManager")
move_util = move_util or require("ProTools.Utilities.moveUtilities")
log = log or require("ProTools.Utilities.logger")


local tArgs = { ... }
if #tArgs ~= 1 then
	log.fatal("Usage: excavate <diameter>", THIS)
	return
end

-- Check for valid size input 
if tonumber(tArgs[1]) < 1 then
	log.fatal("Excavate diameter must be positive", THIS)
	return
end

-- Create new state and set size
state_manager.createState()
state_manager.state.size_x = tonumber(tArgs[1])
state_manager.state.size_z = tonumber(tArgs[1])
state_manager.saveState()
state_manager.log()
	
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
    -- state_manager.state.progress = state_manager.state.current
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
	while state_manager.state.current.pos_y > y do
		if move_util.up() then
			-- do nothing
		elseif turtle.digUp() or turtle.attackUp() then
			collect()
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
			elseif turtle.dig() or turtle.attack() then
				collect()
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
			elseif turtle.dig() or turtle.attack() then
				collect()
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
			elseif turtle.dig() or turtle.attack() then
				collect()
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
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while state_manager.state.current.pos_y < y do
		if move_util.down() then
            -- do nothing
		elseif turtle.digDown() or turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	
	while state_manager.state.current.dir_z ~= zd or state_manager.state.current.dir_x ~= xd do
		move_util.turnLeft()
	end
end

local function excavate()
    log.info("Excavating...", THIS) 
    local done = false
    while not done do
        log.debug(pro_util.varToString(done, "finished"), THIS)

		while (state_manager.state.current.dir_x == 1 and state_manager.state.current.pos_x < (state_manager.state.size_x - 1)) or (state_manager.state.current.dir_x == -1 and state_manager.state.current.pos_x > 0) or (state_manager.state.current.dir_x == 0) do
	    	state_manager.log()
			while (state_manager.state.current.dir_z == 1 and state_manager.state.current.pos_z < (state_manager.state.size_z - 1)) or (state_manager.state.current.dir_z == -1 and state_manager.state.current.pos_z > 0) or (state_manager.state.current.dir_z == 0) do
		    	state_manager.log()
			    if not move_util.forward() then
					log.warn("Can't move forward! 1", THIS)
					-- state_manager.state.progress = state_manager.state.current
					state_manager.saveState()
					state_manager.log()
				    return 
			    end
		    end
		    if state_manager.state.current.pos_x < (state_manager.state.size_x - 1) then
				state_manager.log()
			    if math.fmod(state_manager.state.current.pos_x, 2) == 0 then
					state_manager.log()
				    move_util.turnRight()
				    if not move_util.forward() then
						log.warn("Can't move forward! 2", THIS)
						-- state_manager.state.progress = state_manager.state.current
						state_manager.saveState()
						state_manager.log()
				    	return 
				    end
				    move_util.turnRight()
			    else
				    move_util.turnLeft()
				    if not move_util.forward() then
						log.warn("Can't move forward! 3", THIS)
						-- state_manager.state.progress = state_manager.state.current
						state_manager.saveState()
						state_manager.log()
					    return 
				    end
				    move_util.turnLeft()
			    end
		    end

			-- NOT WORKING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			log.debug("Check is end.", THIS)
			if (state_manager.state.current.dir_x == 0 and state_manager.state.current.pos_x == (state_manager.state.size_x - 1)) or (state_manager.state.current.dir_x == 0 and state_manager.state.current.pos_x == 0) then 
				log.debug("End of x", THIS)
				if (state_manager.state.current.dir_z == 1 and state_manager.state.current.pos_z == (state_manager.state.size_z - 1)) or (state_manager.state.current.dir_z == -1 and state_manager.state.current.pos_z == 0) then 
					log.debug("End of z", THIS)
					break
				end
			end
	    end

        move_util.turnLeft()
        move_util.turnLeft() 
	
	    if not move_util.down() then
			log.warn("Can't move down!", THIS)
			-- state_manager.state.progress = state_manager.state.current
			state_manager.saveState()
			state_manager.log()
		    return 
	    end
    end 
end 


----------- Run -----------
if not refuel() then
	log.warn("Out of Fuel", THIS)
	return
end

-- Excavateing 
excavate()

log.info("Returning to surface...", THIS)

-- Return to where we started
goTo( 0,0,0,0,-1 )
unload( false )
goTo( 0,0,0,0,1 )

log.info("Mined "..(collected + unloaded).." items total.", THIS) 