//
//  Todo.m
//  TinCan
//
//  Created by Drew Harry on 4/27/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "Todo.h"
#import "Participant.h"
#import "TodoItemView.h"


@implementation Todo

@synthesize uuid;
@synthesize text;
@synthesize created;
@synthesize creatorUUID;
@synthesize view;
@synthesize participantOwner;

// Syntactic sugar for auto-generating an internal UUID. Not sure we're actually
// ever going to do this - in the sponsor week demo, at least, all UUIDs are
// going to come from the web app.
- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID {

    // Generate an internal UUID.
    NSString *tUUID = [NSString stringWithFormat:@"%@%d%d",@"p",[NSDate timeIntervalSinceReferenceDate] * 1000, arc4random() %1000];

    return [self initWithText:todoText withCreator:pUUID withUUID:tUUID];
}

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID withUUID:(NSString *)tUUID {
	self = [super init];
	
	self.text = todoText;
	self.creatorUUID = pUUID;
	self.created = [NSDate date];

    self.uuid = tUUID;

	return self;
}

- (id) copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (void) startAssignment:(Participant *)participant withViewController:(TinCanViewController *)viewController {
    
    // Check and see if we're owned by a participant right now AND we don't currently have a view (ie we're
    // in minimized mode inside a participant object.)
    if(participantOwner != nil && [self.view isKindOfClass:[ParticipantView class]]) {
        NSLog(@"Handling the case when we get an assign event on a todo item that currently has an owner.");
        
        // We're going to need to deassign from them first,
        // then start the assignment process.
        // We're also going to need to make sure we START from that position.
        [participantOwner removeTodo:self];
        
        // We're going to need to construct a new TodoItemView now.
        TodoItemView *newTodoView = [[[TodoItemView alloc] initWithTodo:self atPoint:participantOwner.view.center isOriginPoint:false fromParticipant:self.participantOwner useParticipantRotation:true withColor:[UIColor whiteColor]] retain];
        [viewController.view addSubview:newTodoView];
        [viewController.view setNeedsDisplay];
        [newTodoView animateToAssignedParticipant:participant];
    } else {
        if([self.view isKindOfClass:[TodoItemView class]]) {
            [(TodoItemView *)self.view animateToAssignedParticipant:participant];
        } else {
            NSLog(@"Got message to start assignment, but todo's parent view is not a TodoItemView: %@", self.view);
        }
    }

    
}

@end
