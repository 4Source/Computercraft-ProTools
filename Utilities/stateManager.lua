-- ProTools by 4Source
-- State Manager 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/fkVjJJME
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'local state_manager = require("ProTools.Utilities.stateManager")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------
local file_manager = require("ProTools.Utilities.fileManager")
local ui_util = require("ProTools.Utilities.uiUtil")
local log = require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "state_manager"

-- State Variable
local state = {}

-- State Directory
local state_path, state_file_name = "/ProTools", "/state"

----------- Functions -----------
-- Inizialisation
local function init()
    -- Make sure we have the directory
    if not fs.exists(state_path) then 
        fs.makeDir(state_path)
    end
end 

-- Save Current State. return false if went wrong. 
local function saveState()
    log.debug("Save State...", THIS)
    if not file_manager.saveJSON(state_path..state_file_name, state) then 
        log.warn("Something went wrong saving the state.", THIS)
        return false
    end
    return true
end 

-- Load State
local function loadState( program_version )
    log.debug("Search for State...", THIS)
    exists, data = file_manager.loadJSON( state_path..state_file_name )
    if exists then 
        log.debug("Load State...", THIS)
        if data.PROGRAM ~= shell.getRunningProgram() then 
            log.warn("Tryed to load state from another Program.", THIS)
            return false
        end 
        if not file_manager.versionCompatible(program_version, data.VERSION) then 
            log.warn("Incompatible state file. Version is incompatible! Try to update your program or run the setup for this program.", THIS)
            return false
        end  
        state = data
        log.debug("Done.", THIS)
        return true
    end 
    log.debug("No state found.", THIS)
    return false
end

-- 
local function initState( program_version )
    log.info("Initialize State...", THIS)
    if not loadState(program_version) then 
        while sure == nil do 
            if fs.exists(state_path..state_file_name) then 
                sure = ui_util.ensure("Do you want to reset the state that will delete the existing one?")
            else 
                sure = true
            end
        end
        if sure then
            log.debug("Create State...", THIS)
            -- Version of Program this state was created 
            state.VERSION = program_version
            -- The program 
            state.PROGRAM = shell.getRunningProgram()

            -- Target size to dig
            state.size_x, state.size_z, state.size_y = 0, 0, 0
            -- Program finished 
            state.finished = true 

            -- The actual position. Updated instantly after performing move 
            state.current = {} 
            -- Positiok relative to start 
            state.current.pos_x, state.current.pos_z, state.current.pos_y = 0, 0, 0
            -- Direction of the Turtle
            state.current.dir_x, state.current.dir_z = 0, 1

            -- The target position. Updated if other target needed 
            state.target = {} 
            -- Positiok relative to start 
            state.target.pos_x, state.target.pos_z, state.target.pos_y = 0, 0, 0
            -- Direction of the Turtle
            state.target.dir_x, state.target.dir_z = 0, 1

            -- The position where last progress to target was performed. Updated only if doing progress to target. Don't update if moving around from or to start point. 
            state.progress = {} 
            -- Positiok relative to start 
            state.progress.pos_x, state.progress.pos_z, state.progress.pos_y = 0, 0, 0
            -- Direction of the Turtle
            state.progress.dir_x, state.progress.dir_z = 0, 1

            saveState()
        else 
            return 
        end
    end 
end 

-- 
local function getCurrent()
    return state.current
end

local function setCurrent(in_state)
    state.current.pos_x, state.current.pos_z, state.current.pos_y = in_state.pos_x, in_state.pos_z, in_state.pos_y
    state.current.dir_x, state.current.dir_z = in_state.dir_x, in_state.dir_z
    saveState()
end

local function getTarget()
    return state.target
end

local function setTarget(in_state)
    state.target.pos_x, state.target.pos_z, state.target.pos_y = in_state.pos_x, in_state.pos_z, in_state.pos_y
    state.target.dir_x, state.target.dir_z = in_state.dir_x, in_state.dir_z
    saveState()
end

local function getProgress()
    return state.progress
end

local function setProgress(in_state)
    state.progress.pos_x, state.progress.pos_z, state.progress.pos_y = in_state.pos_x, in_state.pos_z, in_state.pos_y
    state.progress.dir_x, state.progress.dir_z = in_state.dir_x, in_state.dir_z
    saveState()
end

local function getSizeX()
    return state.size_x
end

local function setSizeX(size)
    state.size_x = size
    saveState()
end

local function getSizeZ()
    return state.size_z
end

local function setSizeZ(size)
    state.size_z = size
    saveState()
end

local function getSizeY()
    return state.size_y
end

local function setSizeY(size)
    state.size_y = size
    saveState()
end

local function getFinished()
    return state.finished
end

local function setFinished(finished)
    state.finished = finished
    saveState()
end

----------- Run -----------
init()

----------- Return -----------
return{
    initState = initState,
    getCurrent = getCurrent,
    setCurrent = setCurrent,
    getTarget = getTarget,
    setTarget = setTarget,
    getProgress = getProgress,
    setProgress = setProgress,
    getSizeX = getSizeX,
    setSizeX = setSizeX,
    getSizeZ = getSizeZ,
    setSizeZ = setSizeZ,
    getSizeY = getSizeY,
    setSizeY = setSizeY,
    isFinished = getFinished,
    setFinished = setFinished
}