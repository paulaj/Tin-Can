//
//  ParticipantView.h
//  TinCan
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Todo.h";

@interface ParticipantView : UIView {
	NSString *name;
	float rotation;
	NSMutableSet *assignedTodos;
	bool hover;
    
    UIColor *color;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableSet *assignedTodos;
@property (nonatomic, retain) UIColor *color;

- (id) initWithName:(NSString *)participantName withPosition:(CGPoint)pos withRotation:(CGFloat)rot withColor:(UIColor *)c;
- (void) setHoverState:(bool)hoverState;
- (void) assignTodo:(Todo *)todo;

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event;


@end
