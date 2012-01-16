readline = require 'readline'
{createSailthruClient} = require 'sailthru-client'
{log} = require './util'
colors = require 'colors'

class SailthruConsole
    constructor: (options) ->
        _apiKey = if options.apiKey then options.apiKey else ""
        _apiSecret = if options.apiSecret then options.apiSecret else ""
        _apiUrl = if options.apiUrl then options.apiUrl else "https://api.sailthru.com"
        @client = createSailthruClient(_apiKey, _apiSecret, _apiUrl)
        @client.disableLogging()
        @welcomeMessage = "***Welcome to CLI for Sailthru API***"
        @prefix = if options.prefix then options.prefix else "SAILTHRU>"

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
        splits = cmd.split(" ")
        verb = splits[0]
        apiCall = if splits[1] then splits[1] else ""
        payload = @extractPayload cmd

        wait = true

        switch cmd
            when 'help' then @helpMessage()
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
        log 'Nothing for now. But I will add soon'
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
