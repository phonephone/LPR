//
//  CarList.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface CarList : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    NSString *listLimit;
}
@property (nonatomic) NSString *listStatus;

@property (retain, nonatomic) IBOutlet UITableView *myTable;

- (void)loadList:(BOOL)showSpinner;

@end
