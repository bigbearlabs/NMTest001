//
//  DCCachedMenuItemFinder.h
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMMenuItemFinder.h"

@interface NMCachedMenuItemFinder : NMMenuItemFinder {
	NSMutableDictionary *cache;
}
- (id)initWithExpectedMenu:(NSUInteger)aMenu
			 expectedDepth:(NSUInteger)aDepth
		generalSearchDepth:(NSUInteger)aGeneralSearchDepth
					 block:(BOOL (^)(NMUIElement *))aBlock;


- (void)refreshCacheForMenuBar:(NMUIElement *)menuBar pidNum:(NSNumber *)pidNum;
- (NMUIElement *)cachedItemForMenuBar:(NMUIElement *)menuBar pidNum:(NSNumber *)pidNum;
- (void)forgetPidNum:(NSNumber *)pidNum;

@end
