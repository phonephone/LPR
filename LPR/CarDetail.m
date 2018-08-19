//
//  CarDetail.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CarDetail.h"
#import "UIImageView+WebCache.h"
#import "CarZoom.h"
#import "Web.h"
#import "CarList.h"

@interface CarDetail ()

@end

@implementation CarDetail
{
    NSArray *statusArray;
}
@synthesize carID,listStatus,leftBtn,rightBtn,headerTitle,myScroll,myPage,plateTitle,plateField,speedTitle,speedField,dateTitle,dateField,timeTitle,timeField,provinceTitle,provinceField,statusTitle,statusField,approveLabel;

- (void)viewWillLayoutSubviews
{
    myScroll.contentSize = CGSizeMake(myScroll.frame.size.width*picNumber,myScroll.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    statusArray = @[@"รอตรวจสอบ",@"อนุมัติ",@"ไม่อนุมัติ"];
    
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+2];
    
    if ([listStatus isEqualToString:@"1"]) {
        rightBtn.hidden = NO;
    }
    else
    {
        rightBtn.hidden = YES;
    }
    
    plateTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    plateField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+20];
    plateField.tag = 99;
    plateField.delegate = self;
    
    speedTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    speedField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+10];
    
    dateTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    dateField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+4];
    
    timeTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    timeField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+4];
    
    provinceTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    provinceField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+4];
    
    statusTitle.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize];
    statusField.font = [UIFont fontWithName:sharedManager.fontSemibold size:sharedManager.fontSize+4];
    
    approveLabel.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize-2];
    approveLabel.text = @"";
    
    provincePicker = [[UIPickerView alloc]init];
    provincePicker.delegate = self;
    provincePicker.dataSource = self;
    [provincePicker setShowsSelectionIndicator:YES];
    provincePicker.tag = 1;
    [provincePicker selectRow:0 inComponent:0 animated:YES];
    
    statusPicker = [[UIPickerView alloc]init];
    statusPicker.delegate = self;
    statusPicker.dataSource = self;
    [statusPicker setShowsSelectionIndicator:YES];
    statusPicker.tag = 2;
    [statusPicker selectRow:0 inComponent:0 animated:YES];
    
    provinceField.inputView = provincePicker;
    statusField.inputView = statusPicker;
    
    [self loadList];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = myScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = myScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    myPage.currentPage = page; // you need to have a **iVar** with getter for pageControl
}
/*
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    CGFloat pageWidth = myScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = myScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    for (UIView *v in myScroll.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            return v;
        }
    }
    return nil;
}
*/
- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@carDetailService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"Detail",
                                 @"CarID":carID};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"DetailJSON %@",responseObject);
         listJSON = [responseObject objectForKey:@"data"];
         
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             
             NSDictionary *detailArray = [listJSON objectAtIndex:0];
             
             picArray = [detailArray objectForKey:@"picture"];
             for (UIView *v in myScroll.subviews) {
                 if ([v isKindOfClass:[UIImageView class]]) {
                     [v removeFromSuperview];
                 }
             }
             
             for (int i=0; i<[picArray count]; i++)
             {
                 UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(myScroll.frame.size.width*i, 0, myScroll.frame.size.width, myScroll.frame.size.height)];
                 
                 [imgView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:i] objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                 imgView.tag = i;
                 imgView.contentMode = UIViewContentModeScaleAspectFit;
                 
                 UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
                 singleTap.numberOfTapsRequired = 1;
                 [imgView setUserInteractionEnabled:YES];
                 [imgView addGestureRecognizer:singleTap];
                 
                 [myScroll addSubview:imgView];
             }
             picNumber = [picArray count];
             myPage.numberOfPages = [picArray count];
             
             plateField.text = [detailArray objectForKey:@"LicensePlateNo"];
             speedField.text = [NSString stringWithFormat:@"%@ km/h",[detailArray objectForKey:@"Speed"]];
             dateField.text = [detailArray objectForKey:@"date"];
             timeField.text = [detailArray objectForKey:@"time"];
             provinceField.text = [detailArray objectForKey:@"province"];
             
             for (int i=0; i<[sharedManager.provinceJSON count]; i++)
             {
                 NSString *province = [[sharedManager.provinceJSON objectAtIndex:i] objectForKey:@"provincename"];
                 if ([province rangeOfString:provinceField.text].location != NSNotFound) {
                     [provincePicker selectRow:i inComponent:0 animated:YES];
                 }
             }
             
             statusID = [detailArray objectForKey:@"approve_status"];
             
             if ([[detailArray objectForKey:@"approve_status"] isEqualToString:@"1"]) {
                 statusField.text = @"อนุมัติ";
                 statusField.textColor = [UIColor colorWithRed:25.0/255 green:201.0/255 blue:25.0/255 alpha:1.0];
                 [statusPicker selectRow:1 inComponent:0 animated:YES];
             }
             else if ([[detailArray objectForKey:@"approve_status"] isEqualToString:@"2"]) {
                 statusField.text = @"ไม่อนุมัติ";
                 statusField.textColor = [UIColor colorWithRed:234.0/255 green:26.0/255 blue:26.0/255 alpha:1.0];
                 [statusPicker selectRow:2 inComponent:0 animated:YES];
             }
             else{
                 statusField.text = @"รอตรวจสอบ";
                 statusField.textColor = [UIColor colorWithRed:218.0/255 green:190.0/255 blue:0.0/255 alpha:1.0];
                 [statusPicker selectRow:0 inComponent:0 animated:YES];
             }
             
             
             if ([[detailArray objectForKey:@"approve_by_name"] isEqualToString:@"-"]) {
                 approveLabel.text = @"";
             }
             else
             {
                 NSString *approveStr = [NSString stringWithFormat:@"Approve by %@ %@  %@ %@",[detailArray objectForKey:@"approve_by_name"],[detailArray objectForKey:@"approve_by_lastname"],[detailArray objectForKey:@"approve_date"],[detailArray objectForKey:@"approve_time"]];
                 approveLabel.text = approveStr;
             }
         }
         else{
             [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาลองใหม่อีกครั้งในภายหลัง"];
         }
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
         [SVProgressHUD dismiss];
     }];
}

