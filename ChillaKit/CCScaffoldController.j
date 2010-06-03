@import "CCAppController.j"

@implementation CCScaffoldController : CCAppController
{
	CCModel model @accessors;
}

- (Object)dispatchRequest:(CCURLRequest)request
{
	var pathComponents = [request pathComponents];
	
	if ([pathComponents count]>1)
	{
		var actionName = [pathComponents objectAtIndex:1];
		if ([actionName isEqual:@"view"]&&[pathComponents count]>2)
		{
			var record = [self recordWithID:[pathComponents objectAtIndex:2]];
			return [[MAJSONLayout layoutWithContent:record] responseObject];
		}
		else if (![actionName hasPrefix:@"?"])
			return [[CCHTMLLayout layoutWithContent:@"Action not found"] responseObject];
	}
	
	return [[MAJSONLayout layoutWithContent:[self records]] responseObject];
}

- (Object)recordWithID:(CPString)recordID
{
	return [[self model] findByID:recordID];
}

- (CPArray)records
{
	CCLog(@"return records");
	CCLog([[self model] description]);
	return [[self model] findAll];
}

@end