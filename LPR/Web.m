//
//  Web.m
//  LPR
//
//  Created by Firststep Consulting on 19/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Web.h"

@interface Web ()

@end

@implementation Web

@synthesize webURL,myWebView,leftBtn,rightBtn,headerTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:sharedManager.fontSize+2];
    
    myWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:webURL];
    //NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    
    myWebView.delegate = self;
    myWebView.scrollView.bounces = NO;
    requestURL = [[NSURLRequest alloc] initWithURL:url];
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    [myWebView loadRequest:requestURL];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    //https://github.com/SVProgressHUD/SVProgressHUD
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
    
    //[self createPDFfromUIView:myWebView saveToDocumentsWithFileName:@"Test"];
    [self printPdf:myWebView.request.URL.absoluteString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD showErrorWithStatus:@"Error Please check your internet connection"];
}

/*
- (void) createPDFfromUIView:(UIWebView *)aView saveToDocumentsWithFileName:(NSString *)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    //[pdfData writeToFile:documentDirectoryFilename atomically:YES];// if you want to store the file in document directory
    [self printPdf:documentDirectoryFilename]; //for printing PDF
}
*/

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
