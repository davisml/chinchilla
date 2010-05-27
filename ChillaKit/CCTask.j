var OS = require("os");

@implementation CCTask : CPObject
{
	CPString command @accessors;
	Object _taskOpen;
}

- (id)initWithCommand:(CPString)aCommand
{
	if (self = [super init])
	{
		command = aCommand;
	}
	return self;
}

- (void)execute
{
	_taskOpen = OS.popen(command);
}

- (CPString)result
{
	return _taskOpen.stdout.read();
}

+ (id)taskWithCommand:(CPString)aCommand
{
	var task = [[self alloc] initWithCommand:aCommand];
	[task execute];
	return task;
}

@end