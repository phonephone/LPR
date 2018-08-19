//
//  LeftMenu.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "LeftMenu.h"
#import "Login.h"
#import "MenuCell.h"

@interface LeftMenu ()

@end

@implementation LeftMenu

@synthesize myTable,userPic,userName;

- (void)viewWillAppear:(BOOL)animated
{
    userName.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    sharedManager.mainRoot = (MFSideMenuContainerViewController *)self.parentViewController;
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    [self loadProfile];
}

- (void)viewDidLayoutSubviews
{
    //Circle
    userPic.layer.cornerRadius = userPic.frame.size.width/2;
    userPic.layer.masksToBounds = YES;
    
    //Border
    userPic.layer.borderWidth = 1.0f;
    userPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [myTable reloadData];
}

- (void)loadProfile
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@profileService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"Profile",
                                 @"user_id":sharedManager.memberID
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             sharedManager.profileJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             
             userPic.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:[NSURL URLWithString:[sharedManager.profileJSON objectForKey:@"picture"]]]];
             userName.text = [NSString stringWithFormat:@"%@ %@",[sharedManager.profileJSON objectForKey:@"name"],[sharedManager.profileJSON objectForKey:@"lastname"]];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
     }];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    //if (section== 1) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;// 5
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            if (section == 99) {//Offer & Reserve
                return 2+1;
            }
        }
        return 1; // only top row showing
    }
    // Return the number of rows in other section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (!indexPath.row)//Main
        {
            rowHeight = (self.view.frame.size.height/11);
        }
        else//Sub
        {
            rowHeight = (self.view.frame.size.height/12);
        }
    }
    else//Can't Expand
    {
        rowHeight = (self.view.frame.size.height/17);
    }
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    [cell setSelectedBackgroundView:bgColorView];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (indexPath.section == 99) {
            /*
            cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1];
            if (indexPath.row == 0) {
                cell.menuLabel.text = @"ข้อมูลการเดินทาง";
                bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
                [cell setSelectedBackgroundView:bgColorView];
                
                if (alertOffer+alertReserve > 0) { cell.menuAlert.hidden = NO; }
                else{ cell.menuAlert.hidden = YES; }
            }
            else if (indexPath.row == 1) {
                cell.menuLabel.text = @"   การเสนอที่นั่งของคุณ";
                
                if (alertOffer > 0) { cell.menuAlert.hidden = NO; }
                else{ cell.menuAlert.hidden = YES; }
            }
            */
        }
        
        cell.menuLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+4];
        cell.menuLabel.textColor = [UIColor darkGrayColor];
        cell.menuArrow.hidden = NO;
        
        /*
        if (!indexPath.row)//Main
        {
            if ([expandedSections containsIndex:indexPath.section])//Now Expanded
            {
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else//Not Expanded
            {
                //float degrees = 180; //the value in degrees
                //cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
        }
        else//Sub
        {
            cell.menuLabel.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize+2];
            cell.menuLabel.textColor = [UIColor darkGrayColor];
            cell.menuArrow.hidden = YES;
        }
        */
    }
    else//Can't Expand
    {
        if (indexPath.section == 0) {
            cell.menuLabel.text = @"หน้าแรก";
        }
        
        else if (indexPath.section == 1) {
            cell.menuLabel.text = @"ออกจากระบบ";
        }
        
        cell.menuLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1];
        cell.menuLabel.textColor = [UIColor lightGrayColor];
        cell.menuArrow.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    navi = (Navi*)[sharedManager.mainRoot.childViewControllers objectAtIndex:1];

    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)//Main Menu Click
        {
            // only first row toggles exapand/collapse
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                
                float degrees = 90; //the value in degrees
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
            
            //Table row management
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:section]-1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else//Sub Menu Click
        {
            if (indexPath.section == 99) {
                
                if (indexPath.row == 1) {//การเสนอที่นั่งของคุณ
                    //ProfileOffer *pfo = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOffer"];
                    //pfo.mode = @"Offer";
                    //[navi pushViewController:pfo animated:YES];
                }
                else if (indexPath.row == 2) {//การสำรองที่นั่งของคุณ
                    
                }
            }
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
        }
    }
    
    else // can't collapse
    {
        if (indexPath.section == 0) {
            UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"Navi"];
            [self.menuContainerViewController setCenterViewController:navi];
        }
        else if (indexPath.section == 1) {//ออกจากระบบ
            //[self clearToken];
            sharedManager.loginStatus = NO;
            sharedManager.memberID = @"";
            sharedManager.memberToken = @"";
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setBool:sharedManager.loginStatus forKey:@"loginStatus"];
            [ud setObject:sharedManager.memberID forKey:@"memberID"];
            [ud synchronize];
            
            Login *log = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.menuContainerViewController setCenterViewController:log];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
}

/*
- (void)clearToken
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@logout",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"logoutJSON %@",responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
     }];
}
*/

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
