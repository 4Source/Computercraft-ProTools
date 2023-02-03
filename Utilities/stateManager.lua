-- ProTools by 4Source
-- State Manager 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/fkVjJJME
-- Installation: Run installer below for full installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'state_manager = state_manager or require("ProTools.Utilities.stateManager")'
-- Usage: 
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
state_manager = {}

----------- Require -----------
file_util = file_util or require("ProTools.Utilities.fileManager")
log = log or require("ProTools.Utilities.logger")

----------- Variables -----------
-- Name of self
local THIS = "state_manager"

-- State Directory
local state_path, state_file_name = "/ProTools", "/state"

----------- Functions -----------
-- Inizialisation
local function init()
    log.verbose("Inizalise state manager...", THIS)
    -- Make sure we have the directory
    if not fs.exists(state_path) then 
        fs.makeDir(state_path)
    end
end 

-- Save state in file. return false if went wrong. 
function state_manager.saveState()
    log.debug("Save state...", THIS)
    if not file_util.saveJSON(state_path..state_file_name, state) then 
        log.warn("Something went wrong saving the state.", THIS)
        return false
    end
    return true
end 

-- Save input in state file. return false if went wrong. 
function state_manager.saveInState(state_in)
    log.debug("Save state...", THIS)
    if not file_util.saveJSON(state_path..state_file_name, state_in) then 
        log.warn("Something went wrong saving the state.", THIS)
        return false
    end
    return true
end 

-- Load the state from file and return it.
function state_manager.getState()
    log.verbose("Search for state...", THIS)
    exists, data = file_util.loadJSON( state_path..state_file_name )
    if exists then 
        log.verbose("Load State...", THIS)

        -- Check compatible program
        if data.PROGRAM ~= shell.getRunningProgram() then 
            log.warn("Tryed to load state from another Program.", THIS)
            return 
        end 

        -- Check compatible version
        if not file_util.versionCompatible(P_VERSION, data.VERSION) then 
            log.warn("Version of state file is incompatible to running Program!", THIS)
            return
        end  
        -- return found state
        return data
    end 
    log.warn("No state found.", THIS)
    return 
end

-- Create Default State and return it.
function state_manager.createState()
    log.verbose("Creating state...", THIS)

    file_util.downloadFile("/ProTools/state", pasteCode, true)
    return getState()
end 

----------- Run -----------
init()

----------- Return -----------
return state_manager