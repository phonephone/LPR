//
//  Login.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Login.h"
#import "Home.h"
#import "LeftMenu.h"

@interface Login ()

@end

@implementation Login

@synthesize headerLabel,emailField,passField,submitBtn,forgetBtn;

- (void)viewDidLayoutSubviews
{
    if (!firstRender) {
        [self addbottomBorder:emailField withColor:nil];
        [self addbottomBorder:passField withColor:nil];
        firstRender = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    headerLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+10];
    emailField.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1];
    passField.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+3];
    forgetBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize];
    
    //emailField.text = @"sommai@gmail.com";
    //passField.text = @"1111";
}

- (IBAction)loginClick:(id)sender
{
    if ([emailField.text length] < 1||[passField.text length] < 1)
    {
        [self alertTitle:@"ข้อมูลไม่ถูกต้อง" detail:@"กรุณากรอกข้อมูลให้ครบถ้วน"];
    }
    else{
        [self loadLogin];
    }
}

- (void)loadLogin
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@loginService.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"Login",@"email":emailField.text,@"password":passField.text};

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LoginJSON %@",responseObject);
         loginJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
         
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
             sharedManager.memberID = [loginJSON objectForKey:@"user_id"];
             [self loginSuccess];
         }
         else{
             [self alertTitle:@"ไม่สามารถเข้าได้" detail:@"กรุณาตรวจสอบ e-mail และ password ให้ถูกต้อง"];
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

- (void)loginSuccess
{
        sharedManager.loginStatus = YES;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:sharedManager.loginStatus forKey:@"loginStatus"];
        [ud setObject:sharedManager.memberID forKey:@"memberID"];
        [ud synchronize];
        
        LeftMenu *lm = (LeftMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
        [lm loadProfile];
        
        UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"Navi"];
        [self.menuContainerViewController setCenterViewController:navi];
}

- (IBAction)forgetClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ลืมรหัสผ่าน" message:@"กรุณากรอกอีเมลที่คุณได้ลงทะเบียนไว้" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleFont = [[NSMutableAttributedString alloc] initWithString:@"ลืมรหัสผ่าน"];
    NSMutableAttributedString *messageFont = [[NSMutableAttributedString alloc] initWithString:@"กรุณากรอกอีเมลที่คุณได้ลงทะเบียนไว้"];
    [titleFont addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+1]
                      range:NSMakeRange (0, titleFont.length)];
    [messageFont addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize-2]
                        range:NSMakeRange(0, messageFont.length)];
    [alertController setValue:titleFont forKey:@"attributedTitle"];
    [alertController setValue:messageFont forKey:@"attributedMessage"];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"กรอกอีเมลของคุณ";
        textField.font = [UIFont fontWithName:sharedManager.fontLight size:sharedManager.fontSize-2];
        //textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"User e-mail %@", [[alertController textFields][0] text]);
        //compare the current password and do action here
        [self loadForget:[[alertController textFields][0] text]];
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadForget:(NSString*)email
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@forgetPassword.php?",HOST_DOMAIN];
    NSDictionary *parameters = @{@"service":@"Forget",@"email":email};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ForgetPass %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
         [SVProgressHUD dismiss];
     }];
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height + 1, textField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.4].CGColor;
    
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.font = [UIFont fontWithName:sharedManager.fontRegular size:sharedManager.fontSize+2];
    
    return textField;
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
