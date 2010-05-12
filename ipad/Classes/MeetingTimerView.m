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


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    startDate = [[NSDate date] retain];
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    // Draw the background of the progress bar.
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 1.0);
    CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.1, 1.0);
        
    CGContextFillRect(ctx, self.bounds);
    CGContextStrokeRect(ctx, self.bounds);
    
    
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
    
    CGRect progressRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height*timeFraction);
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextFillRect(ctx, progressRect);
    
    // Draw a nice bright line at the current time.
    
}

- (void) dealloc {
    [super dealloc];
    [startDate release];
}

@end
