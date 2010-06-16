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
	NSMutableArray *selectedTimes;
	int elapsedSeconds;
	NSDate *testDate;
	float hourCounter;
	float timeToCompare;
	
	
}

- (id)initWithFrame:(CGRect)frame withStartTime:(NSDate *)time;

-(CGFloat)getMinRotationWithDate:(NSDate *)date;
-(CGFloat)getHourRotationWithDate: (NSDate *)date; 
-(NSMutableArray *)storeNewTimeWithColor:(UIColor *)color withTime: (NSDate *)time;
	-(void)drawArcWithTimes:(NSMutableArray *)times withIndex:(int) index  withContext:(CGContextRef) context;
@end
