@import "CCModelAssociation.j"
@import "CCModelConnection.j"
@import "CCModelSharedFunctions.j"
@import "CCModelQuery.j"

@implementation CCModel : CPObject
{
	Statement		stat;
	CPMutableArray	associations @accessors;
	BOOL			shouldAutoUpdateDates @accessors;
}

- (id)init
{
	if (self = [super init])
	{
		stat = nil;
		shouldAutoUpdateDates = NO;
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
	var timestamp = [CPString stringWithFormat:@"%d",[[CPDate date] timeIntervalSince1970]];
	if (shouldAutoUpdateDates) anObject["updated_at"] = timestamp;
	
	if (anObject["id"] == nil)
	{
		if (shouldAutoUpdateDates) anObject["created_at"] = timestamp;
		return [self insertObject:anObject];
	}
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