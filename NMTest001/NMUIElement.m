//
//  NMUIElement.m
//  dc
//
//  Created by Work on 20/07/2010.
//  Copyright 2010 Nicholas Moore. All rights reserved.
//

#import "NMUIElement.h"

static AXUIElementRef _systemWide = NULL;

@implementation NMUIElement
@synthesize elementRef;

+ (void)initialize
{
	if (self == [NMUIElement class]) // standard check to prevent multiple runs
    {
        if (!_systemWide) {
            _systemWide = AXUIElementCreateSystemWide();
        }
    }
}

+ (NMUIElement *)elementAtLocation:(NSPoint)point
{
	AXUIElementRef element=NULL;
	AXUIElementCopyElementAtPosition (_systemWide, point.x, point.y, &element);
	return [[NMUIElement alloc] initWithElement:element];
}

- (id)initWithElement:(AXUIElementRef)element
{
	[super init];
	if(!element) return nil;
	elementRef=element;
	return self;
}

#pragma mark App Info

- (pid_t)pid
{
	pid_t result=-1;
	AXUIElementGetPid(elementRef, &result);
	return result;
}

#pragma mark Text Selection

- (NSString *)selectedText
{
	NSString *result;
	AXUIElementCopyAttributeValue(elementRef, kAXSelectedTextAttribute, (CFTypeRef *)&result);
	return result;
}

#pragma mark Parent roles (including self)
- (NSSet *)allParentRoles
{
	NSMutableSet *result=[NSMutableSet set];
	NMUIElement *p=self;
	
	while (p)
	{
		NSString *role=p.role;
		if (role) {
			[result addObject:role];
		}
		p=p.parentElement;
	}
	return result;
}

- (NMUIElement *)findParentWithRole:(NSString *)role
{
	NMUIElement *p=self;
	while (p)
	{
		if ([p.role isEqualToString:role]) {
			return p;
		}
		p=p.parentElement;
	}
	return nil;
}

# pragma mark String Attributes

- (NSString *)role
{
	NSString *result;
	AXUIElementCopyAttributeValue(elementRef, kAXRoleAttribute, (CFTypeRef *)&result);
	return result;
}

- (NSString *)subRole
{
	NSString *result;
	AXUIElementCopyAttributeValue(elementRef, kAXSubroleAttribute, (CFTypeRef *)&result);
	return result;
}

- (NSString *)title
{
	NSString *result;
	AXUIElementCopyAttributeValue(elementRef, kAXTitleAttribute, (CFTypeRef *)&result);
	return result;	
}

- (NSString *)menuCmdCharacter
{
	NSString *result;
	AXUIElementCopyAttributeValue(elementRef, kAXMenuItemCmdCharAttribute, (CFTypeRef *)&result);
	return result;	
}

- (NSNumber *)menuCmdKeycode
{
	NSNumber *result;
	AXUIElementCopyAttributeValue(elementRef, kAXMenuItemCmdVirtualKeyAttribute, (CFTypeRef *)&result);
	return result;	
}

- (NSNumber *)menuCmdModifiers
{
	NSNumber *result;
	AXUIElementCopyAttributeValue(elementRef, kAXMenuItemCmdModifiersAttribute, (CFTypeRef *)&result);
	return result;	
}

#pragma mark Boolean Attributes

- (BOOL)selected
{
	CFBooleanRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXSelectedAttribute, (CFTypeRef *)&result);
	return(result && CFBooleanGetValue(result));
}

- (BOOL)enabled
{
	CFBooleanRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXEnabledAttribute, (CFTypeRef *)&result);
	return(result && CFBooleanGetValue(result));	
}

- (BOOL)main
{
	CFBooleanRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXMainAttribute, (CFTypeRef *)&result);
	return(result && CFBooleanGetValue(result));	
}

- (BOOL)hasChildren
{
	CFArrayRef children=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&children);
	return(children && CFArrayGetCount(children)>0);
}

- (BOOL)hasSelectedChildren
{
	CFArrayRef children=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXSelectedChildrenAttribute, (CFTypeRef *)&children);
	return(children && CFArrayGetCount(children)>0);
}

#pragma mark Window Attributes

- (NSPoint)origin
{
	CGPoint result=NSPointToCGPoint(NSZeroPoint);
	AXValueRef ref=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXPositionAttribute, (CFTypeRef *)&ref);
	if(ref)
	{
		AXValueGetValue(ref, kAXValueCGPointType, &result);
	}
	return NSPointFromCGPoint(result);
}

- (NSSize)size
{
	CGSize result=NSSizeToCGSize(NSZeroSize);
	AXValueRef ref=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXSizeAttribute, (CFTypeRef *)&ref);
	if(ref)
	{
		AXValueGetValue(ref, kAXValueCGSizeType, &result);
	}
	return NSSizeFromCGSize(result);
}

