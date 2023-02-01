-- ProTools by 4Source 
-- Logger 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/c7evHdJg
-- Installation: Run installer below for full ProTools installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'local log = require("ProTools.Utilities.logger")'
-- Usage: log.'level'(msg, b_force_print, b_force_log)
--     level: fatal error warn info debug verbose
--     msg: The message which should be logged.
--     b_force_print: (optional) Forces to print the message independent from log level.
--     b_force_log: (optional) Forces to log the message independent from log level.
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Require -----------
local file_manager = require("ProTools.Utilities.fileManager") 
local config_manager = require("ProTools.Utilities.configManager")

----------- Variables -----------
-- Log file Directory
local log_path, log_file_name = "/ProTools", "/log"

----------- Functions -----------
-- Inizialisation
local function init()

end 

-- Convert Log Level to String
local function logLevelToString(log_level)   
    if log_level == 0 then 
        return "NONE"
    elseif log_level == 1 then 
        return "FATAL"
    elseif log_level == 2 then 
        return "ERROR"
    elseif log_level == 3 then 
        return "WARN"
    elseif log_level == 4 then 
        return "INFO"
    elseif log_level == 5 then 
        return "DEBUG"
    elseif log_level == 6 then 
        return "VERBOSE"
    end 
    return 
end 

-- Convert Log Level to Number
local function logLevelToNum(log_level)
    if log_level == "NONE" then 
        return 0
    elseif log_level == "FATAL" then 
        return 1
    elseif log_level == "ERROR" then 
        return 2
    elseif log_level == "WARN" then 
        return 3
    elseif log_level == "INFO" then 
        return 4
    elseif log_level == "DEBUG" then 
        return 5
    elseif log_level == "VERBOSE" then 
        return 6
    end 
    return 
end 

-- Log message to File
local function log(msg, caller, log_level)
    if not msg or msg == "" then return end
    if not caller then caller = "Unknown" end 
    if not log_level then log_level = "Unknown" end
    local log_msg = caller.."|"..log_level..": "..msg
    file_manager.appendFile(log_path..log_file_name, log_msg)
end 

-- Log Fatal 
local function fatal(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("FATAL") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("FATAL") then 
        log(msg, caller, "FATAL")
    end 
end

-- Log Error
local function error(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("ERROR") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("ERROR") then 
        log(msg, caller, "ERROR")
    end  
end

-- Log Warning
local function warn(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("WARN") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("WARN") then 
        log(msg, caller, "WARN")
    end   
end

-- Log Info
local function info(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("INFO") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("INFO") then 
        log(msg, caller, "INFO")
    end  
end

-- Log Debug
local function debug(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("DEBUG") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("DEBUG") then 
        log(msg, caller, "DEBUG")
    end  
end

-- Log Verbose
local function verbose(msg, caller, force_print, force_log)
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("VERBOSE") then 
        print(msg)
    end 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("VERBOSE") then 
        log(msg, caller, "VERBOSE")
    end   
end

----------- Run -----------
init()

----------- Return -----------
return{
    config = config,
    fatal = fatal,
    error = error,
    warn = warn,
    info = info,
    debug = debug,
    verbose = verbose 
}