//
//  PinterestView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/4/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinterestView : UIView<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UILabel *titleLabel;
    NSURL *showURL;
    UIActivityIndicatorView *loading;
    NSURLRequest *myreq;
    
    
    
}
@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UIButton *leftArrowButton;
@property(nonatomic,retain)IBOutlet UIButton *rightArrowButton;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)NSURL *showURL;
@property(nonatomic,retain)UIActivityIndicatorView *loading;
-(IBAction)backButtonAction:(id)sender;
-(IBAction)leftArrowButtonAction:(id)sender;
-(IBAction)rightArrowButtonAction:(id)sender;
-(IBAction)shareButtonAction:(id)sender;
-(IBAction)refreshAction:(id)sender;
-(void)alertMe:(NSString *)customMessage;

@end
