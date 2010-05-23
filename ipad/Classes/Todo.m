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

- (void) startAssignment:(Participant *)participant {
    if([self.view isKindOfClass:[TodoItemView class]]) {
        [(TodoItemView *)self.view animateToAssignedParticipant:participant];
    } else {
        NSLog(@"Got message to start assignment, but todo's parent view is not a TodoItemView: %@", self.view);
    }
}

@end
