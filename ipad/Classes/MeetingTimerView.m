//
//  MeetingTimerView.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "MeetingTimerView.h"
#import <math.h>

@implementation MeetingTimerView


- (id) init {    
    
    // I'm not sure why (0, 350) puts there where it's supposed to be.
    // Rotating seems to cause some weird issues.
    CGRect frame = CGRectMake(0, 425, 600, 150);
    
    self = [super initWithFrame:frame];
    
    startDate = [[NSDate date] retain];

    dateFormatter = [[[NSDateFormatter alloc] init] retain];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    dateFont = [[UIFont boldSystemFontOfSize:24] retain];

    // Rotate it!
    [self setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect progressBarFrame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
    
    // Draw the background of the progress bar.
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 1.0);
    CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.1, 1.0);
        
    CGContextFillRect(ctx, progressBarFrame);
    CGContextStrokeRect(ctx, progressBarFrame);
    
    // Fill it in based on how long it's been since it was created.
    // (use timeIntervalSinceNow).
    
    // For now, lets assume a 10 minute meeting so it's possible to see
    // what's actually going on over the course of a demo.
    // TODO Make this an actual constant.
    
    // We're going to assume the aspect ratio here is thin and tall. At some point,
    // this will probably get abstracted to be a different coordinate system that
    // gets rotated into place, but this will work for now.
    CGFloat meetingDurationSeconds = 300;
    
    // Have to do negative one to flip the sign, since timeIntervalSinceNow goes negative when
    // the current time is more recent than the date it's called on. Feels backwards to me, but
    // what can you do.
    CGFloat timeFraction = -1 * [startDate timeIntervalSinceNow] / (meetingDurationSeconds);
    
    CGRect progressRect = CGRectMake(progressBarFrame.origin.x, progressBarFrame.origin.y, self.bounds.size.width*timeFraction, self.bounds.size.height);
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextFillRect(ctx, progressRect);
    
    
    // Now lets draw the current time.
    NSDate *today = [NSDate date];

    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    NSString *currentTime = [dateFormatter stringFromDate:today];

    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    [currentTime drawAtPoint:CGPointMake(0, 20) withFont:dateFont];

}

- (void) dealloc {
    [super dealloc];
    [startDate release];
    
    [dateFont release];
    [dateFormatter release];
    
}

@end
