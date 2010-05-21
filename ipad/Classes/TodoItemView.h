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
- (void) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;
@end


@interface TodoItemView : UIView {
	bool touched;
	Todo *todo;
    UIFont *f;
    id <TodoDragDelegate> delegate;
}

- (id) initWithTodo:(Todo *)newTodo atPoint:(CGPoint)point;
- (void) deassign;


@property (nonatomic, retain) Todo *todo;
@property (nonatomic, assign) id <TodoDragDelegate> delegate;


@end
