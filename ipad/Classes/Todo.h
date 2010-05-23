//
//  Todo.h
//  TinCan
//
//  Created by Drew Harry on 4/27/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Participant.h"

@class Participant;

@interface Todo : NSObject  <NSCopying> {
    NSString *uuid;
	NSString *text;
	NSDate *created;
    
	NSString *creatorUUID;
	
    Participant *participantOwner;
    
    UIView *view;
	// Some sort of history thing here?
}

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID withUUID:(NSString *)tUUID;
- (id) initWithText:(NSString *)todoText withCreator:(NSString *)pUUID;

- (id) copyWithZone:(NSZone *)zone;

- (void) startAssignment:(Participant *)participant;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *creatorUUID;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) Participant *participantOwner;

@end
