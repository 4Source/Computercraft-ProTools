-- ProTools by 4Source 
-- ExcavatePro  
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/UmUvXfqs
-- Installation: Run installer below for full installation. 
-- Installer: pastebin run wHmS4pNS
-- Usage: (program name) <program mode>
-- Features: 

----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
------ boolean: starts with 'b'  (bIS_CONSTANTS_EXAMPEL) formulated as a statement
-- Variables: Lowercase and Underscores (variable_example)
-- Functions: Camelcase (functionExample)

----------- Constants -----------
HELP_PAGES = {'use', 'start', 'restart', 'continue', 'setup'}
-- Program Version (MAJOR.MINOR.PATCH-PRERELEASE)
P_VERSION = "0.1.0"

----------- Utilities -----------
-- Split Sting 
function split(inputstr, sep)
    if not inputstr then return end
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
 
----------- File Utilities ----------- 
-- Create/Open file and safe data
function saveJSON( filePath, dataIn )
    local file = io.open(filePath,"w")
    if not file then return false end 
    if file:write(textutils.serializeJSON(dataIn)) then 
        return file:close()
    else 
        return false
    end
end
 
-- Load file if exists and return Data Table
function loadJSON( filePath )
    -- Get file, if exists
    local file = io.open(filePath,"r")
    local data = {}
    if not file then return false
    else 
        data = textutils.unserializeJSON(file:read("*a"))
        file:close()
    end
    return true, data
end 

-- Check Version compatibility
-- Conditions: match(MAJOR and MINOR)
function versionCompatible(v1, v2) 
    if v1 ~= v2 then 
        local v1_labels = split(v1, ".")
        local v2_labels = split(v2, ".")
        if v1_labels[1] ~= v2_labels[1] or v1_labels[2] ~= v2_labels[2] then 
            return false 
        end
    end 
    return true 
end 

----------- Config Data ------------
-- Config table
local config = {}
 
-- Defaults
-- Version of config file
config.VERSION = "0.1.0"

-- config.MOVE_FAILURE_ATTEMPTS = 5         -- Attempts try to move without success [Version > ]
 
-- config.bAUTO_REFUEL = true              -- Auto Refuel from Turtel Inventory [Version > ]
-- config.REFUEL_LEVEL = 1000              -- Below this level the Turtle needs to refuel or goes back to start [Version > ]
-- config.bFUEL_SAVER = false              -- Reduses the amount of Fuel needed. Incompatible with some features. [Version > ]
 
-- config.bUSE_ITEM_CHESTS = true          -- Put Item's in Inventory [Version > ]
-- config.bUSE_FUEL_CHESTS = false         -- Use an extra chest with only fuel [Version > ]
-- config.bFILL_FUEL_CHESTS = false        -- Put the Item's which are fuel in fuel chest [Version > ]
-- config.CHESTS = {}                      -- Array of chest's [Version > ]
-- config.CHESTS[1].TYPE = "item"          -- Type of chest { "item", "fuel", "filtered" } [Version > ]
-- config.CHESTS[1].PRIORITY = 1           -- Priority trying to use this chest { higher before lower | closest distance to start } [Version > ]
-- config.CHESTS[1].CHEST_OFFSET_X = 0     -- Chest Positon offset to Turtle start [Version > ]
-- config.CHESTS[1].CHEST_OFFSET_Z = -1    -- Chest Positon offset to Turtle start [Version > ]
-- config.CHESTS[1].CHEST_OFFSET_Y = 0     -- Chest Positon offset to Turtle start [Version > ]
 
-- config.bAUTO_RESTART = false             -- Auto restart when Turtle turned on [Version > ]
 
-- config.bSOLID_WALLS = true              -- In outer ring fill the gabs in wall. (INCOMPATIBLE bFUEL_SAVER) [Version > ]
-- config.bREMOVE_FLUID = true             -- Remove Fluid's in front of the Turtle. (INCOMPATIBLE bFUEL_SAVER) [Version > ]
 
 
local config_path, config_file_name = "/ProTools/ExcavatePro", "/config"
-- Make sure we have the directory 
if not fs.exists(config_path..config_file_name) then 
    if not fs.exists(config_path) then 
        fs.makeDir(config_path)
    end 
end
 
-- Initialize Configuration 
function initConfig()
    print("Initialize Config...")
    -- Load Configs
    exists, data = loadJSON( config_path..config_file_name )
    if exists then 
        if not versionCompatible(P_VERSION, data.VERSION) then 
            error("Incompatible config file. Version is incompatible! Try to update your program or run the setup for this program.")
        end 
        config = data
    else
        -- Download default config
        shell.run("pastebin", "get", "W6KuhCeR", config_path..config_file_name)
        --saveJSON(config_path..config_file_name, config) 
    end 
 
    -- Create Startup file 
    if config.bAUTO_RESTART then 
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

-- Version of Program this state was created 
state.VERSION = P_VERSION
-- The program 
state.PROGRAM = shell.getRunningProgram()

