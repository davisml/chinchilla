@import "CCLayout.j"

@implementation CCAppController : CPObject
{
	CPMutableDictionary controllerClasses;
}

- (id)init
{
	if (self = [super init])
	{
		controllerClasses = [[CPMutableDictionary alloc] init];
	}
	return self;
}

- (void)setClass:(Class)aClass forControllerKey:(CPString)key
{
	CCLog(@"set class");
	[controllerClasses setValue:aClass forKey:key];
}

- (Object)dispatchRequest:(CCURLRequest)request
{
	var htmlLayout = [CCHTMLLayout layout];
	[htmlLayout setStyle:@"body { color:#fff; background-color:#000; padding:20px; font-family: Helvetica, Arial, sans-serif; font-size:14px;} h1 { display:block; font-size:28px;} p {padding-top:10px;}"];
	
	var path = [request pathString];
	var pathComponents = [request pathComponents];
	
	if ([pathComponents count]>0)
	{
		var controllerName = [[pathComponents objectAtIndex:0] lowercaseString];
		if ([controllerClasses containsKey:controllerName])
		{
			var controllerClass = [controllerClasses valueForKey:controllerName];
			var controller = [[controllerClass alloc] init];
			return [controller dispatchRequest:request];
		}
	}
	else if ([path isEqual:@"/"] || [path isEqual:@""])
	{
		[htmlLayout setTitle:@"Welcome to Chinchilla"];
		[htmlLayout setContent:@"<h1>Welcome to Chinchilla</h1><p>Create a subclass of CCAppController with a dispatchRequest: function to setup routes and disable this message.</p>"];
	}
	else
	{
		[htmlLayout setTitle:@"404"];
		[htmlLayout setContent:@"<h1>404</h1><p>The requested URL was not found on the server.</p>"];
	}
	
	return [htmlLayout responseObject];
}

@end