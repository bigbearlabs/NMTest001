//
//  DCCachedMenuItemFinder.m
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import "NMCachedMenuItemFinder.h"
#import "NMAppUtils.h"

@implementation NMCachedMenuItemFinder

- (id)initWithExpectedMenu:(NSUInteger)aMenu
			 expectedDepth:(NSUInteger)aDepth
		generalSearchDepth:(NSUInteger)aGeneralSearchDepth
					 block:(BOOL (^)(NMUIElement *))aBlock
{
	self=[super initWithExpectedMenu:aMenu
					   expectedDepth:aDepth
				  generalSearchDepth:aGeneralSearchDepth
							   block:aBlock];
	if(self)
	{
		cache=[NSMutableDictionary dictionary];		
	}
	return self;
}

- (void)refreshCacheForMenuBar:(NMUIElement *)menuBar pidNum:(NSNumber *)pidNum
{
	if ([pidNum pidValue]<0) {
		return;
	}
	NMMenuItemLocation *location=[cache objectForKey:pidNum];
	if (!location) {
		NMMenuItemLocation *foundLocation=[self findItemInMenuBar:menuBar];		
		if (foundLocation) {			
			@synchronized(cache) {
				[cache setObject:foundLocation forKey:pidNum];
			}
		}
	};
}

- (NMUIElement *)cachedItemForMenuBar:(NMUIElement *)menuBar pidNum:(NSNumber *)pidNum
{
	NMMenuItemLocation *loc;
	@synchronized(cache) {
		loc=[cache objectForKey:pidNum];
	}
	NMUIElement *element=[loc resolveWithMenuBar:menuBar];
	return [self validate:element] ? element : nil;
}

- (void)forgetPidNum:(NSNumber *)pidNum
{
	@synchronized(cache) {
		[cache removeObjectForKey:pidNum];
	}
}

- (NSString *)description {
    return [cache description];
}

@end