-- Defaults Position
-- X: Positive = Right | Z: Positive = Forward | Y: Positive = Up
state.pos_x, state.pos_z, state.pos_y = 0, 0, 0         -- Positiok where the Turtle is relative to start 
state.last_x, state.last_z, state.last_y = 0, 0, 0      -- Position where the Turtle last digged relative to start  
state.dir_x, state.dir_z = 0, 1                         -- Direction the Turtel move 
state.size_x, state.size_z, state.size_y = 0, 0, 0      -- Target size to dig
state.finished = true 
 
local state_path, state_file_name = "/ProTools", "/state"
-- Make sure we have the directory
if not fs.exists(state_path) then 
    fs.makeDir(state_path)
end
 
-- Load State
function initState()
    print("Initialize State...")
    exists, data = loadJSON( state_path..state_file_name )
    if exists then 
        if data.PROGRAM ~= shell.getRunningProgram() then 
            error("Tryed to load state from another Program.")
        end 
        if not versionCompatible(P_VERSION, data.VERSION) then 
            error("Incompatible state file. Version is incompatible! Try to update your program or run the setup for this program.")
        end  
        state = data
    end 

    saveState()
end
-- Save Current State. return false if went wrong. 
function saveState()
    return saveJSON(state_path..state_file_name, state) 
end 
 
----------- UI Functions -----------
-- Get Input from UI
function requestPlayerInput( input_text, helper_text )
    
    if not input_text then return false end
 
    -- Setup UI 
    term.clear()
    term.setCursorPos(1, 1)
    io.write(input_text)
    
    if helper_text then 
        c_pos_x, c_pos_y = term.getCursorPos()
        print("")
        print("")
        print(helper_text)
        term.setCursorPos(c_pos_x, c_pos_y)
    end
    
    -- Get Input from UI
    input = io.read()
 
    -- Clear UI
    term.clear()
    term.setCursorPos(1, 1)
    
    -- Return args
    return split(input)
end
        
----------- Move Functions -----------
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
 
----------- Digging FUNCTIONS ------------
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

----------- QUARRY FUNCTIONS ------------
-- Return false if the row couldn't complete 
function row()
    print("row")
    if state.dir_z == 0 then 
        print("No Z direction value applied.")
        return false, "No Z direction value applied."
    end
    if state.size_z <= state.pos_z or state.pos_z < 0  then 
        print("Turtle is out of Z movement range.")
        return false, "Turtle is out of Z movement range."
    end


    -- while state.dir_z > 0 and (state.size_z - (state.pos_z + state.dir_z)) > 0 or state.dir_z < 0 and state.pos_z > 0 do 
    while state.dir_z > 0 and (state.pos_z + 1) < state.size_z or state.dir_z < 0 and state.pos_z > 0  do
        local done_dig_forward, msg = digForward()
        if not done_dig_forward then return false, msg end 
        sleep(1)     
    end 
    print("end row")
    return true 
end 
 
-- Return false if the layer couldn't complete 
function layer()
    print("layer")
    while state.pos_x  < state.size_x do
        local done_row, msg = row()
        if not done_row then return false, msg end
        
        local current_dir_z = state.dir_z
        -- if not last or first row
        if current_dir_z > 0 then 
            local done_turn_right, msg = turnRight()
            if not done_turn_right then return false, msg end
        else
            local done_turn_left, msg = turnLeft()
            if not done_turn_left then return false, msg end
        end

        if (state.pos_x + 1) < state.size_x then 
            local done_dig_forward, msg = digForward()
            if not done_dig_forward then return false, msg end 
        end

        if current_dir_z > 0 then 
            local done_turn_right, msg = turnRight()
            if not done_turn_right then return false, msg end
        else 
            local done_turn_left, msg = turnLeft()
            if not done_turn_left then return false, msg end
        end

        if (state.pos_x + 1)  >= state.size_x and (state.pos_z + 1) >= state.size_z then return true end

        sleep(1)     
    end
    print("end layer")
    return true 
end 

-- Return false if the excavate couldn't complete 
function excavate()
    print("excavate")
    while state.pos_y > state.size_y  do
        local done_layer, msg = layer()
        if not done_layer then return false, msg end
        
        if (state.pos_z + 1) >= state.size_z and (state.pos_x + 1)  >= state.size_x and (state.pos_y - 1) <= state.size_y then return true end

        local done_dig_down, msg = digDown()
        if not done_dig_down then return false, msg end

        sleep(1)     
    end
    print("end excavate")
    return true 
end

----------- TEST -----------

