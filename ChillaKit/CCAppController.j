@import "CCLayout.j"

@implementation CCAppController : CPObject
{
	
}

- (id)init
{
	if (self = [super init])
	{
	}
	return self;
}

- (Object)dispatchRequest:(CCURLRequest)request
{
	var htmlLayout = [CCHTMLLayout layout];
	
	var path = [request pathString];
	
	if ([path isEqual:@"/"] || [path isEqual:@""])
	{
		[htmlLayout setTitle:@"Welcome to Chinchilla"];
		[htmlLayout setContent:@"<h1>Welcome to Chinchilla</h1><p>Setup a subclass of CCRouter to change this page</p>"];
	}
	else
	{
		[htmlLayout setTitle:@"404"];
		[htmlLayout setContent:@"<h1>404</h1><p>The requested URL was not found on the server.</p>"];
	}
	
	return [htmlLayout responseObject];
}

@end