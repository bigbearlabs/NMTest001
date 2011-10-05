//
//  NMGeometryUtils.m
//  dc
//
//  Created by Work on 03/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NMGeometryUtils.h"

Boolean NMPointsWithinDistance(CGPoint p, CGPoint q, CGFloat d)
{
	return (p.x - q.x) * (p.x - q.x) + (p.y - q.y) * (p.y - q.y) <= d * d;	
}

Boolean NMPointInCorner(CGPoint p, CGRect r, CGFloat d)
{
	CGFloat xmin = r.origin.x + d;
	CGFloat xmax = r.origin.x + r.size.width - 1 - d;
	CGFloat ymin = r.origin.y + d;
	CGFloat ymax = r.origin.y + r.size.height - 1 - d;
	return 	CGRectContainsPoint(r, p)
	&& (p.x <= xmin || p.x >= xmax)
	&& (p.y <= ymin || p.y >= ymax);
}	

CGFloat NMFlipY(CGFloat y)
{
	return [(NSScreen *)[[NSScreen screens] objectAtIndex:0] frame].size.height-y;
}

NSPoint NMFlipPoint(NSPoint point)
{
    point.y=NMFlipY(point.y);
    return point;
}

NSRect NMFlipRect(NSRect rect)
{
	rect.origin.y=NMFlipY(rect.origin.y+rect.size.height);	
	return rect;
}

/* Return origin of inner rect centered in outer rect */
NSPoint NMPointForCenteredBoxInBox(NSSize box, NSSize container)
{
	return NSMakePoint((container.width-box.width)*0.5,(container.height-box.height)*0.5);
}

/* Return inner rect centered in outer rect */
NSRect NMRectForCenteredBoxInBox(NSSize box, NSSize container)
{
	return NSMakeRect((container.width-box.width)*0.5,(container.height-box.height)*0.5, box.width, box.height);
}

NSPoint NMPointRound(NSPoint point)
{
    return NSMakePoint(round(point.x), round(point.y));
}
