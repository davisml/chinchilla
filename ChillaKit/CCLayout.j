@implementation CCLayout : CPObject
{
	CPString content @accessors;
	int status @accessors;
	CPString contentType @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		status = 200;
		contentType = @"text/plain";
	}
	return self;
}

+ (id)layout
{
	return [[[self alloc] init] autorelease];
}

+ (id)layoutWithContent:(CPString)aContent
{
	var layout = [self layout];
	[layout setContent:aContent];
	return layout;
}

- (CPString)stringValue
{
	return content;
}

- (Object)responseObject
{
	return {
	    status : [self status],
	    headers : {"Content-Type":contentType},
	    body : [[self stringValue]]
	};
}

@end

@implementation CCHTMLLayout : CCLayout
{
	CPString title @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		status = 200;
		contentType = @"text/html";
	}
	return self;
}

- (CPString)stringValue
{
	return [CPString stringWithFormat:@"<html>\n\t<head>\n\t\t<title>%@</title>\n\t</head>\n\t<body>\n\t%@\n\t</body>\n</html>",title,content];
}

@end

@implementation CCJSONLayout : CCLayout
{
	
}

- (id)init
{
	if (self = [super init])
	{
		status = 200;
		contentType = @"text/json";
	}
	return self;
}

- (CPString)stringValue
{
	return JSON.stringify(content);
}

@end