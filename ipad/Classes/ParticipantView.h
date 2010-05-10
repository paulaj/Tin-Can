//
//  ParticipantView.h
//  TodoDragTest
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ParticipantView : UIView {
	NSString *name;
	float rotation;
	NSMutableSet *assignedTodos;
	bool hover;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableSet *assignedTodos;

- (id) initWithName:(NSString *)participantName withPosition:(CGPoint)pos withRotation:(CGFloat)rot;
- (void) setHoverState:(bool)hoverState;

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event;


@end
