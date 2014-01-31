readline = require 'readline'
{createSailthruClient} = require 'sailthru-client'
colors = require 'colors'

{log} = require './util'

DEFAULT_URL = 'https://api.sailthru.com'

apiClient = (apiKey, apiSecret, apiUrl) ->
    client = createSailthruClient(apiKey, apiSecret, apiUrl)
    client.disableLogging()
    client

class SailthruConsole
    constructor: (options) ->
        _apiKey = if options.apiKey then options.apiKey else ""
        _apiSecret = if options.apiSecret then options.apiSecret else ""
        _apiUrl = if options.apiUrl then options.apiUrl else DEFAULT_URL
        @client = apiClient(_apiKey, _apiSecret, _apiUrl)
        @welcomeMessage = "***Welcome to CLI for Sailthru API***".cyan
        @prefix = if options.prefix then options.prefix else "SAILTHRU> "

    initialize: ->
        self = this
        log @welcomeMessage
        @readline = readline.createInterface process.stdin, process.stdout
        @readline.on 'line', (cmd) ->
            self.parseCommand cmd
        @readline.on 'close', ->
            process.stdout.write '\n'
            process.exit 0

        @prompt()
        return

    prompt: ->
        length = @prefix.length
        @readline.setPrompt @prefix, length
        @readline.prompt()
        return

    parseCommand: (cmd, callback) ->
        cmd = cmd.trim()
        
        if cmd.length == 0
            @prompt()
            return

        splits = cmd.split(" ")
        verb = splits[0]
        apiCall = if splits[1] then splits[1] else ""
        payload = @extractPayload cmd

        wait = true

        switch cmd
            when 'help'
                @helpMessage()
                wait = false
            when 'quit', 'exit'
                log 'Bye\n'
                process.exit(0)
            else
                cb = ->
                    wait = false
                    return

                @_apiRequest(verb, apiCall, payload, cb)

        @prompt() if wait is false

        return

    extractPayload: (cmd) ->
        splits = cmd.trim().split(" ")
        payload = ''
        if splits.length >= 3
            payload += value + " " for value, index in splits when index >= 2
        return payload.trim()

    helpMessage: ->
        sampleCommandText = 'Sample Command: '.grey
        sampleCommandCmd = sampleCommandText + 'GET'.underline.green + ' ' + 'email'.underline.blue + ' ' + '{"email": "praj@infynyxx.com"}\n'.underline.magenta
        samplecCommandExplanation = "The above command is divided into 3 parts: HTTP Verb, name of API call and JSON payload to make request. JSON payload requires valid JSON format as defined by http://www.json.org/ \n".cyan
        otherCommands = "Other Commands: ".cyan + "help | exit | version | history (will be added soon)".blue
        log sampleCommandCmd + samplecCommandExplanation + otherCommands
        return

    _apiRequest: (verb, action, payload, callback) ->
        validVerbs = ["GET", "POST", "DELETE"]
        verb = verb.toUpperCase()
        verb = "GET" if validVerbs.indexOf(verb) is -1
        self = this
        action = action.toLowerCase()
        error = false

        try
            json = JSON.parse(payload)
        catch err
            error = err

        if error is false
            cb = (response, err) ->
                response = JSON.stringify(response, null, '\t')
                #log payload.blue
                if err then log response.red else log response.green
                self.prompt()

            switch verb
                when 'GET'
                    @client.apiGet action, json, cb
                when 'POST'
                    multipart = []
                    multipart.push 'file' if action is 'job' and json.file
                    @client.apiPost action, json, cb, multipart
                when 'DELETE'
                    @client.apiDelete action, json, cb
        else
            log "Error: ".red + error.toString().red
            log "Payload: ".red + payload.blue

            self.prompt()

        return

exports.createSailthruConsole = (options) ->
    new SailthruConsole options
