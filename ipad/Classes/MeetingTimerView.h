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
	
	UIColor *currentTimerColor;
	bool viewHasBeenTouched;
	NSMutableArray *selectedTimes;
	NSArray *colorWheel;

	
}

-(CGFloat)getMinRotationWithDate:(NSDate *)date;
-(CGFloat)getHourRotation; 
//-(UIColor*)getColorWithInt:(NSUInteger)i;
@end
