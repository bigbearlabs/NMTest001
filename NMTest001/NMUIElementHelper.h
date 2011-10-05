//
//  NMUIElementHelper.h
//  dc
//
//  Created by Work on 21/10/2010.
//  Copyright 2010 Nicholas Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMUIElementHelper : NSObject {
	NSConditionLock *conditionLock;
	NSPoint param;
	AXUIElementRef result;	
	AXError lastError;
}

+ (AXUIElementRef)systemWideElement;
- (AXError) lastError;
- (AXUIElementRef)elementAtUnflippedLocation:(NSPoint) point;
- (AXUIElementRef)elementAtUnflippedLocation:(NSPoint) point
									 timeout:(NSTimeInterval)timeout;

@end
