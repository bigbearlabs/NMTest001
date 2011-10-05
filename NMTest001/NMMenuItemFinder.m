//
//  DCMenuItemFinder.m
//  dc
//
//  Created by Work on 21/01/2011.
//  Copyright 2011 Nicholas Moore. All rights reserved.
//

#import "NMMenuItemFinder.h"

@implementation NMMenuItemLocation
- (NMUIElement *)resolveWithMenuBar:(NMUIElement *)element
{
	if (![self isValid]) return nil;
	const NSUInteger * const end=_start+_depth;
	for(const NSUInteger *p=_start; p<end; p++)
	{
		element=[element childAtIndex:*p];
	}

	return element;
}
- (id)initWithPath:(const NSUInteger *)path depth:(NSUInteger)depth
{
	if (depth>NM_UIELEMENT_MAX_PATH_DEPTH) {
		depth=NM_UIELEMENT_MAX_PATH_DEPTH;
	}
	_start=_path+1;
	_depth=depth;
	memcpy(_start, path, _depth*sizeof(NSUInteger));
	return self;
}
- (id)initWithPath:(const NSUInteger *)path depth:(NSUInteger)depth menuIndex:(NSUInteger)menuIndex
{
	[self initWithPath:path depth:depth];
	*(--_start)=menuIndex;
	_depth++;
	return self;
}
- (id)initWithPath:(const NSUInteger *)path depth:(NSUInteger)depth menuIndex:(NSUInteger)menuIndex appendChild:(NSUInteger)child
{
	[self initWithPath:path depth:depth menuIndex:menuIndex];
	_start[_depth++]=child;
	return self;
}
+ (NMMenuItemLocation *)notFound
{
	return [[NMMenuItemLocation alloc] init];
}
- (BOOL)isNotFound
{
	return _start==NULL;
}
- (BOOL)isValid
{
	return _start!=NULL;
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"Location with depth %lu",_depth];
}
@end


@implementation NMMenuItemFinder

- (id)initWithExpectedMenu:(NSUInteger)aMenu
			 expectedDepth:(NSUInteger)aDepth
		generalSearchDepth:(NSUInteger)aGeneralSearchDepth
					 block:(BOOL (^)(NMUIElement *))aBlock
{
	self=[super init];
	if (self) {
		expectedMenu=aMenu;
		expectedDepth=aDepth*2;
		generalSearchDepth=aGeneralSearchDepth?(aGeneralSearchDepth+1)*2:0;
		block=aBlock;
	}
	return self;
}

- (BOOL)validate:(NMUIElement *)element
{
	return block(element);
}

- (NMMenuItemLocation *)findItemInMenuBar:(NMUIElement *)menuBar
{
	__block NMMenuItemLocation *result=nil;
		
	// look for it in expected menu, if depth specified
	if (expectedDepth)
	{
		[[menuBar childAtIndex:expectedMenu] enumerateDescendentsToDepth:expectedDepth
			usingBlock:^(NMUIElement *element, NSUInteger depth, const NSUInteger *path, BOOL *stop) {
				if (depth==expectedDepth-1)
				{
					if ([self validate:[element childAtIndex:lastIndex]])
					{
						result=[[NMMenuItemLocation alloc] initWithPath:path depth:depth menuIndex:expectedMenu appendChild:lastIndex];
						*stop=YES;
					}
				}
				else if (depth==expectedDepth)
				{
					if ([self validate:element])
					{
						lastIndex=path[depth-1];
						result=[[NMMenuItemLocation alloc] initWithPath:path depth:depth menuIndex:expectedMenu];
						*stop=YES;
					}
				}
			}];
	}
	
	// if not found yet, do general search if depth specified
	if (!result&&generalSearchDepth)
	{
		// look at all menus starting from number 1 (not the apple menu)
		[menuBar enumerateDescendentsToDepth:generalSearchDepth
			usingBlock:^(NMUIElement *element, NSUInteger depth, const NSUInteger *path, BOOL *stop) {
				if ([self validate:element])
				{
				   result=[[NMMenuItemLocation alloc] initWithPath:path depth:depth];
				   *stop=YES;
				}
			}];
	}
	
	if (!result) {
		return [NMMenuItemLocation notFound];
	}
	else {
		return result;		
	}
}

@end
