//
//  DCMenuItemHelper.m
//  dc
//
//  Created by Work on 25/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import "NMMenuItemHelper.h"
#import "NMAppUtils.h"
#import "NMFlagCache.h"
#import "NMCachedMenuItemFinder.h"
#import "NMUIElement.h"

@implementation NMMenuItemHelper

- (id)init
{
	self=[super init];
	if (self) {
		_flagCache=[[NMFlagCache alloc] init];
		_finders=[NSMutableArray array];
		_opq=[[NSOperationQueue alloc] init];
		[_opq setMaxConcurrentOperationCount:8]; // just to stop it getting carried away
	}
	return self;
}

- (void)addFinder:(NMCachedMenuItemFinder *)finder
{
	[_finders addObject:finder];
}

- (void)updateInBackgroundForPid:(pid_t)pid
{
    AXUIElementRef ref=AXUIElementCreateApplication(pid);
    if (ref) {            
        BOOL refReleased=NO;
        if (pid>=0 ) {
            NSNumber *pidNum=[NSNumber numberWithPid:pid];
            if ([_flagCache raiseFlagForKey:pidNum]) {
                refReleased=YES;
                [_opq addOperationWithBlock: ^{
                    NMUIElement *menuBar=[[[NMUIElement alloc] initWithElement:ref] menuBarDirect];
                    if (menuBar) {
                        for(NMCachedMenuItemFinder *finder in _finders) {
                            [finder refreshCacheForMenuBar:menuBar pidNum:pidNum];
                        }
                    }
                    [_flagCache lowerFlagForKey:pidNum];                         
                    if (ref) {
                        CFRelease(ref);
                    }
                }];
            }		
        }
        if(!refReleased) {
            CFRelease(ref);
        }
    }
}

- (void)forgetPid:(pid_t)pid
{
	if (pid<0) {
		return;
	}
	NSNumber *pidNum=[NSNumber numberWithPid:pid];
	[_finders makeObjectsPerformSelector:@selector(forgetPidNum:) withObject:pidNum];
	[_flagCache discardFlagIfNotRaised:pidNum];
}

- (void)forgetAllRunningPids
{
    for(NSRunningApplication *ra in [[NSWorkspace sharedWorkspace] runningApplications]) {
        [self forgetPid:ra.processIdentifier];
    }
}

@end
