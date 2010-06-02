var JDBC = require("jdbc");

@implementation CCModel : CPObject
{
	Statement stat;
}

- (id)init
{
	if (self = [super init])
	{
		stat = [[CCModelConnection sharedModelConnection] createStatement];
	}
	return self;
}

+ (id)model
{
	return [[self alloc] init];
}

- (CPArray)columns
{
	return [];
}

- (CPString)tableName
{
	return @"";
}

- (CPString)name
{
	return @"";
}

- (CPArray)findAll
{
	var queryString = "select * from "+[self tableName]+";";
	return CCModelRecordsWithResult(stat.executeQuery(queryString),[self columns]);
}

- (Object)findByID:(CPString)recordID
{
	var queryString = "select * from "+[self tableName]+" where id = "+recordID+";";
	var records = CCModelRecordsWithResult(stat.executeQuery(queryString),[self columns]);
	return [records lastObject];
}

- (void)insert:(Object)anObject
{
	var keys = [CPMutableArray array];
	var values = [CPMutableArray array];
	
	for (var key in anObject)
	{
		[keys addObject:key];
		[values addObject:anObject["key"]];
	}
	
	var fieldString = [keys componentsJoinedByString:@", "];
	var valueString = "'"+[values componentsJoinedByString:@"', '"]+"'";
	var sqlString = "INSERT INTO "+[self tableName]+" ("+fieldString+") VALUES("+valueString+");";
	
	stat.executeUpdate(sqlString);
}

@end

var sharedModelConnection;

@implementation CCModelConnection : CPObject
{
	Connection	conn;
}

- (id)init
{
	if (self = [super init])
	{
		conn = JDBC.connect("jdbc:mysql://"+CONFIG.dbHost+":3306/"+CONFIG.dbName+"?user="+CONFIG.dbUser+"&password="+CONFIG.dbPassword);
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

function CCModelRecordWithResult(rs,columns)
{
	var record = {};

	for (var i=0; i<[columns count]; i++)
	{
		var column = [columns objectAtIndex:i];
		record[column] = ""+rs.getString(column);
	}

	return record;
}

function CCModelRecordsWithResult(rs,columns)
{
	var records = [];
	while (rs.next()) records.push(CCModelRecordWithResult(rs,columns));
	rs.close();
	return records;
}