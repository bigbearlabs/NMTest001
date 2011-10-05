//
//  DCMenuItemHelper.h
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NMCachedMenuItemFinder, NMFlagCache, NMUIElement;

@interface NMMenuItemHelper : NSObject {
	NMFlagCache *_flagCache;
	NSMutableArray *_finders;
	NSOperationQueue *_opq;
}
- (void)addFinder:(NMCachedMenuItemFinder *)finder;
- (void)updateInBackgroundForPid:(pid_t)pid;
- (void)forgetPid:(pid_t)pid;
- (void)forgetAllRunningPids;
@end
