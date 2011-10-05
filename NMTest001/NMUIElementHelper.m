//
//  NMUIElementHelper.m
//  dc
//
//  Created by Work on 21/10/2010.
//  Copyright 2010 Nicholas Moore. All rights reserved.
//

#import "NMUIElementHelper.h"

static const NSInteger _work=1;
static const NSInteger _free=0;

@implementation NMUIElementHelper

+ (AXUIElementRef) systemWideElement {
	static AXUIElementRef systemWide = NULL;
	if (!systemWide) {
		systemWide = AXUIElementCreateSystemWide();
	}
	return systemWide;
}

- (AXError) lastError
{
	return lastError;
}

// this method can block for several seconds
- (AXUIElementRef)elementAtUnflippedLocation:(NSPoint)point
{
	lastError=kAXErrorSuccess;
	
	// get system element
	AXUIElementRef element=NULL;
	
	// get current element
	lastError=AXUIElementCopyElementAtPosition ([NMUIElementHelper systemWideElement], point.x, point.y, &element);
	CFRelease(system);
	if (kAXErrorSuccess!=lastError || !element)
	{
		return NULL;
	}
	
	return element;
}

// get a UI element within "timeout" seconds if possible. otherwise just return nil.
- (AXUIElementRef)elementAtUnflippedLocation:(NSPoint) point timeout:(NSTimeInterval)timeout
{
	if ([conditionLock tryLockWhenCondition:_free])
	{
		param=point;
		[conditionLock unlockWithCondition:_work];			
		if([conditionLock lockWhenCondition:_free beforeDate:[NSDate dateWithTimeIntervalSinceNow:timeout]])
		{
			[conditionLock unlock];
			return result;
		}
	}
	return nil;
}

- (void)threadRoutine
{
	while (1) { // producer thread runs indefinitely
		[conditionLock lockWhenCondition:_work];
		result = [self elementAtUnflippedLocation:param]; 
		[conditionLock unlockWithCondition:_free];				
	}
}

- (id)init
{
	self=[super init];
	conditionLock = [[NSConditionLock alloc] initWithCondition:_free];
	[NSThread detachNewThreadSelector:@selector(threadRoutine) toTarget:self withObject:nil];	
	return self;
}

@end
