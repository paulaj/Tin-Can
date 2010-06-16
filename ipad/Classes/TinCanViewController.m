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
#import "Todo.h"
#import "Participant.h"
#import "TodoItemView.h"
#import "DragManager.h"

#define INITIAL_REVISION_NUMBER 10000

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
    
    NSDate *startingTime = [NSDate date];
    NSLog(@"starting time in seconds: %f", [startingTime timeIntervalSince1970]);
    NSTimeInterval startingTimeInSeconds = [startingTime timeIntervalSince1970]-1800;
    
    meetingTimerView = [[MeetingTimerView alloc] initWithFrame:CGRectMake(200, 200, 400, 400) withStartTime:[NSDate dateWithTimeIntervalSince1970:startingTimeInSeconds]];
    [meetingTimerView retain];
    [self.view addSubview:meetingTimerView];
    
    // Create the participants view.
    participantsContainer = [[UIView alloc] initWithFrame:self.view.frame];
    [participantsContainer retain];
    [self.view addSubview:participantsContainer];
        
    [self initParticipantsView];
    [self initTodoViews];
    
    [[DragManager sharedInstance] initWithRootView:self.view withParticipantsContainer:participantsContainer];

    [self.view bringSubviewToFront:participantsContainer];
	[self.view bringSubviewToFront:meetingTimerView];
    
    queue = [[[NSOperationQueue alloc] init] retain];

    lastRevision = INITIAL_REVISION_NUMBER;
    
    NSLog(@"Done loading view.");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Kick off the timer.
    clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clk) userInfo:nil repeats:YES];
    [clock retain];    
    
    // Push an update into the queue.
    [queue addOperation:[[TodoUpdateOperation alloc] initWithViewController:self withRevisionNumber:INITIAL_REVISION_NUMBER]];
    
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
}


- (void)dealloc {
    [super dealloc];
    [self.view release];
    
    [participantsContainer release];
    
    [participants release];
    [todos release];
    
    [todoViews release];
    
    [queue release];
    
    [clock invalidate];
}




#pragma mark Internal Methods

- (void)clk {
    [meetingTimerView setNeedsDisplay];
}   

- (void)initParticipantsView {
    
    participants = [[NSMutableDictionary dictionary] retain];
        
    // Make a set of names.
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:10];
    [names addObject:@"Matt"];
    [names addObject:@"Andrea"];
    [names addObject:@"Jaewoo"];
    [names addObject:@"Charlie"];
    [names addObject:@"Chris"];
    [names addObject:@"Paula"];
    [names addObject:@"Ig-Jae"];
    [names addObject:@"Trevor"];
    [names addObject:@"Paulina"];
    [names addObject:@"Dori"];
    
    
    
    // Now loop through that set.
    int i = 0;
    for (NSString *name in names) {
        // This is going to get really ugly for now, since we don't
        // have a nice participant layout manager. Just hardcode
        // positions.
        
        CGPoint point;
        CGFloat rotation;
        UIColor *color;
        NSString *uuid;
        switch(i) {
            case 0:
                point = CGPointMake(256, 1060);
                rotation = 0.0;
                color = [UIColor redColor];
                uuid = @"p1";
                break;
            case 1:
                point = CGPointMake(512, 1060);
                rotation = 0.0;
                color = [UIColor redColor];
                uuid = @"p2";
                break;
            case 2:
                point = CGPointMake(-30, 256);
                rotation = M_PI/2;
                color = [UIColor redColor];
                uuid = @"p3";
                break;
            case 3:
                point = CGPointMake(-30, 512);
                rotation = M_PI/2;
                color = [UIColor blueColor];
                uuid = @"p4";
                break;
            case 4:
                point = CGPointMake(-30, 768);
                rotation = M_PI/2;
                color = [UIColor blueColor];
                uuid = @"p5";
                break;
            case 5:
                point = CGPointMake(798, 256);
                rotation = -M_PI/2;
                color = [UIColor blueColor];
                uuid = @"p6";
                break;
            case 6:
                point = CGPointMake(798, 512);
                rotation = -M_PI/2;
                color = [UIColor yellowColor];
                uuid = @"p7";
                break;
            case 7:
                point = CGPointMake(798, 768);
                rotation = -M_PI/2;
                color = [UIColor yellowColor];
                uuid = @"p8";
                break;
            case 8:
                point = CGPointMake(256, -30);
                rotation = M_PI;
                color = [UIColor greenColor];
                uuid = @"p9";
                break;
            case 9:        
                point = CGPointMake(512, -30);
                rotation = M_PI;
                color = [UIColor purpleColor];
                uuid = @"p10";
                break;
        }
        
        Participant *p = [[Participant alloc] initWithName:name withUUID:uuid];

        [participants setObject:p forKey:p.uuid];
        
        // Now make the matching view.
        ParticipantView *newParticipantView = [[ParticipantView alloc] initWithParticipant:p withPosition:point withRotation:rotation withColor:color];
        p.view = newParticipantView;
        [participantsContainer addSubview:newParticipantView];
        [participantsContainer bringSubviewToFront:newParticipantView];
        [newParticipantView setNeedsDisplay];
        i++;
    }
}

