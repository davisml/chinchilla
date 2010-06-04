@import "CCController.j"

@implementation CCAppController : CCController
{
	CPMutableDictionary exposedControllerClasses;
}

- (id)init
{
	if (self = [super init])
	{
		exposedControllerClasses = [[CPMutableDictionary alloc] init];
	}
	return self;
}

- (void)exposeClass:(Class)aClass forPath:(CPString)aPath
{
	[exposedControllerClasses setValue:aClass forKey:aPath];
}

- (void)exposeAction:(SEL)aSelector
{
	CCLog(@"WARNING: Actions cannot be exposed in subclasses of CCAppController, only CCController");
}

- (void)exposeDefaultAction:(SEL)aSelector
{
	CCLog(@"WARNING: Default action cannot be exposed in subclasses of CCAppController, only CCController");
}

- (Object)dispatchRequest:(CCURLRequest)request
{
	var path = [request pathString];
	var controllerName = [request controllerComponent];
	
	if (controllerName != nil)
	{
		controllerName = [controllerName lowercaseString];
		if ([exposedControllerClasses containsKey:controllerName])
		{
			var controllerClass = [exposedControllerClasses valueForKey:controllerName];
			var controller = [[controllerClass alloc] init];
			return [controller dispatchRequest:request];
		}
	}
	else if ([path isEqual:@"/"] || [path isEqual:@""])
	{
		var htmlLayout = [CCController defaultLayout];
		[htmlLayout setTitle:@"Welcome to Chinchilla"];
		[htmlLayout setContent:@"<h1>Welcome to Chinchilla</h1><p>Create a subclass of CCAppController with a dispatchRequest: function to setup routes and disable this message.</p>"];
		return [htmlLayout responseObject];
	}
	
	return [super dispatchRequest:request];
}

@end