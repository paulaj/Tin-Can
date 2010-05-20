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
@synthesize creatorUUID;
@synthesize parentView;



// Syntactic sugar for auto-generating an internal UUID. Not sure we're actually
// ever going to do this - in the sponsor week demo, at least, all UUIDs are
// going to come from the web app.
- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID {

    // Generate an internal UUID.
    NSString *tUUID = [NSString stringWithFormat:@"%@%d%d",@"p",[NSDate timeIntervalSinceReferenceDate] * 1000, arc4random() %1000];

    return [self initWithText:todoText withCreator:pUUID withUUID:tUUID];
}

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID withUUID:(NSString *)tUUID {
	self = [super init];
	
	self.text = todoText;
	self.creatorUUID = pUUID;
	self.created = [NSDate date];

    self.uuid = tUUID;

	return self;
}

- (id) copyWithZone:(NSZone *)zone {
    return [self retain];
}

@end
