//
//  NMTest001AppDelegate.m
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NMTest001AppDelegate.h"
#import "NMUIElement.h"
#import "NMMenuItemFinder.h"

@implementation NMTest001AppDelegate

@synthesize window, appDisplayName, menuItemTitle, foundMenuItemTitle, foundMenuItemState;

- (NMUIElement *)findItemInMenuBar:(NMUIElement *)menuBar usingBlock:(BOOL (^)(NMUIElement *))block;
{
    __block NMUIElement *result=nil;
    NSUInteger expectedMenu=3;
    NSUInteger expectedDepth=2;
    [[menuBar childAtIndex:expectedMenu] enumerateDescendentsToDepth:expectedDepth
                                                          usingBlock:^(NMUIElement *element, NSUInteger depth, const NSUInteger *path, BOOL *stop) {
                                                              if (depth==expectedDepth)
                                                              {
                                                                  if (block(element))
                                                                  {
                                                                      result=element;
                                                                      *stop=YES;
                                                                  }
                                                              }
                                                          }];
    return result;
}

- (void)handleNewElement:(NMUIElement *)element
{
    // finf and save new menu bar
    NMUIElement *appElement=[element appElement];
    NMUIElement *menuBar=[appElement menuBar];
    menuItem=[self findItemInMenuBar:menuBar usingBlock:^(NMUIElement *element) {
        return [[element title] isEqualToString:self.menuItemTitle];
    }];

    NSLog(@"menuItem %@ %@ %d", menuItem, menuItem.title, menuItem.enabled);
    
    
    // what it this app's name and pid
    self.appDisplayName=[appElement title];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.window setLevel:NSFloatingWindowLevel];
    self.menuItemTitle=@"Copy";
    
    // Insert code here to initialize your application
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSLeftMouseUpMask handler:^(NSEvent *event) {
        static pid_t prev_pid=-1;

        // get the UI Element at the mouse location
		NSPoint point=NSPointFromCGPoint(CGEventGetUnflippedLocation((CGEventRef)NSMakeCollectable(CGEventCreate(NULL))));
        
        NMUIElement *const element=[NMUIElement elementAtLocation:point timeout:0.5];
        const pid_t this_pid=element.pid;

        const NSEventType type=[event type];        
        if (type==NSLeftMouseDown) {
            if (this_pid!=prev_pid) {
                [self handleNewElement:element];
            }
        }
        else if (type==NSLeftMouseUp)
        {
            NSLog(@"left mouse up");
        }
        
        prev_pid=this_pid;
    }];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    YES;
}

@end
