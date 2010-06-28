//
//  UITableTestAppDelegate.h
//  UITableTest
//
//  Created by Drew Harry on 6/18/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableTestViewController;

@interface UITableTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITableTestViewController *viewController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITableTestViewController *viewController;

@end

