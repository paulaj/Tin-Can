//
//  ParticipantView.m
//  TinCan
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "ParticipantView.h"
#import "Todo.h"
#import "UIColor+Util.h"
#import "Participant.h"
#import <math.h>

@implementation ParticipantView

@synthesize color;
@synthesize participant;

- (id) initWithParticipant:(Participant *)newParticipant withPosition:(CGPoint)pos withRotation:(CGFloat)rot withColor:(UIColor *)c {
	self = [super initWithFrame:CGRectMake(0,0, 260, 260)];
	
	NSLog(@"initing participant view.");
	hover = false;
	self.bounds = CGRectMake(-130, -130, 260, 260);
	self.center = pos;
    
    // TODO figure out how to write the setter for self.color so
    // we can update hoverColor when self.color gets updated.
    self.color = [c colorDarkenedByPercent:0.3];
        
	rotation = rot;
    
    [self setBackgroundColor:[UIColor clearColor]];
	
	self.participant = newParticipant;
    
    return self;
}


- (void) drawRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextRotateCTM(ctx, rotation);
	
	if(ctx != nil) {

        //CGContextSetFillColorWithColor(ctx, hoverColor.CGColor);

        
		if(hover)
            CGContextSetFillColorWithColor(ctx, [self.color colorDarkenedByPercent:0.3].CGColor);
		else
			CGContextSetFillColorWithColor(ctx, self.color.CGColor);

		CGContextAddEllipseInRect(ctx, CGRectMake(-100, -100, 200, 200));
		CGContextFillPath(ctx);
		
		// Now draw the person's name on top of it.
		CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
		CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
		
		
		// Going to try drawing with the NSString methods + UIFont, to see if it works.
		// We wants this because NSString and UIFonts know how they're going to be
		// rendered, but the straight CG approach doesn't have that info. 
		
		UIFont *f = [UIFont boldSystemFontOfSize:18];
		CGSize nameSize = [[self.participant.name uppercaseString] sizeWithFont:f];
		
		[[self.participant.name uppercaseString] drawAtPoint:CGPointMake(-nameSize.width/2, -nameSize.height/2-55) withFont:f];

		CGContextSetFillColorWithColor(ctx, self.color.CGColor);
		
		CGContextRotateCTM(ctx, M_PI/10);

		// Now, draw a circle outside the radius for each todo object.
		for(int i=0; i<[self.participant.assignedTodos count]; i++) {
			// Draw a circle at zero e
			CGContextRotateCTM(ctx, M_PI/10);
			CGContextAddEllipseInRect(ctx, CGRectMake(-140, 0, 30, 30));
			CGContextFillPath(ctx);
		}
	}
}


- (void) setHoverState:(bool)hoverState {
	hover = hoverState;
	[self setNeedsDisplay];
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	// We want to do our hit test a little differently - just return true
	// if it's inside the circle part of the participant rendering.
	CGFloat distance = sqrt(pow(point.x, 2) + pow(point.y, 2));
	
	// NSLog(@"distance=%f, radius=%f", distance, 40000.0);
	
	if (distance <= 100.0f) {
		return self;	
	}
	else {
		return nil;
	}
}

- (void) dealloc {
	[super dealloc];
	[name release];
}
@end
