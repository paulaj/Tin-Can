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
	
	if(self = [super initWithFrame:CGRectMake(100, 100, 200, 75)]) {
		touched = false;

		f = [UIFont systemFontOfSize:12];

		// figure out how big this is going to need to be.
		CGSize fontSize = [todoText sizeWithFont:f];
		
		self.bounds = CGRectMake(-20, -20, fontSize.width+40, fontSize.height+40);

		[self setBackgroundColor:[UIColor clearColor]];
        
		self.todo = [[Todo alloc] initWithText:todoText withCreator:@"Drew"];
		[self.todo retain];
		
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

		[self.todo.text drawAtPoint:CGPointMake(40, 0) withFont:f];		
		
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
		
	float dX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
	float dY = [touch locationInView:self].y - [touch previousLocationInView:self].y;
		
	self.center = CGPointMake(self.center.x + dX, self.center.y + dY);

    
    [self.delegate todoDragMovedWithTouch:touch withEvent:event];
	
	[self setNeedsDisplay];
	[self bringSubviewToFront:self];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [touches anyObject];
    
    
    touched = false;
    
    [self.delegate todoDragEndedWithTouch:touch withEvent:event withTodo:self.todo];
	[self setNeedsDisplay];
}

- (void)dealloc {
    // This causes a warning because "release" isn't in the protocol - can't we assume
    // everything inherits from NSObject? 
    [delegate release];
	[todo release];
	[super dealloc];
}

@end
