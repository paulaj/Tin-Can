//
//  MeetingTimerView.h
//  TinCan
//
//  Created by Drew Harry on 5/20/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeetingTimerView : UIView {
    CGFloat initialRot;
    NSDate *startTime;
	
	//CGFloat rotationOfTouchedTime;
	bool viewHasBeenTouched;
	NSMutableArray *selectedTimes;
	
}

-(CGFloat)getMinRotationWithDate:(NSDate *)date;
-(CGFloat)getHourRotation; 

@end
