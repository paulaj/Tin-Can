//
//  TinCanAppDelegate.h
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TinCanViewController;

@interface TinCanAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TinCanViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TinCanViewController *viewController;

@end

