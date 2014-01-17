//
//  PinterestView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/4/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "PinterestView.h"
#import "Constants.h"
@implementation PinterestView
@synthesize webView,titleLabel,leftArrowButton,rightArrowButton,showURL,loading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"PinterestView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
    }
    titleLabel.font=[UIFont fontWithName:FontLight size:20];
    titleLabel.textColor=kLightWhiteColor;
	loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loading.hidesWhenStopped = YES;
    loading.frame=CGRectMake(500, 270,40, 40);
    [self addSubview:loading];
	[loading startAnimating];
    webView.multipleTouchEnabled=YES;
	webView.scalesPageToFit=YES;
	webView.delegate=self;
    showURL=[NSURL URLWithString:@"http://pinterest.com/"];
    if(showURL != nil){
		myreq = [NSURLRequest requestWithURL:showURL];
		[webView loadRequest:myreq];
    } 
    return self;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[loading startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[loading stopAnimating];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
