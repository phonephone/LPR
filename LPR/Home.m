//
//  Home.m
//  LPR
//
//  Created by Firststep Consulting on 17/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Home.h"
#import "CarList.h"

@interface Home () <CarbonTabSwipeNavigationDelegate> {
    NSArray *listCat;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}

@end

@implementation Home

@synthesize toolBar,targetView,leftBtn,headerTitle,searchBtn,filterBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    sharedManager = [Singleton sharedManager];
    
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+2];
    searchBtn.hidden = YES;
    filterBtn.hidden = YES;
    
    UIImage *test = [self generateImageWithText:[UIImage imageNamed:@"dot_red"] text:@"TEST"];
    
    listCat = @[
                @"รอตรวจสอบ",
                //test,
                @"อนุมัติ",
                @"ไม่อนุมัติ"
                ];
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:listCat toolBar:toolBar delegate:self];
    
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.targetView];
    
    sharedManager.mainCarbon = carbonTabSwipeNavigation;
    
    [self loadProvince];
    [self style];
}

- (void)loadProvince
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@provinceService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"List"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"ProvinceJSON %@",responseObject);
         
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             sharedManager.provinceJSON = [[responseObject objectForKey:@"data"] mutableCopy];
             NSMutableDictionary* none = [NSMutableDictionary dictionary];
             [none setObject:@"-" forKey:@"provincename"];
             [none setObject:@"0" forKey:@"provinceid"];
             [sharedManager.provinceJSON insertObject:none atIndex:0];
         }
         else{
             [self loadProvince];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
     }];
}

- (void)style {
    
    /*
     UIColor *color = [UIColor colorWithRed:243.0 / 255 green:75.0 / 255 blue:152.0 / 255 alpha:1];
     self.navigationController.navigationBar.translucent = NO;
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.barTintColor = color;
     self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
     */
    
    //carbonTabSwipeNavigation.toolbar.backgroundColor = [UIColor redColor];
    carbonTabSwipeNavigation.toolbar.barTintColor = [UIColor whiteColor];
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:[UIColor colorWithRed:0.0/255 green:131.0/255 blue:202.0/255 alpha:1]];
    
    carbonTabSwipeNavigation.toolbarHeight = [NSLayoutConstraint constraintWithItem:toolBar
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0
                                                                           constant:45];
    
    [self.view addConstraint:carbonTabSwipeNavigation.toolbarHeight];
    
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    
    int width = [UIScreen mainScreen].bounds.size.width/3;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:2];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1] font:[UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor colorWithRed:54.0/255 green:54.0/255 blue:54.0/255 alpha:1] font:[UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1]];
    [carbonTabSwipeNavigation setCurrentTabIndex:0];
    carbonTabSwipeNavigation.carbonTabSwipeScrollView.scrollEnabled = NO;
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    CarList *cl = [self.storyboard instantiateViewControllerWithIdentifier:@"CarList"];
    switch (index)
    {
        case 0:{
            cl.listStatus = @"0";
            return cl;
            break;
        }
        case 1:{
            cl.listStatus = @"1";
            return cl;
            break;
        }
        case 2:{
            cl.listStatus = @"2";
            return cl;
            break;
        }
            
        default:{
            cl.listStatus = @"0";
            return cl;
            break;
        }
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    //NSLog(@"Will move at index: %ld", (unsigned long)index);
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    //NSLog(@"Did move at index: %ld", (unsigned long)index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

- (UIImage*) generateImageWithText:(UIImage*)img text:(NSString*)text
{
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.frame = CGRectMake(0, 0, img.size.width/1.75, img.size.height/1.75);
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, toolBar.frame.size.width/5, toolBar.frame.size.height*0.25)];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor redColor];
    lbl.text = text;
    
    UIGraphicsBeginImageContextWithOptions(lbl.bounds.size, NO, 0);
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(toolBar.frame.size.width/3, toolBar.frame.size.height), NO, 0);
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    [lbl.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageWithText = UIGraphicsGetImageFromCurrentImageContext();
    //[imageWithText imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    
    return imageWithText;
}

- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)rightMenu:(id)sender {
    
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
