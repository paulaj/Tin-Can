//
//  Participant.m
//  TinCan
//
//  Created by Drew Harry on 5/19/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "Participant.h"
#import "ParticipantView.h"
#include <stdlib.h>

@implementation Participant

@synthesize uuid;
@synthesize name;
@synthesize assignedTodos;
@synthesize view;

- (id) initWithName:(NSString *)participantName withUUID:(NSString *)pUUID{
    
    self = [super init];
    
    self.name = participantName;
    
    self.assignedTodos = [[NSMutableSet set] retain];
    
    // If I'm using synthesized properties like this, do I need
    // to have a custom dealloc method in here? Probably not, right?
    

    // Generate the uuid. 
    self.uuid = pUUID;
//    self.uuid = [NSString stringWithFormat:@"%@%d%d",@"p",[NSDate timeIntervalSinceReferenceDate] * 1000, arc4random() %1000];
    
    return self;
}

- (void) assignTodo:(Todo *)todo {
    NSLog(@"Assigning todo: %@ to %@", todo, self.uuid);
    
	[self.assignedTodos addObject:todo];

    NSLog(@"todo view? %@", todo.view);
    
    [todo.view removeFromSuperview];
    [todo.view release];
    
    // This is kind of pointless, but okay. It's not actually being
    // rendered as a child of this this participant's view, so
    // this is kind of vestigal. 
    todo.view = self.view;
    todo.participantOwner = self;
    
	NSLog(@"Received new todo: %@, total now %d", todo.text, [assignedTodos count]);
    [self.view setHoverState:false];
	[self.view setNeedsDisplay];
}

- (void) removeTodo:(Todo *)todo {
    
    [self.assignedTodos removeObject:todo];
    todo.view = nil;
    todo.participantOwner = nil;
    
    [self.view setNeedsDisplay];
}


- (NSString *)description {
    
    return [NSString stringWithFormat:@"<Participant name=%@, uuid=%@, numTodos=%d>", self.name, self.uuid, [self.assignedTodos count]];
}

- (void) dealloc {
    [assignedTodos release];
    [super dealloc];
}

@end
