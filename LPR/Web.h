//
//  Web.h
//  LPR
//
//  Created by Firststep Consulting on 19/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface Web : UIViewController <UIWebViewDelegate,UIPrintInteractionControllerDelegate>
{
    Singleton *sharedManager;
    
    NSURLRequest *requestURL;
}

@property (nonatomic) NSString *webURL;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightBtn;
@property (retain, nonatomic) IBOutlet UILabel *headerTitle;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end
