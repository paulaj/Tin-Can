//
//  Todo.h
//  TinCan
//
//  Created by Drew Harry on 4/27/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Todo : NSObject  <NSCopying> {
    NSString *uuid;
	NSString *text;
	NSDate *created;
	NSString *createdBy;
	
    UIView *parentView;
	// Some sort of history thing here?
}

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)creator;

- (id) copyWithZone:(NSZone *)zone;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *createdBy;
@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, retain) NSString *uuid;

@end
