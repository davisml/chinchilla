//var OS = require("os");

@import <Foundation/Foundation.j>
@import "ChillaKit/ChillaKit.j"
@import "MediaController.j"

@implementation WebController : CCAppController
{
	BOOL		showHidden;
	BOOL		showExtensions;
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
	var path = [request pathString];
	
	if ([path hasPrefix:@"/media"])
	{
		var mediaController = [[MediaController alloc] init];
		return [[CCJSONLayout layoutWithContent:[mediaController mediaItems]] responseObject];
	}
	
	return [super dispatchRequest:request];
}

@end
