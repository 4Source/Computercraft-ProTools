-- ProTools by 4Source 
-- ExcavatePro  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/UmUvXfqs
-- Installation: It is recommended to use the installer for full feature support.
-- Installer: pastebin run wHmS4pNS
-- Usage: (program name) <program mode>
-- Features: 

----------- Constants -----------
HELP_PAGES = {'use', 'start', 'restart', 'continue', 'setup'}

----------- File Functions ----------- 
-- Create/Open file and safe data
function SaveFile( filePath, dataIn )
    local file = io.open(filePath,"w")
    local returnValue = true
    if file then 
        returnValue= file:write(textutils.serialize(dataIn))
        returnValue = file:close()
    end
    return returnValue
end
 
-- Load file if exists and return Data Table
function LoadFile( filePath )
    -- Get file, if exists
    local file = io.open(filePath,"r")
    local tempData = {}
    if not file then return false
    else 
        tempData = textutils.unserialize(file:read("*a"))
        file:close()
    end
    return true, tempData
end 
 
----------- Config Data ------------
-- Config table
local config = {}
 
-- Defaults
-- config.MOVE_FAILURE_ATTEMPTS = 5         -- Attempts try to move without success 
 
-- config.bAUTO_REFUEL = true              -- Auto Refuel from Turtel Inventory
-- config.REFUEL_LEVEL = 1000              -- Below this level the Turtle needs to refuel or goes back to start 
-- config.bFUEL_SAVER = false              -- Reduses the amount of Fuel needed. Incompatible with some features.
 
-- config.bUSE_ITEM_CHESTS = true          -- Put Item's in Chest(Inventory) 
-- config.bUSE_FUEL_CHESTS = false         -- Use an extra chest with only fuel 
-- config.bFILL_FUEL_CHESTS = false        -- Put the Item's which are fuel in fuel chest 
-- config.CHESTS = {}                      -- Array of chest's 
-- config.CHESTS[1].TYPE = "item"          -- Type of chest { "item", "fuel", "filtered" }
-- config.CHESTS[1].PRIORITY = 1           -- Priority trying to use this chest { higher before lower | closest distance to start } 
-- config.CHESTS[1].CHEST_OFFSET_X = 0     -- Chest Positon offset to Turtle start
-- config.CHESTS[1].CHEST_OFFSET_Z = -1    -- Chest Positon offset to Turtle start
-- config.CHESTS[1].CHEST_OFFSET_Y = 0     -- Chest Positon offset to Turtle start
 
config.bAUTO_RESTART = true             -- Auto restart when Turtle turned on 
 
-- config.bSOLID_WALLS = true              -- In outer ring fill the gabs in wall. (INCOMPATIBLE bFUEL_SAVER)
-- config.bREMOVE_FLUID = true             -- Remove Fluid's in front of the Turtle. (INCOMPATIBLE bFUEL_SAVER)
 
 
local config_path, config_file_name = "/data/ExcavatePro", "/config"
-- Make sure we have the directory
if not fs.exists(config_path) then 
    fs.makeDir(config_path)
end

-- Initialize Configuration 
function InitConfig()
    -- Load Configs
    exist, data = LoadFile( config_path..config_file_name )
    if exist then 
        config = data
    end 
 
    -- Create Startup file 
    if config.bAUTO_RESTART then 
        print()
        local data = 'shell.run("'..shell.getRunningProgram()..' continue")'
 
        local file = io.open("/startup","w")
        if file then 
            file:write(data)
            file:close()
        end
    end 
end 


----------- State Data ------------
-- Data table
local state = {}

-- Defaults Position
-- X: Positive = Right | Z: Positive = Forward | Y: Positive = Up
state.posX, state.posZ, state.posY = 0, 0, 0 		-- Positiok where the Turtle is relative to start 
state.lastX, state.lastZ, state.lastY = 0, 0, 0    -- Position where the Turtle last digged relative to start  
state.dirX, state.dirZ, state.dirY = 0, 1, -1 		-- Direction the Turtel move 
state.sizeX, state.sizeZ, state.sizeY = 0, 0, 0 	-- Target size to dig
state.finished = true 

local state_path, state_file_name = "/data/ExcavatePro", "/state"
-- Make sure we have the directory
if not fs.exists(state_path) then 
	fs.makeDir(state_path)
end

-- Load State
function LoadState()
	exist, data = LoadFile( state_path..state_file_name )
	if exist then 
		state = data
	end 
end

----------- UI Functions -----------
-- Get Input from UI
function RequestPlayerInput( input_text, helper_text )
	
	if not input_text then return false end

    -- Setup UI 
    term.clear()
	term.setCursorPos(1, 1)
    io.write(input_text)
    
    if helper_text then 
        cPosX, cPosY = term.getCursorPos()
        print("")
        print("")
        print(helper_text)
        term.setCursorPos(cPosX, cPosY)
    end
    
    -- Get Input from UI
    input = io.read()
    
    -- Prosses Input 
    args = {}
    i=1
    for s in string.gmatch(input, "%S+") do
        args[i] = s
        i=i+1
    end

    -- Clear UI
    term.clear()
    term.setCursorPos(1, 1)
    
    -- Return args
    return args
