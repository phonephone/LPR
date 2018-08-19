//
//  CarZoom.m
//  LPR
//
//  Created by Firststep Consulting on 19/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CarZoom.h"
#import "UIImageView+WebCache.h"

@interface CarZoom ()

@end

@implementation CarZoom

@synthesize picURL,leftBtn,rightBtn,headerTitle,myScroll;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+2];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, myScroll.frame.size.height)];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    //imgView.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:[NSURL URLWithString:picURL]]];
    imgView.tag = 123;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    myScroll.delegate = self;
    [myScroll addSubview:imgView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:123];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
