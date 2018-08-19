//
//  MenuCell.m
//  LPR
//
//  Created by Firststep Consulting on 17/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize menuLabel,menuArrow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
