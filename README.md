sailthru-cli
=============

Command Line Interface for `Sailthru API` as per [http://docs.sailthru.com/api](http://docs.sailthru.com/api)

CLI command is divided into 3 parts:

*  VERB: `GET` / `DELETE` / `POST` [Case insensitive; if non of them then, uses GET]
*  Action: Any valid actions listed on[http://docs.sailthru.com/api](http://docs.sailthru.com/api)
*  Payload `Valid JSON` payload like: `{"email": "praj@infynyxx.com"}`


Installation
------------
    npm install sailthru-cli -g

If node is not installed, install it from [http://nodejs.org](http://nodejs.org/)

Usage
------

### Usage without config file
    sailthru-cli --key *** --secret ***

### Usage with config file
    sailthru-cli --config ~/client.1226.json

If `--url` is not defined in the command or `apiUrl` is not present in the config file then, by default `https://api.sailthru,com` will be used which in most of the cases should work

Config File
------------

    {
        "apiKey": "****",
        "apiSecret": "***",
        "apiUrl": "https://api.sailthru.com"
    }

JSON Payload
------------

### Valid Payload

    {"email": "praj@infynyxx.com"}

### Invalid Payload
    
    {'email': "praj@infynyxx.com"}

Screenshot
----------
![Screenshot](https://img.skitch.com/20120116-mu93g9m97hbdj7bb43b65jb2d8.png)

