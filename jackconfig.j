#!/usr/bin/env jackup

@import <Foundation/Foundation.j>

@implementation WebController : CPObject
{
}

- (Object)dispatch:(Object)env
{
    return {
        status : 200,
        headers : {"Content-Type":"text/plain"},
        body : ["controller="+self]
    };
}

@end

var controller = [[WebController alloc] init];

// the "app" export is the default property used by jackup:
exports.app = function(env) {
    return [controller dispatch:env];
}

// specify custom sets of middleware and initialization routines
// by defining a function with the same name as the environment:
exports.development = function(app) {
    return require("jack/commonlogger").CommonLogger(
        require("jack/showexceptions").ShowExceptions(
            require("jack/lint").Lint(
                require("jack/contentlength").ContentLength(app))));
}
