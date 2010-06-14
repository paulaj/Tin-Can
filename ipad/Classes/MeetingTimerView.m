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
		currentTimerColor=[[UIColor blueColor] retain];
		//colorWheel= [NSArray arrayWithObjects: [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor], nil];
		viewHasBeenTouched=false;
		selectedTimes=[[NSMutableArray array] retain];
    }
    return self;
}





-(CGFloat)getMinRotationWithDate:(NSDate *)date{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
	return ((minute*60 + second)/3600.0f) * (2*M_PI);
}

-(CGFloat)getHourRotation{ 
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
	return  ((hour%12)*3600 + minute*60 + second)/(43200.0f) * (2*M_PI);
}

//-(UIColor *)getColorWithInt:(NSUInteger)i{
//	if ((i<[colorWheel count]-1) & (i>0)) {
//		return[colorWheel objectAtIndex:i];
//	}
//	else{		
//		return [colorWheel objectAtIndex: i-3];
//
//	}
//}

	
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Wipe the layer manually because clearsContext doesn't work.
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1.0);
    CGContextFillRect(ctx, CGRectMake(-200, -200, 500, 500));

	
	
    // Puts it in landscape mode, basically - so the top of the clock is to the right in portrait mode
    CGContextRotateCTM(ctx, M_PI/2);
    // Draw the outline of the clock.
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(ctx, 3.0);
    
    CGContextSaveGState(ctx);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(-140, -140, 280, 280));

	if (viewHasBeenTouched==true) {
		int i=0;
		while(i< [selectedTimes count]){
			CGContextRotateCTM(ctx, [[[selectedTimes objectAtIndex:i] objectAtIndex:0]floatValue]);
			CGContextMoveToPoint(ctx, 0, 0);
			//CGContextAddLineToPoint(ctx, 0,-150);
			CGContextStrokePath(ctx);
			
			if (i>0){
				NSDate *tempStartTime=[[selectedTimes objectAtIndex:i-1] objectAtIndex:1];
				NSDate *tempEndTime=[[selectedTimes objectAtIndex:i] objectAtIndex:1];
				int elapsedSeconds = abs([ tempStartTime  timeIntervalSinceDate:tempEndTime ]);
				CGFloat arcLength = elapsedSeconds/3600.0f * (2*M_PI);
				CGContextMoveToPoint(ctx, 0, 0); 
				CGContextAddArc(ctx, 0, 0, 130, -M_PI/2-arcLength, -M_PI/2, 0);
				
				UIColor *colorRetrieved=[[selectedTimes objectAtIndex:i] objectAtIndex:2];
				CGContextSetFillColorWithColor(ctx, colorRetrieved.CGColor);


				CGContextFillPath(ctx);
			}
			else if(i==0) {
				NSDate *tempEndTime=[[selectedTimes objectAtIndex:i] objectAtIndex:1];
				int elapsedSeconds = abs([startTime timeIntervalSinceDate:tempEndTime]);
				CGFloat arcLength = elapsedSeconds/3600.0f * (2*M_PI);
				CGContextMoveToPoint(ctx, 0, 0);
				CGContextAddArc(ctx, 0, 0, 130, -M_PI/2 - arcLength, -M_PI/2 , 0);
				
				//currentTimerColor=[[selectedTimes objectAtIndex:i] objectAtIndex:2];
				//CGContextSetFillColorWithColor(ctx, currentTimerColor.CGColor);
				
				//NSLog(@"Array %@", [selectedTimes objectAtIndex:i]);
				UIColor *colorRetrieved=[[selectedTimes objectAtIndex:i] objectAtIndex:2];
				//NSLog(@"Color: %@", colorRetrieved);
				CGContextSetFillColorWithColor(ctx, colorRetrieved.CGColor);

				//NSLog(@"Index: %d", i);
//				NSLog(@"Color: %@", currentTimerColor);
				CGContextFillPath(ctx);
			}
			CGContextRestoreGState(ctx);
			CGContextSaveGState(ctx);
			i++;
			
		}
	}
	
	
	CGFloat hourRotation= [self getHourRotation];
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
    
    // Now put a 12 on top.
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
        //NSLog(@"Setting initial rotation: %f", initialRot);
    } else {
        // Figure out the total number of elapsed seconds.
        int elapsedSeconds = abs([[[selectedTimes lastObject] objectAtIndex:1] timeIntervalSinceNow]);
        
        // Gameplan here is always draw a line from 0,0 straight up, then
        // arc around to the current rotation. Rotate the whole context by
        // initialRot to put it in the right place.
        //
        // Defer wrap-around detection, for now. We'll figure that out later. 
		CGContextRotateCTM(ctx, [[[selectedTimes lastObject] objectAtIndex:0]floatValue]);
		NSLog(@"Color: %@", currentTimerColor);
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
	
	NSDate *timeToSetTimeTo = [[NSDate date]retain];
	CGFloat rotationOfTouchedTime= [self getMinRotationWithDate:timeToSetTimeTo];
	[selectedTimes addObject:[[NSMutableArray alloc] initWithCapacity:2]];
	[[selectedTimes lastObject] addObject:[NSNumber numberWithFloat: rotationOfTouchedTime]];
	[[selectedTimes lastObject] addObject:timeToSetTimeTo];
	
	//getting color
	NSMutableArray *tempObject= [selectedTimes lastObject];
	int currentIndex=[selectedTimes indexOfObject:tempObject];
	UIColor *colorToStore=[UIColor colorWithRed:0 green:0 blue:(currentIndex +1)*.1 alpha:1];
	viewHasBeenTouched=true;
	currentTimerColor= [[UIColor alloc] initWithRed:0 green:0 blue:(currentIndex +2)*.1 alpha:1];
	[[selectedTimes lastObject] addObject: colorToStore];
	//NSLog(@"End");
	
	
}

- (void)dealloc {
	[currentTimerColor release];
    [startTime release];
	[selectedTimes release];
    [super dealloc];
	[UIColor release];
	
}


@end
