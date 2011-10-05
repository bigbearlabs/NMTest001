//
//  NMTest001AppDelegate.h
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NMUIElement;

@interface NMTest001AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;

    // internals
    NMUIElement *menuItem;
    
    // ui
    NSString *appDisplayName;
    NSString *menuItemTitle;
    NSString *foundMenuItemTitle;
    NSString *foundMenuItemState;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) NSString *appDisplayName;
@property (assign) NSString *menuItemTitle;
@property (assign) NSString *foundMenuItemTitle;
@property (assign) NSString *foundMenuItemState;
@end
