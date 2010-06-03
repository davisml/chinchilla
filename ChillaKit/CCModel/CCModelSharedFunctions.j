function CCModelRawName(modelName)
{
	return [[modelName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"]
}

function CCModelTableName(modelName)
{
	return CCModelRawName(modelName) + "s";
}