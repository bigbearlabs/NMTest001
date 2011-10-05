//
//  NMPoint.m
//  DCTest
//
//  Created by Nicholas Moore on 10/03/2010.
//  Copyright 2010 Nicholas Moore. All rights reserved.
//

#import "NMPoint.h"
#import "NMMouseUtils.h"
#import "NMGeometryUtils.h"

@implementation NMPoint

#pragma mark Class methods

// mouse location in appkit coordinates
+ (NMPoint *)currentUnflippedMouseLocation
{
	return [[NMPoint alloc] initWithCGPoint:NMCurrentUnflippedMouseLocation()];
}

// mouse location in quartz coordinates
+ (NMPoint *)currentFlippedMouseLocation
{
	return [[NMPoint alloc] initWithCGPoint:NMCurrentFlippedMouseLocation()];	
}

+ (NMPoint *)zeroPoint
{
	return [[NMPoint alloc] initWithNSPoint:NSZeroPoint];
}

+ (NMPoint *)pointWithNSPoint:(NSPoint)nsPoint
{
	return [[NMPoint alloc] initWithNSPoint:nsPoint];	

}

+ (NMPoint *)pointWithCGPoint:(CGPoint)cgPoint
{
	return [[NMPoint alloc] initWithCGPoint:cgPoint];	
	
}

+ (NMPoint *)pointWithX:(CGFloat)x Y:(CGFloat)y
{
	return [[NMPoint alloc] initWithX:x Y:y];
}


#pragma mark Initializers

- (id)initWithNSPoint:(NSPoint)nsPoint
{
	point = nsPoint;
	return self;
}

- (id)initWithCGPoint:(CGPoint)cgPoint
{
	point = NSPointFromCGPoint(cgPoint);
	return self;
}

- (id)initWithX:(CGFloat)x Y:(CGFloat)y
{
	point.x = x;
	point.y = y;
	return self;
}


#pragma mark Point access

- (NSPoint)nsPoint
{
	return point;
}

- (CGPoint)cgPoint
{
	return NSPointToCGPoint(point);
}

#pragma mark X and Y Components

- (CGFloat)x
{
	return point.x;
}

- (CGFloat)y
{
	return point.y;
}

#pragma mark Flip method

- (NMPoint *)flip
{
	return [NMPoint pointWithX:[self x] Y:[(NSScreen *)[[NSScreen screens] objectAtIndex:0] frame].size.height-[self y]];
}

#pragma mark Distance methods

- (BOOL)isWithinDistance:(CGFloat)distance
				 ofPoint:(NMPoint *)aPoint
{
	return NMPointsWithinDistance([self cgPoint], [aPoint cgPoint], distance);
}

- (BOOL)isWithinDistance:(CGFloat)distance
		  ofCornerOfRect:(NSRect)rect;
{
	return NMPointInCorner([self cgPoint], NSRectToCGRect(rect), distance);
}

#pragma mark NSObject methods

- (BOOL)isEqual:(id)object
{
	if (self == object) {
		return YES;
	}
	if (![object isKindOfClass:[NMPoint class]]) {
		return NO;
	}
	return [self x] == [object x] && [self y] == [object y];
}

- (NSUInteger)hash
{
	return [self x] * 11 + [self y] * 13;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"(%f, %f)", [self x], [self y]];
}

@end