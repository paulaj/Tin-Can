//
//  TodoUpdateOperation.m
//  TinCan
//
//  Created by Drew Harry on 5/18/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "TodoUpdateOperation.h"
#import "TinCanAppDelegate.h"
#import "JSON.h"

@implementation TodoUpdateOperation

@synthesize viewController;

- (id)initWithViewController:(TinCanViewController *)vC {
    
    if (![super init]) return nil;
    
    [self setViewController:vC];
    
    return self;
}

- (void)main {
 
    // in here, make an update request.
    NSLog(@"About to make an update request!");
    
    // This section based on:
    // http://blog.zachwaugh.com/post/309924609/how-to-use-json-in-cocoaobjective-c
    
    // TODO abstract this out. Can we share this across all operations easily?
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    
    // Request the latest event from toqbot.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://toqbot.com/db/?tincan"]];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSLog(@"json response: %@",json_string);
    
    // parse the JSON response into an object
    // Here we're using NSArray since we're parsing an array of JSON status objects
    NSArray *result = [parser objectWithString:json_string error:nil];
    
    // We're expecting an array with a single dictionary in it.
    // Dump the fields we're expecting.
    NSDictionary *entry = [result objectAtIndex:0];
    NSLog(@"dictionary: %@", entry);
    
    [viewController handleTodoCommandString:[entry objectForKey:@"data"]];
}

- (void)dealloc {
    [viewController release], viewController = nil;
    [super dealloc];
}

@end
