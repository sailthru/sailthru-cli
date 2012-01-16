(function() {
  var log;

  log = function(str) {
    if (typeof str === 'string') str = str.trim("\n");
    return console.log(str);
  };

  exports.parseConfigFile = function(file) {
    var colors, error, fileBuffer, fs, json, msg;
    fs = require('fs');
    colors = require('colors');
    error = false;
    try {
      fileBuffer = fs.readFileSync(file);
      try {
        json = JSON.parse(fileBuffer.toString());
        return json;
      } catch (jsonErr) {
        log(jsonErr.toString().red);
        msg = "Error parsing JSON file";
        log(msg.red);
      }
    } catch (err) {
      msg = JSON.stringify(err);
      log(msg.red);
    }
    return false;
  };

  exports.log = log;

}).call(this);
