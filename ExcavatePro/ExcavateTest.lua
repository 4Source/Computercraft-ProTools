local state_manager = require("ProTools.Utilities.stateManager")
local log = require("ProTools.Utilities.logger")

-- Program Version (MAJOR.MINOR.PATCH-PRERELEASE)
P_VERSION = "0.1.0"
-- Name of self
local this = "ExcavateTest"

local tArgs = { ... }
if #tArgs ~= 1 then
	log.warn("Usage: excavate <diameter>", this)
	return
end

-- Mine in a quarry pattern until we hit something we can't dig
state_manager.setSizeX(tonumber( tArgs[1] ))
if state_manager.getSizeX() < 1 then
	log.warn("Excavate diameter must be positive", this)
	return
end

state_manager.initState(P_VERSION)
	
local unloaded = 0
local collected = 0

local goTo -- Filled in further down (function)
local refuel -- Filled in further down
 
local function unload( _bKeepOneFuelStack )
	log.info("Unloading items...", this)
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
    state_manager.setProgress(state_manager.getCurrent())


	log.info("Returning to surface...", this)
	goTo( 0,0,0,0,-1 )
	
	local fuelNeeded = 2*(x+y+z) + 1
	if not refuel( fuelNeeded ) then
		unload( true )
		log.info("Waiting for fuel", this)
		while not refuel( fuelNeeded ) do
			os.pullEvent( "turtle_inventory" )
		end
	else
		unload( true )	
	end
	
	log.info("Resuming mining...", this)
	goTo( state_manager.getProgress().pos_x, state_manager.getProgress().pos_y, state_manager.getProgress().pos_z, state_manager.getProgress().dir_x, state_manager.getProgress().dir_z )
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
			log.info("Mined "..(collected + unloaded).." items.", this)
		end
	end
	
	if bFull then
		log.warn("No empty slots left.", this)
		return false
	end
	return true
end

function refuel( ammount )
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
	
	local needed = ammount or (state_manager.getCurrent().pos_x + state_manager.getCurrent().pos_z + state_manager.getCurrent().pos_y + 2)
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

local function tryForwards()
	if not refuel() then
		log.warn("Not enough Fuel", this)
		returnSupplies()
	end
	
	while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end
	
    local temp_state = state_manager.getCurrent()
    temp_state.pos_x = state_manager.getCurrent().pos_x + state_manager.getCurrent().dir_x
    temp_state.pos_z = state_manager.getCurrent().pos_z + state_manager.getCurrent().dir_z
    state_manager.setCurrent(temp_state)

	-- state_manager.getCurrent().pos_x = state_manager.getCurrent().pos_x + state_manager.getCurrent().dir_x
	-- state_manager.getCurrent().pos_z = state_manager.getCurrent().pos_z + state_manager.getCurrent().dir_z
	return true
end

local function tryDown()
	if not refuel() then
		log.warn("Not enough Fuel", this)
		returnSupplies()
	end
	
	while not turtle.down() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end

    local temp_state = state_manager.getCurrent()
    temp_state.pos_y = state_manager.getCurrent().pos_y + 1
    state_manager.setCurrent(temp_state)

	-- state_manager.getCurrent().pos_y = state_manager.getCurrent().pos_y + 1

	if math.fmod( state_manager.getCurrent().pos_y, 10 ) == 0 then
		log.info("Descended "..state_manager.getCurrent().pos_y.." metres.", this)
	end

	return true
end

local function turnLeft()
	turtle.turnLeft()
    local temp_state = state_manager.getCurrent()
    temp_state.dir_x, temp_state.dir_z = -state_manager.getCurrent().dir_z, state_manager.getCurrent().dir_x
    state_manager.setCurrent(temp_state)

	-- state_manager.getCurrent().dir_x, state_manager.getCurrent().dir_z = -state_manager.getCurrent().dir_z, state_manager.getCurrent().dir_x
end

local function turnRight()
	turtle.turnRight()
    turtle.turnLeft()
    local temp_state = state_manager.getCurrent()
    temp_state.dir_x, temp_state.dir_z = state_manager.getCurrent().dir_z, -state_manager.getCurrent().dir_x
    state_manager.setCurrent(temp_state)

	-- state_manager.getCurrent().dir_x, state_manager.getCurrent().dir_z = state_manager.getCurrent().dir_z, -state_manager.getCurrent().dir_x
