// Constructors

function CGRectMake(x,y,width,height)
{
	var rect = new Object();
	rect.origin = CGPointMake(x,y);
	rect.size = CGSizeMake(width,height);
	return rect;
}

function CGPointMake(x,y)
{
	var point = new Object();
	point.x = x;
	point.y = y;
	return point;
}

function CGSizeMake(width,height)
{
	var size = new Object();
	size.width = width;
	size.height = height;
	return size;
}

// Triangles

function CGPointGetHypotenuse(point)
{
	var aSqr = point.x * point.x;
	var bSqr = point.y * point.y;
	return Math.sqrt(aSqr + bSqr);
}

function CGPointUnitVector(point)
{
	var absX = Math.abs(point.x);
	var absY = Math.abs(point.y);
	var unitScaleFactor = (absX > absY)?absX:absY;
	return CGPointMake(point.x/unitScaleFactor,point.y/unitScaleFactor);
}

// Rectangles

function CGRectGetWidth(rect)
{
	return rect.size.width;
}

function CGRectGetHeight(rect)
{
	return rect.size.height;
}

function CGRectGetMinX(rect)
{
	return rect.origin.x;
}

function CGRectGetMinY(rect)
{
	return rect.origin.y;
}

function CGRectGetMaxX(rect)
{
	return rect.origin.x + rect.size.width;
}

function CGRectGetMaxY(rect)
{
	return rect.origin.y + rect.size.height;
}

function CGRectContainsPoint(rect,point)
{
	return (point.x >= rect.origin.x && point.y >= rect.origin.y && point.x < CGRectGetMaxX(rect) && point.y < CGRectGetMaxY(rect));
}

function CGRectInset(rect,xInset,yInset)
{
	return CGRectMake(rect.origin.x+xInset,rect.origin.y+yInset,rect.size.width-xInset,rect.size.height-yInset);
}

// Copying

function CGPointCreateCopy(aLocation)
{
	return CGPointMake(aLocation.x,aLocation.y);
}

function CGSizeCreateCopy(aSize)
{
	return CGSizeMake(aSize.width,aSize.height);
}

function CGRectCreateCopy(aRect)
{
	return CGRectMake(aRect.origin.x,aRect.origin.y,aRect.size.width,aRect.size.height);
}