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
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Wipe the layer manually because clearsContext doesn't work.
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.0);
    CGContextFillRect(ctx, self.bounds);

    // Puts it in landscape mode, basically - so the top of the clock is to the right in portrait mode
    CGContextRotateCTM(ctx, M_PI/2);
    // Draw the outline of the clock.
    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextSaveGState(ctx);

    
    CGContextStrokeEllipseInRect(ctx, CGRectMake(-140, -140, 280, 280));
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
    
    NSLog(@"time: %d:%d", hour, minute);
        
    // Draw the hour hand.
    // Figure out what the rotation should be.
    CGFloat hourRotation = ((hour%12)/12.0f) * (2*M_PI);
    CGFloat minRotation = ((minute*60 + second)/3600.0f) * (2*M_PI);

    NSLog(@"time rots: %f:%f", hourRotation, minRotation);

    
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

    CGContextSetRGBFillColor(ctx, 0.3, 0.3, 0.3, 1.0);
    [twelve drawAtPoint:CGPointMake(-10, -140) withFont:[UIFont systemFontOfSize:18]];
    
    
    
}

- (void)dealloc {
    [super dealloc];
}


@end
