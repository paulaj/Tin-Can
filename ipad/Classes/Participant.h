//
//  Participant.h
//  TinCan
//
//  Created by Drew Harry on 5/19/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticipantView.h"

@class ParticipantView;

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

- (void) assignTodo:(Todo *)todo;



@end
