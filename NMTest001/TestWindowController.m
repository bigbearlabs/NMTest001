//
//  TestWindowController.m
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestWindowController.h"


@implementation TestWindowController

@synthesize appDisplayName, menuItemTitle, foundMenuItemTitle, foundMenuItemState;


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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window setLevel:NSFloatingWindowLevel];

    self.menuItemTitle=@"Copy";
}

- (void)showWindow:(id)sender
{
    NSLog(@"sw");
    [self.window center];
    [self.window makeKeyAndOrderFront:self];
}

@end
