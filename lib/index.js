(function() {
  var VERSION, commander, createSailthruConsole, parseConfigFile;

  commander = require('commander');

  createSailthruConsole = require('./sailthru-console').createSailthruConsole;

  parseConfigFile = require('./util').parseConfigFile;

  VERSION = '0.0.1';

  exports.VERSION = VERSION;

  exports.main = function() {
    var options;
    commander.version(VERSION).option('-k, --key [value]', 'API Key').option('-s, --secret [value]', 'API Secret').option('-u, --url [value]', 'API URL').option('-c, --config [value]', 'Config File').parse(process.argv);
    options = {};
    if (commander.config) options = parseConfigFile(commander.config);
    if (commander.key) options.apiKey = commander.key;
    if (commander.secret) options.apiSecret = commander.secret;
    return createSailthruConsole(options).initialize();
  };

}).call(this);
