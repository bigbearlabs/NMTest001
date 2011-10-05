//
//  TestWindowController.h
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NMUIElement.h"

@interface TestWindowController : NSWindowController {
    // internals
    NMUIElement *menuItem;
    NSDate *lastMouseUpDate;
    NSTimer *timer;
    BOOL lastState;
    BOOL timing;
    
    // ui
    NSString *appDisplayName;
    NSString *menuItemTitle;
    NSString *foundMenuItemTitle;
    NSString *foundMenuItemState;
    NSString *timerString;
}

@property (assign) NSString *appDisplayName;
@property (assign) NSString *menuItemTitle;
@property (assign) NSString *foundMenuItemTitle;
@property (assign) NSString *foundMenuItemState;
@property (assign) NSString *timerString;

- (void)handleNewElement:(NMUIElement *)element;
- (void)handleMouseUpInWindow;

@end
