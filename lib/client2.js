(function() {
  var client, createSailthruClient;

  createSailthruClient = require('sailthru-client').createSailthruClient;

  client = createSailthruClient(apiKey, apiSecret, apiUrl);

}).call(this);
