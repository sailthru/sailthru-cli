{createSailthruConsole} =      require '../lib/sailthru-console'
{testCase} = require 'nodeunit'


exports.extractPayload = (test) ->
    test.expect 3

    c = createSailthruConsole({})
    actual1 = c.extractPayload 'GET job {"job_id": "4dd58f036803fa3b5500000b"}'
    expected1 = '{"job_id": "4dd58f036803fa3b5500000b"}'
    test.equal actual1, expected1

    # adding space at the end
    actual2 = c.extractPayload 'GET job {"job_id": "4dd58f036803fa3b5500000b"}   '
    expected2 = '{"job_id": "4dd58f036803fa3b5500000b"}'
    test.equal actual2, expected2

    # adding space at the end
    actual3 = c.extractPayload 'GET job     {"job_id": "4dd58f036803fa3b5500000b"}   '
    expected3 = '{"job_id": "4dd58f036803fa3b5500000b"}'
    test.equal actual3, expected3


    test.done()
