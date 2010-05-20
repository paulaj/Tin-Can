//
//  TodoItemView.m
//  TodoDragTest
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "TodoItemView.h"
#import "Todo.h"
#import "ParticipantView.h"

@implementation TodoItemView

@synthesize todo;
@synthesize delegate;

- (id) initWithTodoText:(NSString *)todoText{
	
    // Decide how big to be by looking at the text itself.
    f = [UIFont systemFontOfSize:18];
    CGSize fontSize = [todoText sizeWithFont:f];
    CGSize totalSize = CGSizeMake(fontSize.width + 80, fontSize.height+40);
    
    // .height and .width are intenaditionally flipped here, to adjust the orientation
    // to the standard horizontal one. 
	if(self = [super initWithFrame:CGRectMake(100, 100, totalSize.width, totalSize.height)]) {
		touched = false;

		// figure out how big this is going to need to be.
		
		self.bounds = CGRectMake(-20, -20, totalSize.width, totalSize.height);

		[self setBackgroundColor:[UIColor clearColor]];
        
		self.todo = [[Todo alloc] initWithText:todoText withCreator:@"Drew"];
		[self.todo retain];
        
        self.todo.parentView = self;

        [self setTransform:CGAffineTransformMakeRotation(M_PI/2)];

		[self setNeedsDisplay];
	}
	return self;
}

- (void) drawRect:(CGRect)rect {
	

	CGContextRef ctx = UIGraphicsGetCurrentContext();
        
	if(ctx != nil) {

 		// at 0,0, draw a circle to represent this todo object.
		if(touched) {
			CGContextSetRGBFillColor(ctx, 1.0, 0.1, 0.1, 1.0);
		} else {
			CGContextSetRGBFillColor(ctx, 0.8, 0.1, 0.1, 1.0);
		}
		
		CGContextFillEllipseInRect(ctx, CGRectMake(-15, -15, 30, 30));
		
		CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
		CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);

		[self.todo.text drawAtPoint:CGPointMake(20, -10) withFont:f];		
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	touched = true;
	
	[self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// When we move, we want to know the delta from its previous location
	// and then we can adjust our position accordingly. 
	
	UITouch *touch = [touches anyObject];
		
    // Getting the points relative to self.superview instead of self fixes my rotation problem.
    // This is a little bit cheating. It works because the superview isn't rotated, and since
    // all we care about is the delta positions dX and dY not their absolute values,
    // we can calculate that in any non-rotated coordinate system. The alternate way to do this,
    // (I think) is to apply the current view transform to the resulting points. Not sure
    // which way is better, so going with this for now because it's less code. But be aware
    // in the future of what's going on with this as I shift more drawing code to sensible
    // coordinate systems and then rotate them into place.
	float dX = [touch locationInView:self.superview].x - [touch previousLocationInView:self.superview].x;
	float dY = [touch locationInView:self.superview].y - [touch previousLocationInView:self.superview].y;
		
	self.center = CGPointMake(self.center.x + dX, self.center.y + dY);

    [self.delegate todoDragMovedWithTouch:touch withEvent:event withTodo:self.todo];
	
	[self setNeedsDisplay];
	[self bringSubviewToFront:self];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [touches anyObject];
    
    touched = false;
    
    [self.delegate todoDragEndedWithTouch:touch withEvent:event withTodo:self.todo];
	[self setNeedsDisplay];
}

- (void) deassign {
    [self.todo release];
    self.todo = nil;
    [self removeFromSuperview];
}

- (void)dealloc {
    // This causes a warning because "release" isn't in the protocol - can't we assume
    // everything inherits from NSObject? 
    [delegate release];
	[todo release];
	[super dealloc];
}

@end
