@import "../../Config/CCDatabaseConfig.j"

var JDBC = require("jdbc");
var sharedModelConnection;

@implementation CCModelConnection : CPObject
{
	Connection	conn;
}

- (id)init
{
	if (self = [super init])
	{
		CCLog(@"init database connection");
		CCLog(CCDatabaseConfig.adapter);
		
		if ([CCDatabaseConfig.adapter isEqual:@"mysql"])
			conn = JDBC.connect("jdbc:mysql://"+CCDatabaseConfig.server+":3306/"+CCDatabaseConfig.database+"?user="+CCDatabaseConfig.username+"&password="+CCDatabaseConfig.password);
		else if ([[self adapter] hasPrefix:@"sqlite"])
			conn = JDBC.connect("jdbc:sqlite:"+CCDatabaseConfig.database);
	}
	return self;
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