// TODO Nuke this function. Doesn't make much sense now that we're not hardcoding anymore.
- (void)initTodoViews {
    todoViews = [[NSMutableSet set] retain];
    todos = [[NSMutableDictionary dictionary] retain];    
}

// Should this operate on the Todo level or TodoItemView? I like Todo better,
// but since there's that initWithText sugar, they're equally easy to 
// do right now. TODO refactor this later.
- (void)addTodo:(Todo *)todo {
     
    TodoItemView *view = [[TodoItemView alloc] initWithTodo:todo atPoint:[self getNextTodoPosition] isOriginPoint:true fromParticipant:[participants objectForKey:todo.creatorUUID] useParticipantRotation:false withColor:[UIColor whiteColor]];

    [todos setObject:todo forKey:todo.uuid];

    [todoViews addObject:view];

    [self.view addSubview:view];
    [view setNeedsDisplay];
}


- (CGPoint) getNextTodoPosition {
    // Place todos in a column on the left side of the display, and move down
    // the list as todos are added. 
    return CGPointMake(600 - 40*[todos count], 115);
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
    NSString *todoId = [args objectAtIndex:1];
    NSString *userId = [args objectAtIndex:2];
    
    // Need to construct an array that's just the back 3:end of the original.
    // This should be easy, but it's not AFAICT.
    NSRange textComponents = NSMakeRange(3, [args count]-3);
    NSString *todoText = [[args subarrayWithRange:textComponents] componentsJoinedByString:@" "];
    
    NSLog(@"NEW_TODO: from %@, with id %@ and text '%@'", todoId, userId, todoText);
    
    // This is a trivial implementation - this should really split the data
    // field up and decide based on commands. But for now...
    Todo *newTodo = [[Todo alloc] initWithText:todoText withCreator:userId withUUID:todoId];
    
    // TODO move this all into a proper init sequence - there should be
    // no way to create a todo and not register it with the todo store.
    // Really, I need to make a singleton data manager and have
    // everyone interact with that on init.    
    [self addTodo:newTodo];    
}

// ASSIGN_TODO todo_id user_id
// user_id=-1 means deassign the todo from everyone
- (void)handleAssignTodoWithArguments:(NSArray *)args {
    if ([args count] != 3) {
        NSLog(@"Received ASSIGN_TODO with inappropriate number of arguments: %@", args);
        return;        
    }
    
    NSLog(@"ASSIGN TODO participant retain count: %d", [participants retainCount]);
    
    NSString *todoId = [args objectAtIndex:1];
    NSString *assignedUserId = [args objectAtIndex:2];
    
    // Now get the todo object and the assigned user object.
    NSLog(@"todoId %@", todoId);
    
    Todo *todo = [todos objectForKey:todoId];
    Participant *participant = [participants objectForKey:assignedUserId];
    
    [todo startAssignment:participant withViewController:self];
}


- (void)dispatchTodoCommandString:(NSString *)operation fromRevision:(int)revision{

    // First, grab the revision number.
    // If no revision is set (ie the previous request timed out and didn't return one)
    // grab the saved revision number and use that for the next operation.
    // Otherwise, we got good data and should save the revision number.
    if(revision==-1) {
        revision = lastRevision;
    }
    // This covers the case when the very first query times out. Just keep
    // the revision number at the initial value to wait for the first message
    // from the server.
    else if (revision == -1 && lastRevision == INITIAL_REVISION_NUMBER) {
        revision = INITIAL_REVISION_NUMBER;
    }
    else {
        lastRevision = revision;
    }

    NSLog(@"returned revision number: %d", revision);
            
    // Trying to do this at the top - hopefully this doesn't clog
    // the queue or anything? But it needs to be before any exception
    // handling, so exceptions don't break the update cycle like they
    // were when I had it at the end.
    [queue addOperation:[[TodoUpdateOperation alloc] initWithViewController:self withRevisionNumber:(revision+1)]];
    if (operation == nil) {
        return;
    }


    // Do a little dispatch / handling here where we look for the command
    // code and then parse the arguments appropriately.
    
    // TODO properly handle message with no spaces in them - they seem to 
    // die in a terrible way right now.
    
    // TODO switch this over to a fully JSON structure, instead of this
    // shitty space-delimited format I'm using now. 
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
}


@end
