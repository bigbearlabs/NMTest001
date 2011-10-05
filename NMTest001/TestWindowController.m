//
//  TestWindowController.m
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestWindowController.h"


@implementation TestWindowController

@synthesize appDisplayName, menuItemTitle, foundMenuItemTitle, foundMenuItemState, timerString;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NMUIElement *)findItemInMenuBar:(NMUIElement *)menuBar usingBlock:(BOOL (^)(NMUIElement *))block;
{
    __block NMUIElement *result=nil;
    NSUInteger expectedMenu=3; // note: searching edit menu only
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

// called frequently to poll the menu item state and update the ui
- (void)timerRoutine
{
    NSString *titleString=[NSString stringWithFormat:@"no match for '%@'", self.menuItemTitle];
    NSString *stateString=@"unknown";
    NSString *newTimerString=self.timerString;
    
    const BOOL currentState=[menuItem enabled];
    if (currentState!=lastState) {
        // state changed
        timing=NO;
    }
    lastState=[menuItem enabled];
    
    if (menuItem) {
        titleString=[menuItem title];
        stateString=currentState?@"Enabled":@"Disabled";
    }
    else {
        newTimerString=@"";
    }
    
    if(timing) {
        NSTimeInterval interval=-[lastMouseUpDate timeIntervalSinceNow];    
        newTimerString=[NSString stringWithFormat:@"%0.2fs", interval];
    }
    
    // update the UI
    self.foundMenuItemTitle=titleString;
    self.foundMenuItemState=stateString;
    self.timerString=newTimerString;
}

- (void)handleNewElement:(NMUIElement *)element
{
    // find and save new menu bar
    NMUIElement *appElement=[element appElement];
    NMUIElement *menuBar=[appElement menuBar];
    menuItem=[self findItemInMenuBar:menuBar usingBlock:^(NMUIElement *element) {
        return [[element title] isEqualToString:self.menuItemTitle];
    }];

    // what it this app's name and pid
    self.appDisplayName=[NSString stringWithFormat:@"%@ (%i)", [appElement title],[appElement pid]];
    [self timerRoutine];    
}

- (void)handleMouseUpInWindow
{
    // start timing
    lastMouseUpDate=[NSDate date];
    timing=!!menuItem;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setLevel:NSFloatingWindowLevel];
    self.menuItemTitle=@"Copy";
    self.appDisplayName=@"(click in an app window)";
    
    lastState=NO;
    timing=NO;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(timerRoutine) userInfo:nil repeats:YES];
}

- (void)showWindow:(id)sender
{
    [self.window center];
    [self.window makeKeyAndOrderFront:self];
}

@end
