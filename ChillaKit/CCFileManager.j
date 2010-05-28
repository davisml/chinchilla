var file = require("file");
var defaultManager = nil;

@implementation CCFileManager : CPObject
{
	
}

- (id)init
{
	if (self = [super init])
	{
		
	}
	return self;
}

+ (id)defaultManager
{
	if (defaultManager==nil)
		defaultManager = [[self alloc] init];
	return defaultManager;
}

- (CPArray)contentsOfDirectoryAtPath:(CPString)path error:(CPError)error
{
	return file.list(path);
}

- (BOOL)fileExistsAtPath:(CPString)path
{
	return CCFileExistsAtPath(path);
}

- (BOOL)fileExistsAtPath:(CPString)path isDirectory:(BOOL)flagPointer
{
	flagPointer = CCFileIsDirectoryAtPath(path);
	return [self fileExistsAtPath:path];
}

- (CPData)contentsAtPath:(CPString)path
{
	return CCFileContentsAtPath(path);
}

- (BOOL)contentsEqualAtPath:(CPString)path1 andPath:(CPString)path2
{
	return ([self contentsAtPath:path1]==[self contentsAtPath:path2]);
}

- (BOOL)moveItemAtPath:(CPString)path1 toPath:(CPString)path2 error:(CPError)error
{
	return CCFileMoveToPath(path1,path2);
}

- (BOOL)copyItemAtPath:(CPString)path1 toPath:(CPString)path2 error:(CPError)error
{
	return CCFileCopyToPath(path1,path2);
}

@end

function CCFileCleanPath(path)
{
	var newPath = path;
	if ([newPath hasPrefix:@"file:"])
	 	newPath = [newPath substringFromIndex:5];
	return newPath;
}

function CCFileExistsAtPath(path)
{
	return file.exists(CCFileCleanPath(path));
}

function CCFileIsDirectoryAtPath(path)
{
	return file.isDirectory(CCFileCleanPath(path));
}

function CCFileContentsAtPath(path)
{
	return file.read(CCFileCleanPath(path),[]);
}

function CCFileMoveToPath(filePath,toPath)
{
	file.move(CCFileCleanPath(filePath),CCFileCleanPath(toPath));
	return YES;
}


function CCFileCopyToPath(filePath,toPath)
{
	file.copy(CCFileCleanPath(filePath),CCFileCleanPath(toPath));
	return YES;
}