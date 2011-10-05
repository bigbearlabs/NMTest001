//
//  DCLockedCache.h
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMFlagCache : NSObject {
	NSMutableDictionary *_flags;
}
- (BOOL)raiseFlagForKey:(id)key; // YES if lock was aquired
- (void)lowerFlagForKey:(id)key;
- (void)discardFlagIfNotRaised:(id)key; // only removes if not locked
@end
