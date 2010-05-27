@implementation CCDataCredentials : CPObject
{
	CPString host @accessors;
	CPString username @accessors;
	CPString password @accessors;
	CPString database @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		host = @"localhost";
	}
	return self;
}

+ (id)credentialsWithUsername:(CPString)aUsername password:(CPString)aPassword database:(CPString)aDatabase
{
	var credentials = [[self alloc] init];
	credentials.username = aUsername;
	credentials.password = aPassword;
	credentials.database = aDatabase;
	return [credentials autorelease];
}

@end