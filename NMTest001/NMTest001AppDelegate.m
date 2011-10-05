//
//  NMTest001AppDelegate.m
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NMTest001AppDelegate.h"

@implementation NMTest001AppDelegate

- (IBAction)createNewWindow:(id)sender
{
    TestWindowController *windowController=[[TestWindowController alloc] initWithWindowNibName:@"Window"];
    [windowControllers addObject:windowController];
    [windowController showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    windowControllers=[NSMutableArray array];
    [self createNewWindow:self];
    
    
    // Insert code here to initialize your application
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSLeftMouseUpMask handler:^(NSEvent *event) {
        static pid_t prev_pid=-1;
        
        // get the UI Element at the mouse location
		NSPoint point=NSPointFromCGPoint(CGEventGetUnflippedLocation((CGEventRef)NSMakeCollectable(CGEventCreate(NULL))));
        
        NMUIElement *const element=[NMUIElement elementAtLocation:point timeout:0.5];
        const pid_t this_pid=element.pid;
        
        const NSEventType type=[event type];
        NSLog(@"lmd");
        if (type==NSLeftMouseDown) {
            if (this_pid!=prev_pid) {
                [windowControllers makeObjectsPerformSelector:@selector(handleNewElement:) withObject:element];
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
    return YES;
}

@end
