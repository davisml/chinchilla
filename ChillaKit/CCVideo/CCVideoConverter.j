var VideoConfig = require("./video_config");

@implementation CCVideoConverter : CPObject
{
	CPString	inputFile @accessors;
}

+ (id)converterWithContentsOfFile:(CPString)aString
{
	return [[self alloc] initWithContentsOfFile:aString];
}

- (id)initWithContentsOfFile:(CPString)aString
{
	if (self = [super init])
	{
		inputFile = aString;
	}
	return self;
}

- (CPString)_scriptPath
{
	return ""+VideoConfig.ffmpegPath;
}

- (BOOL)writePosterImageToFile:(CPString)outputFile atomically:(BOOL)flag
{
	var commandString = [CPString stringWithFormat:@"%@ -i %@ -r 1 -t 00:00:01 -f image2 %@",[self _scriptPath],inputFile,outputFile];
	var convertTask = [CCTask taskWithCommand:commandString];
	return YES;
}

@end