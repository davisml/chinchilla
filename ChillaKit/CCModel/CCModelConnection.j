var DBConfig = require("./Config/database_config");
var JDBC = require("jdbc");

var sharedModelConnection;

@implementation CCModelConnection : CPObject
{
	Connection	conn;
	CPString	adapter @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		if ([[self adapter] isEqual:@"mysql"])
			conn = JDBC.connect("jdbc:mysql://"+DBConfig.server+":3306/"+DBConfig.database+"?user="+DBConfig.username+"&password="+DBConfig.password);
		else if ([[self adapter] hasPrefix:@"sqlite"])
			conn = JDBC.connect("jdbc:sqlite:"+DBConfig.database);
	}
	return self;
}

- (CPString)adapter
{
	return ""+DBConfig.adapter;
}

- (id)createStatement
{
	return conn.createStatement();
}

+ (CCModelConnection)sharedModelConnection
{
	if (!sharedModelConnection)
		sharedModelConnection = [[self alloc] init];
	return sharedModelConnection;
}

@end