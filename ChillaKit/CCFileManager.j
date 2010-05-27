var file = require("file");
var defaultManager = nil;

@implementation CCFileManager : CPObject
{
	
}

- (id)init
{
	if (self = [super init])
	{
		
	}
	return self;
}

+ (id)defaultManager
{
	if (defaultManager==nil)
		defaultManager = [[self alloc] init];
	return defaultManager;
}

- (CPArray)contentsOfDirectoryAtPath:(CPString)path error:(CPError)error
{
	return file.list(path);
}

@end