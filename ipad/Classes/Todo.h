//
//  Todo.h
//  TinCan
//
//  Created by Drew Harry on 4/27/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Todo : NSObject {
	NSString *text;
	NSDate *created;
	NSString *createdBy;
	
	// Some sort of history thing here?
}

- (id) initWithText:(NSString *)todoText withCreator:(NSString *)creator;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *createdBy;


@end
