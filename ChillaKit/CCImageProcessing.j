var MagickConfig = require("./magick_config");

@implementation CCImageConverter : CPObject
{
	CPString inputFile @accessors;
	CPString outputFile @accessors;
	CGSize originalSize @accessors;
	CGSize destinationSize @accessors;
}

- (id)initWithContentsOfFile:(CPString)aString
{
	if (self = [super init])
	{
		inputFile = aString;
		outputFile = nil;
		originalSize = CGSizeMake(500,180);
		destinationSize = CGSizeMake(250,90);
	}
	return self;
}

- (void)execute
{
	if (outputFile != nil)
	{
		var origSizeString = [CPString stringWithFormat:@"%dx%d",originalSize.width,originalSize.height];
		var destSizeString = [CPString stringWithFormat:@"%dx%d",destinationSize.width,destinationSize.height];
		var magickPath = ""+MagickConfig.magickPath;
		
		var commandString = [CPString stringWithFormat:@"%@/convert -define jpeg:size=%@ %@ -auto-orient -thumbnail %@ -unsharp 0x.5 %@"
			,magickPath,origSizeString,inputFile,destSizeString,outputFile];
		
		var convertTask = [CCTask taskWithCommand:commandString];
	}
}

@end