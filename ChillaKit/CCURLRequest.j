var Request = require("jack/request").Request;

var CCJackEnvRequestMethodKey = @"REQUEST_METHOD";
var CCJackEnvPathInfoKey = @"PATH_INFO";
var CCJackEnvQueryStringKey = @"QUERY_STRING";

@implementation CCURLRequest : CPObject
{
	CPString HTTPMethod @accessors;
	CPString pathString @accessors;
	CPString queryString @accessors;
	Object jsRequest @accessors;
}

- (id)initWithEnvironment:(Object)environment
{
	if (self = [super init])
	{
		jsRequest = new Request(environment);
		HTTPMethod = environment[CCJackEnvRequestMethodKey];
		pathString = environment[CCJackEnvPathInfoKey];
		queryString = environment[CCJackEnvQueryStringKey];
	}
	return self;
}

+ (id)requestWithEnvironment:(Object)environment
{
	return [[[self alloc] initWithEnvironment:environment] autorelease];
}

@end