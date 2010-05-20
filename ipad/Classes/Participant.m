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
    
    self.assignedTodos = [NSMutableSet set];
    
    // If I'm using synthesized properties like this, do I need
    // to have a custom dealloc method in here? Probably not, right?
    

    // Generate the uuid. 
    self.uuid = pUUID;
//    self.uuid = [NSString stringWithFormat:@"%@%d%d",@"p",[NSDate timeIntervalSinceReferenceDate] * 1000, arc4random() %1000];
    
    return self;
}

- (void) assignTodo:(Todo *)todo {
    
	[assignedTodos addObject:todo];
    
    [todo.parentView removeFromSuperview];
    
    // This is kind of pointless, but okay. It's not actually being
    // rendered as a child of this this participant's view, so
    // this is kind of vestigal. 
    todo.parentView = self.view;
    
	NSLog(@"Received new todo: %@, total now %d", todo.text, [assignedTodos count]);
	[self.view setNeedsDisplay];
}

@end
