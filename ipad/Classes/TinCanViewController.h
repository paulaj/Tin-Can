//
//  TinCanViewController.h
//  TinCan
//
//  Created by Drew Harry on 5/10/10.
//  Copyright MIT Media Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingTimerView.h"

@interface TinCanViewController : UIViewController {
    UIView* participantsContainer;
    NSMutableSet* participants;
    MeetingTimerView *meetingTimerView;
}


- (void)initParticipantsView;

@end

