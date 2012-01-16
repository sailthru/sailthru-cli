{parseConfigFile} =      require '../lib/util'
{testCase} = require 'nodeunit'

exports.testParseConfigFile = (test) ->
    test.expect 2
    
    invalid = './test/fixtures/invalid.config.json'
    json = parseConfigFile invalid
    test.equal typeof json is 'object', false

    valid = './test/fixtures/valid.config.json'
    json = parseConfigFile valid
    test.equal typeof json is 'object', true


    test.done()
