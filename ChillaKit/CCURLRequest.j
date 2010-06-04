var Request = require("jack/request").Request;

var CCJackEnvRequestMethodKey = @"REQUEST_METHOD";
var CCJackEnvPathInfoKey = @"PATH_INFO";
var CCJackEnvQueryStringKey = @"QUERY_STRING";

@implementation CCURLRequest : CPObject
{
	CPString		HTTPMethod @accessors;
	CPString		pathString @accessors;
	CPString		queryString @accessors;
	Object			jsRequest @accessors;
	CPMutableArray	pathComponents;
}

- (id)initWithEnvironment:(Object)environment
{
	if (self = [super init])
	{
		jsRequest = new Request(environment);
		HTTPMethod = environment[CCJackEnvRequestMethodKey];
		pathString = environment[CCJackEnvPathInfoKey];
		queryString = environment[CCJackEnvQueryStringKey];
		pathComponents = nil;
	}
	return self;
}

- (Object)postData
{
	return jsRequest.POST();
}

- (CPString)controllerComponent
{
	if ([[self pathComponents] count]>0)
		return [[self pathComponents] objectAtIndex:0];
	return nil;
}

- (CPString)actionComponent
{
	if ([[self pathComponents] count]>1)
		return [[self pathComponents] objectAtIndex:1];
	return nil;
}

- (CPArray)pathComponents
{
	if (pathComponents == nil)
	{
		pathComponents = [[CPMutableArray alloc] init];
		
		var componentArray = [pathString componentsSeparatedByString:@"/"];
		for (var i=0;i<[componentArray count];i++)
		{
			var componentString = [componentArray objectAtIndex:i];
			if ([componentString length]>0)
				[pathComponents addObject:componentString];
		}
	}
	
	return pathComponents;
}

+ (id)requestWithEnvironment:(Object)environment
{
	return [[[self alloc] initWithEnvironment:environment] autorelease];
}

@end