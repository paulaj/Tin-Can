//
//  TinCanViewController.h
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingTimerView.h"
#import "ParticipantView.h"
#import "Todo.h"

@class Todo;

@interface TinCanViewController : UIViewController {    
    UIView *participantsContainer;
    
    NSMutableSet *todoViews;

    
    NSMutableDictionary *participants;
    NSMutableDictionary *todos;
    
    MeetingTimerView *meetingTimerView;
    NSTimer *clock;
        
    // Not sure if this should live here or in AppDelegate,
    // but we'll start with here for now.
    NSOperationQueue *queue;
    
    int lastRevision;
}


- (void) initParticipantsView;
- (void) initTodoViews;

- (void) clk;

- (void) addTodo:(Todo *)todo;

- (void) dispatchTodoCommandString:(NSString *)operation fromRevision:(int)revision;

- (void) handleNewTodoWithArguments:(NSArray *)args;
- (void) handleAssignTodoWithArguments:(NSArray *)args;

- (CGPoint) getNextTodoPosition;

@end

