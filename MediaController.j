var JDBC = require("jdbc");

@implementation MediaController : CPObject
{
	Connection	conn;
	Statement	stat;
}

- (id)init
{
	if (self = [super init])
	{
		conn = JDBC.connect("jdbc:mysql://"+CONFIG.dbHost+":3306/"+CONFIG.dbName+"?user="+CONFIG.dbUser+"&password="+CONFIG.dbPassword);
		stat = conn.createStatement();
		//prep = conn.prepareStatement("insert into people values (?, ?);");
	}
	return self;
}

- (void)mediaItems
{
	var mediaItems = [];

	var rs = stat.executeQuery("select * from media;");
	while (rs.next()) {
		var mediaID = ""+rs.getString("id");
		var mediaURL = ""+rs.getString("media_url");
		var thumbnailURL = ""+rs.getString("thumbnail_url");
		var caption = ""+rs.getString("caption");
		
	    mediaItems.push({id: mediaID, media_url:mediaURL, thumbnail_url:thumbnailURL, caption:caption, entity_name:"Photo"});
	}
	rs.close();
	
	return {code:"1", records:mediaItems};
}

@end