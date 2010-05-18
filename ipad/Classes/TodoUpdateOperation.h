//
//  TodoUpdateOperation.h
//  TinCan
//
//  Created by Drew Harry on 5/18/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TinCanViewController.h"

// This was very helpful in structuring this class.
// http://www.cimgf.com/2008/02/16/cocoa-tutorial-nsoperation-and-nsoperationqueue/


@interface TodoUpdateOperation : NSOperation {
    TinCanViewController *viewController;
}

- (id)initWithViewController:(TinCanViewController *)vC;

@property(retain) TinCanViewController *viewController;

@end
