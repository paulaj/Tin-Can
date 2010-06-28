//
//  UITableTestCell.h
//  UITableTest
//
//  Created by Drew Harry on 6/18/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableTestCellView.h"

@interface UITableTestCell : UITableViewCell {
    UITableTestCellView *testCellView;
    NSString *name;
}

- (void) setName:(NSString *)name;

@property (nonatomic, retain) NSString *name;

@end
