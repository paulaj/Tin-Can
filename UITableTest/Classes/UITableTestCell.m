//
//  UITableTestCell.m
//  UITableTest
//
//  Created by Drew Harry on 6/18/10.
//  Copyright 2010 MIT Media Lab. All rights reserved.
//

#import "UITableTestCell.h"


@implementation UITableTestCell

@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        CGRect tzvFrame = CGRectMake(0.0, 2.0, 320, self.contentView.bounds.size.height);

        testCellView = [[UITableTestCellView alloc] initWithFrame:tzvFrame];
        testCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:testCellView];
    }
    return self;
}

- (void)setName:(NSString *)newName {
    
    [testCellView setName:newName];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


- (void)dealloc {
    [super dealloc];
}


@end
