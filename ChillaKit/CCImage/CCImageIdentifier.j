@import "../../Config/CCImageConfig.j"

@implementation CCImageIdentifier : CPObject
{
	CPString inputFile @accessors;
	CPString identifyOutput @accessors;
	CPDictionary imageDictionary @accessors;
}

- (id)initWithContentsOfFile:(CPString)aString
{
	if (self = [super init])
	{
		inputFile = aString;
		
		var identifierPath = [self _scriptPath];
		var commandString = [CPString stringWithFormat:@"%@ -verbose %@",identifierPath,inputFile];
		identifyOutput = [[CCTask taskWithCommand:commandString] result];
		imageDictionary = CCImageDictionaryFromString(identifyOutput);
	}
	return self;
}

- (CPString)_scriptPath
{
	return CCImageConfig.path+"/identify";
}

- (CGSize)size
{
	var sizeString = [imageDictionary valueForKey:@"Geometry"];
	var components = [sizeString componentsSeparatedByString:@"+"];
	if ([components count]>0)
	{
		sizeString = [components objectAtIndex:0];
		var sizeComponents = [sizeString componentsSeparatedByString:@"x"];
		if ([sizeComponents count]>1)
			return CGSizeMake([[sizeComponents objectAtIndex:0] floatValue],[[sizeComponents objectAtIndex:1] floatValue]);
	}
	return CGSizeMake(0,0);
}

@end

function CCImageDictionaryFromString(identifyString)
{
	var imageDictionary = [CPDictionary dictionary];
	var lines = identifyString.split("\n");
	for (var i=0;i<[lines count];i++)
	{
		var line = [lines objectAtIndex:i];
		var match = line.match(/^  ([^:]+):\s*(.+)$/);
		if (match)
		{
			var key = match[1];
			var value = match[2];
			[imageDictionary setValue:value forKey:key];
		}
	}
	return imageDictionary;
}