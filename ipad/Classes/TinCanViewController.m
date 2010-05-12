//
//  TinCanViewController.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import "TinCanViewController.h"
#import "ParticipantView.h"

@implementation TinCanViewController

#pragma mark Application Events

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {    
    // TODO I don't like having to hardcode the frame here - worried about rotation and 
    // portability / scalability if resolutions change in the future.
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)] retain];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Now, drop the MeetingTimer in the middle of the screen.
    
    // Add the timer first, so it's underneath everything.
    meetingTimerView = [[MeetingTimerView alloc] init];
    [meetingTimerView retain];
    [self.view addSubview:meetingTimerView];

    // Create the participants view.
    participantsContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [participantsContainer retain];
    [self.view addSubview:participantsContainer];
    
    todosContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [todosContainer retain];
    [self.view addSubview:todosContainer];
    
    [self initParticipantsView];
    [self initTodoViews];
    
    NSLog(@"Done loading view.");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Kick off the timer.
    clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clk) userInfo:nil repeats:YES];
    [clock retain];

    lastTodoDropTargets = [[NSMutableDictionary dictionary] retain];
    
    NSLog(@"viewDidLoad");
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [participantsContainer release];
    participantsContainer = nil;
    
    [meetingTimerView release];
    meetingTimerView = nil;
    
    [todosContainer release];
    todosContainer = nil;
}


- (void)dealloc {
    [super dealloc];
    [self.view release];
    [participants release];
    [todoViews release];
    
    [lastTodoDropTargets release];
    
    [clock invalidate];
    [clock release];
}


#pragma mark TodoDragDelegate

- (void) todoDragMovedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo{
    
    // Get the last target
    ParticipantView *lastDropTarget = [lastTodoDropTargets objectForKey:todo];
    
    // Now check and see if we're over a participant right now.
	ParticipantView *curDropTarget = [self participantAtTouch:touch withEvent:event];
        
	// rethinking this...
	// if cur and last are the same, do nothing.
	// if they're different, release the old and retain the new and manage states.
	// if cur is nothing and last is something, release and set false
	// if cur is something and last is nothing, retain and set true
	
	if(curDropTarget != nil) {
		if (lastDropTarget == nil) {
			[curDropTarget setHoverState:true];
			[curDropTarget retain];
			lastDropTarget = curDropTarget;			
		} else if(curDropTarget != lastDropTarget) {
			// transition.
			[lastDropTarget setHoverState:false];
			[lastDropTarget release];
            
			// No matter what, we want to set the current one true
			[curDropTarget setHoverState:true];
			[curDropTarget retain];
			lastDropTarget = curDropTarget;
		}
		
		// If they're the same, do nothing - don't want to be sending the
		// retain count through the roof.
	} else {
		// curTargetView IS nul.
		if(lastDropTarget != nil) {
			[lastDropTarget setHoverState:false];
			[lastDropTarget release];		
			lastDropTarget = nil;
		}
		
		// If they're both nil, do nothing.
	}
	
	
	[lastDropTarget setHoverState:false];
	[lastDropTarget release];
	if(curDropTarget !=nil) {
		[curDropTarget setHoverState:true];
		lastDropTarget = curDropTarget;
		[lastDropTarget retain];
	}
        
    // Now push the current last into the dictionary.
    [lastTodoDropTargets setValue:lastDropTarget forKey:todo];
}

- (void) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo {
    // Get the current target
    ParticipantView *curTargetView = [self participantAtTouch:touch withEvent:event];	

    // Assign the todo.
    if(curTargetView != nil) {
        
        // remove the current view containing the todo
        // from view. This is making me a bit unsettled - why
        // are views containing data objects like this? Should
        // I be segmenting this design further, so each of these
        // views has its own controller, too, that contains
        // this stuff?
        [todo.parentView deassign];
        
        [curTargetView assignTodo:todo];
        [curTargetView setHoverState:false];
    }
    
    
}


#pragma mark Internal Methods

- (ParticipantView *) participantAtTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self.view];
    UIView *returnedView = [participantsContainer hitTest:point withEvent:event];
    if(returnedView==nil) {
        return nil;
    }
    
    if([returnedView isKindOfClass:[ParticipantView class]]) {
        return ((ParticipantView *) returnedView);
    }
    else {
        return nil;
    }
    
}


- (void)clk {
    [meetingTimerView setNeedsDisplay];
}   

- (void)initParticipantsView {
    
    participants = [[NSMutableSet set] retain];
    
    // For now, hard code these. Eventually, these will get pulled from the server.
    // We'll also want to the layout quite a bit more - right now we're having to
    // hardcode both the rotation and the actual positions. That's a post
    // sponsor week TODO, though.
    [participants addObject:[[ParticipantView alloc] initWithName:@"MATT" withPosition:CGPointMake(256, 1060) withRotation:0.0 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"ANDREA" withPosition:CGPointMake(512, 1060) withRotation:0.0 withColor:[UIColor redColor]]];
    
    [participants addObject:[[ParticipantView alloc] initWithName:@"JAEWOO" withPosition:CGPointMake(-30, 256) withRotation:M_PI/2 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"CHARLIE" withPosition:CGPointMake(-30, 512) withRotation:M_PI/2 withColor:[UIColor redColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"TREVOR" withPosition:CGPointMake(-30, 768) withRotation:M_PI/2 withColor:[UIColor yellowColor]]];

    [participants addObject:[[ParticipantView alloc] initWithName:@"CHRIS" withPosition:CGPointMake(798, 256) withRotation:-M_PI/2 withColor:[UIColor yellowColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"DREW" withPosition:CGPointMake(798, 512) withRotation:-M_PI/2 withColor:[UIColor greenColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"IG-JAE" withPosition:CGPointMake(798, 768) withRotation:-M_PI/2 withColor:[UIColor blueColor]]];

    [participants addObject:[[ParticipantView alloc] initWithName:@"DORI" withPosition:CGPointMake(256, -20) withRotation:M_PI withColor:[UIColor blueColor]]];
    [participants addObject:[[ParticipantView alloc] initWithName:@"PAULINA" withPosition:CGPointMake(512, -20) withRotation:M_PI withColor:[UIColor blueColor]]];

    
    for(ParticipantView *participant in participants) {
        
        [participantsContainer addSubview:participant];
        [participantsContainer bringSubviewToFront:participant];
        [participant setNeedsDisplay];
    }
}

- (void)initTodoViews {
    
    // Add in some fake todos here so we can re-test the dragging/dropping code.
    todoViews = [[NSMutableSet set] retain];
    
    [todoViews addObject:[[TodoItemView alloc] initWithTodoText:@"Update the figures."]];
    [todoViews addObject:[[TodoItemView alloc] initWithTodoText:@"Write a new introduction."]];
    [todoViews addObject:[[TodoItemView alloc] initWithTodoText:@"Set up a meeting with Debbie."]];

     for(TodoItemView *todoItem in todoViews) {
         [todoItem setDelegate:self];
         [todosContainer addSubview:todoItem];
         [todosContainer bringSubviewToFront:todoItem];
         [todoItem setNeedsDisplay];
     }
     
     
}



@end
