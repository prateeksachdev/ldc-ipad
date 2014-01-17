//
//  SettingsView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/22/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "SettingsView.h"
#import "Constants.h"
#import "DDProgressView.h"
#import "Reachability.h"
#import "ShareView.h"
#import "SCGIFImageView.h"

@implementation SettingsView
@synthesize checkUpdateButton,logoutButton,topLabel,delegate,logoutAction,settingBackgroundVIew,settingViewLogout,downloadingView,selectordownload,progressView,cancelButton,downloadLable,loadingImageView,selectorUpdate,retryButton,gifImageView,selectorToRemoveViewOnTouch,shareViewObj,aboutRoundedCornerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:1];
        [self addSubview:viewObj];
    }
    self.logoutButton.titleLabel.font=[UIFont fontWithName:FontRegular size:30];
    [self.logoutButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    self.checkUpdateButton.titleLabel.font=[UIFont fontWithName:FontRegular size:30];
    [self.checkUpdateButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    self.topLabel.font=[UIFont fontWithName:FontRegular size:20];
    [self.topLabel setTextColor:kGrayColor];
    
    self.downloadLable.font=[UIFont fontWithName:FontRegular size:20];
    [self.downloadLable setTextColor:kGrayColor];

    cancelButton.titleLabel.font=[UIFont fontWithName:FontRegular size:30];
    [cancelButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    retryButton.titleLabel.font=[UIFont fontWithName:FontRegular size:30];
    [retryButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    faceButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
    [faceButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
    [shareButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
    twitterButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
    [twitterButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
    contactButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
    [contactButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
    websiteButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
    [websiteButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
    
//    aboutRoundedCornerView=[[UIView alloc]initWithFrame:CGRectMake(249, 299,526, 626)];
    //aboutRoundedCornerView.frame=CGRectMake(0, 0, 526, 626);
  
    
    UITapGestureRecognizer *singleTapObj = [[UITapGestureRecognizer alloc] initWithTarget:backgroundImageView action:@selector(removeSettingView)];
    [singleTapObj setNumberOfTapsRequired:1];
    return self;
}
-(void)removeSettingView{
//    NSLog(@"removeSettingView ");
//    NSLog(@"settingViewLogout : %@",settingViewLogout);
//    NSLog(@"self.settingViewLogout : %@",self.settingViewLogout);
//    NSLog(@"background Image %@",backgroundImageView);
}
-(IBAction)checkupdate:(id)sender{
 
    [checkUpdateButton setSelected:YES];
 
    Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];

    if ([checkUpdateButton.currentTitle isEqualToString:@"Check For Update"])
    {
        if (netStatus == NotReachable)
        {

            downloadLable.text=@"No Internet Connection";
            
            retryButton.hidden=FALSE;
            
            [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
            
            [cancelButton setTitle:@"OK" forState:UIControlStateNormal];
            

            downloadingView.hidden=FALSE;
            settingViewLogout.hidden=TRUE;

        }
        else
        {
            
        retryButton.hidden=TRUE;

            
        if (!gifImageView)
        {
            
            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"loadbar.gif" ofType:nil];
            NSData* imageData = [NSData dataWithContentsOfFile:filePath];
            
            gifImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(20.0f,89.0f,300,45.0f)];
          
            [gifImageView setData:imageData];
            
            //[self.view addSubview:gifImageView];
//            [downloadingView addSubview:gifImageView];
            loadingImageView=[[UIImageView alloc]initWithFrame: CGRectMake(20.0f,89.0f,300,45.0f)];
          //  [loadingImageView setImage:[UIImage imageNamed:@"loadbar.gif"]];
           
            
            [loadingImageView setAnimationImages:[NSArray arrayWithObject:[UIImage imageNamed:@"loadbar.gif"]]];
            [loadingImageView setAnimationDuration:1.0f];
            loadingImageView.animationRepeatCount = 0;

            [loadingImageView startAnimating];

            [loadingImageView setBackgroundColor:[UIColor clearColor]];
        }
            
        [checkUpdateButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];

        topLabel.text=@"Checking for updates";
        downloadLable.text=@"Checking for updates...";
        downloadingView.hidden=FALSE;
        settingViewLogout.hidden=TRUE;
        retryButton.hidden=TRUE;

        if (progressView) {
        
            progressView=nil;
        }
        progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(20.0f,89.0f,300,45.0f)] ;

        [progressView setOuterColor: [UIColor colorWithRed:73.0/255.0 green:73.0/255.0  blue:73.0/255.0  alpha:1.0]] ;
        [progressView setInnerColor: [UIColor colorWithRed:25.0/255.0 green:172.0/255.0  blue:205.0/255.0  alpha:1.0]] ;
        [progressView setEmptyColor: [UIColor colorWithRed:73.0/255.0 green:73.0/255.0  blue:73.0/255.0  alpha:1.0]] ;
        [downloadingView addSubview: progressView];
        [downloadingView addSubview:gifImageView];
            
        if ([delegate respondsToSelector:selectordownload]) {
            [delegate performSelector:selectordownload withObject:nil afterDelay:0.0];
        }
            
            if([[retryButton currentTitle] isEqualToString:@"Download"])
            {
                if ([delegate respondsToSelector:@selector(downloadUpdate)]) {
                    
                    [delegate performSelector:@selector(downloadUpdate)];
                }

            }
            else {
                
           if ([delegate respondsToSelector:selectorUpdate]) {
                [delegate performSelector:selectorUpdate withObject:self afterDelay:0.0];
            }
            }
        return;
        }
    }
    
    else {
        
        if ([cancelButton.currentTitle isEqualToString:@"Cancel"]) {
            
            
            [self removeFromSuperview];
            
            return;
        }
        if ([cancelButton.currentTitle isEqualToString:@"OK"]) {
            
            
            [self removeFromSuperview];
            
            
            return;
        }

    }
    
    if ([checkUpdateButton.currentTitle isEqualToString:@"Cancel"]) {
        
        [checkUpdateButton setTitle:@"Cancel" forState:UIControlStateNormal];
        topLabel.text=@"Checking for updates";
        
        return;
    }

}

-(void)simulateCheckupdateClicked{
    [checkUpdateButton setSelected:YES];
    
    Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
    
    if ([checkUpdateButton.currentTitle isEqualToString:@"Check For Update"])
    {
        if (netStatus == NotReachable)
        {
            
            downloadLable.text=@"No Internet Connection";
            
            retryButton.hidden=FALSE;
            
            [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
            
            [cancelButton setTitle:@"OK" forState:UIControlStateNormal];
            
            
            downloadingView.hidden=FALSE;
            settingViewLogout.hidden=TRUE;
            
        }
        else
        {
            
            retryButton.hidden=TRUE;
            
            
            if (!gifImageView)
            {
                
                NSString* filePath = [[NSBundle mainBundle] pathForResource:@"loadbar.gif" ofType:nil];
                NSData* imageData = [NSData dataWithContentsOfFile:filePath];
                
                gifImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(20.0f,89.0f,300,45.0f)];
                
                [gifImageView setData:imageData];
                
                //[self.view addSubview:gifImageView];
                //            [downloadingView addSubview:gifImageView];
                loadingImageView=[[UIImageView alloc]initWithFrame: CGRectMake(20.0f,89.0f,300,45.0f)];
                //  [loadingImageView setImage:[UIImage imageNamed:@"loadbar.gif"]];
                
                
                [loadingImageView setAnimationImages:[NSArray arrayWithObject:[UIImage imageNamed:@"loadbar.gif"]]];
                [loadingImageView setAnimationDuration:1.0f];
                loadingImageView.animationRepeatCount = 0;
                
                [loadingImageView startAnimating];
                
                [loadingImageView setBackgroundColor:[UIColor clearColor]];
            }
            
            [checkUpdateButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            
            topLabel.text=@"Checking for updates";
            downloadLable.text=@"Checking for updates...";
            downloadingView.hidden=FALSE;
            settingViewLogout.hidden=TRUE;
            retryButton.hidden=TRUE;
            
            if (progressView) {
                
                progressView=nil;
            }
            progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(20.0f,89.0f,300,45.0f)] ;
            
            [progressView setOuterColor: [UIColor colorWithRed:73.0/255.0 green:73.0/255.0  blue:73.0/255.0  alpha:1.0]] ;
            [progressView setInnerColor: [UIColor colorWithRed:25.0/255.0 green:172.0/255.0  blue:205.0/255.0  alpha:1.0]] ;
            [progressView setEmptyColor: [UIColor colorWithRed:73.0/255.0 green:73.0/255.0  blue:73.0/255.0  alpha:1.0]] ;
            [downloadingView addSubview: progressView];
            [downloadingView addSubview:gifImageView];
            
            if ([delegate respondsToSelector:selectordownload]) {
                [delegate performSelector:selectordownload withObject:nil afterDelay:0.0];
            }
            
            if([[retryButton currentTitle] isEqualToString:@"Download"])
            {
                if ([delegate respondsToSelector:@selector(downloadUpdate)]) {
                    
                    [delegate performSelector:@selector(downloadUpdate)];
                }
                
            }
            else {
                
                if ([delegate respondsToSelector:selectorUpdate]) {
                    [delegate performSelector:selectorUpdate withObject:self afterDelay:0.0];
                }
            }
            return;
        }
    }
    
    else {
        
        if ([cancelButton.currentTitle isEqualToString:@"Cancel"]) {
            
            
            [self removeFromSuperview];
            
            return;
        }
        if ([cancelButton.currentTitle isEqualToString:@"OK"]) {
            
            
            [self removeFromSuperview];
            
            
            return;
        }
        
    }
    
    if ([checkUpdateButton.currentTitle isEqualToString:@"Cancel"]) {
        
        [checkUpdateButton setTitle:@"Cancel" forState:UIControlStateNormal];
        topLabel.text=@"Checking for updates";
        
        return;
    }
}

-(IBAction)retryButtonAction:(id)sender
{
    [self removeFromSuperview];

    if([[cancelButton currentTitle] isEqualToString:@"Cancel"])
    {
        if ([delegate respondsToSelector:@selector(cancelUpdate)]) {
            
            [delegate performSelector:@selector(cancelUpdate)];
        }
//
//        settingView.hidden=FALSE;
//        downloadingView.hidden=TRUE;
//
    }
//    else {
    settingViewLogout.hidden=FALSE;
    downloadingView.hidden=TRUE;
//    }
}

-(void)progress:(float)value
{
    [progressView setProgress:value];
}

-(void)removeprogress
{
    [progressView removeFromSuperview];
}

-(IBAction)logoutButtonAction:(id)sender{
//    [logoutButton setSelected:YES];
//    if ([logoutButton.currentTitle isEqualToString:@"Log Out"]) {
//        [logoutButton setTitle:@"Confirm" forState:UIControlStateNormal];
//        return;
//    }
//   else if ([logoutButton.currentTitle isEqualToString:@"Confirm"]) {
       if ([delegate respondsToSelector:logoutAction]) {
           [delegate performSelector:logoutAction withObject:@"LogOut" afterDelay:0.0];
       }
       return;

//    }

}

-(IBAction)aboutRCButtonAction:(id)sender
{
    
//    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil];
//    UIView *viewObj = [viewArray objectAtIndex:0];
//    aboutRoundedCornerView=viewObj;
    aboutRoundedCornerView.frame=CGRectMake(249,61, 526, 626);
    [self addSubview:aboutRoundedCornerView];
     
//    aboutRoundedCornerView=[[UIView alloc]initWithFrame:CGRectMake(249, 299,526, 626)];
//    [self addSubview:aboutRoundedCornerView];
}

//About Rounded Corners View
-(IBAction)faceButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.alpha=1.0;
    inAppbrowserObj.titleLabel.text=@"Facebook";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.showURL=[NSURL URLWithString:@"https://www.facebook.com/roundedcorners"];
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];

}
-(IBAction)twitterButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.alpha=1.0;
    inAppbrowserObj.titleLabel.text=@"Twitter";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.showURL=[NSURL URLWithString:@"https://twitter.com/rc_apps"];
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
}
-(IBAction)shareButtonAction:(id)sender{
//    NSLog(@"shareclicked");
    
    if (!shareViewObj) {
        shareViewObj=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, 1024,748)];
        [shareViewObj setSelectorFaceBookAction:@selector(shareFaceBook)];
        [shareViewObj setSelectorTwitterAction:@selector(shareTwitter)];
        [shareViewObj setSelectorEmailAction:@selector(shareEmail)];
    }
    shareViewObj.delegate=self;
    [self addSubview:shareViewObj];
    [self fadeView:shareViewObj fadein:YES timeAnimation:0.3];

}
-(void)shareFaceBook{
    if ([delegate respondsToSelector:@selector(shareFaceBookForRC)]) {
        [delegate performSelector:@selector(shareFaceBookForRC) withObject:nil afterDelay:0.0];
    }
    
}
-(void)shareTwitter{
    if ([delegate respondsToSelector:@selector(shareTwitterForRC)]) {
        [delegate performSelector:@selector(shareTwitterForRC) withObject:nil afterDelay:0.0];
    }
    
}
-(void)shareEmail{
    if ([delegate respondsToSelector:@selector(shareEmailForRC)]) {
        [delegate performSelector:@selector(shareEmailForRC) withObject:nil afterDelay:0.0];
    }
    
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = ([touches count] == 1 ? [touches anyObject] : nil);
//    if (touch.view==shareViewObj.shareBackgroundView)
//    {
//        [shareViewObj removeFromSuperview];
//    }
//    NSLog(@"settingViewLogout : %@",settingViewLogout);
//    NSLog(@"self.settingViewLogout : %@",self.settingViewLogout);
//    NSLog(@"background Image %@",backgroundImageView);
//    if ([delegate respondsToSelector:@selector(cancelUpdate)]) {
//        [delegate performSelector:@selector(cancelUpdate) withObject:nil afterDelay:0.0];
//    }
//}
-(void)fadeView:(UIView *)view fadein:(BOOL)fade timeAnimation:(NSTimeInterval)timeAnim
{
    
    if(fade){
        view.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:timeAnim];
        [UIView setAnimationDelegate:self];
        view.alpha =1;
        [UIView commitAnimations];
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:timeAnim];
        [UIView setAnimationDelegate:self];
        view.alpha = 0;
        [UIView commitAnimations];
    }
    
}
-(IBAction)contactButtonAction:(id)sender{
//    NSLog(@"contactclicked");
    if ([delegate respondsToSelector:@selector(contactButtonActionForRC)]) {
        [delegate performSelector:@selector(contactButtonActionForRC) withObject:nil afterDelay:0.0];
    }

}
-(IBAction)websiteButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.alpha=1.0;
    inAppbrowserObj.titleLabel.text=@"Rounded Corners";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.showURL=[NSURL URLWithString:@"https://www.roundedcorners.com"];
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
}
-(IBAction)closeButtonAction:(id)sender{
  
    [aboutRoundedCornerView removeFromSuperview];
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
