//
//  CarList.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CarList.h"
#import "CarCell.h"
#import "CarDetail.h"
#import "UIImageView+WebCache.h"
#import <CarbonKit/CarbonKit.h>

@interface CarList ()

@end

@implementation CarList

@synthesize listStatus,myTable;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    [myTable setContentInset:UIEdgeInsetsMake (10, 0, 10, 0)];
    
    listLimit = @"10";
    
    [self loadList:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadList:YES];
}

- (void)loadList:(BOOL)showSpinner
{
    if (showSpinner) {
        [SVProgressHUD showWithStatus:@"Loading"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@carListService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"List",
                                 @"orderBy":@"CarImageID",
                                 @"orderType":@"desc",
                                 @"limit":listLimit,
                                 @"status":listStatus};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         listJSON = [responseObject objectForKey:@"data"];
         
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             [myTable reloadData];
         }
         else{
             [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาลองใหม่อีกครั้งในภายหลัง"];
         }
         
         if (showSpinner) {
             [SVProgressHUD dismiss];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
         [SVProgressHUD dismiss];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listJSON count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.height/3.5);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarCell *cell = (CarCell *)[tableView dequeueReusableCellWithIdentifier:@"CarCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    cell.carBg.clipsToBounds = YES;
    cell.carBg.layer.cornerRadius = 7;
    
    cell.carBg.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.carBg.layer.shadowOffset = CGSizeMake(1, 1);
    cell.carBg.layer.shadowOpacity = 0.6;
    cell.carBg.layer.shadowRadius = 1.0;
    cell.carBg.clipsToBounds = NO;
    
    [cell.carPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    //cell.licenseLabel.text = [NSString stringWithFormat:@"LICENSE : %@",[cellArray objectForKey:@"LicensePlateNo"]];
    //cell.licenseLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize];
    
    UIColor *leftColor = [UIColor colorWithRed:0.0/255 green:131.0/255 blue:202.0/255 alpha:1.0];
    UIColor *rightColor = [UIColor colorWithRed:112.0/255 green:112.0/255 blue:112.0/255 alpha:1.0];
    
    //LICENSE PLATE
    UIFont *plateFontL = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize-3];
    NSDictionary *plateDictL = [NSDictionary dictionaryWithObject: plateFontL forKey:NSFontAttributeName];
    NSMutableAttributedString *plateAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"ป้ายทะเบียน : " attributes: plateDictL];
    [plateAttrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, plateAttrStringL.length))];
    
    UIFont *plateFontR = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+1];
    NSDictionary *plateDictR = [NSDictionary dictionaryWithObject:plateFontR forKey:NSFontAttributeName];
    NSMutableAttributedString *plateAttrStringR = [[NSMutableAttributedString alloc]initWithString:[cellArray objectForKey:@"LicensePlateNo"] attributes:plateDictR];
    [plateAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, plateAttrStringR.length))];
    
    [plateAttrStringL appendAttributedString:plateAttrStringR];
    cell.licenseLabel.attributedText = plateAttrStringL;
    
    ////DETAIL
    UIFont *detailFontL = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize-4];
    NSDictionary *detailDictL = [NSDictionary dictionaryWithObject: detailFontL forKey:NSFontAttributeName];
    
    UIFont *detailFontR = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize-3];
    NSDictionary *detailDictR = [NSDictionary dictionaryWithObject:detailFontR forKey:NSFontAttributeName];
    
    ////Province
    NSMutableAttributedString *provinceAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"จังหวัด : " attributes: detailDictL];
    [provinceAttrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, provinceAttrStringL.length))];
    
    NSMutableAttributedString *provinceAttrStringR = [[NSMutableAttributedString alloc] initWithString:[cellArray objectForKey:@"province"] attributes: detailDictR];
    [provinceAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, provinceAttrStringR.length))];
    
    [provinceAttrStringL appendAttributedString:provinceAttrStringR];
    
    ////Date
    NSMutableAttributedString *dateAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"\nวันที่ : " attributes: detailDictL];
    [dateAttrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, dateAttrStringL.length))];
    
    NSMutableAttributedString *dateAttrStringR = [[NSMutableAttributedString alloc] initWithString:[cellArray objectForKey:@"date"] attributes: detailDictR];
    [dateAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, dateAttrStringR.length))];
    
    [dateAttrStringL appendAttributedString:dateAttrStringR];
    
    ////Time
    NSMutableAttributedString *timeAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"\tเวลา : " attributes: detailDictL];
    [timeAttrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, timeAttrStringL.length))];
    
    NSMutableAttributedString *timeAttrStringR = [[NSMutableAttributedString alloc] initWithString:[cellArray objectForKey:@"time"] attributes: detailDictR];
    [timeAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, timeAttrStringR.length))];
    
    [timeAttrStringL appendAttributedString:timeAttrStringR];
    
    [provinceAttrStringL appendAttributedString:dateAttrStringL];
    [provinceAttrStringL appendAttributedString:timeAttrStringL];
    
    //cell.createLabel.attributedText = provinceAttrStringL;
    
    ////SPACE
    UIFont *spaceFont = [UIFont fontWithName:sharedManager.fontBold size:sharedManager.fontSize-15];
    NSDictionary *spaceDict = [NSDictionary dictionaryWithObject: spaceFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *spaceAttrString = [[NSMutableAttributedString alloc] initWithString:@"\n\n" attributes: spaceDict];
    [spaceAttrString addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, spaceAttrString.length))];
    
    ////APPROVE
    UIFont *approveFont = [UIFont fontWithName:sharedManager.fontBold size:sharedManager.fontSize-4];
    NSDictionary *approveDict = [NSDictionary dictionaryWithObject: approveFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *approveAttrString = [[NSMutableAttributedString alloc] initWithString:@"ตรวจสอบ" attributes: approveDict];
    [approveAttrString addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, approveAttrString.length))];
    
    [spaceAttrString appendAttributedString:approveAttrString];
    
    ////Date2
    NSMutableAttributedString *dateAttrStringL2 = [[NSMutableAttributedString alloc] initWithString:@"\nวันที่ : " attributes: detailDictL];
    [dateAttrStringL2 addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, dateAttrStringL2.length))];
    
    NSMutableAttributedString *dateAttrStringR2 = [[NSMutableAttributedString alloc] initWithString:[cellArray objectForKey:@"approve_date"] attributes: detailDictR];
    [dateAttrStringR2 addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, dateAttrStringR2.length))];
    
    [dateAttrStringL2 appendAttributedString:dateAttrStringR2];
    
    ////Time2
    NSString *tabSpace;
    if ([[cellArray objectForKey:@"approve_date"] isEqualToString:@"-"]) {
        tabSpace = @"\t\t\tเวลา : ";
    }
    else
    {
        tabSpace = @"\tเวลา : ";
    }
    
    NSMutableAttributedString *timeAttrStringL2 = [[NSMutableAttributedString alloc] initWithString:tabSpace attributes: detailDictL];
    [timeAttrStringL2 addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, timeAttrStringL2.length))];
    
    NSMutableAttributedString *timeAttrStringR2 = [[NSMutableAttributedString alloc] initWithString:[cellArray objectForKey:@"approve_time"] attributes: detailDictR];
    [timeAttrStringR2 addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, timeAttrStringR2.length))];
    
    [timeAttrStringL2 appendAttributedString:timeAttrStringR2];
    
    ////By
    NSMutableAttributedString *byAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"\nโดย " attributes: detailDictR];
    [byAttrStringL addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, byAttrStringL.length))];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",[cellArray objectForKey:@"approve_by_name"],[cellArray objectForKey:@"approve_by_lastname"]];
    if ([fullName isEqualToString:@"- -"]) {
        fullName = @"-";
    }
    
    NSMutableAttributedString *byAttrStringR = [[NSMutableAttributedString alloc] initWithString:fullName attributes: detailDictR];
    [byAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, byAttrStringR.length))];
    
    [byAttrStringL appendAttributedString:byAttrStringR];
    
    [spaceAttrString appendAttributedString:dateAttrStringL2];
    [spaceAttrString appendAttributedString:timeAttrStringL2];
    [spaceAttrString appendAttributedString:byAttrStringL];
    
    //FINAL
    
    [provinceAttrStringL appendAttributedString:spaceAttrString];
    cell.createLabel.attributedText = provinceAttrStringL;
    
    cell.statusLabel.font = detailFontR;
    cell.approveBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize-6];
    cell.approveBtn.clipsToBounds = YES;
    cell.approveBtn.layer.cornerRadius = 7;
    
    if ([[cellArray objectForKey:@"approve_status"] isEqualToString:@"1"]) {
        [cell.approveBtn setTitle:@"อนุมัติ" forState:UIControlStateNormal];
        [cell.approveBtn setBackgroundColor:[UIColor colorWithRed:25.0/255 green:201.0/255 blue:25.0/255 alpha:1.0]];
    }
    else if ([[cellArray objectForKey:@"approve_status"] isEqualToString:@"2"]) {
        [cell.approveBtn setTitle:@"ไม่อนุมัติ" forState:UIControlStateNormal];
        [cell.approveBtn setBackgroundColor:[UIColor colorWithRed:234.0/255 green:26.0/255 blue:26.0/255 alpha:1.0]];
    }
    else{
        [cell.approveBtn setTitle:@"รอตรวจสอบ" forState:UIControlStateNormal];
        [cell.approveBtn setBackgroundColor:[UIColor colorWithRed:218.0/255 green:190.0/255 blue:0.0/255 alpha:1.0]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarDetail *cd = [self.storyboard instantiateViewControllerWithIdentifier:@"CarDetail"];
    cd.carID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"CarImageID"];
    cd.listStatus = listStatus;
    [self.navigationController pushViewController:cd animated:YES];
}

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
