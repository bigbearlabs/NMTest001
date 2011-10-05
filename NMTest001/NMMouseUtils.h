/*
 *  NMMouseLocation.h
 *  NMTest
 *
 *  Created by Nicholas Moore on 05/03/2010.
 *  Copyright 2010 Nicholas Moore. All rights reserved.
 *
 */

#include <ApplicationServices/ApplicationServices.h>

void NMSetOverridePoint(CGPoint flipped, CGPoint unflipped);
void NMSetOverride(BOOL state);
BOOL NMOverride(void);

// Location of mouse in "flipped" coordinates as used by the Quartz subsystem.
// Height is inverted from w.r.t. AppKit coordinates.
CGPoint NMCurrentFlippedMouseLocation(void);

// AppKit-compatible location equivalent to [NSEvent mouseLocation]
CGPoint NMCurrentUnflippedMouseLocation(void);

void NMPostMouseEvent(CGEventType type, CGPoint point, uint64_t clickState);

void NMPostMouseEventWithFlags(CGEventType type, CGPoint point, uint64_t clickState, CGEventFlags flags);
