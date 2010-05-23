//
//  DragManager.h
//  TinCan
//
//  Created by Drew Harry on 5/23/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Todo.h"
#import "TodoItemView.h"

@interface DragManager : NSObject <TodoDragDelegate> {
    UIView *rootView;
    UIView *participantsContainer;
    
    NSMutableDictionary *lastTodoDropTargets;
}


+ (DragManager*)sharedInstance;

// I feel weird having an init method that returns void, but since it's a singleton, not sure
// what else to do. 
- (void) initWithRootView:(UIView *)view withParticipantsContainer:(UIView *)container;

- (void) todoDragMovedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;
- (bool) todoDragEndedWithTouch:(UITouch *)touch withEvent:(UIEvent *)event withTodo:(Todo *)todo;


@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, retain) UIView *participantsContainer;


@end
