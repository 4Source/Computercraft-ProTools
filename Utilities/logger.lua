-- ProTools by 4Source 
-- Logger 
-- Version: v0.1.0
-- License: MIT 
-- GitHub: https://github.com/4Source/Computercraft-ProTools
-- Pastebin: https://pastebin.com/c7evHdJg
-- Installation: Run installer below for full ProTools installation.
-- Installer: 'pastebin run wHmS4pNS'
-- Require: 'log = log or require("ProTools.Utilities.logger")'
-- Usage: log.'level'(msg, b_force_print, b_force_log)
--     level: The level how critical 
--         fatal: One or more key functionalities are not working, program can't run probably.
--         error: An issue preventing one or more functionalities from properly functioning.
--         warn: Indicates that something unexpected happened, but the code can continue the work.
--         info: The standard log level indicating that something happened.
--         debug: Used for diagnosing issues and troubleshooting.
--         verbose: Very detailed information like what happened each step.
--     msg: The message which should be logged.
--     b_force_print: (optional) Forces to print the message independent from log level.
--     b_force_log: (optional) Forces to log the message independent from log level.
 
----------- Formatting -----------
-- Constants: Uppercase and Underscores (CONSTANTS_EXAMPEL)
--     boolean: starts with 'b' formulated as a statement (bIS_CONSTANTS_EXAMPEL) 
-- Variables: Lowercase and Underscores (variable_example)
--     boolean: formulated as a statement (is_example) 
-- Functions: Camelcase (functionExample)  

----------- Module -----------
log = {}

----------- Require -----------
file_util = file_util or require("ProTools.Utilities.fileUtilities")
config_manager = config_manager or require("ProTools.Utilities.configManager")

----------- Variables -----------
-- Log file Directory
local log_path, log_file_name = "/ProTools", "/log"

----------- Functions -----------
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
local function logging(msg, caller, log_level, without_timestamp)
    -- exit if no message resived
    if not msg or msg == "" then
        msg = "Invalid Logging Input!"
        caller = "log ("..caller..")"
        log_level = "ERROR"
    end
    
    -- log message 
    local log_msg = {}

    -- Add timestamp
    if not without_timestamp then 
        table.insert(log_msg, 1, textutils.formatTime(os.time("local")))
    end 
    
    -- Add caller
    if not caller then caller = "Unknown" end 
    table.insert(log_msg, 2, caller)

    -- Add log level
    if not log_level then log_level = "Unknown" end
    table.insert(log_msg, 3, log_level)

    -- Add message
    table.insert(log_msg, 4, msg)

    -- Save in file
    file_util.appendFile(log_path..log_file_name, log_msg)
end 

-- Log Fatal 
function log.fatal(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("FATAL") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("FATAL") then 
        logging(msg, caller, "FATAL")
    end 
end

-- Log Error
function log.error(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("ERROR") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("ERROR") then 
        logging(msg, caller, "ERROR")
    end  
end

-- Log Warning
function log.warn(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("WARN") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("WARN") then 
        logging(msg, caller, "WARN")
    end   
end

-- Log Info
function log.info(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("INFO") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("INFO") then 
        logging(msg, caller, "INFO")
    end  
end

-- Log Debug
function log.debug(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("DEBUG") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("DEBUG") then 
        logging(msg, caller, "DEBUG")
    end  
end

-- Log Verbose
function log.verbose(msg, caller, force_print, force_log)
    -- get the configuration for the logger
    local config = config_manager.searchCategory("Logger")
    if not config then return end
    -- print the message if level is high enough 
    if force_print or logLevelToNum(config.PRINT_LEVEL) >= logLevelToNum("VERBOSE") then 
        print(msg)
    end 
    -- log the message if level is high enough 
    if force_log or logLevelToNum(config.LOG_LEVEL) >= logLevelToNum("VERBOSE") then 
        logging(msg, caller, "VERBOSE")
    end   
end

----------- Run -----------

----------- Return -----------
return log