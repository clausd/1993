* jQuery plugin to extract data and submit to server
* Framework to regenerate browser state from server json-state
    (could use event sourching - dom change events, could use template generation, depends on how client->server submit is actually implemented)

* Early "punk" version should probably just extract html and ship it out, makes re-generation of client obvious
    (But how do we rebuild client eventing after server load....)

TODO for the punk version: Capture CGI/form changes in html to send...
