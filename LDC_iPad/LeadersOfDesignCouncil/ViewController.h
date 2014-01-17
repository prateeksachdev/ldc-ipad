//
//  ViewController.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppBrowser.h"
#import <Social/Social.h>
@class SettingsView,AppDelegate,HomeViewController,UpdateDatabase,ShareView;
@interface ViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate>

{
    IBOutlet UILabel *memberLable;
    
    IBOutlet UIButton *abouttheLDC;
    
    IBOutlet UIButton *memberDirectory;
    
    IBOutlet UITextField *password;
    
    IBOutlet UIButton *requestPassword;
    
    IBOutlet UIView *requestPasswordView;
    
    IBOutlet UITextField *fullName;
    
    IBOutlet UITextField *emailAddress;
    
    IBOutlet UILabel *requestPasswordViewLable1;
    IBOutlet UILabel *requestPasswordViewLable2;

    IBOutlet UILabel *requestPasswordViewLable3;

    IBOutlet UILabel *requestPasswordViewLable4;

    IBOutlet UILabel *requestPasswordViewLable5;
    
    IBOutlet UILabel *requestPasswordViewLable6;

    SettingsView *settingView;
    
    SEL selectorSaveData;
    AppDelegate *appDelegate;
    InAppBrowser *inAppbrowserObj;
    HomeViewController *hmvcobj;
    UpdateDatabase *updatedata;;
    NSDictionary *responsedict;
    NSInteger numberOfAttempts;
    ShareView *shareViewObj;

}
@property (nonatomic,retain)NSURLConnection *urlConnection;
@property (nonatomic,retain)NSMutableData *urldata;
@property (nonatomic,retain)IBOutlet UIView *aboutRcView;
@property (nonatomic,retain)id delegate;
@property (nonatomic,assign)SEL selectorSaveData;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain)IBOutlet UIImageView *homeImageView;
//@property(nonatomic,retain)SLComposeViewController *fbController;

-(IBAction)go_Clicked:(id)sender;
-(IBAction)abouttheLDC_Clicked:(id)sender;
-(IBAction)memberDirectory_Clicked:(id)sender;
-(IBAction)requestPassword_Clicked:(id)sender;
-(IBAction)requestAccess_Clicked:(id)sender;
-(IBAction)aboutRCButtonAction:(id)sender;

//About Rounded Corners View
-(IBAction)faceButtonAction:(id)sender;
-(IBAction)twitterButtonAction:(id)sender;
-(IBAction)shareButtonAction:(id)sender;
-(IBAction)contactButtonAction:(id)sender;
-(IBAction)websiteButtonAction:(id)sender;
-(IBAction)closeButtonAction:(id)sender;

-(void)checkForUpdate;
-(void)cancelUpdate;
-(BOOL)isUpdateAvailable;
-(void)updateOrShowAlert;           //Added By Umesh to check if update is available while authenticating user

-(NSString*)documentCatchePath;

@end
