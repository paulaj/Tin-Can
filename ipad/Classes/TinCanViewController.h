//
//  TinCanViewController.h
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingTimerView.h"
#import "TodoItemView.h"
#import "ParticipantView.h"

@interface TinCanViewController : UIViewController <TodoDragDelegate> {
    UIView *participantsContainer;
    UIView *todosContainer;
    
    NSMutableSet *participants;
    NSMutableSet *todoViews;
    
    MeetingTimerView *meetingTimerView;
    NSTimer *clock;
    
    NSMutableDictionary *lastTodoDropTargets;
    
    // This is going to have to turn into a dictionary in a sec, but
    // for the one-touch-case, this will work.
    ParticipantView *lastTargetParticipant;
    
    // Not sure if this should live here or in AppDelegate,
    // but we'll start with here for now.
    NSOperationQueue *queue;
}


- (void)initParticipantsView;
- (void)initTodoViews;

- (void)clk;


- (ParticipantView *) participantAtTouch:(UITouch *)touch withEvent:(UIEvent *)event;



- (void) todoDragMovedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;
- (void) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;


- (void)handleTodoCommandString:(NSString *)operation;


@end

