/*
	@global
	@group CCQueryKey
*/

CCQueryConditionsKey = @"conditions";
CCQueryFieldsKey = @"fields";
CCQueryOrderKey = @"order";
CCQueryLimitKey = @"limit";
CCQueryRecursive = @"recursive";

function CCModelQueryWithObject(queryObject,model)
{
	var tableArray = [CPMutableArray array];
	[tableArray addObject:[model tableName]];
	
	var conditionArray = [CPMutableArray array];
	var sortArray = [CPMutableArray array];
	var limit = 0;
	
	/*var associations = [model associations];
	for (var i=0; i<[associations count]; i++)
	{
		var association = [associations objectAtIndex:i];
		[tableArray addObject:[association foreignTable]];
	}*/
	
	if (queryObject != nil)
	{
		/*var fields = queryObject[CCQueryFieldsKey];
		
		if (fields != nil)
		{
			fieldsStatement = @"";
			var conditionStrings = [CPMutableArray array];
		
			for (var key in conditions)
			{
				var value = conditions[key];
				var conditionString = key+"='"+value+"'";
				[conditionStrings addObject:conditionString];
			}
		
			if ([conditionStrings count]>0)
				whereStatement = " WHERE "+[conditionStrings componentsJoinedByString:@", "];
		}*/
		
		var conditions = queryObject[CCQueryConditionsKey];
		if (conditions != nil)
		{
			for (var key in conditions)
			{
				var value = conditions[key];
				var conditionString = key+"='"+value+"'";
				[conditionArray addObject:conditionString];
			}
		}
		
		var limitString = queryObject[CCQueryLimitKey];
		if (limitString != nil)
			limit = parseInt(limitString);
		
		var sortDescriptors = queryObject[CCQueryOrderKey];
		if (sortDescriptors != nil)
		{
			for (var i=0;i<[sortDescriptors count];i++)
			{
				var sortDescriptor = [sortDescriptors objectAtIndex:i];
				var orderString = [sortDescriptor key]+" "+[sortDescriptor ascending]?@"ASC":@"DESC";
				[sortArray addObject:orderString];
			}
		}
	}
	
	var fieldStatement = "*";
	var tableStatement = ([tableArray count]==1)?[tableArray lastObject]:[tableArray componentsJoinedByString:@", "];
	var whereStatement = ([conditionArray count]>0)?" WHERE "+[conditionArray componentsJoinedByString:@", "]:"";
	var orderStatement = ([sortArray count]>0)?" ORDER BY "+[sortArray componentsJoinedByString:@", "]:"";
	var limitStatement = (limit > 0)?" LIMIT "+limit:"";
	
	var queryString = "SELECT "+fieldStatement+" FROM "+tableStatement+whereStatement+orderStatement+limitStatement+";";
	CCLog(queryString);
	return queryString;
}