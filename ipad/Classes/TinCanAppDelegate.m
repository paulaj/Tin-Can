//
//  TinCanAppDelegate.m
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import "TinCanAppDelegate.h"
#import "TinCanViewController.h"
#import "ParticipantView.h"

@implementation TinCanAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    

    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
