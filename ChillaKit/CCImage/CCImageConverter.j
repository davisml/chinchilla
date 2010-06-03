var MagickConfig = require("./Config/magick_config");
@import "CCImageTypes.j"

@implementation CCImageConverter : CPObject
{
	CPString	inputFile @accessors;
	CGSize		inputSize @accessors;
	CGSize		outputSize @accessors;
	BOOL 		autoOrient @accessors;
	BOOL		blur @accessors;
	CCImageEffect effect @accessors;
	CPString	inputFormat @accessors;
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
		inputFormat = nil;
		if ([inputFile hasPrefix:@".jpg"]||[inputFile hasPrefix:@".jpeg"])
			inputFormat = @"jpeg";
		outputFile = nil;
		inputSize = nil;
		outputSize = nil;
		blur = nil;
		unsharpen = nil;
		effect = CCImageEffectNone;
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
	if (effect != CCImageEffectNone)
		argumentString = [argumentString stringByAppendingString:CCStringFromEffect(effect)];
	
	
	var commandString = [CPString stringWithFormat:@"%@%@ %@%@ %@",convertPath,definitionString,inputFile,argumentString,outputFile];
	CCLog(commandString);
	var convertTask = [CCTask taskWithCommand:commandString];
	
	return YES;
}

- (BOOL)writeToFile:(CPString)outputFile withOutputSize:(CGSize)newSize atomically:(BOOL)flag
{
	outputSize = newSize;
	return [self writeToFile:outputFile atomically:flag];
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

function CCStringFromEffect(effect)
{
	if (effect == CCImageEffectSepia)
		return @" -sepia-tone 80%";
	else if (effect == CCImageEffectGrayscale)
		return @" -colorspace Gray";
	else if (effect == CCImageEffectAntique)
		return @" -sepia-tone 80% -modulate 175,60,104";
	else if (effect == CCImageEffectSketch)
		return @" -sketch 2";
	else if (effect == CCImageEffectBoostColor)
		return @" -modulate 100,140";
	else if (effect == CCImageEffectFadeColor)
		return @" -modulate 100,60";
	else if (effect == CCImageEffectVignette)
		return @" -background black -vignette 10x20";
	else if (effect == CCImageEffectMatte)
		return @" -background white -vignette 10x20";
	return @"";
}