var JDBC = require("jdbc");

var CCQueryConditionsKey = @"conditions";
var CCQueryFieldsKey = @"fields";
var CCQueryOrderKey = @"order";
var CCQueryLimitKey = @"limit";

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

- (CPArray)find:(Object)queryObject
{
	return CCModelRecordsWithQuery(stat,queryObject,[self tableName],[self columns]);
}

- (CPArray)findAll
{
	return [self find:nil];
}

- (Object)findByID:(CPString)recordID
{
	var queryObject = {CCQueryConditionsKey:{"id":recordID},CCQueryLimitKey:"1"};
	return [[self find:queryObject] lastObject];
}

- (void)insert:(Object)anObject
{
	var keys = [CPMutableArray array];
	var values = [CPMutableArray array];
	
	for (var key in anObject)
	{
		[keys addObject:key];
		[values addObject:"'"+anObject[key]+"'"];
	}
	
	var keyString = " ("+[keys componentsJoinedByString:@", "]+")";
	var valueString = " VALUES("+[values componentsJoinedByString:@", "]+")";
	var sqlString = "INSERT INTO "+[self tableName]+keyString+valueString+";";
	
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

function CCModelRecordsWithQuery(stat,queryObject,tableName,columns)
{
	var queryString = CCModelQueryWithObject(queryObject,tableName);
	return CCModelRecordsWithResult(stat.executeQuery(queryString),columns);
}

function CCModelRecordsWithResult(rs,columns)
{
	var records = [];
	while (rs.next()) records.push(CCModelRecordWithResult(rs,columns));
	rs.close();
	return records;
}

function CCModelQueryWithObject(queryObject,tableName)
{
	var whereStatement = @"";
	var orderStatement = @"";
	var limitStatement = @"";
	
	if (queryObject != nil)
	{
		var conditions = queryObject[CCQueryConditionsKey];
	
		if (conditions != nil)
		{
			var conditionStrings = [CPMutableArray array];
		
			for (var key in conditions)
			{
				var value = conditions[key];
				var conditionString = key+"='"+value+"'";
				[conditionStrings addObject:conditionString];
			}
		
			if ([conditionStrings count]>0)
				whereStatement = " WHERE "+[conditionStrings componentsJoinedByString:@", "];
		}
	}
	
	var limit = queryObject[CCQueryLimitKey];
	if (limit != nil)
		limitStatement = " LIMIT "+limit;
	
	var sortDescriptors = queryObject[CCQueryOrderKey];
	if (sortDescriptors != nil)
	{
		var orderStatements = [CPMutableArray array];
		
		for (var i=0;i<[sortDescriptors count];i++)
		{
			var sortDescriptor = [sortDescriptors objectAtIndex:i];
			[orderStatements addObject:[sortDescriptor key]+" "+[sortDescriptor ascending]?@"ASC":@"DESC"];
		}
		
		orderStatement = " ORDER BY "+[orderStatements componentsJoinedByString:@", "];
	}
	
	return "select * from "+tableName+whereStatement+orderStatement+limitStatement+";";
}