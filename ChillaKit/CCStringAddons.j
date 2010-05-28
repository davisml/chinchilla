@i@implementation CPString (CCStringAddons)

- (id)initWithContentsOfFile:(CPString)filePath
{
	return [CPString stringWithString:[[CCFileManager defaultManager] contentsAtPath:filePath]];
}

+ (CPString)stringWithContentsOfFile:(CPString)filePath
{
	return [[self alloc] initWithContentsOfFile:filePath];
}

@end