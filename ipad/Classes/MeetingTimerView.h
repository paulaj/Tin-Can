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
	NSMutableArray *colorWheel;
	int indexForColorWheel;
	int elapsedSeconds;
	NSDate *testDate;
	float hourCounter;
	float timeToCompare;
	int hourCheck;
	
}

- (id)initWithFrame:(CGRect)frame withStartTime:(NSDate *)time;

-(CGFloat)getMinRotationWithDate:(NSDate *)date;
-(CGFloat)getHourRotationWithDate: (NSDate *)date; 
-(NSMutableArray *)storeNewTimeWithColor:(UIColor *)color withTime: (NSDate *)time withHour:(float) hour withType:(NSString *)type;
	-(void)drawArcWithTimes:(NSMutableArray *)times withIndex:(int) index  withContext:(CGContextRef) context;
@end
