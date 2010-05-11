//
//  MeetingTimerView.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "MeetingTimerView.h"


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
}

- (void) dealloc {
    [startDate release];
}

@end
