//
//  DCLockedCache.m
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import "NMFlagCache.h"

@interface DCFlag : NSObject {
	BOOL on;
}
@end
@implementation DCFlag
- (BOOL)tryRaise {
	return on ? NO : (on=YES);
}
- (void)lower {
	on=NO;
}
@end

// flag can be raised and lowered fo each object. call from any thread, since all operations occur on main thread (avoids sync issues)
@implementation NMFlagCache
- (id)init
{
	self=[super init];
	if (self) {
		_flags=[NSMutableDictionary dictionary];
	}
	return self;
}
- (BOOL)raiseFlagForKey:(id)key
{
	__block BOOL gotLock=NO;
	@synchronized(_flags) {
		DCFlag *lock=[_flags objectForKey:key];
		if (!lock) {
			lock=[[DCFlag alloc] init];
			[_flags setObject:lock forKey:key];
		}
		gotLock=[lock tryRaise];
	}
	return gotLock;
}
- (void)lowerFlagForKey:(id)key
{
	@synchronized(_flags) {
		[[_flags objectForKey:key] lower];
	}
}
- (void)discardFlagIfNotRaised:(id)key
{
	@synchronized(_flags) {
		DCFlag *lock=[_flags objectForKey:key];
		if ([lock tryRaise]) {
			[_flags removeObjectForKey:key];
			[lock lower];
		}
	}
}
@end