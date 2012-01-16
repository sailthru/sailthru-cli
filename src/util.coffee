
log = (str) ->
    str = str.trim("\n") if typeof str is 'string'
    console.log str

exports.parseConfigFile = (file) ->
    fs = require 'fs'
    colors = require 'colors'

    error = false
    try
        fileBuffer = fs.readFileSync file
        try
            json = JSON.parse fileBuffer.toString()
            return json
        catch jsonErr
            log jsonErr.toString().red
            msg = "Error parsing JSON file"
            log msg.red
    catch err
        msg = JSON.stringify(err)
        log msg.red
    return false

exports.log = log
