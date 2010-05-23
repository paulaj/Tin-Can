//
//  TodoItemView.h
//  TodoDragTest
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticipantView.h"
#import "Todo.h"

@class TodoDragTestAppDelegate;

@protocol TodoDragDelegate
- (void) todoDragMovedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;

// Returns true if the drag ended on a drop target, false otherwise.
// (TODO should this actually return the target we dropped on instead of just true/false?)
// (alternatively, should we have a generic drop target interface? Hmm.)
- (bool) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;
@end


@interface TodoItemView : UIView {
	bool touched;
	Todo *todo;
    UIFont *f;
    id <TodoDragDelegate> delegate;
    
    CGPoint initialOrigin;
}

- (id) initWithTodo:(Todo *)newTodo atPoint:(CGPoint)point isOriginPoint:(bool)isOrigin fromParticipant:(Participant *)participant useParticipantRotation:(bool)useParticipantRotation;
- (void) deassign;

- (void) animateToAssignedParticipant:(Participant *)participant;
- (void) animateToAssignedParticipantDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context;


@property (nonatomic, retain) Todo *todo;
@property (nonatomic, assign) id <TodoDragDelegate> delegate;


@end
