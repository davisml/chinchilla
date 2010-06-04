@import "CCAppController.j"

@implementation CCScaffoldController : CCController
{
	CCModel model @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		[self exposeAction:@selector(view:) forPath:@"view/:obj1"];
		[self exposeDefaultAction:@selector(list)];
	}
	return self;
}

- (Object)view:(CPString)recordID
{
	CCLog("view item: "+recordID);
	
	if (recordID != nil)
		return [[MAJSONLayout layoutWithContent:[self recordWithID:recordID]] responseObject];
	
	var errorLayout = [CCLayout layout];
	[errorLayout setStatus:400];
	return errorLayout;
}

- (Object)list
{
	return [[MAJSONLayout layoutWithContent:[self records]] responseObject];
}

- (Object)recordWithID:(CPString)recordID
{
	return [[self model] findByID:recordID];
}

- (CPArray)records
{
	return [[self model] findAll];
}

@end