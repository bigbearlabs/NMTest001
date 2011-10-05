//
//  NMGeometryUtils.h
//  dc
//
//  Created by Work on 03/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

Boolean NMPointsWithinDistance(CGPoint p, CGPoint q, CGFloat d);

Boolean NMPointInCorner(CGPoint p, CGRect r, CGFloat d);

CGFloat NMFlipY(CGFloat y);

NSPoint NMFlipPoint(NSPoint point);

NSRect NMFlipRect(NSRect rect);

NSPoint NMPointForCenteredBoxInBox(NSSize box, NSSize container);

NSRect NMRectForCenteredBoxInBox(NSSize box, NSSize container);

NSPoint NMPointRound(NSPoint point);