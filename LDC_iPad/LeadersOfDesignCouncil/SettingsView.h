//
//  SettingsView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/22/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppBrowser.h"
#import "SCGIFImageView.h"

@class DDProgressView;
@class SCGIFImageFrame,ShareView;
@interface SettingsView : UIView
{
    IBOutlet UILabel *topLabel;
    IBOutlet UIButton *logoutButton;
    IBOutlet UIButton *checkUpdateButton;
    
    IBOutlet UIView *aboutRoundedCornerView;
    IBOutlet UIButton *faceButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *contactButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *websiteButton;
    id delegate;
    SEL logoutAction;
    SEL selectordownload;
    SEL selectorToRemoveViewOnTouch;
    
    DDProgressView *progressView ;
    
    IBOutlet UIView *settingViewLogout;
    IBOutlet UIView *downloadingView;
 
    IBOutlet UIButton *cancelButton;
    IBOutlet UILabel *downloadLable;
    
    

    IBOutlet UIButton *retryButton;
    InAppBrowser *inAppbrowserObj;
    SCGIFImageView * gifImageView;
    ShareView *shareViewObj;
    IBOutlet UIImageView *backgroundImageView;
}

@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)ShareView *shareViewObj;;
@property(nonatomic,assign)SEL logoutAction;
@property(nonatomic,assign)SEL selectordownload;
@property(nonatomic,assign)SEL selectorUpdate;
@property(nonatomic,assign)SEL selectorToRemoveViewOnTouch;
@property(nonatomic,retain) IBOutlet UILabel *topLabel;
@property(nonatomic,retain) IBOutlet UIButton *logoutButton;
@property(nonatomic,retain) IBOutlet UIButton *checkUpdateButton;
@property(nonatomic,retain) IBOutlet UIView *settingBackgroundVIew;
@property(nonatomic,retain) IBOutlet UIView *settingViewLogout;
@property(nonatomic,retain) IBOutlet UIView *downloadingView;
@property(nonatomic,retain) DDProgressView *progressView;
@property(nonatomic,retain) IBOutlet UIButton *cancelButton;
@property(nonatomic,retain) IBOutlet UILabel *downloadLable;
@property(nonatomic,retain) IBOutlet UIButton *retryButton;
@property (nonatomic,retain) UIImageView *loadingImageView;
@property(nonatomic, retain)IBOutlet UIView *aboutRoundedCornerView;

@property (nonatomic,retain) SCGIFImageView * gifImageView;

-(IBAction)logoutButtonAction:(id)sender;
-(IBAction)checkupdate:(id)sender;
-(IBAction)aboutRCButtonAction:(id)sender;

//About Rounded Corners View
-(IBAction)faceButtonAction:(id)sender;
-(IBAction)twitterButtonAction:(id)sender;
-(IBAction)shareButtonAction:(id)sender;
-(IBAction)contactButtonAction:(id)sender;
-(IBAction)websiteButtonAction:(id)sender;
-(IBAction)closeButtonAction:(id)sender;

-(void)progress:(float)value;
-(void)removeprogress;

-(void)simulateCheckupdateClicked;
-(void)fadeView:(UIView *)view fadein:(BOOL)fade timeAnimation:(NSTimeInterval)timeAnim;
@end
