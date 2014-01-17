//
//  InAppBrowser.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppBrowser : UIView<UIWebViewDelegate>
{
    IBOutlet UIWebView *appWebView;
    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UILabel *titleLabel;
    NSURL *showURL;
    UIActivityIndicatorView *loading;
    NSURLRequest *myreq;

    SEL selectorScrollViewScrolling;
    SEL selectorClose;
}
@property(nonatomic,retain)IBOutlet UIWebView *appWebView;
@property(nonatomic,retain)IBOutlet UIButton *leftArrowButton;
@property(nonatomic,retain)IBOutlet UIButton *rightArrowButton;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)NSURL *showURL;
@property(nonatomic,retain)UIActivityIndicatorView *loading;
@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorScrollViewScrolling;
@property(nonatomic,assign)SEL selectorClose;

-(IBAction)backButtonAction:(id)sender;
-(IBAction)leftArrowButtonAction:(id)sender;
-(IBAction)rightArrowButtonAction:(id)sender;
-(IBAction)shareButtonAction:(id)sender;
-(IBAction)refreshAction:(id)sender;
-(void)alertMe:(NSString *)customMessage;
-(void)loadWebRequest;
@end
