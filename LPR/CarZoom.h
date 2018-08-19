//
//  CarZoom.h
//  LPR
//
//  Created by Firststep Consulting on 19/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface CarZoom : UIViewController <UIScrollViewDelegate>
{
    Singleton *sharedManager;
}

@property (nonatomic) NSString *picURL;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UILabel *headerTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;

@end


