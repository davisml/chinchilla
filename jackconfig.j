#!/usr/bin/env jackup

require("./Classes/MyController");

var JACK = require("jack");
var appController = [[MyController alloc] init];

exports.app = JACK.URLMap({
	"/public" : JACK.File("public"),
	"/" : function(env)
	{
    	return [appController dispatchRequest:[CCURLRequest requestWithEnvironment:env]];
	}
});

// specify custom sets of middleware and initialization routines
// by defining a function with the same name as the environment:
exports.development = function(app) {
    return require("jack/commonlogger").CommonLogger(
        require("jack/showexceptions").ShowExceptions(
            require("jack/lint").Lint(
                require("jack/contentlength").ContentLength(app))));
}
