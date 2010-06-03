@import "CCModelAssociation.j"
@import "CCModelConnection.j"
@import "CCModelSharedFunctions.j"

var CCQueryConditionsKey = @"conditions";
var CCQueryFieldsKey = @"fields";
var CCQueryOrderKey = @"order";
var CCQueryLimitKey = @"limit";

@implementation CCModel : CPObject
{
	Statement		stat;
	CPMutableArray	associations @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		stat = nil;
		associations = [[CPMutableArray alloc] init];
	}
	return self;
}

+ (id)model
{
	return [[self alloc] init];
}

- (void)addAssociation:(CCModelAssociation)association
{
	[association setAssociatedModel:self];
	[associations addObject:association];
}

- (Statement)statement
{
	CCLog(@"return statement");
	if (stat == nil)
		stat = [[CCModelConnection sharedModelConnection] createStatement];
	return stat;
}

- (CPArray)columns
{
	return [];
}

- (CPString)tableName
{
	return CCModelTableName([self name]);
}

- (CPString)name
{
	return @"";
}

- (CPArray)find:(Object)queryObject
{
	return CCModelRecordsWithQuery([self statement],queryObject,[self tableName],[self _allColumns]);
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

- (BOOL)saveObject:(Object)anObject
{
	if (anObject["id"] == nil)
		return [self insertObject:anObject];
	return [self updateObject:anObject];
}

- (BOOL)insertObject:(Object)anObject
{
	return CCModelInsertObject([self statement],anObject,[self tableName]);
}

- (BOOL)updateObject:(Object)anObject
{
	// Implement this
	return NO;
}

- (CPString)idKey
{
	return @"id";
}

- (CPArray)_allColumns
{
	var allColumns = [CPMutableArray arrayWithArray:[self columns]];
	if ([self idKey]!=nil)
	{
		if (![allColumns containsObject:[self idKey]])
			[allColumns addObject:[self idKey]];
	}
	return allColumns;
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
	}
	
	return "select * from "+tableName+whereStatement+orderStatement+limitStatement+";";
}

function CCModelInsertObject(stat,anObject,tableName)
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
	var sqlString = "INSERT INTO "+tableName+keyString+valueString+";";

	stat.executeUpdate(sqlString);
}