//
//  MeetingTimerView.m
//  TinCan
//
//  Created by Drew Harry on 5/20/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "MeetingTimerView.h"


@implementation MeetingTimerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.bounds = CGRectMake(-150, -150, 300, 300);
        self.center = CGPointMake(384, 512);
        
        self.clearsContextBeforeDrawing = YES;
        
        initialRot = -1;
        startTime = [[NSDate date] retain];
		currentTimerColor=[[[UIColor alloc] initWithRed:0 green:0 blue:0.2 alpha:1] retain];
		viewHasBeenTouched=false;
		selectedTimes=[[NSMutableArray array] retain];
		elapsedSeconds=0.0;
    }
    return self;
}




//calculates Rotation for things tracked by minutes (ie:minute hand)
-(CGFloat)getMinRotationWithDate:(NSDate *)date{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
	return ((minute*60 + second)/3600.0f) * (2*M_PI);
}
//calculates Rotation for hour hand
-(CGFloat)getHourRotationWithDate: (NSDate *)date{ 
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
	return  ((hour%12)*3600 + minute*60 + second)/(43200.0f) * (2*M_PI);
}

// Stores the important info to be used in the creation of a Time Arc
-(NSMutableArray *)storeNewTimeWithColor:(UIColor *)color{
	
	NSDate *timeToSetTimeTo = [[NSDate date]retain];
	CGFloat rotationOfTouchedTime= [self getMinRotationWithDate:timeToSetTimeTo];
	UIColor *colorToStore=color;
	NSMutableArray *newlyStoredTime=[[NSMutableArray alloc] initWithCapacity:3];
	[newlyStoredTime addObject:[NSNumber numberWithFloat: rotationOfTouchedTime]];
	[newlyStoredTime addObject:timeToSetTimeTo];
	[newlyStoredTime addObject: colorToStore];
	return newlyStoredTime;
}

