var JDBC = require("jdbc");

@import "CCDataCredentials.j"

@implementation CCDataConnection : CPObject
{
	Connection _jdbcConnection @accessors;
}

- (id)initWithCredentials:(CCDataCredentials)credentials
{
	if (self = [super init])
	{
		var connectionURL = [CPString stringWithFormat:@"jdbc:mysql://%@:3306/%@?user=%@&password=%@",[credentials host],[credentials database],[credentials username],[credentials password]];
		_jdbcConnection = JDBC.connect(connectionURL);
	}
	return self;
}

- (id)createStatement
{
	return [[CCDataStatement alloc] initWithDataConnection:self];
}

- (id)prepareStatement:(CPString)statement
{
	return _jdbcConnection.prepareStatement(statement);
}

+ (id)connectionWithCredentials:(CCDataCredentials)credentials
{
	return [[[self alloc] initWithCredentials:credentials] autorelease];
}

@end

@implementation CCDataStatement : CPObject
{
	Statement _jdbcStatement;
}


- (id)initWithDataConnection:(id)dbConnection
{
	if (self = [super init])
	{
		_jdbcStatement = dbConnection.createStatement();
	}
	return self;
}

- (void)executeUpdate:(CPString)updateString
{
	_jdbcStatement.executeUpdate(updateString);
}

- (id)executeQuery:(CPString)queryString
{
	return _jdbcStatement.executeQuery(queryString);
}

@end