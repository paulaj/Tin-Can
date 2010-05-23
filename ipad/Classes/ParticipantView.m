//
//  ParticipantView.m
//  TinCan
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "ParticipantView.h"
#import "Todo.h"
#import "TodoItemView.h"
#import "UIColor+Util.h"
#import "Participant.h"
#import <math.h>

@implementation ParticipantView

@synthesize color;
@synthesize participant;

- (id) initWithParticipant:(Participant *)newParticipant withPosition:(CGPoint)pos withRotation:(CGFloat)rot withColor:(UIColor *)c {
	self = [super initWithFrame:CGRectMake(0,0, 260, 260)];
	
	NSLog(@"initing participant view");
	hover = false;
	self.bounds = CGRectMake(-130, -330, 260, 660);
	self.center = pos;
    
    // TODO figure out how to write the setter for self.color so
    // we can update hoverColor when self.color gets updated.
    self.color = [c colorDarkenedByPercent:0.3];
        
	rotation = rot;
    
    
    todosExpanded = false;
    
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


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touches began on participant: %@", self.participant.name);
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touches moved on participant: %@", self.participant.name);
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // When a touch ends on the participant, we're going to pop up any todos associated with this person.
    // In practical terms, this is going to deassign the todos from here (so they stop showing
    // up as circles). A subsequent touch will reassign them to the participant.
    
    // Problem: we need to pass these todos up the chain to the main view controller. Or maybe we can get away
    // with them actually being subviews? We'll try making them local and see what happens. Most obvious issue
    // is with hit testing against the participant container, but maybe we can find a way around that being a problem.
    NSLog(@"got a touches ended on a participant view");
    NSSet *todos = [self.participant.assignedTodos copy];
    
    if(!todosExpanded) {
        expandedTodoViews = [[NSMutableSet set] retain];
        // Expand existing todos. Recreate TodoItemViews for each,
        // attach them to the super view and animate them into position
        // near the participant.
        int i=0;
        for (Todo *todo in todos) {
            // For each todo, remove it from the participant and then create it.
            [self.participant.assignedTodos removeObject:todo];
            [self setNeedsDisplay];
            
            TodoItemView *todoView = [[[TodoItemView alloc] initWithTodo:todo atPoint:CGPointMake(400, 200-15*i) fromParticipant:participant] retain];
            [expandedTodoViews addObject:todoView];
            
            [self.superview addSubview:todoView];
        }
        todosExpanded = true;
    } else {
        // Get all the todo item views associated with this 
        for(TodoItemView *todoView in expandedTodoViews) {
            // Reassign all of these views back to this participant.
            
            // First check and see if we still own all the todos.
            if(todoView.todo.participantOwner == self.participant)
                [todoView animateToAssignedParticipant:self.participant];
        }
        
        [expandedTodoViews release];
        expandedTodoViews = nil;
        todosExpanded = false;
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