- (void)tapDetected:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view; //cast pointer to the derived class if needed
    //NSLog(@"single Tap on imageview %ld",(long)view.tag);
    
    CarZoom *cz = [self.storyboard instantiateViewControllerWithIdentifier:@"CarZoom"];
    cz.picURL = [[picArray objectAtIndex:view.tag] objectForKey:@"picture"];
    [self.navigationController pushViewController:cz animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Start");
    
    if (textField.tag == 99) {
        if ([textField.text isEqualToString:@"-"]) {
            plateField.text = @"";
        }
        else{
            //priceField.text = [textField.text stringByReplacingOccurrencesOfString:@" บาท" withString:@""];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"End");
    
    if (textField.tag == 99) {
        if ([textField.text isEqualToString:@""]) {
            plateField.text = @"-";
        }
        else{
            //priceField.text = [textField.text stringByReplacingOccurrencesOfString:@" บาท" withString:@""];
        }
    }
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    switch (pickerView.tag) {
            
        case 1://Province
            rowNum = [sharedManager.provinceJSON count];
            break;
            
        case 2://Status
            rowNum = [statusArray count];
            break;
            
        default:
            break;
    }
    
    return rowNum;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    
    switch (pickerView.tag) {
            
        case 1://Province
            rowTitle = [[sharedManager.provinceJSON objectAtIndex:row] objectForKey:@"provincename"];
            break;
            
        case 2://Status
            rowTitle = [statusArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
    
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
            
        case 1://Province
            provinceField.text = [[sharedManager.provinceJSON objectAtIndex:row] objectForKey:@"provincename"];
            break;
            
        case 2://Status
            statusField.text = [statusArray objectAtIndex:row];
            statusID = [NSString stringWithFormat:@"%ld",(long)row];
            
            if ([statusID isEqualToString:@"1"]) {
                statusField.textColor = [UIColor colorWithRed:25.0/255 green:201.0/255 blue:25.0/255 alpha:1.0];
            }
            else if ([statusID isEqualToString:@"2"]) {
                statusField.textColor = [UIColor colorWithRed:234.0/255 green:26.0/255 blue:26.0/255 alpha:1.0];
            }
            else{
                statusField.textColor = [UIColor colorWithRed:218.0/255 green:190.0/255 blue:0.0/255 alpha:1.0];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)provinceClick:(id)sender
{
    [provinceField becomeFirstResponder];
}

- (IBAction)statusClick:(id)sender
{
    [statusField becomeFirstResponder];
}

- (IBAction)submit:(id)sender
{
    NSLog(@"SUBMIT Car ID:%@\n Status:%@\n By:%@\n Province:%@\n Plate:%@",carID,statusID,sharedManager.memberID,provinceField.text,plateField.text);
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@carApproveService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"Approve",
                                 @"CarID":carID,
                                 @"Status":statusID,
                                 @"Approve_by":sharedManager.memberID,
                                 @"province":provinceField.text,
                                 @"LicensePlateNo":plateField.text,
                                 };
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"SubmitJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:@"บันทึกข้อมูลเรียบร้อย"];//[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             
             if ([statusID isEqualToString:@"1"])
             {
                 rightBtn.hidden = NO;
             }
             else{
                 rightBtn.hidden = YES;
             }
             
             //NSLog(@"ALL PAGE %@",sharedManager.mainCarbon.viewControllers);
             for (int i=0; i<[sharedManager.mainCarbon.viewControllers count]; i++)
             {
                 NSNumber *pageNo = @(i);
                 NSLog(@"Reload %@",pageNo);
                 CarList *cl = (CarList*)[sharedManager.mainCarbon.viewControllers objectForKey:pageNo];
                 [cl loadList:NO];
             }
         }
         else{
             [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาลองใหม่อีกครั้งในภายหลัง"];
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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)print:(id)sender
{
    Web *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
    wb.webURL = [NSString stringWithFormat:@"http://www.tmadigital.com/lpr/index.php?pdf/ticket/detail/%@",carID];
    [self.navigationController pushViewController:wb animated:YES];
    
    //[self printPdf:[NSString stringWithFormat:@"http://www.tmadigital.com/lpr/index.php?pdf/ticket/detail/%@",carID]];
    
    //[self printPdf:@"http://www.pdf995.com/samples/pdf.pdf"];
    //[self printPdf:[NSString stringWithFormat:@"http://www.tmadigital.com/lpr/uploads/pdf_gen/%@_ticket.pdf",carID]];
}

- (void) printPdf:(NSString *)path
{
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    //NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    //if (printController && [UIPrintInteractionController canPrintData:myData])
    //{
    printController.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [path lastPathComponent];
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    printController.printingItem = myData;
    void ( ^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController * printController, BOOL completed, NSError * error) {
        if (!completed && error)
        {
            NSLog (@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
        }
    };
    [printController presentAnimated:YES completionHandler:completionHandler];
    //}
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
