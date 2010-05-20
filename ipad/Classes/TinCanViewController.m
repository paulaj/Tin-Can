//
//  TinCanViewController.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import "TinCanViewController.h"
#import "ParticipantView.h"
#import "TodoUpdateOperation.h"

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
//    meetingTimerView = [[MeetingTimerView alloc] init];
//    [meetingTimerView retain];
//    [self.view addSubview:meetingTimerView];

    // Create the participants view.
    participantsContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [participantsContainer retain];
    [self.view addSubview:participantsContainer];
    
    todosContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [todosContainer retain];
    [self.view addSubview:todosContainer];
    
    [self initParticipantsView];
    [self initTodoViews];
    
    queue = [[[NSOperationQueue alloc] init] retain];
    
    NSLog(@"Done loading view.");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Kick off the timer.
    clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clk) userInfo:nil repeats:YES];
    [clock retain];

    lastTodoDropTargets = [[NSMutableDictionary dictionary] retain];
    
    
    // Push an update into the queue.
    [queue addOperation:[[TodoUpdateOperation alloc] initWithViewController:self]];
    
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
    
    [queue release];
    
    [clock invalidate];
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
    
    participants = [[NSMutableDictionary dictionary] retain];
    
    // Make a set of names.
    NSMutableSet *nameSet = [NSMutableSet set];
    [nameSet addObject:@"Matt"];
    [nameSet addObject:@"Andrea"];
    [nameSet addObject:@"Jaewoo"];
    [nameSet addObject:@"Charlie"];
    [nameSet addObject:@"Chris"];
    [nameSet addObject:@"Drew"];
    [nameSet addObject:@"Ig-Jae"];
    [nameSet addObject:@"Trevor"];
    [nameSet addObject:@"Paulina"];
    [nameSet addObject:@"Dori"];
    
    
    
    // Now loop through that set.
    int i = 0;
    for (NSString *name in [nameSet allObjects]) {
        Participant *p = [[Participant alloc] initWithName:name];
        
        [participants setObject:p forKey:p.uuid];
        // Now make the matching view.
        // This is going to get really ugly for now, since we don't
        // have a nice participant layout manager. Just hardcode
        // positions.
        
        CGPoint point;
        CGFloat rotation;
        UIColor *color;
        switch(i) {
            case 0:
                point = CGPointMake(256, 1060);
                rotation = 0.0;
                color = [UIColor redColor];
                break;
            case 1:
                point = CGPointMake(512, 1060);
                rotation = 0.0;
                color = [UIColor redColor];
                break;
            case 2:
                point = CGPointMake(-30, 256);
                rotation = M_PI/2;
                color = [UIColor redColor];
                break;
                
            case 3:
                point = CGPointMake(-30, 512);
                rotation = M_PI/2;
                color = [UIColor blueColor];
                break;
            case 4:
                point = CGPointMake(-30, 768);
                rotation = M_PI/2;
                color = [UIColor blueColor];
                break;
            case 5:
                point = CGPointMake(798, 256);
                rotation = -M_PI/2;
                color = [UIColor blueColor];
                break;
            case 6:
                point = CGPointMake(798, 512);
                rotation = -M_PI/2;
                color = [UIColor yellowColor];
                break;
            case 7:
                point = CGPointMake(798, 768);
                rotation = -M_PI/2;
                color = [UIColor yellowColor];
                break;
            case 8:
                point = CGPointMake(256, -20);
                rotation = M_PI;
                color = [UIColor greenColor];
                break;
            case 9:        
                point = CGPointMake(512, -20);
                rotation = M_PI;
                color = [UIColor purpleColor];
                break;
        }
        
        
        ParticipantView *newParticipantView = [[ParticipantView alloc] initWithParticipant:p withPosition:point withRotation:rotation withColor:color];
        [participantsContainer addSubview:newParticipantView];
        [participantsContainer bringSubviewToFront:newParticipantView];
        [newParticipantView setNeedsDisplay];
        i++;
    }
    
    
}

- (void)initTodoViews {
    
    // Add in some fake todos here so we can re-test the dragging/dropping code.
    todoViews = [[NSMutableSet set] retain];
    
    [self addTodoItemView:[[TodoItemView alloc] initWithTodoText:@"Update the figures."]];
    [self addTodoItemView:[[TodoItemView alloc] initWithTodoText:@"Write a new introduction."]];
    [self addTodoItemView:[[TodoItemView alloc] initWithTodoText:@"Set up a meeting with Debbie."]];     
}

// Should this operate on the Todo level or TodoItemView? I like Todo better,
// but since there's that initWithText sugar, they're equally easy to 
// do right now. TODO refactor this later.
- (void)addTodoItemView:(TodoItemView *)view {
 
    [todoViews addObject:view];
    [view setDelegate:self];
    [todosContainer addSubview:view];
    [view setNeedsDisplay];
}


#pragma mark Communication Handling

// NEW_TODO todo_id user_id todo_text
- (void)handleNewTodoWithArguments:(NSArray *)args {

    // Check for the right argument count first.
    // TODO need some kind of error handling here. Not sure how to do
    // that nicely in obj c yet.
    if ([args count] < 4) {
        NSLog(@"Tried to handle a new todo message, but it didn't have enough args: %@", args);
        return;
    }

    NSLog(@"valid number of arguments: %@", args);
    
    // Split up the arguments.
    int todoId = [[args objectAtIndex:1] intValue];
    int userId = [[args objectAtIndex:2] intValue];
    
    // Need to construct an array that's just the back 3:end of the original.
    // This should be easy, but it's not AFAICT.
    NSRange textComponents = NSMakeRange(3, [args count]-3);
    NSString *todoText = [[args subarrayWithRange:textComponents] componentsJoinedByString:@" "];
    
    NSLog(@"NEW_TODO: from %d, with id %d and text '%@'", todoId, userId, todoText);
    
    // This is a trivial implementation - this should really split the data
    // field up and decide based on commands. But for now...
    [self addTodoItemView:[[TodoItemView alloc] initWithTodoText:todoText]];    
}

// ASSIGN_TODO todo_id user_id
// user_id=-1 means deassign the todo from everyone
- (void)handleAssignTodoWithArguments:(NSArray *)args {
    NSLog(@"Got assign todo message, but can't do anything useful with it yet. args: %@", args);
}


- (void)dispatchTodoCommandString:(NSString *)operation {
    if (operation == nil) {
        return;
    }
    
    // Do a little dispatch / handling here where we look for the command
    // code and then parse the arguments appropriately.
    
    // TODO properly handle message with no spaces in them - they seem to 
    // die in a terrible way right now.
    NSArray *commandParts = [operation componentsSeparatedByString:@" "];
    
    // Ignore if it doesn't have at least three parts (the current
    // minimum number of arguments for a command)
    if([commandParts count] >= 3)  {        
        NSString *opCode = [commandParts objectAtIndex:0];
        NSLog(@"opCode: %@", opCode);
        if([opCode isEqualToString:@"NEW_TODO"]) {
            NSLog(@"about to drop into handleNewTodo");
            [self handleNewTodoWithArguments:commandParts];
        } else if ([opCode isEqualToString:@"ASSIGN_TODO"]) {
            [self handleAssignTodoWithArguments:commandParts];        
        } else {
            NSLog(@"Received unknown opCode: %@", opCode);
        }
    }
    
    // Now kick off a new update operation. Since these are
    // long polling, we should only do this exactly as often
    // as we're getting events from toqbot.
    NSLog(@"Enqueing a new update operation...");
    [queue addOperation:[[TodoUpdateOperation alloc] initWithViewController:self]];
}


@end