end
        
----------- Move Functions -----------


----------- Modes Run -----------
-- Start Function
function start()
    -- Get Excavate Size from User input
    local validArgs = false
    while not validArgs do
		local sizeX
        local sizeZ
        local sizeY

		local tArgs = {}

		-- Request X Size
        tArgs = RequestPlayerInput( "Excavate X Size: ", "The Number of Blocks to the right of the Turtle, including the Block where the Turtle stands." )

		if #tArgs == 1 then 
			sizeX = tonumber( tArgs[1] )
		else
			sizeX = 0
		end
		
		-- Request Z Size
		tArgs = RequestPlayerInput( "Excavate Z Size: ", "(optional) The Number of Blocks in front of the Turtle, including the Block where the Turtle stands. If 0 or not passed in the <X Size> would be used." )

		if #tArgs == 1 then 
			sizeZ = tonumber( tArgs[1] )
		else
			sizeZ = sizeX
		end

		-- Request Y Size
		tArgs = RequestPlayerInput( "Excavate Y Size: ", "(optional) The Number of Blocks the Turtle should go down, including the Block where the Turtle stands. If 0 or not passed in depth is until we hit something we can't dig." )

		if #tArgs == 1 then 
			sizeY = tonumber( tArgs[1] )
			sizeY = sizeY * -1
		else
			sizeY = 0
		end

		-- Check inputs Valid and safe in state
        if sizeX >= 1 and sizeZ >= 1 and sizeY <= 0 then
			state.sizeX = sizeX
			state.sizeZ = sizeZ
			state.sizeY = sizeY
			state.finished = false

            if SaveFile( state_path..state_file_name, state ) then 
                validArgs = true
            end
        end    
    end
    
    -- Excavate
    -- while not state.finished do
        
    -- end

end

-- Restart Function
function restart()

end

-- Continue Function
function continue()

end

-- Setup Function
function setup()

end

-- Help Function
function help( topic )
	-- Help Page for use
	if topic == "use" then 
		print( "use" )

	-- Help Page for start
	elseif topic == "start" then 
		print( "start" )
	
	-- Help Page for restart
	elseif topic == "restart" then 
		print( "restart" )
	
	-- Help Page for restart
	elseif topic == "continue" then
		print( "continue" )
		
	-- Help Page for setup
	elseif topic == "setup" then
		print( "setup" )		

	else
		print( "No Help page found for this topic." )  
		print( "Topic's: 'use', 'start', 'restart', 'continue', 'setup'")
		return
	end
end
        
----------- RUN -----------
-- Check for input arguments 
local tArgs = { ... }
if #tArgs < 1 then 
    -- print( "Usage: (program name) <program mode>" )
    print( "Usage: "..shell.getRunningProgram().." <program mode>" ) 
	return
end 
                
-- Initialize Configuration 
InitConfig()

-- Load state
LoadState()
                
-- Switch to selected program mode 
local pMode = tArgs[1]
-- Start: Request Player inputs and start digging 
if pMode == "start" then 
	if #tArgs > 1 then 
		print( "Usage: "..shell.getRunningProgram().." start" ) 
		print( "No extra Arguments allowed in this program mode." )
		return
	end 

	print( "Starting..." )
    start()
   
-- Restart: Restarts an old session with position of the Turtle manually placed to Start point 
elseif pMode == "restart" then 
	if #tArgs > 1 then 
		print( "Usage: "..shell.getRunningProgram().." restart" ) 
		print( "No extra Arguments allowed in this program mode." )
		return
	end 

	print( "Restarting..." )
    restart()
   
-- Continue: Turtle Stopped program restart at position where stopped 
elseif pMode == "continue" then
	if #tArgs > 1 then 
		print( "Usage: "..shell.getRunningProgram().." continue" ) 
		print( "No extra Arguments allowed in this program mode." )
		return
	end 

	print( "Continue..." )
    continue()
    
-- Setup: Open Setup Menu to change default behaviors 
elseif pMode == "setup" then
	if #tArgs > 1 then 
		print( "Usage: "..shell.getRunningProgram().." setup" ) 
		print( "No extra Arguments allowed in this program mode." )
		return
	end 

	print( "Open Setup Menu..." )
    setup()
    
-- Help: Shows information about how to use this program 
elseif pMode == "help" then 
	if #tArgs ~= 2 then 
		print( "Usage: "..shell.getRunningProgram().." help <topic>" ) 
		print( "Topic's: 'use', 'start', 'restart', 'continue', 'setup'")
		return
	end 

    help(tArgs[2])
    
else
    print( "Usage: "..shell.getRunningProgram().." <program mode>" )
    print( "Valid <program mode> is required!" )
    print( "Modes: 'start', 'restart', 'setup', 'help'" )    
    return
end
