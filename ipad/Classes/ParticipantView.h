//
//  ParticipantView.h
//  TinCan
//
//  Created by Drew Harry on 4/15/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Todo.h"
#import "Participant.h"

@class Participant;

@interface ParticipantView : UIView {
	NSString *name;
	float rotation;
	bool hover;
    
    UIColor *color;
    
    Participant *participant;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) Participant *participant;

- (id) initWithParticipant:(Participant *)newParticipant withPosition:(CGPoint)pos withRotation:(CGFloat)rot withColor:(UIColor *)c;
- (void) setHoverState:(bool)hoverState;

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event;


@end
