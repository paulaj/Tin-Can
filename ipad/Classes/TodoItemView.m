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
#import "DragManager.h"

@implementation TodoItemView

@synthesize todo;
@synthesize delegate;

- (id) initWithTodo:(Todo *)newTodo atPoint:(CGPoint)point fromParticipant:(Participant *)participant{
	
    // Decide how big to be by looking at the text itself.
    f = [UIFont systemFontOfSize:18];
    CGSize fontSize = [newTodo.text sizeWithFont:f];
    CGSize totalSize = CGSizeMake(fontSize.width + 80, fontSize.height+40);
    
    // If we have an appropriate participant object, use its 
    // position as the starting point for our new TodoItemView and
    // animate it into position from there. Otherwise, just start
    // it in its final position and leave it there.
    CGPoint startingPoint;
    if(participant != nil) {
        startingPoint = participant.view.frame.origin;
        NSLog(@"starting point: %f,%f", startingPoint.x, startingPoint.y);
        NSLog(@"from participant: %@", participant.name);
    } else {
        startingPoint = point;
    }
    
	if(self = [super initWithFrame:CGRectMake(startingPoint.x, startingPoint.y, totalSize.width, totalSize.height)]) {
		touched = false;
		
		self.bounds = CGRectMake(-20, -20, totalSize.width, totalSize.height);

		[self setBackgroundColor:[UIColor clearColor]];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        transform = CGAffineTransformScale(transform, 0.4, 0.4);        
        [self setTransform:transform];
        
        self.alpha = 0.4;
		self.todo = newTodo;
		[self.todo retain];
        
        self.todo.view = self;

        // Save our initial position so we can animate back to it if we're dropped on a non-participant.
        initialOrigin = point;

        // Set the drag manager as our delegate.
        [self setDelegate:[DragManager sharedInstance]];

		[self setNeedsDisplay];
                
        // Animate to the destination point.
        if(!CGPointEqualToPoint(startingPoint, point)) {
            [UIView beginAnimations:@"initial_move_into_position" context:nil];
            [UIView setAnimationDuration:2.0];
                            
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
            transform = CGAffineTransformScale(transform, 1.0, 1.0);        
            [self setTransform:transform];

            // This needs to happen after the transform, because when it's done
            // before the transform, it's setting the location of the 0.4 scaled
            // version of the view, not the 1.0 scaled. Tricksy.
            CGRect newFrame = self.frame;
            newFrame.origin = point;
            self.frame = newFrame;
            self.alpha = 1.0;
            
            [UIView commitAnimations];
        }
        
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
	
    initialOrigin = self.frame.origin;
    
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
    
    
    // If this returns false, it means we didn't land on top of something and should 
    // animate back to our original position.
    if (![self.delegate todoDragEndedWithTouch:touch withEvent:event withTodo:self.todo]) {
        [UIView beginAnimations:@"snap_to_initial_position" context:nil];
        
        [UIView setAnimationDuration:1.0f];
        
        CGRect newFrame = self.frame;
        newFrame.origin = initialOrigin;
        self.frame = newFrame;
        NSLog(@"animating to initialOrigin: %f, %f", initialOrigin.x, initialOrigin.y);
                
        [UIView commitAnimations];
    }
        
	[self setNeedsDisplay];
}

- (void) animateToAssignedParticipant:(Participant *)participant {
    // Animate to the participant's view's location, and on
    // delegated callback do the actual assignment.
    [UIView beginAnimations:@"move_to_assigned_participant" context:participant];
    
    [UIView setAnimationDuration:1.0f];
    self.center = participant.view.center;
    
    self.alpha = 0.2;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    transform = CGAffineTransformScale(transform, 0.4, 0.4);        
    [self setTransform:transform];
    
    // Now set the callback. 
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animateToAssignedParticipantDidStop:finished:context:)];
    
    [UIView commitAnimations];
}

- (void) animateToAssignedParticipantDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    // When this triggers, finish the actual assignment.
    Participant *participant = (Participant *)context;
    
    [participant assignTodo:self.todo];
}

- (void) deassign {
    [self.todo release];
    self.todo = nil;
    [self removeFromSuperview];
}

- (void)dealloc {
    // This causes a warning because "release" isn't in the protocol - can't we assume
    // everything inherits from NSObject? (Ah, no - delegates aren't actually retained,
    // so you're not supposed to release them.)
    
    //[delegate release];

	[todo release];
	[super dealloc];
}

@end
