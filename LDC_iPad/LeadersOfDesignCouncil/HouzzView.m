//
//  HouzzView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/1/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "HouzzView.h"
#import "Constants.h"
@implementation HouzzView
@synthesize webView,titleLabel,leftArrowButton,rightArrowButton,showURL,loading;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"HouzzView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
    }
    self.titleLabel.font=[UIFont fontWithName:FontLight size:20];
    self.titleLabel.textColor=kLightWhiteColor;
	self.loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.loading.hidesWhenStopped = YES;
    self.loading.frame=CGRectMake(500, 270,40, 40);
    [self addSubview:self.loading];
	[loading startAnimating];
    webView.multipleTouchEnabled=YES;
	webView.scalesPageToFit=YES;
	webView.delegate=self;
    showURL=[NSURL URLWithString:@"http://www.houzz.com"];
    if(showURL != nil){
		myreq = [NSURLRequest requestWithURL:showURL];
		[webView loadRequest:myreq];
    }
    return self;
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
	//	webURL.text = [[webView.request URL] absoluteString];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
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

-(IBAction)backButtonAction:(id)sender{
    [self removeFromSuperview];
}
-(IBAction)leftArrowButtonAction:(id)sender{
    
}
-(IBAction)rightArrowButtonAction:(id)sender{
    
}
-(IBAction)shareButtonAction:(id)sender
{
    
}
-(IBAction)refreshAction:(id)sender{
    
}


@end
