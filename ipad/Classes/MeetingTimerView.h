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
	NSDate *newDate;
	UIColor *currentTimerColor;
	bool viewHasBeenTouched;
	NSMutableArray *selectedTimes;
	int elapsedSeconds;
	
	
}

-(CGFloat)getMinRotationWithDate:(NSDate *)date;
-(CGFloat)getHourRotationWithDate: (NSDate *)date; 
-(NSMutableArray *)storeNewTimeWithColor:(UIColor *)color;
-(void)drawArcWithTimes:(NSMutableArray *)times withIndex:(int) index  withContext:(CGContextRef) context;
@end
