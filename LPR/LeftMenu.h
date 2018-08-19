//
//  LeftMenu.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Navi.h"

@interface LeftMenu : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    Singleton *sharedManager;
    NSMutableIndexSet *expandedSections;
    Navi *navi;
}

@property (retain, nonatomic) IBOutlet UITableView *myTable;

@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;

- (void)loadProfile;
@end
