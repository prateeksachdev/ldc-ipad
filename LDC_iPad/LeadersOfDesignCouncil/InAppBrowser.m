//
//  InAppBrowser.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "InAppBrowser.h"
#import "Constants.h"
@implementation InAppBrowser

@synthesize appWebView,titleLabel,leftArrowButton,rightArrowButton,showURL,loading;
@synthesize delegate,selectorScrollViewScrolling,selectorClose;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"InAppBrowser" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
    }
    self.titleLabel.font=[UIFont fontWithName:FontLight size:20];
    self.titleLabel.textColor=kLightWhiteColor;
	self.loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.loading.hidesWhenStopped = YES;
    //made the laoder to be in center by Umesh
//    loading.frame=CGRectMake(500, 270,40, 40);
    self.loading.center = self.appWebView.center;
    [self addSubview:self.loading];
	[self.loading startAnimating];
    self.appWebView.multipleTouchEnabled=YES;
	self.appWebView.scalesPageToFit=YES;
	self.appWebView.delegate=self;
    return self;
}

-(void)loadWebRequest
{
       if(showURL != nil)
    {
        myreq = [NSURLRequest requestWithURL:showURL];
        [self.appWebView loadRequest:myreq];
    }

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.loading startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[self.loading stopAnimating];
    if (self.appWebView.canGoBack==YES) {
        [self.leftArrowButton setImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
        
    }
    else{
        [self.leftArrowButton setImage:[UIImage imageNamed:@"leftArrow_1.png"] forState:UIControlStateNormal];
        
    }
    if (self.appWebView.canGoForward==YES) {
        [self.rightArrowButton setImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
        
    }
    else{
        [self.rightArrowButton setImage:[UIImage imageNamed:@"rightArrow_1.png"] forState:UIControlStateNormal];
        
    }

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"webView URL %@",webView.request);
//    NSLog(@"showURL URL %@",showURL);
//    NSLog(@"error %@",error.description);
//    NSLog(@"error %@",error.debugDescription);
//    NSLog(@"error %@",error.domain);
//    NSLog(@"error %@",error.userInfo);
//    NSLog(@"error %@",error.localizedDescription);
//     NSLog(@"error code %d",error.code);
    if (!(error.code == -999)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [self.loading stopAnimating];
//    [self backButtonAction:nil];
	if(error){
        //		[self alertMe:@"Network Unavailable"];
        //        [loading stopAnimating];
    }
}
-(void)alertMe:(NSString *)customMessage{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:customMessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

-(IBAction)backButtonAction:(id)sender
{
    [self.appWebView stopLoading];
    if ([delegate respondsToSelector:selectorScrollViewScrolling]) {
        
        [delegate performSelector:selectorScrollViewScrolling withObject:nil afterDelay:0.0];
    }
    
    if ([delegate respondsToSelector:selectorClose]) {
        [delegate performSelector:selectorClose withObject:nil afterDelay:0.0];
    }

  //  [self removeFromSuperview];
    
    [self fadeView:self fadein:NO timeAnimation:0.3];

}
-(IBAction)leftArrowButtonAction:(id)sender{
    [self.appWebView goBack];
   
}
-(IBAction)rightArrowButtonAction:(id)sender{
    [self.appWebView goForward];

}
-(IBAction)shareButtonAction:(id)sender
{
 //this is to show the same link in safari. :)
    if (showURL) {
        [[UIApplication sharedApplication] openURL:showURL];
    }
}
-(IBAction)refreshAction:(id)sender{
    [self.appWebView reload];
}

-(void)fadeView:(UIView *)view fadein:(BOOL)fade timeAnimation:(NSTimeInterval)timeAnim
{
    
    if(fade){
        view.alpha = 0;
        
        [UIView animateWithDuration:timeAnim animations:^(void){
            view.alpha = 1;
        }completion:^(BOOL finished){
//            [self removeFromSuperview];
        }];
        
        
    }else {
        
        [UIView animateWithDuration:timeAnim animations:^(void){
             view.alpha = 0;
        }completion:^(BOOL finished){
            [view removeFromSuperview];
        }];

    }
    
}


@end
