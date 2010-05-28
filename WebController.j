//var OS = require("os");

@import <Foundation/Foundation.j>
@import "ChillaKit/ChillaKit.j"
@import "MediumAPI/MAMediaController.j"
@import "MediumAPI/MAUserController.j"

@implementation WebController : CCAppController
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
	var pathComponents = [request pathComponents];
	if ([pathComponents count]>0)
	{
		var controllerName = [[pathComponents objectAtIndex:0] lowercaseString];
		if ([controllerName isEqualToString:@"media"])
		{
			var mediaController = [[MAMediaController alloc] init];
			return [mediaController dispatchRequest:request];
		} else if ([controllerName isEqualToString:@"user"])
		{
			var userController = [[MAUserController alloc] init];
			return [userController dispatchRequest:request];
		} else if([controllerName isEqualToString:@"thumbnail"])
		{
			var imageConverter = [[CCImageConverter alloc] initWithContentsOfFile:@"/Users/markdavis/Colorsplash1.jpg"];
			[imageConverter setOutputFile:@"/Users/markdavis/Colorsplash_thumbnail.jpg"];
			[imageConverter execute];
		}
	}
	
	return [super dispatchRequest:request];
}

@end
