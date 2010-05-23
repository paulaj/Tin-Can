//
//  DragManager.m
//  TinCan
//
//  Created by Drew Harry on 5/23/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "DragManager.h"
#import "Todo.h"
#import "ParticipantView.h"
#import "ASIFormDataRequest.h"

@implementation DragManager

static DragManager *sharedInstance = nil;

@synthesize rootView;
@synthesize participantsContainer;

#pragma mark -
#pragma mark class instance methods


- (void) initWithRootView:(UIView *)view withParticipantsContainer:(UIView *)container {
 
    self.rootView = view;
    self.participantsContainer = container;
    
    lastTodoDropTargets = [[NSMutableDictionary dictionary] retain];
}


- (ParticipantView *) participantAtTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint point = [touch locationInView:self.rootView];
    
    UIView *returnedView = [self.participantsContainer hitTest:point withEvent:event];
    
    NSLog(@"checking participantAtTouch. point: %f, %f. returned view: %@", point.x, point.y, returnedView);
    
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

- (bool) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo {
    // Get the current target
    ParticipantView *curTargetView = [self participantAtTouch:touch withEvent:event];	
    
    // Assign the todo.
    if(curTargetView != nil) {
        // For now, disable this part - let it happen in the loopback through toqbot. 
        //        [curTargetView.participant assignTodo:todo];
        //        [curTargetView setHoverState:false];
        
        // Now, send a message back to toqbot about the assignment.
        // TODO abstract this out into some nice communication singleton
        
        NSLog(@"about to try to post something.");
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://toqbot.com/db/"]];
        [request setPostValue:[NSString stringWithFormat:@"ASSIGN_TODO %@ %@", todo.uuid, curTargetView.participant.uuid] forKey:@"tincan"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        return true;
    }
    
    return false;
}

- (void) requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"request finished! %@", [request responseString]);
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"request failed: %@", [request error]);
}


#pragma mark -
#pragma mark Singleton methods

+ (DragManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[DragManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end

