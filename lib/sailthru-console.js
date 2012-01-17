(function() {
  var DEFAULT_URL, SailthruConsole, apiClient, colors, createSailthruClient, log, readline;

  readline = require('readline');

  createSailthruClient = require('sailthru-client').createSailthruClient;

  colors = require('colors');

  log = require('./util').log;

  DEFAULT_URL = 'https://api.sailthru.com';

  apiClient = function(apiKey, apiSecret, apiUrl) {
    var client;
    client = createSailthruClient(apiKey, apiSecret, apiUrl);
    client.disableLogging();
    return client;
  };

  SailthruConsole = (function() {

    function SailthruConsole(options) {
      var _apiKey, _apiSecret, _apiUrl;
      _apiKey = options.apiKey ? options.apiKey : "";
      _apiSecret = options.apiSecret ? options.apiSecret : "";
      _apiUrl = options.apiUrl ? options.apiUrl : DEFAULT_URL;
      this.client = apiClient(_apiKey, _apiSecret, _apiUrl);
      this.welcomeMessage = "***Welcome to CLI for Sailthru API***".cyan;
      this.prefix = options.prefix ? options.prefix : "SAILTHRU> ";
    }

    SailthruConsole.prototype.initialize = function() {
      var self;
      self = this;
      log(this.welcomeMessage);
      this.readline = readline.createInterface(process.stdin, process.stdout);
      this.readline.on('line', function(cmd) {
        return self.parseCommand(cmd);
      });
      this.readline.on('close', function() {
        process.stdout.write('\n');
        return process.exit(0);
      });
      this.prompt();
    };

    SailthruConsole.prototype.prompt = function() {
      var length;
      length = this.prefix.length;
      this.readline.setPrompt(this.prefix, length);
      this.readline.prompt();
    };

    SailthruConsole.prototype.parseCommand = function(cmd, callback) {
      var apiCall, cb, payload, splits, verb, wait;
      cmd = cmd.trim();
      splits = cmd.split(" ");
      verb = splits[0];
      apiCall = splits[1] ? splits[1] : "";
      payload = this.extractPayload(cmd);
      wait = true;
      switch (cmd) {
        case 'help':
          this.helpMessage();
          wait = false;
          break;
        case 'quit':
        case 'exit':
          log('Bye\n');
          process.exit(0);
          break;
        default:
          cb = function() {
            wait = false;
          };
          this._apiRequest(verb, apiCall, payload, cb);
      }
      if (wait === false) this.prompt();
    };

    SailthruConsole.prototype.extractPayload = function(cmd) {
      var index, payload, splits, value, _len;
      splits = cmd.trim().split(" ");
      payload = '';
      if (splits.length >= 3) {
        for (index = 0, _len = splits.length; index < _len; index++) {
          value = splits[index];
          if (index >= 2) payload += value + " ";
        }
      }
      return payload.trim();
    };

    SailthruConsole.prototype.helpMessage = function() {
      var otherCommands, sampleCommandCmd, sampleCommandText, samplecCommandExplanation;
      sampleCommandText = 'Sample Command: '.grey;
      sampleCommandCmd = sampleCommandText + 'GET'.underline.green + ' ' + 'email'.underline.blue + ' ' + '{"email": "praj@infynyxx.com"}\n'.underline.magenta;
      samplecCommandExplanation = "The above command is divided into 3 parts: HTTP Verb, name of API call and JSON payload to make request. JSON payload requires valid JSON format as defined by http://www.json.org/ \n".cyan;
      otherCommands = "Other Commands: ".cyan + "help | exit | version | history (will be added soon)".blue;
      log(sampleCommandCmd + samplecCommandExplanation + otherCommands);
    };

    SailthruConsole.prototype._apiRequest = function(verb, action, payload, callback) {
      var cb, error, json, multipart, self, validVerbs;
      validVerbs = ["GET", "POST", "DELETE"];
      verb = verb.toUpperCase();
      if (validVerbs.indexOf(verb) === -1) verb = "GET";
      self = this;
      action = action.toLowerCase();
      error = false;
      try {
        json = JSON.parse(payload);
      } catch (err) {
        error = err;
      }
      if (error === false) {
        cb = function(response, err) {
          response = JSON.stringify(response, null, '\t');
          if (err) {
            log(response.red);
          } else {
            log(response.green);
          }
          return self.prompt();
        };
        switch (verb) {
          case 'GET':
            this.client.apiGet(action, json, cb);
            break;
          case 'POST':
            multipart = [];
            if (action === 'job' && json.file) multipart.push('file');
            this.client.apiPost(action, json, cb, multipart);
            break;
          case 'DELETE':
            this.client.apiDelete(action, json, cb);
        }
      } else {
        log("Error: ".red + error.toString().red);
        log("Payload: ".red + payload.blue);
        self.prompt();
      }
    };

    return SailthruConsole;

  })();

  exports.createSailthruConsole = function(options) {
    return new SailthruConsole(options);
  };

}).call(this);
