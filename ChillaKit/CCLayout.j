@implementation CCLayout : CPObject
{
	CPString content @accessors;
	int status @accessors;
	JSObject headers @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		status = 200;
		headers = {};
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
	    headers : [self headers],
	    body : [[self stringValue]]
	};
}

@end

@implementation CCHTMLLayout : CCLayout
{
	CPString title @accessors;
	CPString style @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		status = 200;
		title = @"Chinchilla";
		style = @"";
		headers = {"Content-Type":"text/html"};
	}
	return self;
}

- (CPString)stringValue
{
	return [CPString stringWithFormat:@"<html>\n\t<head>\n\t\t<title>%@</title>\n\t\t<style type=\"text/css\">%@</style>\n\t</head>\n\t<body>\n\t%@\n\t</body>\n</html>",title,style,content];
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
		headers = {"Content-Type":"text/json"};
	}
	return self;
}

- (CPString)stringValue
{
	return JSON.stringify(content);
}

@end