//
//  Login.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface Login : UIViewController <UITextFieldDelegate>
{
    Singleton *sharedManager;
    NSMutableDictionary *loginJSON;
    
    BOOL firstRender;
}
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end