function goTo( x, y, z, xd, zd )
	while state.pos_y > y do
		if turtle.up() then
			state.pos_y = state.pos_y - 1
		else
			sleep( 0.5 )
		end
	end

	if state.pos_x > x then
		while state.dir_x ~= -1 do
			turnLeft()
		end
		while state.pos_x > x do
			if turtle.forward() then
				state.pos_x = state.pos_x - 1
			else
				sleep( 0.5 )
			end
		end
	elseif state.pos_x < x then
		while state.dir_x ~= 1 do
			turnLeft()
		end
		while state.pos_x < x do
			if turtle.forward() then
				state.pos_x = state.pos_x + 1
			else
				sleep( 0.5 )
			end
		end
	end
	
	if state.pos_z > z then
		while state.dir_z ~= -1 do
			turnLeft()
		end
		while state.pos_z > z do
			if turtle.forward() then
				state.pos_z = state.pos_z - 1
			else
				sleep( 0.5 )
			end
		end
	elseif state.pos_z < z then
		while state.dir_z ~= 1 do
			turnLeft()
		end
		while state.pos_z < z do
			if turtle.forward() then
				state.pos_z = state.pos_z + 1
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while state.pos_y < y do
		if turtle.down() then
			state.pos_y = state.pos_y + 1
		else
			sleep( 0.5 )
		end
	end
	
	while state.dir_z ~= zd or state.dir_x ~= xd do
		turnLeft()
	end
end


----------- Modes Run -----------
-- Start Function
function start()
    -- Get Excavate Size from User input
    local validArgs = false
    while not validArgs do
        local size_x
        local size_z
        local size_y
 
        local tArgs = {}

        -- Request Z <size> (<offset>)
        tArgs = requestPlayerInput( "Excavate Z Size: ", "(optional) The Number of Blocks in front of the Turtle, including the Block where the Turtle stands." )
 
        if #tArgs == 1 then 
            size_z = tonumber( tArgs[1] )
        else
            size_z = size_x
        end
 
        -- Request X (<size>) (<offset>)
        tArgs = requestPlayerInput( "Excavate X Size: ", "The Number of Blocks to the right of the Turtle, including the Block where the Turtle stands. If 0 or not passed in the <X Size> would be used." )
 
        if #tArgs == 1 then 
            size_x = tonumber( tArgs[1] )
        else
            size_x = 0
        end
 
        -- Request Y (<size>) (<offset>)
        tArgs = requestPlayerInput( "Excavate Y Size: ", "(optional) The Number of Blocks the Turtle should go down, including the Block where the Turtle stands. If 0 or not passed in depth is until we hit something we can't dig." )
 
        if #tArgs == 1 then 
            size_y = tonumber( tArgs[1] )
            size_y = size_y * -1
        else
            size_y = 0
        end
 
        -- Check inputs Valid and safe in state
        if size_x >= 1 and size_z >= 1 and size_y <= 0 then
            state.size_x = size_x
            state.size_z = size_z
            state.size_y = size_y
            state.finished = false
            
            validArgs = saveState()
        end    
    end
    
    -- Excavate
    if not state.finished then 
        -- TODO: Version compatibility 
		print("Excavate...")
        done_excavate, msg = excavate()
        if not done_excavate then 
            print(msg)
        end
        
        state.finished = done_excavate
        saveState()
    end
	print("Finish...")
end
 
-- Restart Function
function restart()
    -- Reset Turtle position in state values 
 
 
    -- Excavate
    if not state.finished then 
        state.finished = excavate()
        saveState()
    end 
 
end
 
-- Continue Function
function continue()
    -- Excavate
    if not state.finished then 
        state.finished = excavate()
        saveState()
    end 
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
        local s = "Topic's: "
        for h in HELP_PAGES do 
            s = s..h.." "
        end 
        print( s )
        return
    end
end

-- Development Function
function dev()
    local size_x
    local size_z
    local size_y
    local dir_x
    local dir_z
    local tArgs = {}

    -- Request Z 
    tArgs = requestPlayerInput( "Excavate Z Size: " )

    if #tArgs == 1 then 
        size_z = tonumber( tArgs[1] )
    end

    -- Request X 
    tArgs = requestPlayerInput( "Excavate X Size: " )

    if #tArgs == 1 then 
        size_x = tonumber( tArgs[1] )
    end

    -- Request Y 
    tArgs = requestPlayerInput( "Excavate Y Size: " )

    if #tArgs == 1 then 
        size_y = tonumber( tArgs[1] )
    end

    -- Request Z dir
    tArgs = requestPlayerInput( "Z Direction: " )

    if #tArgs == 1 then 
        dir_z = tonumber( tArgs[1] )
    end

    -- Request Y dir
    tArgs = requestPlayerInput( "X Direction: " )

    if #tArgs == 1 then 
        dir_x = tonumber( tArgs[1] )
    end

    print("z/x/y "..size_z.." "..size_x.." "..size_y)
    print("dirZ/dirX "..dir_z.." "..dir_x)

    goTo( size_x, size_y, size_z, dir_x, dir_z )

end
        
----------- RUN -----------
-- Check for input arguments 
local tArgs = { ... }
if #tArgs < 1 then 
    print( "Usage: "..shell.getRunningProgram().." <program mode>" ) 
    return
end 
                
-- Initialize Configuration 
initConfig()
 
-- Load state
initState()
                
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

-- Development mode
elseif pMode == "dev" then  
    print( "Development..." )
    dev()
   
-- Invalid     
else
    print( "Usage: "..shell.getRunningProgram().." <program mode>" )
    print( "Valid <program mode> is required!" )
    print( "Modes: 'start', 'restart', 'setup', 'help'" )    
    return
end