- (NSNumber *)insertionPointLineNumber
{
    CFTypeRef result=nil;
	AXUIElementCopyAttributeValue(elementRef, kAXInsertionPointLineNumberAttribute, (CFTypeRef *)&result);
    return (NSNumber *)result;
}

- (NSNumber *)numberOfCharacters
{
    CFTypeRef result=nil;
	AXUIElementCopyAttributeValue(elementRef, kAXNumberOfCharactersAttribute, (CFTypeRef *)&result);
    return (NSNumber *)result;
}

#pragma mark Relates Elements

- (NMUIElement *)parentElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXParentAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)topLevelElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXTopLevelUIElementAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)windowElement
{
	NMUIElement *result=nil;
	if ([self.role isEqualToString:(NSString *)kAXWindowRole])
	{
		result=self;
	}
	else
	{
		NMUIElement *top=self.topLevelElement;
		if ([top.role isEqualToString:(NSString *)kAXWindowRole])
		{
			result=top;
		}			
	}
	return result;
}

- (NSArray *)children
{
	NSArray *result;
	AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&result);
	return result;
}

- (NMUIElement *)appElement
{
	AXUIElementRef result=[[self findParentWithRole:(NSString *)kAXApplicationRole] elementRef];
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)menuBar
{
	AXUIElementRef result=NULL;
	AXUIElementRef app=[[self findParentWithRole:(NSString *)kAXApplicationRole] elementRef];
	if (app) {
		AXUIElementCopyAttributeValue(app, kAXMenuBarRole, (CFTypeRef *)&result);
	}
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)menuBarDirect
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXMenuBarRole, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

-(NMUIElement *)childAtIndex:(NSUInteger)index
{
	NMUIElement *result=nil;
	NSArray *itemChildren;
	AXUIElementCopyAttributeValue(elementRef, kAXChildrenAttribute, (CFTypeRef *)&itemChildren);
	if (itemChildren&&[itemChildren count]>index) {
		result=[[NMUIElement alloc] initWithElement:(AXUIElementRef)[itemChildren objectAtIndex:index]];
	}
	return result;
}

- (NMUIElement *)closeButtonElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXCloseButtonAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)zoomButtonElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXZoomButtonAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)minimizeButtonElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXMinimizeButtonAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)toolbarButtonElement
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, kAXToolbarButtonAttribute, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NMUIElement *)attributeNamed:(NSString *)name
{
	AXUIElementRef result=NULL;
	AXUIElementCopyAttributeValue(elementRef, (CFTypeRef)name, (CFTypeRef *)&result);
	return [[NMUIElement alloc] initWithElement:result];
}

- (NSArray *)actionNames
{
	NSArray *result;
	AXUIElementCopyActionNames(elementRef, (CFArrayRef*)&result);	
	return result;
}

- (void)performAction:(NSString *)name
{
	AXUIElementPerformAction(elementRef, (CFStringRef)name);
}

- (NMUIElement *)topLevelMenuWithIndex:(NSUInteger)index
{
	NMUIElement *result=nil;
	NMUIElement *menuBar=[self menuBar];
	if (menuBar) {
		NSArray *menus=[menuBar children];
		if ([menus count]>index) {
			result=[[NMUIElement alloc] initWithElement:(AXUIElementRef)[menus objectAtIndex:index]];
		}
	}
	return result;
}

static void _enumerate(void (^block)(NMUIElement *element, NSUInteger depth, const NSUInteger *path, BOOL *stop),
					   NMUIElement *element, BOOL *stop, NSUInteger depth, NSUInteger maxDepth, NSUInteger *path)
{
	// check depth
	if (depth>maxDepth) {
		return;
	}

	// call the block
	block(element, depth, path, stop);

	// we are going one level deeper
	NSUInteger *pathLocation=path+depth++;
	
	// enumerate any children
	NSArray *children=(NSArray *)[element children];
	if (children) {
		NSUInteger subChildIndex=0;
		for(id childRef in children)
		{
			if (*stop) {
				break;
			}
			NMUIElement *child=[[NMUIElement alloc] initWithElement:(AXUIElementRef)childRef];
			*pathLocation=subChildIndex++;
			_enumerate(block, child, stop, depth, maxDepth, path);
		}
	}
}

- (void)enumerateDescendentsToDepth:(NSUInteger)maxDepth
						 usingBlock:(void (^)(NMUIElement *element, NSUInteger depth, const NSUInteger *path, BOOL *stop))block;
{
	__block BOOL stop=NO;
	__block NSUInteger path[NM_UIELEMENT_MAX_PATH_DEPTH]={0};
	if (maxDepth>NM_UIELEMENT_MAX_PATH_DEPTH) {
		maxDepth=NM_UIELEMENT_MAX_PATH_DEPTH;
	}
	_enumerate(block, self, &stop, 0, maxDepth, path);
}
@end

