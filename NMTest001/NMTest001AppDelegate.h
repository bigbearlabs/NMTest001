//
//  NMTest001AppDelegate.h
//  NMTest001
//
//  Created by Nick Moore on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TestWindowController.h"

@interface NMTest001AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray *windowControllers;
}
- (IBAction)createNewWindow:(id)sender;

@end
