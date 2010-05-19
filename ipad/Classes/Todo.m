//
//  Todo.m
//  TinCan
//
//  Created by Drew Harry on 4/27/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "Todo.h"


@implementation Todo

@synthesize uuid;
@synthesize text;
@synthesize created;
@synthesize createdBy;
@synthesize parentView;

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)creator {
	self = [super init];
	
	self.text = todoText;
	self.createdBy = creator;
	self.created = [NSDate date];
	
    // Generate the uuid. 
    self.uuid = [NSString stringWithFormat:@"%@%d%d",@"p",[NSDate timeIntervalSinceReferenceDate] * 1000, arc4random() %1000];

	return self;
}

- (id) copyWithZone:(NSZone *)zone {
    return [self retain];
}

@end
