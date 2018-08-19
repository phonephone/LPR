//
//  CarDetail.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface CarDetail : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UIPrintInteractionControllerDelegate>
{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    NSMutableArray *picArray;
    
    long picNumber;
    
    UIPickerView *provincePicker;
    UIPickerView *statusPicker;
    
    NSString* statusID;
}

@property (nonatomic) NSString *carID;
@property (nonatomic) NSString *listStatus;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UILabel *headerTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPage;

@property (retain, nonatomic) IBOutlet UILabel *plateTitle;
@property (retain, nonatomic) IBOutlet UITextField *plateField;

@property (retain, nonatomic) IBOutlet UILabel *speedTitle;
@property (retain, nonatomic) IBOutlet UILabel *speedField;

@property (retain, nonatomic) IBOutlet UILabel *dateTitle;
@property (retain, nonatomic) IBOutlet UILabel *dateField;
@property (retain, nonatomic) IBOutlet UILabel *timeTitle;
@property (retain, nonatomic) IBOutlet UILabel *timeField;

@property (retain, nonatomic) IBOutlet UILabel *provinceTitle;
@property (retain, nonatomic) IBOutlet UITextField *provinceField;

@property (retain, nonatomic) IBOutlet UILabel *statusTitle;
@property (retain, nonatomic) IBOutlet UITextField *statusField;

@property (retain, nonatomic) IBOutlet UILabel *approveLabel;

@end