//Creates a Time Arc from an Array of Time Arc information and the current index
-(void)drawArcWithTimes:(NSMutableArray *)timelist withIndex:(int) index withContext:(CGContextRef) context{
	NSMutableArray *times= timelist;
	int i=index;
	CGContextRef ctx=context;
	CGContextRotateCTM(ctx, [[[selectedTimes objectAtIndex:i] objectAtIndex:0]floatValue]);
	CGContextMoveToPoint(ctx, 0, 0);
	if (i==0){ //The Start Case
		NSDate *tempEndTime=[[times objectAtIndex:i] objectAtIndex:1];
		int elapsedTime = abs([startTime timeIntervalSinceDate:tempEndTime]);
		CGFloat arcLength = elapsedTime/3600.0f * (2*M_PI);
		CGContextMoveToPoint(ctx, 0, 0);
		CGContextAddArc(ctx, 0, 0, 130, -M_PI/2 - arcLength, -M_PI/2 , 0);
	}
	else { 
		NSDate *tempStartTime=[[times objectAtIndex:i-1] objectAtIndex:1];
		NSDate *tempEndTime=[[times objectAtIndex:i] objectAtIndex:1];
		int elapsedTime = abs([ tempStartTime  timeIntervalSinceDate:tempEndTime ]);
		CGFloat arcLength = elapsedTime/3600.0f * (2*M_PI);
		CGContextMoveToPoint(ctx, 0, 0);
		CGContextAddArc(ctx, 0, 0, 130, -M_PI/2 - arcLength, -M_PI/2 , 0);
	}
	// Let's Color!
	UIColor *colorRetrieved=[[times objectAtIndex:i] objectAtIndex:2];	
	CGContextSetFillColorWithColor(ctx, colorRetrieved.CGColor);
	CGContextFillPath(ctx);
}

	
- (void)drawRect:(CGRect)rect {
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Wipe the layer manually because clearsContext doesn't work.
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1.0);
    CGContextFillRect(ctx, CGRectMake(-200, -200, 500, 500));

	
    // Puts it in landscape mode, basically - so the top of the clock is to the right in portrait mode
    CGContextRotateCTM(ctx, M_PI/2);
    // Draw the outline of the clock.
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSaveGState(ctx);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(-140, -140, 280, 280));
	
	// colors in time span per touch
	if (viewHasBeenTouched==true) {
		int i=0;
		while(i< [selectedTimes count]){
			[self drawArcWithTimes:selectedTimes withIndex:i  withContext:ctx];
			CGContextRestoreGState(ctx);
			CGContextSaveGState(ctx);
			i++;
		}
	}
	
	CGFloat hourRotation= [self getHourRotationWithDate:[NSDate date]];
	CGFloat minRotation= [self getMinRotationWithDate:[NSDate date]];
	
    CGContextRotateCTM(ctx, hourRotation);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, -90);
    CGContextStrokePath(ctx);
        
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    CGContextRotateCTM(ctx, minRotation);
	CGContextMoveToPoint(ctx, 0, 0);
	CGContextAddLineToPoint(ctx, 0, -130);
    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
    
    // Now put numbers on the face of the clock
    NSString *twelve = @"12";
    NSString *six = @"6";
    NSString *three = @"3";
    NSString *nine = @"9";

    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1.0);
    [twelve drawAtPoint:CGPointMake(-10, -140) withFont:[UIFont boldSystemFontOfSize:18]];
    [six drawAtPoint:CGPointMake(-10, 115) withFont:[UIFont boldSystemFontOfSize:18]];
    [three drawAtPoint:CGPointMake(125, -10) withFont:[UIFont boldSystemFontOfSize:18]];
    [nine drawAtPoint:CGPointMake(-135, -10) withFont:[UIFont boldSystemFontOfSize:18]];
    
    if(initialRot==-1) {
        initialRot = minRotation;
		NSLog(@"initial rotation: %f", initialRot);
		
    } 
	else {
		NSLog(@"selectedTime:%@", selectedTimes);
		NSLog(@"selectedTime:%d", [selectedTimes count]);
		
		float rotation;		
		if([selectedTimes count] == 0) {
			elapsedSeconds = abs([startTime timeIntervalSinceNow]);
			rotation = initialRot;
		}
		else {
	 		elapsedSeconds = abs([[[selectedTimes lastObject] objectAtIndex:1] timeIntervalSinceNow]);
			rotation = [[[selectedTimes lastObject] objectAtIndex:0]floatValue];
		}   
		
		NSLog(@"elapsedSeconds: %d, rotation: %f", elapsedSeconds, rotation);
		
        // Gameplan here is always draw a line from 0,0 straight up, then
        // arc around to the current rotation. Rotate the whole context by
        // initialRot to put it in the right place.
        //
        // Defer wrap-around detection, for now. We'll figure that out later.
		
		CGContextRotateCTM(ctx, rotation);
        CGContextSetFillColorWithColor(ctx, currentTimerColor.CGColor);
        CGContextMoveToPoint(ctx, 0.0, 0.0);
        
        // Not sure about the PI/2 term yet - why is it always off by 90 deg? Shouldn't
        // the CTM rotation fix this? Or maybe this is on top of the earlier rotation?
        // TODO sort this out so it's not so hacky.
        CGFloat arcLength = elapsedSeconds/3600.0f * (2*M_PI);
        CGContextAddArc(ctx, 0, 0, 130, -M_PI/2, -M_PI/2 + arcLength, 0);
        CGContextAddLineToPoint(ctx, 0, 0);
        CGContextFillPath(ctx);
	}
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"Touched");
	//getting current index in color creation (for testing only)
	
	int currentIndex=[selectedTimes count];
	UIColor *colorToStore=[UIColor colorWithRed:0 green:0 blue:(currentIndex +1)*.2 alpha:1];
	currentTimerColor= [[UIColor alloc] initWithRed:0 green:0 blue:(currentIndex +2)*.2 alpha:1];
	
	//notes Touches and stores important time info per touch
	viewHasBeenTouched=true;
	[selectedTimes addObject:[self storeNewTimeWithColor: colorToStore]];	
}



- (void)dealloc {
	[currentTimerColor release];
    [startTime release];
	[selectedTimes release];
    [super dealloc];
	[UIColor release];
	
}


@end
