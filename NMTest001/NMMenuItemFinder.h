//
//  DCMenuItemFinder.h
//  dc
//
//  Created by Work on 21/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMUIElement.h"

@interface NMMenuItemLocation : NSObject {
	NSUInteger _path[NM_UIELEMENT_MAX_PATH_DEPTH+2];
	NSUInteger *_start;
	NSUInteger _depth;
}
- (NMUIElement *)resolveWithMenuBar:(NMUIElement *)element;
- (BOOL)isNotFound;
- (BOOL)isValid;
@end

@interface NMMenuItemFinder : NSObject {
	NSUInteger lastIndex;
	NSUInteger expectedMenu;
	NSUInteger expectedDepth;
	NSUInteger generalSearchDepth;
	BOOL (^block)(NMUIElement *);
}

- (id)initWithExpectedMenu:(NSUInteger)aMenu
			 expectedDepth:(NSUInteger)aDepth
		generalSearchDepth:(NSUInteger)aGeneralSearchDepth
					 block:(BOOL (^)(NMUIElement *))aBlock;

- (BOOL)validate:(NMUIElement *)element;
- (NMMenuItemLocation *)findItemInMenuBar:(NMUIElement *)app;

@end