end

function goTo( x, y, z, xd, zd )
	while state_manager.getCurrent().pos_y > y do
		if turtle.up() then
            local temp_state = state_manager.getCurrent()
            temp_state.pos_y = state_manager.getCurrent().pos_y - 1
            state_manager.setCurrent(temp_state)

			-- state_manager.getCurrent().pos_y = state_manager.getCurrent().pos_y - 1
		elseif turtle.digUp() or turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end

	if state_manager.getCurrent().pos_x > x then
		while state_manager.getCurrent().dir_x ~= -1 do
			turnLeft()
		end
		while state_manager.getCurrent().pos_x > x do
			if turtle.forward() then
                local temp_state = state_manager.getCurrent()
                temp_state.pos_x = state_manager.getCurrent().pos_x - 1
                state_manager.setCurrent(temp_state)

				-- state_manager.getCurrent().pos_x = state_manager.getCurrent().pos_x - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif state_manager.getCurrent().pos_x < x then
		while state_manager.getCurrent().dir_x ~= 1 do
			turnLeft()
		end
		while state_manager.getCurrent().pos_x < x do
			if turtle.forward() then
                local temp_state = state_manager.getCurrent()
                temp_state.pos_x = state_manager.getCurrent().pos_x + 1
                state_manager.setCurrent(temp_state)

				-- state_manager.getCurrent().pos_x = state_manager.getCurrent().pos_x + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	end
	
	if state_manager.getCurrent().pos_z > z then
		while state_manager.getCurrent().dir_z ~= -1 do
			turnLeft()
		end
		while state_manager.getCurrent().pos_z > z do
			if turtle.forward() then
                local temp_state = state_manager.getCurrent()
                temp_state.pos_z = state_manager.getCurrent().pos_z - 1
                state_manager.setCurrent(temp_state)

				-- state_manager.getCurrent().pos_z = state_manager.getCurrent().pos_z - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif state_manager.getCurrent().pos_z < z then
		while state_manager.getCurrent().dir_z ~= 1 do
			turnLeft()
		end
		while state_manager.getCurrent().pos_z < z do
			if turtle.forward() then
                local temp_state = state_manager.getCurrent()
                temp_state.pos_z = state_manager.getCurrent().pos_z + 1
                state_manager.setCurrent(temp_state)

				-- state_manager.getCurrent().pos_z = state_manager.getCurrent().pos_z + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while state_manager.getCurrent().pos_y < y do
		if turtle.down() then
            local temp_state = state_manager.getCurrent()
            temp_state.pos_y = state_manager.getCurrent().pos_y + 1
            state_manager.setCurrent(temp_state)

			-- state_manager.getCurrent().pos_y = state_manager.getCurrent().pos_y + 1
		elseif turtle.digDown() or turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	
	while state_manager.getCurrent().dir_z ~= zd or state_manager.getCurrent().dir_x ~= xd do
		turnLeft()
	end
end

if not refuel() then
	log.warn("Out of Fuel", this)
	return
end

log.info("Excavating...", this)

local reseal = false
turtle.select(1)
if turtle.digDown() then
	reseal = true
end

local alternate = 0
local done = false
while not done do
	for n=1, state_manager.getSizeX() do
		for m=1, state_manager.getSizeX() - 1 do
			if not tryForwards() then
				done = true
				break
			end
		end
		if done then
			break
		end
		if n < state_manager.getSizeX() then
			if math.fmod(n + alternate,2) == 0 then
				turnLeft()
				if not tryForwards() then
					done = true
					break
				end
				turnLeft()
			else
				turnRight()
				if not tryForwards() then
					done = true
					break
				end
				turnRight()
			end
		end
	end
	if done then
		break
	end
	
	if state_manager.getSizeX() > 1 then
		if math.fmod(state_manager.getSizeX(), 2) == 0 then
			turnRight()
		else
			if alternate == 0 then
				turnLeft()
			else
				turnRight()
			end
			alternate = 1 - alternate
		end
	end
	
	if not tryDown() then
		done = true
		break
	end
end

log.info("Returning to surface...", this)

-- Return to where we started
goTo( 0,0,0,0,-1 )
unload( false )
goTo( 0,0,0,0,1 )

-- Seal the hole
if reseal then
	turtle.placeDown()
end

log.info("Mined "..(collected + unloaded).." items total.", this) 