var MagickConfig = require("./magick_config");

@implementation CCImageConverter : CPObject
{
	CPString	inputFile @accessors;
	CGSize		inputSize @accessors;
	CGSize		outputSize @accessors;
	BOOL 		autoOrient @accessors;
	BOOL		blur @accessors;
	CPString	inputFormat @accessors;
}

- (id)initWithContentsOfFile:(CPString)aString
{
	if (self = [super init])
	{
		inputFile = aString;
		inputFormat = nil;
		outputFile = nil;
		inputSize = nil;
		outputSize = nil;
		blur = nil;
		unsharpen = nil;
		
		autoOrient = YES;
		unsharpen = NO;
	}
	return self;
}

- (CPString)_scriptPath
{
	return ""+MagickConfig.magickPath+"/convert";
}

- (BOOL)writeToFile:(CPString)outputFile atomically:(BOOL)flag
{
	var convertPath = [self _scriptPath];
	
	var definitionString = @"";
	if ([inputFormat isEqualToString:@"jpeg"])
	{
		definitionString = @" -define jpeg";
		if (inputSize != nil)
			definitionString = [definitionString stringByAppendingFormat:@":size=%@",CCStringFromSize(inputSize)];
	}
	
	var argumentString = @"";
	if (autoOrient)
		argumentString = [argumentString stringByAppendingString:@" -auto-orient"];
	if (outputSize != nil)
		argumentString = [argumentString stringByAppendingFormat:@" -thumbnail %@",CCStringFromSize(outputSize)];
	if (unsharpen)
		argumentString = [argumentString stringByAppendingString:@" -unsharp 0x.5"];
	if (blur != nil)
		argumentString = [argumentString stringByAppendingFormat:@" -blur %@",CCStringFromBlur(blur)];
	
	var commandString = [CPString stringWithFormat:@"%@%@ %@%@ %@",convertPath,definitionString,inputFile,argumentString,outputFile];
	CCLog(commandString);
	var convertTask = [CCTask taskWithCommand:commandString];
	
	return YES;
}

@end

function CCBlurMake(radius,sigma)
{
	var blur = new Object();
	blur.radius = radius;
	blur.sigma = sigma;
	return blur;
}

function CCStringFromBlur(blur)
{
	return blur.radius + "x" + blur.sigma;
}

function CCStringFromSize(size)
{
	return size.width + "x" + size.height;
}