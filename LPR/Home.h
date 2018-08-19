//
//  Home.h
//  LPR
//
//  Created by Firststep Consulting on 17/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CarbonKit/CarbonKit.h>

@interface Home : UIViewController
{
    Singleton *sharedManager;}

@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property(weak, nonatomic) IBOutlet UIView *targetView;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UILabel *headerTitle;
@property (retain, nonatomic) IBOutlet UIButton *searchBtn;
@property (retain, nonatomic) IBOutlet UIButton *filterBtn;
@end
