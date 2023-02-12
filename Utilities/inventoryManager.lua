-- ProTools by 4Source 
-- Inventory Manager 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/9RTF5CDF
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'inv_manager = inv_manager or require("ProTools.Utilities.inventoryManager")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
inv_manager = {}

----------- Require -----------
fuel_manager = fuel_manager or require("ProTools.Utilities.fuelManager")
move_util = move_util or require("ProTools.Utilities.moveUtilities")
log = log or require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "inv_manager"

-- Is the inventory full
inv_manager.is_full = false
inv_manager.collected = 0
inv_manager.unloaded = 0

----------- Functions -----------
-- Collect 
function inv_manager.collect()	
	inv_manager.is_full = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			inv_manager.is_full = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if nTotalItems > inv_manager.collected then
		inv_manager.collected = nTotalItems
		if math.fmod(inv_manager.collected + inv_manager.unloaded, 50) == 0 then
			log.info("Mined "..(inv_manager.collected + inv_manager.unloaded).." items.", THIS)
		end
	end
	
	if inv_manager.is_full then
		log.info("No empty slots left.", THIS)
		return false
	end
	return true
end

-- Unload Items
function inv_manager.unload(_bKeepOneFuelStack)
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
				inv_manager.unloaded = inv_manager.unloaded + nCount
			end
		end
	end
	inv_manager.collected = 0
	turtle.select(1)
end

-- Return Supplies to Start
function inv_manager.returnSupplies()
	log.info("Returning to surface...", THIS)
	move_util.goTo({ pos_x = 0, pos_y = 0, pos_z = 0, dir_x = 0, dir_z = -1})
	
	local fuelNeeded = 2*(state_manager.state.progress.pos_x + state_manager.state.progress.pos_z + state_manager.state.progress.pos_y) + 1
	if not fuel_manager.refuel( fuelNeeded ) then
		inv_manager.unload( true )
		log.info("Waiting for fuel", THIS)
		while not fuel_manager.refuel( fuelNeeded ) do
			os.pullEvent( "turtle_inventory" )
		end
	else
		inv_manager.unload( true )	
	end
	
	log.info("Resuming mining...", THIS)
	state_manager.log()
	move_util.goTo(state_manager.state.progress)
end

----------- Return -----------
return inv_manager