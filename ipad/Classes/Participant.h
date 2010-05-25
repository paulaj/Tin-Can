//
//  Participant.h
//  TinCan
//
//  Created by Drew Harry on 5/19/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticipantView.h"
#import "Todo.h"

@class ParticipantView;
@class Todo;

@interface Participant : NSObject {
    NSString *uuid;
    NSString *name;
    
    // Something about table position?
    // Links to created todos?
    ParticipantView *view;
    NSMutableSet *assignedTodos;
}

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableSet *assignedTodos;
@property (nonatomic, retain) ParticipantView *view;

- (id) initWithName:(NSString *)participantName withUUID:(NSString *)pUUID;

- (void) assignTodo:(Todo *)todo;
- (void) removeTodo:(Todo *)todo;



@end
