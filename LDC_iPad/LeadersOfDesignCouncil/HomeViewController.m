//
//  HomeView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "Social/Social.h"
#import "EventListView.h"
#import "LDCFavoritesView.h"
#import <MessageUI/MessageUI.h>
#import "FavoriteView.h"
#import "InAppBrowser.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import "FBHandler.h"
#import <Twitter/Twitter.h>
#import "UpdateDatabase.h"
#import "EmailLinks.h"
#import "ViewController.h"
#import "Reachability.h"
@interface HomeViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    
    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [membersselectedImageView setImage:[UIImage imageNamed:@""]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];

    homeButton.titleLabel.font=[UIFont fontWithName:FontLight size:20];
    membersButton.titleLabel.font=[UIFont fontWithName:FontLight size:20];
    eventsButton.titleLabel.font=[UIFont fontWithName:FontLight size:20];
    ldcFavoritesButton.titleLabel.font=[UIFont fontWithName:FontLight size:20];

    [homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    if (TopView) {
        
        TopView=nil;
    }
    
    TopView=[[UIView alloc]initWithFrame:CGRectMake(0,748, 1024,227)];
    
    TopView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:TopView];
    
    if (homeViewObj) {
        
        homeViewObj=nil;
    }

    //chagned by Umesh on 27 Feb 2013, set selector and allocated homeViewObj memory only when it is not available 
    homeViewObj=[[HomeView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    [homeViewObj setHomeView];
    [homeViewObj setDelegate:self];
    [homeViewObj setSelectorToBringToolBarInFront:@selector(bringToolBarToFront:)];
    [homeViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    [self.view addSubview:homeViewObj];
    
    [self getTempratureOfCity:homeViewObj];
    
    toolBarView.frame=CGRectMake(0, 663, 1024, 85);
    
    [self.view addSubview:toolBarView];
    bottomViewBackground = [[UIView alloc] initWithFrame:bottomViewFrameInvisibleMode];
    bottomViewBackground.backgroundColor = [UIColor blackColor];
    bottomViewBackground.alpha = 1;
    [self.view addSubview:bottomViewBackground];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults boolForKey:@"checkForUpdate"]) {
//        [self simulateSettingButtonClikced];
//    }
//    [defaults setBool:FALSE forKey:@"checkForUpdate"];
//    [defaults synchronize];
    
//    [settingViewObj simulateCheckupdateClicked];
}
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"checkForUpdate"]) {
        Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
        if (!(netStatus == NotReachable))
        {
            
            [self simulateSettingButtonClikced];
        }
        
        
        
    }
    [defaults setBool:FALSE forKey:@"checkForUpdate"];
    [defaults synchronize];
}
-(void)bringToolBarToFront:(NSString *)selectedView{
  
    
    //Changed by Umesh to fix issue form pivotal tracker to make selected category highlighted
    if ([selectedView isEqualToString:@"event"]) {
        [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [eventsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
        [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
        [membersselectedImageView setImage:[UIImage imageNamed:@""]];
        [eventsselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
        [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
        [settingselectedImageView setImage:[UIImage imageNamed:@""]];
    }
    else{
        
        [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [membersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        
        [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
        [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
        [membersselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
        [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
        [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
        [settingselectedImageView setImage:[UIImage imageNamed:@""]];
        
    }
    
    [homeViewObj bringSubviewToFront:toolBarView];
    
}

-(void)getTempratureOfCity :(HomeView*)homeviewobj
{
    NSUserDefaults *userDefaultObj = [NSUserDefaults standardUserDefaults];
//    NSLog(@"[userDefaultObj valueForKey:KeyWeatherAPICountry]:%@",[userDefaultObj valueForKey:KeyWeatherAPICountry]);
//     NSLog(@"[userDefaultObj valueForKey:KeyWeatherAPITimeZone]:%@",[userDefaultObj valueForKey:KeyWeatherAPITimeZone]);
//    NSLog(@"[userDefaultObj keycity]:%@",[userDefaultObj valueForKey:KeyWeatherAPICity]);

    Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
    }
    else{
        
        NSString *timeTest = [NSString stringWithFormat:@"City=%@&country=%@&timezone=%@",[userDefaultObj valueForKey:KeyWeatherAPICity],[userDefaultObj valueForKey:KeyWeatherAPICountry],[userDefaultObj valueForKey:KeyWeatherAPITimeZone]];
        //NSString *timeStamp=@"City=&Zipcode=";
        //    NSString *timeStamp=@"City=Berlin&Zipcode=10119";
        
        NSData *timeStampData = [timeTest dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.leadersofdesign.com/api.asmx/Weather"]];
        [request setValue:timeTest forHTTPHeaderField:@"json"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:timeStampData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSError *error1=nil;
             //         NSLog(@"data : %@",data);
             //return statement added by Umesh to stop the app from crashing if no responce is recieved.
             if (!data) {
//                 NSLog(@"nahi aaya>>>");
                 return;
             }
             NSDictionary* responseDictionary = [NSJSONSerialization
                                                 JSONObjectWithData:data options:kNilOptions error:&error1];
             
//             NSLog(@"error");
             
             //       NSDictionary* dict=[responseDictionary valueForKey:@"Weather"];
             
             if ([responseDictionary isEqual:[NSNull null]]) {
                 
             }
             else
             {
                 
                 NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                 NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-GB"];
                 dateFormatter.locale = enLocale;
                 
                 [dateFormatter setDateFormat:@"hh:mm a"];     //format changed from EEE, dd MMM yyyy hh:mm a zzz to
                 
                 NSDate *date=[dateFormatter dateFromString:[responseDictionary valueForKey:@"time"]];    //change from Datetime to time by Umesh
                 
                 NSTimeZone *pacificTime = [NSTimeZone timeZoneWithName:@"Europ/Berlin"];
                 
                 [dateFormatter setTimeZone:pacificTime];
                 [dateFormatter setDateFormat:@"hh:mm a"];
                 
                 NSString *strtime=[dateFormatter stringFromDate:date];
                 
                 float temp=[[responseDictionary valueForKey:@"temp"]floatValue];
                 //             float fahrenheitTemp=((temp*9/5)+32);
                 //             NSLog(@"temp:%f",fahrenheitTemp);
                 homeviewobj.theLDCLTemperatureLable.text=[NSString stringWithFormat:@"%.0f°F",temp];
                 homeviewobj.theLDCTimeLable.text=strtime;
             }
         }
         ];
    }
   
    
}

-(IBAction)setttingButtonAction:(id)sender
{
   
    TopView.frame=CGRectMake(0,748, 1024,227);

    
     if (settingViewObj) {
         [settingViewObj removeFromSuperview];
         settingViewObj=nil;
     }
    
        settingViewObj=[[SettingsView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
        [settingViewObj setDelegate:self];
        [settingViewObj setLogoutAction:@selector(logoutAction)];
        [settingViewObj setSelectorUpdate:@selector(UpdateDatabase:)];
    [settingViewObj setSelectorToRemoveViewOnTouch:@selector(removeSettingViewFromItsParentView)];
        [self.view addSubview:settingViewObj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
    [defaults synchronize];
}
-(void)removeSettingViewFromItsParentView{
//    NSLog(@"Aaya yaha pe");
}
-(void)simulateSettingButtonClikced{
    
    
    NSUserDefaults *defaultObj=[NSUserDefaults standardUserDefaults];
    
    
    NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",[defaultObj valueForKey:@"Synchdate"]];
    
    NSData *timeStampData = [timeStamp dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.leadersofdesign.com/api.asmx/CheckUpdate"]];
    [request setValue:timeStamp forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:timeStampData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError *error1;
         if (!data) {
//             NSLog(@"nahi aaya<<<");
             return;
         }
         NSDictionary *updateResponsedict = [NSJSONSerialization
                                       JSONObjectWithData:data options:kNilOptions error:&error1];
         
//         NSLog(@"responc=%@   %d",updateResponsedict,[updateResponsedict count]);
//         NSLog(@"status: %@",[updateResponsedict valueForKey:@"status"]);
         
         if (updateResponsedict) {
             if (![[updateResponsedict valueForKey:@"status"] isEqualToString:@"FALSE"]) {
                 TopView.frame=CGRectMake(0,748, 1024,227);
                 
                 
                 if (settingViewObj) {
                     [settingViewObj removeFromSuperview];
                     settingViewObj=nil;
                 }
                 
                 settingViewObj=[[SettingsView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
                 [settingViewObj setDelegate:self];
                 [settingViewObj setLogoutAction:@selector(logoutAction)];
                 [settingViewObj setSelectorUpdate:@selector(UpdateDatabase:)];
                 [settingViewObj simulateCheckupdateClicked];
                 [self.view addSubview:settingViewObj];
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setBool:FALSE forKey:@"checkForUpdate"];
                 [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
                 [defaults synchronize];
                 
             }
             
         }
         
     }
     
     ];
 
   
    
    
}
-(void)UpdateDatabase:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
    
    NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",[defaults valueForKey:@"Synchdate"]];
    
    NSData *timeStampData = [timeStamp dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.leadersofdesign.com/api.asmx/Pull"]];
    [request setValue:timeStamp forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:timeStampData];

      [NSURLConnection sendAsynchronousRequest:request
                                         queue:[NSOperationQueue currentQueue]
                             completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
       {
             NSError *error1;
           if (!data) {
//               NSLog(@"nahi aaya===");
               [settingViewObj.checkUpdateButton setTitle:@"Check For Update" forState:UIControlStateNormal];
               
               settingViewObj.downloadLable.text=@"No updates available";
               
               settingViewObj.retryButton.hidden=FALSE;
               
               [settingViewObj.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
               
               [settingViewObj.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
               
               settingViewObj.downloadingView.hidden=FALSE;
               settingViewObj.settingViewLogout.hidden=TRUE;
               
               [settingViewObj.gifImageView removeFromSuperview];
               [settingViewObj removeprogress];
               return;
           }
           responsedict = [NSJSONSerialization
                                        JSONObjectWithData:data options:kNilOptions error:&error1];
           
//           NSLog(@"responc=%@   %d",responsedict,[responsedict count]);
           
           if (responsedict) {
               
               
               if ([[responsedict valueForKey:@"Status"] isEqualToString:@"NO_NEW_UPDATE"])
               {
                
                [settingViewObj.checkUpdateButton setTitle:@"Check For Update" forState:UIControlStateNormal];

                  settingViewObj.downloadLable.text=@"No updates available";
                   
                   settingViewObj.retryButton.hidden=FALSE;
                   
                   [settingViewObj.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
                   
                   [settingViewObj.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
                   
                   settingViewObj.downloadingView.hidden=FALSE;
                   settingViewObj.settingViewLogout.hidden=TRUE;

                   [settingViewObj.gifImageView removeFromSuperview];
                   [settingViewObj removeprogress];

               }
               else if ([[responsedict valueForKey:@"Status"] isEqualToString:@"OK"])
               {
                
                   [settingViewObj.checkUpdateButton setTitle:@"Check For Update" forState:UIControlStateNormal];

                   
                   settingViewObj.downloadLable.text=@"There is an update available.";
                   
                   settingViewObj.retryButton.hidden=FALSE;
                   
                   [settingViewObj.retryButton setTitle:@"Download" forState:UIControlStateNormal];
                   
                   [settingViewObj.cancelButton setTitle:@"Later" forState:UIControlStateNormal];
                   
                   settingViewObj.downloadingView.hidden=FALSE;
                   settingViewObj.settingViewLogout.hidden=TRUE;
                   
                   [settingViewObj.gifImageView removeFromSuperview];
                   [settingViewObj removeprogress];

               }
               else
               {
                   
               }
           }
           
//             [self addData:responseDictionary];
//             [self addAboutUs:responseDictionary];
    
//           if ([delegate respondsToSelector:selectorSaveData]) {
//    
//               [delegate performSelector:selectorSaveData withObject:data afterDelay:0.0];
//           }
           
       }
       ];

}

-(void)downloadUpdate
{
    if (updatedata) {
        updatedata = nil;
    }
    updatedata=[UpdateDatabase initObject];
     updatedata.responceDict=responsedict;
     [updatedata addFiles:settingViewObj];
   
//      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//      [defaults setObject:[responsedict valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
//     [[NSUserDefaults standardUserDefaults] synchronize];

}
-(void)cancelUpdate{
    [updatedata cancelUpdate];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = ([touches count] == 1 ? [touches anyObject] : nil);
    
    if ((touch.view==settingViewObj.settingBackgroundVIew) || (touch.view==settingViewObj.shareViewObj.shareBackgroundView))
    {
        if ([settingViewObj.aboutRoundedCornerView superview]) {
//            NSLog(@"Do naothing");
            if (touch.view==settingViewObj.shareViewObj.shareBackgroundView)
            {
                [settingViewObj.shareViewObj removeFromSuperview];
            }
            return;
        }
        if (touch.view==settingViewObj.shareViewObj.shareBackgroundView)
        {
            [settingViewObj.shareViewObj removeFromSuperview];
        }
        else{
            if ([settingViewObj.downloadLable.text isEqualToString:@"Downloading Updates..."]) {
//                NSLog(@"do not do anything");
            }
            else{
                [settingViewObj removeFromSuperview];
            }
        }
        
    }
    else if (touch.view==TopView)
    {
        [UIView animateWithDuration:0.3f animations:^
         {
             bottomViewBackground.frame = CGRectMake(0,748, 1024, 437);
             [memberCatalogViewObj setFrame:CGRectMake(0,748, 1024, 317)];
             ldcFavoritesViewObj.frame=CGRectMake(0.0,748.0,1024.0,437.0);
             eventListViewObj.frame=CGRectMake(0, 748, 1024, 437);
             toolBarView.frame=CGRectMake(0, 663, 1024, 85);
             
         } completion:^(BOOL finished)
         {
             
             if (finished)
             {
                 TopView.frame=CGRectMake(0,748, 1024,227);
               
                 [bottomViewBackground removeFromSuperview];
                 [memberCatalogViewObj removeFromSuperview];
                 [ldcFavoritesViewObj removeFromSuperview];
                 [eventListViewObj removeFromSuperview];
                 bottomViewBackground=nil;
                 ldcFavoritesViewObj=nil;
                 eventListViewObj=nil;

                 toolBarView.frame=CGRectMake(0, 663, 1024, 85);
                 homeViewObj.userInteractionEnabled=YES;

             }
         }];

    }
    
    
}


-(void)logoutAction{
    
    
   // ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];

//    [appDelegate.navigationController pushViewController:appDelegate.viewController animated:YES];
    appDelegate.navigationController=[[UINavigationController alloc]initWithRootViewController:appDelegate.viewController];
    appDelegate.navigationController.navigationBarHidden=YES;
    appDelegate.window.rootViewController=appDelegate.navigationController;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"loginStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];

//    [[self navigationController]popToRootViewControllerAnimated:YES];
}
-(void)twitterButtonAction:(NSString *)str{
     if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
         if ([TWTweetComposeViewController canSendTweet])
         {
             TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
             [tweetSheet setInitialText:@"Check out this"];
             
             if (str)
            {
                [tweetSheet addImage:[UIImage imageWithContentsOfFile:str]];
            }
             [self presentModalViewController:tweetSheet animated:YES];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                 message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
         }

     }
     else{
    SLComposeViewController *twController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:str];
        }
        [twController setInitialText:@"Shared via the Leaders of Design Council"];
        [twController addImage:imageObj];
        //[twController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
        [twController setCompletionHandler:completionHandler];
        [self presentViewController:twController animated:YES completion:nil];
    }
     }
//}


-(void)twitterButtonActionForMember:(NSDictionary *)sharedDataDict{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"Shared by %@ via the Leaders of Design Council",[sharedDataDict valueForKey:@"memberName"]]];
            
            if ([sharedDataDict valueForKey:@"imageName"])
            {
                [tweetSheet addImage:[UIImage imageWithContentsOfFile:[sharedDataDict valueForKey:@"imageName"]]];
            }
            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    else{
        SLComposeViewController *twController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [twController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            UIImage *imageObj = [UIImage imageWithContentsOfFile:[sharedDataDict valueForKey:@"imageName"]];
            if (!imageObj) {
                imageObj = [UIImage imageNamed:[sharedDataDict valueForKey:@"imageName"]];
            }
            [twController setInitialText:[NSString stringWithFormat:@"Shared by %@ via the Leaders of Design Council",[sharedDataDict valueForKey:@"memberName"]]];
            [twController addImage:imageObj];
            //[twController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
            [twController setCompletionHandler:completionHandler];
            [self presentViewController:twController animated:YES completion:nil];
        }
    }
//}

-(void)facebookAction:(NSString *)str
{
     if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
    FBHandler *fb = [FBHandler sharedInstance];
    [fb controller:self AndMessage:str];
    [self.view addSubview:fb];
    }
    else{
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        [fbController setInitialText:@"Shared via the Leaders of Design Council"];
        UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:str];
        }
        [fbController addImage:imageObj];
        //[fbController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
    }

-(void)facebookActionForMembers:(NSDictionary *)sharedDataDict
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
        FBHandler *fb = [FBHandler sharedInstance];
        [fb controller:self AndMessage:[sharedDataDict valueForKey:@"imageName"]];
        [self.view addSubview:fb];
    }
    else{
        SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [fbController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            [fbController setInitialText:[NSString stringWithFormat:@"Shared by %@ via the Leaders of Design Council",[sharedDataDict valueForKey:@"memberName"]]];
            UIImage *imageObj = [UIImage imageWithContentsOfFile:[sharedDataDict valueForKey:@"imageName"]];
            if (!imageObj) {
                imageObj = [UIImage imageNamed:[sharedDataDict valueForKey:@"imageName"]];
            }
            [fbController addImage:imageObj];
            //[fbController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
            [fbController setCompletionHandler:completionHandler];
            [self presentViewController:fbController animated:YES completion:nil];
        }
    }
    
//}








-(void)shareFaceBookForRC{
    NSString *str = @"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog.";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
        FBHandler *fb = [FBHandler sharedInstance];
        [fb controller:self AndMessage:str];
        [self.view addSubview:fb];
    }
    else{
        SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [fbController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            [fbController setInitialText:str];
            //            UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
            //            if (!imageObj) {
            //                imageObj = [UIImage imageNamed:str];
            //            }
            //            [fbController addImage:imageObj];
            //[fbController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
            [fbController setCompletionHandler:completionHandler];
            [self presentViewController:fbController animated:YES completion:nil];
        }
    }
    
//}
-(void)shareTwitterForRC{
    NSString *str = @"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog @rc_apps";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]< 6.0) {
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:str];
            
            if (str)
            {
                [tweetSheet addImage:[UIImage imageWithContentsOfFile:str]];
            }
            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    else{
        SLComposeViewController *twController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [twController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            [twController setInitialText:str];
            //            [twController addImage:imageObj];
            //[twController addURL:[NSURL URLWithString:@"http://www.mocha.co/"]];
            [twController setCompletionHandler:completionHandler];
            [self presentViewController:twController animated:YES completion:nil];
        }
    }
    
-(void)shareEmailForRC{
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray array]];
    [mailComposer setSubject:@"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog."];
    
    // Use the document file name for the subject
    // [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[emailIDArray objectAtIndex:0]] mimeType:@".png" fileName:@"ShareImage"];
    
    
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring = @"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog.\n\n\n--\n\n\nRounded Corners is proud to have built the Leaders of Design Council iPhone and iPad apps.  We are an app-building platform that allows companies create and distribute apps faster and more easily than ever before. We specialize in well-designed catalog and portfolio apps.  Our mission is to build and distribute powerful apps that help brands enter a market where the norm is long and costly development.\n\nDiscover the power of the Rounded Corners app builder. Whether for your product line or portfolio, this is the only app creator designed for the luxury industry. This one-of-a-kind service allows you to personalize your app, upload your catalog and update your content quickly and easily.  Our catalog builder lets you create an elegant and accessible catalog of your products or projects.  Plus:  Instantly update your catalog when you have new products or collections.  The cost of distributing new product information to your clients through catalogs or sample books is virtually eliminated.\n\nWe also specialize in custom design work with Rounded Corners Bespoke.  That's what we did for the LDC. For custom design work or to interface with your existing platform, contact us.\n\nSent via the LDC iPhone App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
-(void)contactButtonActionForRC{
//    NSLog(@"contactclicked");
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray arrayWithObject:@"info@roundedcorners.com"]];
    [mailComposer setSubject:@""];
    
    // Use the document file name for the subject
    // [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[emailIDArray objectAtIndex:0]] mimeType:@".png" fileName:@"ShareImage"];
    
    
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    //    NSString *mailBOdySTring = @"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog.\n\n\n--\n\n\nRounded Corners is proud to have built the Leaders of Design Council iPhone and iPad apps.  We are an app-building platform that allows companies create and distribute apps faster and more easily than ever before. We specialize in well-designed catalog and portfolio apps.  Our mission is to build and distribute powerful apps that help brands enter a market where the norm is long and costly development.\n\nDiscover the power of the Rounded Corners app builder. Whether for your product line or portfolio, this is the only app creator designed for the luxury industry. This one-of-a-kind service allows you to personalize your app, upload your catalog and update your content quickly and easily.  Our catalog builder lets you create an elegant and accessible catalog of your products or projects.  Plus:  Instantly update your catalog when you have new products or collections.  The cost of distributing new product information to your clients through catalogs or sample books is virtually eliminated.\n\nWe also specialize in custom design work with Rounded Corners Bespoke.  That's what we did for the LDC. For custom design work or to interface with your existing platform, contact us.";
    //    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    [self presentViewController:mailComposer animated:YES completion:nil];
    
    
}





-(void)hideUnhideToolBarView:(NSString *)hideToolBarView{
    if ([hideToolBarView isEqualToString:@"True"]) {
        [self hideToolBarView];
    }
    else{
        [self showToolBarView];
    }
}
-(IBAction)aboutLdcButtonAction:(id)sender{
    
    isHomeClicked = TRUE;
    
    TopView.frame=CGRectMake(0,748, 1024,227);

    [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
    [membersselectedImageView setImage:[UIImage imageNamed:@""]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];
    [aboutLdcViewObj removeFromSuperview];
    
    if (!aboutLdcViewObj) {
        
        aboutLdcViewObj=[[AboutLDCView alloc]initWithFrame:CGRectMake(0,0, 1024, 748)];
        [aboutLdcViewObj setDelegate:self];
        [aboutLdcViewObj setSelectorFaceBookAction:@selector(facebookAction:)];
        [aboutLdcViewObj setSelectorTwitterAction:@selector(twitterButtonAction:)];
        [aboutLdcViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
        [aboutLdcViewObj setSelectorNewsLetterAction:@selector(newsLettersAction:)];
        [aboutLdcViewObj setSelectorFounderClicked:@selector(memberDetailButtonAction:)];
        [aboutLdcViewObj setSelectorShareEmailAction:@selector(showEmailPopOvew:)];
        [aboutLdcViewObj setSelectorShareImageViaEmailAction:@selector(ShareEmail:)];
    }
    [aboutLdcViewObj setAboutLDCView];
    aboutLdcViewObj.userInteractionEnabled=YES;
  //  toolBarView.frame=CGRectMake(0, 663, 1024, 85);
    bottomViewBackground.frame = bottomViewFrameInvisibleMode;
    
    
    [UIView animateWithDuration:0.3f animations:^
     {
         bottomViewBackground.frame = CGRectMake(0,748, 1024, 437);  //
         
         [memberCatalogViewObj setFrame:CGRectMake(0,748, 1024, 317)];
         ldcFavoritesViewObj.frame=CGRectMake(0.0,748.0,1024.0,437.0);
         eventListViewObj.frame=CGRectMake(0, 748, 1024, 437);
         
         toolBarView.frame=CGRectMake(0, 663, 1024, 85);
         
     } completion:^(BOOL finished)
     {
         
         if (finished) {

             if (homeViewObj)
             {
                 [homeViewObj removeFromSuperview];
                 homeViewObj=nil;
             }

    [memberCatalogViewObj removeFromSuperview];
    [memberBioViewObj removeFromSuperview];
    [memberBioViewListObj removeFromSuperview];
    [eventViewObj removeFromSuperview];
    [eventMainViewObj removeFromSuperview];
    [eventListViewObj removeFromSuperview];
    [ldcFavoritesViewObj removeFromSuperview];
    [settingViewObj removeFromSuperview];
    [self.view addSubview:aboutLdcViewObj];
    [self.view addSubview:toolBarView];
    [self fadeView:aboutLdcViewObj fadein:YES timeAnimation:0.3];
             
}
         
     }];
}

//-(void)sendEmail:(NSArray *)emialIdArray{
//    
//    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
//    [mailComposer setToRecipients:emialIdArray];
////    [mailComposer setSubject:[emailDetailsDict valueForKey:@"Subject"]]; // Use the document file name for the subject
//    
//    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
////    [mailComposer setMessageBody:[emailDetailsDict valueForKey:@"Body"] isHTML:FALSE];
//    
//    mailComposer.mailComposeDelegate = self; // Set the delegate
//    [self presentViewController:mailComposer animated:YES completion:nil];
//    
//}
-(void)newsLettersAction:(NSString *)str{
    
    if (!pdfReaderViewControllerObj) {
        pdfReaderViewControllerObj = [[PdfReaderViewController alloc] init];
    }
    if (!pdfReaderViewControllerNavObj) {
        pdfReaderViewControllerNavObj = [[UINavigationController alloc] initWithRootViewController:pdfReaderViewControllerObj];
    }
//    NSLog(@"[self navigationController] :%@",[self navigationController]);
//    pdfReaderViewControllerNavObj.view.frame = self.view.frame;
    pdfReaderViewControllerNavObj.view.backgroundColor = [UIColor redColor];
    pdfReaderViewControllerNavObj.navigationBarHidden = TRUE;
    
    [pdfReaderViewControllerObj setPdfFileName:str];
    [pdfReaderViewControllerObj setAddPreAndPostFix:false];      //Set this value as false if you the file in not in bundle or if you giving full path
    [pdfReaderViewControllerObj setDelegate:self];
    [pdfReaderViewControllerObj setSelectorToRemovePdfReaderView:@selector(removePdfReaderView)];
    [[self navigationController] pushViewController:pdfReaderViewControllerObj animated:NO];
//    [[self navigationController] presentModalViewController:[pdfReaderViewControllerNavObj.viewControllers objectAtIndex:0] animated:NO];
    pdfReaderViewControllerObj.view.frame = self.view.bounds;
//    [self.view addSubview:pdfReaderViewControllerNavObj.view];

}
-(void)removePdfReaderView{
    if (pdfReaderViewControllerNavObj) {
        [[self navigationController] popViewControllerAnimated:YES];
    }

    if ([pdfReaderViewControllerObj.view superview]) {
        [pdfReaderViewControllerObj.view removeFromSuperview];
    }
    if ([pdfReaderViewControllerNavObj.view superview]) {
        [pdfReaderViewControllerNavObj.view removeFromSuperview];
    }
    if (pdfReaderViewControllerNavObj) {
        pdfReaderViewControllerNavObj = nil;
    }
    if (pdfReaderViewControllerObj) {
        pdfReaderViewControllerObj = nil;
    }
}
-(IBAction)homeButtonAction:(id)sender{
    isHomeClicked = TRUE;
    
    TopView.frame=CGRectMake(0,748, 1024,227);

    [homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    
    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [membersselectedImageView setImage:[UIImage imageNamed:@""]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];

    
    if (!homeViewObj)
    {
        homeViewObj=[[HomeView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    }
//    [homeViewObj setHomeView];
    [homeViewObj setDelegate:self];
    [homeViewObj setSelectorToBringToolBarInFront:@selector(bringToolBarToFront:)];
    [homeViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
   // [self.view addSubview:homeViewObj];
    [self getTempratureOfCity:homeViewObj];
    homeViewObj.userInteractionEnabled=YES;
    
    

        [UIView animateWithDuration:0.3f animations:^
        {
            bottomViewBackground.frame = CGRectMake(0,748, 1024, 437);  //

            [memberCatalogViewObj setFrame:CGRectMake(0,748, 1024, 317)];
            ldcFavoritesViewObj.frame=CGRectMake(0.0,748.0,1024.0,437.0);
             eventListViewObj.frame=CGRectMake(0, 748, 1024, 437);

             toolBarView.frame=CGRectMake(0, 663, 1024, 85);
            
        } completion:^(BOOL finished)
         {
             
             if (finished) {
                                  
                
                 [homeViewObj removeAddedViews];
//                 [aboutLdcViewObj removeFromSuperview];
//                 [homeViewObj removeFromSuperview];
//                 [memberCatalogViewObj removeFromSuperview];
//                 [memberBioViewObj removeFromSuperview];
//                 [memberBioViewListObj removeFromSuperview];
//                 [eventViewObj removeFromSuperview];
//                 [eventMainViewObj removeFromSuperview];
//                 [eventListViewObj removeFromSuperview];
//                 [ldcFavoritesViewObj removeFromSuperview];
//                 [settingViewObj removeFromSuperview];
                 [self removeAllViews];
                 [homeViewObj setHomeView];

                 [self.view addSubview:homeViewObj];
                 [self.view addSubview:toolBarView];
                 [self fadeView:homeViewObj fadein:YES timeAnimation:0.3];

             }
             
         }];

    
    
}
//Added By Umesh 
-(void)removeAllViews{
    [aboutLdcViewObj removeFromSuperview];
    [homeViewObj removeFromSuperview];
    [memberCatalogViewObj removeFromSuperview];
    [memberBioViewObj removeFromSuperview];
    [memberBioViewListObj removeFromSuperview];
    [eventViewObj removeFromSuperview];
    [eventMainViewObj removeFromSuperview];
    [eventListViewObj removeFromSuperview];
    [ldcFavoritesViewObj removeFromSuperview];
    [settingViewObj removeFromSuperview];
    if ([memberBioViewListObj superview]) {
        [memberBioViewListObj removeFromSuperview];
    }
}

-(IBAction)membersButtonAction:(id)sender{
    isHomeClicked = FALSE;
  
    
    TopView.frame=CGRectMake(0,0, 1024, 227);
    
    [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [membersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    
    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
    [membersselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];

     if (memberCatalogViewObj) {
         [memberCatalogViewObj removeFromSuperview];
         memberCatalogViewObj=nil;
        
     }
    if (bottomViewBackground) {
       
        [bottomViewBackground removeFromSuperview];

        bottomViewBackground=nil;
    }
    
    // Changes made by sanat
    
        memberCatalogViewObj=[[MemberCatalogRegisterView alloc]initWithFrame:CGRectMake(0,748, 1024, 437)];
        memberCatalogViewObj.delegate=self;
        [memberCatalogViewObj setSelectorMemberCatalogAction:@selector(memberCatalogRegisterViewFrame:)];
        [memberCatalogViewObj setSelectorMemberCatalogDetailAction:@selector(memberDetailButtonAction:)];

    
      aboutLdcViewObj.userInteractionEnabled=NO;

      [eventListViewObj removeFromSuperview];
      [ldcFavoritesViewObj removeFromSuperview];

    bottomViewBackground = [[UIView alloc] initWithFrame:bottomViewFrameInvisibleMode];
    bottomViewBackground.backgroundColor = [UIColor blackColor];
    bottomViewBackground.alpha = 1;

    [self.view addSubview:bottomViewBackground];
    [self.view addSubview:memberCatalogViewObj];

    if (toolBarView.center.y==269.500000)
    {
    memberCatalogViewObj.frame=CGRectMake(0,311, 1024, 437);    
    bottomViewBackground.frame = bottomViewFrameVisibleMode;

    [self fadeView:memberCatalogViewObj fadein:YES timeAnimation:0.3];
    
    [self.view bringSubviewToFront:TopView];

    }
    else {
        
        [UIView animateWithDuration:0.3f animations:^
         {
             toolBarView.frame=CGRectMake(0, 227, 1024, 85);
             bottomViewBackground.frame = bottomViewFrameVisibleMode;
             memberCatalogViewObj.frame=CGRectMake(0,311, 1024, 437);
             
         } completion:^(BOOL finished)
         {
             
             if (finished)
             {
                 [self.view bringSubviewToFront:TopView];
                 
             }
         }];


    }

}

-(IBAction)eventButtonAction:(id)sender
{
    isHomeClicked = FALSE;
    TopView.frame=CGRectMake(0,0, 1024, 227);

    
    [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
    [membersselectedImageView setImage:[UIImage imageNamed:@""]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@""]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];

    if (eventListViewObj)
    {
        [eventListViewObj removeFromSuperview];
        [bottomViewBackground removeFromSuperview];

        eventListViewObj=nil;
    }
    
    eventListViewObj=[[EventListView alloc]initWithFrame:CGRectMake(0, 748, 1024, 437)];
    
    //homeViewObj.userInteractionEnabled=NO;
    aboutLdcViewObj.userInteractionEnabled=NO;
    eventListViewObj.delegate=self;
    
    
    [eventListViewObj setSelectoreventListAction:@selector(eventDetailButtonAction:)];
    [eventListViewObj setSelectorEventListSearchAction:@selector(eventViewFrame:)];

    if (bottomViewBackground) {
        
        [bottomViewBackground removeFromSuperview];
        
        bottomViewBackground=nil;
    }
    bottomViewBackground = [[UIView alloc] initWithFrame:bottomViewFrameInvisibleMode];
    bottomViewBackground.backgroundColor = [UIColor blackColor];
    bottomViewBackground.alpha = 1;
    [eventListViewObj removeFromSuperview];

    [memberCatalogViewObj removeFromSuperview];
   
    [ldcFavoritesViewObj removeFromSuperview];
  
    [self.view addSubview:bottomViewBackground];
    [self.view addSubview:eventListViewObj];

    if (toolBarView.center.y==269.500000) {
        
      eventListViewObj.frame=CGRectMake(0, 311, 1024, 437);
    bottomViewBackground.frame = bottomViewFrameVisibleMode;

     [self fadeView:eventListViewObj fadein:YES timeAnimation:0.3];

     [self.view bringSubviewToFront:TopView];
  
    }
    else {
                
        [UIView animateWithDuration:0.3f animations:^
         {
             toolBarView.frame=CGRectMake(0, 227, 1024, 85);
             bottomViewBackground.frame = bottomViewFrameVisibleMode;
             eventListViewObj.frame=CGRectMake(0, 311, 1024, 437);
             
         } completion:^(BOOL finished)
         {
             
             if (finished)
             {
                 [self.view bringSubviewToFront:TopView];
                 
             }
         }];

        
    }

}

-(IBAction)ldcFavoritesAction:(id)sender
{
    isHomeClicked = FALSE;
    TopView.frame=CGRectMake(0,0, 1024, 227);

    
    [homeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [membersButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventsButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [ldcFavoritesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [ledearsOfDesignselectedImageView setImage:[UIImage imageNamed:@""]];
    [lhomeselectedImageView setImage:[UIImage imageNamed:@""]];
    [membersselectedImageView setImage:[UIImage imageNamed:@""]];
    [eventsselectedImageView setImage:[UIImage imageNamed:@""]];
    [ldcFavoritesselectedImageView setImage:[UIImage imageNamed:@"tab_bar_on_bg.png"]];
    [settingselectedImageView setImage:[UIImage imageNamed:@""]];

    
    if (ldcFavoritesViewObj)
    {
        [ldcFavoritesViewObj removeFromSuperview];
        [bottomViewBackground removeFromSuperview];

        ldcFavoritesViewObj=nil;
    }
    
    ldcFavoritesViewObj=[[LDCFavoritesView alloc]initWithFrame:CGRectMake(0, 748, 1024, 437)];
 
    homeViewObj.userInteractionEnabled=NO;
    aboutLdcViewObj.userInteractionEnabled=NO;
    ldcFavoritesViewObj.delegate=self;
  
    [ldcFavoritesViewObj setSelectorFavSearch:@selector(favoriteViewFrame:)];
    
    [ldcFavoritesViewObj setSelectorFavDetail:@selector(favoritesDetailButtonAction:)];
    
    if (bottomViewBackground) {
        
        [bottomViewBackground removeFromSuperview];
        
        bottomViewBackground=nil;
    }
    bottomViewBackground = [[UIView alloc] initWithFrame:bottomViewFrameInvisibleMode];
    bottomViewBackground.backgroundColor = [UIColor blackColor];
    bottomViewBackground.alpha = 1;
    
    [memberBioViewObj removeFromSuperview];
    
    [eventViewObj removeFromSuperview];
    
    [memberCatalogViewObj removeFromSuperview];

    [eventListViewObj removeFromSuperview];
    
    [self.view addSubview:bottomViewBackground];
    [self.view addSubview:ldcFavoritesViewObj];
    
//    NSLog(@"%f",toolBarView.center.y);
    
    if (toolBarView.center.y==269.500000) {
        
        ldcFavoritesViewObj.frame=CGRectMake(0, 311, 1024, 437);
        bottomViewBackground.frame = bottomViewFrameVisibleMode;

        [self fadeView:ldcFavoritesViewObj fadein:YES timeAnimation:0.3];
        
        [self.view bringSubviewToFront:TopView];

    }
    
    else {
                
        [UIView animateWithDuration:0.3f animations:^
         {
             toolBarView.frame=CGRectMake(0, 227, 1024, 85);
             bottomViewBackground.frame = bottomViewFrameVisibleMode;
             ldcFavoritesViewObj.frame=CGRectMake(0, 311, 1024, 437);
             
         } completion:^(BOOL finished)
         {
             
             if (finished)
             {
                 [self.view bringSubviewToFront:TopView];
                 
             }
         }];

        
    }
    

}

// Changes made by sanat

-(void)memberDetailButtonAction:(id)sender
{
    
    TopView.frame=CGRectMake(0,748, 1024,227);
    MemberBioViewList *oldView = memberBioViewListObj;
    
    if (memberBioViewListObj)
    {
//        [memberBioViewListObj removeFromSuperview];
        memberBioViewListObj=nil;
    }
    
    memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    memberBioViewListObj.memberBioViewListScrollView.frame=CGRectMake(0, 0, 1024, 748);
    memberBioViewListObj.publicBackButton.hidden=TRUE;
    memberBioViewListObj.publicBarImageView.hidden=TRUE;

    [memberBioViewListObj setDelegate:self];        //Added By Umesh
    [memberBioViewListObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    [memberBioViewListObj setSelectorFacebookAction:@selector(facebookActionForMembers:)];
    [memberBioViewListObj setSelectorTwitterAction:@selector(twitterButtonActionForMember:)];
//    [memberBioViewListObj setSelectorMailAction:@selector()];
    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
   
    NSDictionary *dictionary=(NSMutableDictionary*)sender;
    
    MemberBioViewObj1.Status=YES;
    MemberBioViewObj2.Status=YES;

    NSArray *memberListArray=[dictionary valueForKey:@"Array"];
    
    MemberBioViewObj1.arraySave=memberListArray;
    MemberBioViewObj2.arraySave=memberListArray;

    
    UIButton *buttonTag=[dictionary valueForKey:@"membertag"];
    
    int selectIndex=buttonTag.tag;

    int widthCount=[memberListArray count];

    MemberBioViewObj1.closeButton.hidden=TRUE;
    MemberBioViewObj2.closeButton.hidden=TRUE;

    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj1 setSelectorShareGalleryImageEmailAction:@selector(shareEmailAction:)];
    [MemberBioViewObj1 setSelectorTwitterAction:@selector(twitterAction:)];
    [MemberBioViewObj1 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    [MemberBioViewObj1 setSelectorFacbookAction:@selector(facebookAction:)];
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj2 setSelectorShareGalleryImageEmailAction:@selector(shareEmailAction:)];
    [MemberBioViewObj2 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    [MemberBioViewObj2 setSelectorFacbookAction:@selector(facebookAction:)];
    [MemberBioViewObj2 setSelectorTwitterAction:@selector(twitterAction:)];

    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
     memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
        
    [memberBioViewListObj applyNewIndex:selectIndex totalCount:widthCount  pageController:MemberBioViewObj1];
    
    memberBioViewListObj.pageCount=[memberListArray count]-1;
    
    memberBioViewListObj.currentPage=MemberBioViewObj1;
    memberBioViewListObj.nextPage=MemberBioViewObj2;
    
    if (selectIndex+1 <[memberListArray count]) {
        

        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex+1 totalCount:widthCount pageController:MemberBioViewObj2];
        
        
    }
    else if (selectIndex-1 >=0)
    {
        
        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex-1 totalCount:widthCount pageController:MemberBioViewObj2];
        
    }
    
    CGRect frame = memberBioViewListObj.memberBioViewListScrollView.frame;
    frame.origin.x = frame.size.width *selectIndex;
    frame.origin.y = 0;
    //
    [memberBioViewListObj.memberBioViewListScrollView scrollRectToVisible:frame animated:NO];

    [UIView animateWithDuration:0.3f animations:^
     {
         bottomViewBackground.frame = CGRectMake(0,748, 1024, 437);  //
         [memberCatalogViewObj setFrame:CGRectMake(0,748, 1024, 317)];
         ldcFavoritesViewObj.frame=CGRectMake(0,748.0,1024.0,437.0);
         eventListViewObj.frame=CGRectMake(0, 748, 1024, 437);
         
         toolBarView.frame=CGRectMake(0, 663, 1024, 85);
         
     } completion:^(BOOL finished)
     {
         
         if (finished) {
             [memberCatalogViewObj removeFromSuperview];
             [memberCatalogViewObj removeFromSuperview];
             [bottomViewBackground removeFromSuperview];

             [self.view addSubview:memberBioViewListObj];
             
             [self.view addSubview:toolBarView];
             memberBioViewListObj.alpha = 0;
             [UIView animateWithDuration:0.3 animations:^{
                 memberBioViewListObj.alpha = 1;
             }completion:^(BOOL finished){
                 [oldView removeFromSuperview];
             }];
//             [self fadeView:memberBioViewListObj fadein:YES timeAnimation:0.3];
             

         }
     }];


}

-(void)eventDetailButtonAction:(id)sender
{
    TopView.frame=CGRectMake(0,748, 1024,227);

    EventMainView *oldEventDetailView = eventMainViewObj;
    if (eventMainViewObj) {
        eventMainViewObj=nil;
    }

    if (eventViewObj) {
        
        eventViewObj=nil;
    }
    
       
        eventViewObj=[[EventView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
 
        eventMainViewObj=[[EventMainView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    
    
    [eventMainViewObj setDelegate:self];        //Added By Umesh
    [eventMainViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    [eventMainViewObj setSelectorTwitterAction:@selector(twitterButtonAction:)];
    [eventMainViewObj setSelectorFacebookAction:@selector(facebookAction:)];
    [eventMainViewObj setSelectorMailAction:@selector(ShareEmail:)];
    [eventMainViewObj setSelectorRegisterForEventAction:@selector(registerForEvent:)];       //Added By Umesh
    
    EventView *eventViewObj1=[[EventView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    EventView *eventViewObj2=[[EventView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];

    eventViewObj1.delegate=eventMainViewObj;
    [eventViewObj1 setSelectorLeftEventAction:@selector(leftArrowAction:)];
    [eventViewObj1 setSelectorRightEventAction:@selector(rightArrowAction:)];
    [eventViewObj1 setSelectorScrollingEnable:@selector(scrollingEnable:)];
    [eventViewObj1 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    [eventViewObj1 setSelectorFaceBookAction:@selector(faceBookAction:)];
    [eventViewObj1 setSelectorTwitterAction:@selector(twitterAction:)];
    [eventViewObj1 setSelectorShareEmailAction:@selector(emailAction:)];
    [eventViewObj1 setSelectorRegisterForEventAction:@selector(registerForEvent:)];         //Added By Umesh
     eventViewObj2.delegate=eventMainViewObj;
    [eventViewObj2 setSelectorLeftEventAction:@selector(leftArrowAction:)];
    [eventViewObj2 setSelectorRightEventAction:@selector(rightArrowAction:)];
    [eventViewObj2 setSelectorScrollingEnable:@selector(scrollingEnable:)];
    [eventViewObj2 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    [eventViewObj2 setSelectorFaceBookAction:@selector(faceBookAction:)];
    [eventViewObj2 setSelectorTwitterAction:@selector(twitterAction:)];
    [eventViewObj2 setSelectorShareEmailAction:@selector(emailAction:)];
    [eventViewObj2 setSelectorRegisterForEventAction:@selector(registerForEvent:)];         //Added By Umesh

    NSDictionary *dictionary=(NSMutableDictionary*)sender;
    
    NSArray *eventListArray=[dictionary valueForKey:@"Array"];
    
    UIButton *eventButton=(UIButton*)[dictionary valueForKey:@"EventTag"];
    
    int widthCount=[eventListArray count];

    int selectedIndex=eventButton.tag;
    
    eventViewObj1.arraySave=eventListArray;
    eventViewObj2.arraySave=eventListArray;
    
    eventMainViewObj.currentPage=eventViewObj1;
    eventMainViewObj.nextPage=eventViewObj2;

    eventMainViewObj.eventMainViewScrollView.contentSize =CGSizeMake(
               eventMainViewObj.eventMainViewScrollView.frame.size.width * widthCount,
               eventMainViewObj.eventMainViewScrollView.frame.size.height);
	
    eventMainViewObj.eventMainViewScrollView.contentOffset = CGPointMake(0, 0);

    [eventMainViewObj.eventMainViewScrollView addSubview:eventViewObj1];    
    
    [eventMainViewObj applyNewIndex:selectedIndex totalCount:widthCount pageController:eventViewObj1];

    eventMainViewObj.pageCount=[eventListArray count]-1;
    
    if (selectedIndex+1 <[eventListArray count]) {
        
        [eventMainViewObj.eventMainViewScrollView addSubview:eventViewObj2];
        
        [eventMainViewObj applyNewIndex:selectedIndex+1 totalCount:widthCount pageController:eventViewObj2];
        
    }
    else if (selectedIndex-1 >=0)
    {
               
        [eventMainViewObj.eventMainViewScrollView addSubview:eventViewObj2];
        
        [eventMainViewObj applyNewIndex:selectedIndex-1 totalCount:widthCount pageController:eventViewObj2];
        
    }
    
    CGRect frame = eventMainViewObj.eventMainViewScrollView.frame;
    frame.origin.x = frame.size.width *selectedIndex;
    frame.origin.y = 0;
    
    [eventMainViewObj.eventMainViewScrollView scrollRectToVisible:frame animated:NO];

    [UIView animateWithDuration:0.3f animations:^
     {
         bottomViewBackground.frame = CGRectMake(0,748, 1024, 437);  //
         
         [memberCatalogViewObj setFrame:CGRectMake(0,748, 1024, 317)];
         ldcFavoritesViewObj.frame=CGRectMake(0.0,748.0,1024.0,437.0);
         eventListViewObj.frame=CGRectMake(0, 748, 1024, 437);
         
         toolBarView.frame=CGRectMake(0, 663, 1024, 85);
         
     } completion:^(BOOL finished)
     {
         
         if (finished)
         {
             
             [self.view addSubview:eventMainViewObj];
             [self.view addSubview:toolBarView];
             
              eventMainViewObj.alpha = 0;
             [UIView animateWithDuration:0.3 animations:^{
                 eventMainViewObj.alpha = 1;
             }completion:^(BOOL finished){
                 [oldEventDetailView removeFromSuperview];
             }];
             
//             [self fadeView:eventMainViewObj fadein:YES timeAnimation:0.3];
             
         }
     }];

}
-(void)registerForEvent:(NSDictionary *)emailDetailsDict{
//    NSLog(@"emailDetailsDict : %@",emailDetailsDict);
//    NSLog(@"registerForEvent?>>>>");
   
    
    NSArray *arrayOfEmailLinks=[[CoreDataOprations initObject]fetchRequestAccordingtoCategory:@"EmailLinks" :@"accessId" :@"type" :@"2" :appDelegate.managedObjectContext];
    
   if( [arrayOfEmailLinks count]!=0)
   {
    
    EmailLinks *emailLinksObj=[arrayOfEmailLinks objectAtIndex:0];
       
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray arrayWithObject:emailLinksObj.email]];
    [mailComposer setSubject:[emailDetailsDict valueForKey:@"Subject"]]; // Use the document file name for the subject
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    [mailComposer setMessageBody:[NSString stringWithFormat:@"%@\n\nSent via the LDC iPad App",[emailDetailsDict valueForKey:@"Body"]] isHTML:FALSE];
    
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
   }
   else {
     
       MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
       [mailComposer setToRecipients:[NSArray arrayWithObject:@"hello@leadersofdesign.com"]];
       [mailComposer setSubject:[emailDetailsDict valueForKey:@"Subject"]]; // Use the document file name for the subject
       
       mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
       mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
       [mailComposer setMessageBody:[NSString stringWithFormat:@"%@\n\nSent via the LDC iPad App",[emailDetailsDict valueForKey:@"Body"]] isHTML:FALSE];
       
       mailComposer.mailComposeDelegate = self; // Set the delegate
       [self presentViewController:mailComposer animated:YES completion:nil];

   }
}

-(void)favoritesDetailButtonAction:(id)sender
{
   // TopView.frame=CGRectMake(0,748, 1024,227);

   FavoriteView *favoriteViewObj=(FavoriteView*)sender;
   if (inAppBrowserObj)
   {
       inAppBrowserObj=nil;
    }
    if (favoriteViewObj.urlString) {
    inAppBrowserObj=[[InAppBrowser alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
  
    inAppBrowserObj.titleLabel.text=favoriteViewObj.titleString;
    if ([favoriteViewObj.urlString hasPrefix:@"http://"]) {
        inAppBrowserObj.showURL= [NSURL URLWithString:favoriteViewObj.urlString];
    } else {
        inAppBrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",favoriteViewObj.urlString]];
    }

    [inAppBrowserObj loadWebRequest];
    
    [self.view addSubview:inAppBrowserObj];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];

    }

   // NSLog(@"favourates=%@",favoriteViewObj.urlString);
}

// Changes made by sanat

-(void)memberCatalogRegisterViewFrame:(NSString *)string
{
    if (isHomeClicked) {
        return;
    }
    if ([string isEqualToString:@"YES"]) {
        [UIView animateWithDuration:0.3 animations:^(void){
            memberCatalogViewObj.frame=CGRectMake(0,84,1024,437);
            toolBarView.frame=CGRectMake(0,0,1024,85);
        }completion:^(BOOL finished){
//            NSLog(@"moved up");
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^(void){
            memberCatalogViewObj.frame=CGRectMake(0,311,1024,437);
            toolBarView.frame=CGRectMake(0,227,1024,85);
        }completion:^(BOOL finished){
//            NSLog(@"moved down");
            
        }];
        [self.view bringSubviewToFront:memberCatalogViewObj];
    }
    [self.view addSubview:toolBarView];
    [self.view addSubview:memberCatalogViewObj];
}

-(void)eventViewFrame:(NSString *)string
{
    if (isHomeClicked) {
        return;
    }
    if ([string isEqualToString:@"YES"]) {
        [UIView animateWithDuration:0.3 animations:^(void){
            eventListViewObj.frame=CGRectMake(0, 84, 1024, 437);
            toolBarView.frame=CGRectMake(0, 0, 1024, 85);
        }completion:^(BOOL finished){
//            NSLog(@"moved up");
        }];
    }
    else {
        
        [UIView animateWithDuration:0.3 animations:^(void){
            eventListViewObj.frame=CGRectMake(0,311, 1024, 437);
            toolBarView.frame=CGRectMake(0, 227, 1024, 85);
        }completion:^(BOOL finished){
//            NSLog(@"moved down");
            
        }];
    }
    [self.view addSubview:toolBarView];
    [self.view addSubview:eventListViewObj];
}

-(void)favoriteViewFrame:(NSString *)string
{
    if (isHomeClicked) {
        return;
    }
    if ([string isEqualToString:@"YES"]) {
        [UIView animateWithDuration:0.3 animations:^(void){
            
            ldcFavoritesViewObj.frame=CGRectMake(0, 84, 1024, 437);
            toolBarView.frame=CGRectMake(0, 0, 1024, 85);
        }completion:^(BOOL finished){
//            NSLog(@"moved up");
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^(void){
            
            ldcFavoritesViewObj.frame=CGRectMake(0,311, 1024, 437);
            toolBarView.frame=CGRectMake(0, 227, 1024, 85);
        }completion:^(BOOL finished){
//            NSLog(@"moved down");
            
        }];        
    }
    [self.view addSubview:toolBarView];
    [self.view addSubview:ldcFavoritesViewObj];
}


#pragma Fade In and fade Out Animation Method

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
#pragma mark fade in/out Toolbarview
//Added By Umesh on 19 Feb 2013 :  to hide the tool bar view (to show a view, galleryview, in full screen mode)
-(void)hideToolBarView{
    [toolBarView setHidden:TRUE];
//    [self fadeView:toolBarView fadein:FALSE timeAnimation:0.3];
}
//Added By Umesh on 19 Feb 2013 :  to show the tool bar view (to show tool bar on exiting full screen mode.)
-(void)showToolBarView{
    [toolBarView setHidden:FALSE];
//    [self fadeView:toolBarView fadein:TRUE timeAnimation:0.3];
}

-(void)showEmailPopOvew:(NSArray *)emailIDArray{
//    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:emailIDArray];
    [mailComposer setSubject:@""]; // Use the document file name for the subject
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}

-(void)ShareEmailForMember:(NSDictionary *)emailIDArray{
//    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray array]];
    [mailComposer setSubject:[NSString stringWithFormat:@"Shared by %@ via the Leaders of Design Council",[emailIDArray valueForKey:@"memberName"]]];
    
    // Use the document file name for the subject
   // [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[emailIDArray objectAtIndex:0]] mimeType:@".png" fileName:@"ShareImage"];
    
    UIImage * image;
    if ([UIImage imageWithContentsOfFile:[[emailIDArray objectForKey:@"imageName"] objectAtIndex:0]]) {
        
        image = [UIImage imageWithContentsOfFile:[[emailIDArray objectForKey:@"imageName"] objectAtIndex:0]];

    }
    else {
         image = [UIImage imageNamed:[[emailIDArray objectForKey:@"imageName"] objectAtIndex:0]];

    }
    [mailComposer addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}

-(void)ShareEmail:(NSArray *)emailIDArray{
    //    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray array]];
    [mailComposer setSubject:@" Shared via the Leaders of Design Council"];
    
    // Use the document file name for the subject
    // [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[emailIDArray objectAtIndex:0]] mimeType:@".png" fileName:@"ShareImage"];
    
    UIImage * image;
    if ([UIImage imageWithContentsOfFile:[emailIDArray objectAtIndex:0]]) {
        
        image = [UIImage imageWithContentsOfFile:[emailIDArray objectAtIndex:0]];
        
    }
    else {
        image = [UIImage imageNamed:[emailIDArray objectAtIndex:0]];
        
    }
    [mailComposer addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
