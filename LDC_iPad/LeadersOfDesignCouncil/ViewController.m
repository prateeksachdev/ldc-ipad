//
//  ViewController.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "ViewController.h"

#import "Constants.h"


#import "HomeViewController.h"

#import "AboutLdcViewController.h"
#import "MembersCatalogPublicViewController.h"
#import <MessageUI/MessageUI.h>
#import "CoreDataOprations.h"
#import "AppsPassword.h"
#import "EmailLinks.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import "HomeGallery.h"
#import "UpdateDatabase.h"
#import "Reachability.h"
#import "ShareView.h"

#import "Social/Social.h"
#import "FBHandler.h"
#import <Twitter/Twitter.h>

@interface ViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation ViewController
@synthesize aboutRcView,urlConnection,urldata,managedObjectContext,delegate,selectorSaveData,homeImageView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	
    // Do any additional setup after loading the view, typically from a nib.
    
    
    urldata=[[NSMutableData alloc]init];
    
    memberLable.font=[UIFont fontWithName:FontThin size:30];
    
    abouttheLDC.titleLabel.font=[UIFont fontWithName:FontThin size:36];
    
    memberDirectory.titleLabel.font=[UIFont fontWithName:FontThin size:36];

    requestPassword.titleLabel.font=[UIFont fontWithName:FontBold size:12];
    
    password.font=[UIFont fontWithName:FontThin size:30];

    fullName.font=[UIFont fontWithName:FontLight size:20];
    
    emailAddress.font=[UIFont fontWithName:FontLight size:20];

    requestPasswordViewLable1.font=[UIFont fontWithName:FontThin size:30];
    requestPasswordViewLable1.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    requestPasswordViewLable2.font=[UIFont fontWithName:FontThin size:20];
    requestPasswordViewLable2.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

    requestPasswordViewLable3.font=[UIFont fontWithName:FontThin size:20];
    requestPasswordViewLable3.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

    requestPasswordViewLable4.font=[UIFont fontWithName:FontBold size:12];
    requestPasswordViewLable4.textColor=[UIColor colorWithRed:25.0/255.0 green:172.0/255.0 blue:204.0/255.0 alpha:1.0];

    requestPasswordViewLable5.font=[UIFont fontWithName:FontBold size:12];
    requestPasswordViewLable5.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

    requestPasswordViewLable6.font=[UIFont fontWithName:FontBold size:12];
    requestPasswordViewLable6.textColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //Umesh commented this line to remove downloading from the starting
    
    if (![self coreDataHasEntriesForEntityName:@"Events"]) {
     
        settingView=[[SettingsView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
        [settingView setDelegate:self];
        [settingView setSelectordownload:@selector(download)];
        //comment the below two lines

        [settingView checkupdate:settingView.checkUpdateButton];
//
//        [self.view addSubview:settingView];
    }
//    hmvcobj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    if ([defaults boolForKey:@"checkForUpdate"]) {
        
        Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
        if (netStatus == NotReachable)
        {
            
        }
        else{
            [self checkForUpdate];
        }
        
    }
    [defaults setBool:FALSE forKey:@"checkForUpdate"];
    [defaults synchronize];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    numberOfAttempts = 0;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSArray *arrayOfhomeBackground=[[CoreDataOprations initObject]fetchRequest:@"HomeGallery" :@"imageId" :appDelegate.managedObjectContext];
    if ([arrayOfhomeBackground count]!=0) {
        
        int randomNumber = arc4random()%[arrayOfhomeBackground count];
//        NSLog(@"arrayOfhomeBackground : %@",arrayOfhomeBackground);

        HomeGallery *homeGalleryObj=[arrayOfhomeBackground objectAtIndex:randomNumber];
//        NSLog(@"homeGalleryObj.image : %@",homeGalleryObj.image);

        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",homeGalleryObj.image];
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            homeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
        }
        else if ([UIImage imageNamed:homeGalleryObj.image]) {
             homeImageView.image=[UIImage imageNamed:homeGalleryObj.image];
        }
        else {
            
            homeImageView.image=[UIImage imageNamed:@"pic_01.png"];
        }
    }
    
//    [hmvcobj simulateSettingButtonClikced];

}
-(NSString*)documentCatchePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}
-(BOOL)isUpdateAvailable{
    
    NSUserDefaults *defaultObj=[NSUserDefaults standardUserDefaults];
    
    
    NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",[defaultObj valueForKey:@"Synchdate"]];
    
    NSData *timeStampData = [timeStamp dataUsingEncoding:NSUTF8StringEncoding];
    NSError        *error = nil;
    NSHTTPURLResponse  *response = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.leadersofdesign.com/api.asmx/CheckUpdate"]];
    [request setValue:timeStamp forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:timeStampData];
    NSData *dataObj =  [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    NSError *error1;
    NSDictionary *updateResponsedict = [NSJSONSerialization
                                        JSONObjectWithData:dataObj options:kNilOptions error:&error1];
    
//    NSLog(@"error : %@",error);
//    NSLog(@"response : %@",response);
//    NSLog(@"updateResponsedict : %@",updateResponsedict);

    if (![[updateResponsedict valueForKey:@"status"] isEqualToString:@"FALSE"]) {
        return TRUE;
    }
    return FALSE;
    
}
-(void)updateOrShowAlert{
    
    numberOfAttempts = 0;
    if (settingView) {
        
        settingView=nil;
    }
    
    
    NSUserDefaults *defaultObj=[NSUserDefaults standardUserDefaults];
    
    
   
    
    Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please Check your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
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
             NSDictionary *updateResponsedict = [NSJSONSerialization
                                                 JSONObjectWithData:data options:kNilOptions error:&error1];
             
//             NSLog(@"responc=%@   %d",updateResponsedict,[updateResponsedict count]);
//             NSLog(@"status: %@",[updateResponsedict valueForKey:@"status"]);
             
             if (updateResponsedict) {
                 if (![[updateResponsedict valueForKey:@"status"] isEqualToString:@"FALSE"]) {
                     settingView=[[SettingsView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
                     [settingView setDelegate:self];
                     [settingView setLogoutAction:@selector(logoutAction)];
                     [settingView setSelectorUpdate:@selector(UpdateDatabase:)];
                     [settingView simulateCheckupdateClicked];
                     [self.view addSubview:settingView];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setBool:FALSE forKey:@"checkForUpdate"];
                     [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
                     [defaults synchronize];
                     [password resignFirstResponder];
                     
                 }
                 else{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please Check your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             }
             
         }
         
         ];
    }
    
    
   
    
}

-(void)checkForUpdate{
//    numberOfAttempts = 0;
    if (settingView) {
        
        settingView=nil;
    }
    
    
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
         NSDictionary *updateResponsedict = [NSJSONSerialization
                                             JSONObjectWithData:data options:kNilOptions error:&error1];
         
//         NSLog(@"responc=%@   %d",updateResponsedict,[updateResponsedict count]);
//         NSLog(@"status: %@",[updateResponsedict valueForKey:@"status"]);
         
         if (updateResponsedict) {
             if (![[updateResponsedict valueForKey:@"status"] isEqualToString:@"FALSE"]) {
                 settingView=[[SettingsView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
                 [settingView setDelegate:self];
                 [settingView setLogoutAction:@selector(logoutAction)];
                 [settingView setSelectorUpdate:@selector(UpdateDatabase:)];
                 [settingView simulateCheckupdateClicked];
                 [self.view addSubview:settingView];
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
        responsedict = [NSJSONSerialization
                         JSONObjectWithData:data options:kNilOptions error:&error1];
         
         //           NSLog(@"responc=%@   %d",responsedict,[responsedict count]);
         
         if (responsedict) {
             
             
             if ([[responsedict valueForKey:@"Status"] isEqualToString:@"NO_NEW_UPDATE"])
             {
                 
                 [settingView.checkUpdateButton setTitle:@"Check For Update" forState:UIControlStateNormal];
                 
                 settingView.downloadLable.text=@"No updates available";
                 
                 settingView.retryButton.hidden=FALSE;
                 
                 [settingView.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
                 
                 [settingView.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
                 
                 settingView.downloadingView.hidden=FALSE;
                 settingView.settingViewLogout.hidden=TRUE;
                 
                 [settingView.gifImageView removeFromSuperview];
                 [settingView removeprogress];
                 
             }
             else if ([[responsedict valueForKey:@"Status"] isEqualToString:@"OK"])
             {
                 
                 [settingView.checkUpdateButton setTitle:@"Check For Update" forState:UIControlStateNormal];
                 
                 
                 settingView.downloadLable.text=@"There is an update available.";
                 
                 settingView.retryButton.hidden=FALSE;
                 
                 [settingView.retryButton setTitle:@"Download" forState:UIControlStateNormal];
                 
                 [settingView.cancelButton setTitle:@"Later" forState:UIControlStateNormal];
                 
                 settingView.downloadingView.hidden=FALSE;
                 settingView.settingViewLogout.hidden=TRUE;
                 
                 [settingView.gifImageView removeFromSuperview];
                 [settingView removeprogress];
                 
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
    numberOfAttempts = 0;
    if (updatedata) {
        updatedata = nil;
    }
    updatedata=[UpdateDatabase initObject];
    updatedata.responceDict=responsedict;
    [updatedata addFiles:settingView];
    
    //      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //      [defaults setObject:[responsedict valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
    //     [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)cancelUpdate{
    [updatedata cancelUpdate];
}
-(void)download
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  
//    NSLog(@"%@",cachePath);
    
    if(![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:@"myfile.zip"]]) {
        //create it, copy it from app bundle, download it etc.
    }

    self.view.userInteractionEnabled=false;
    settingView.userInteractionEnabled=FALSE;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    
//    NSString *attributeValue=[dateFormatter stringFromDate:[NSDate date]];
    
    NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",@""];
    
    NSData *timeStampData = [timeStamp dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.leadersofdesign.com/api.asmx/Pull"]];
    [request setValue:timeStamp forHTTPHeaderField:@"json"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:timeStampData];
    

//    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ldc.azurewebsites.net/api.asmx/Pull"]] delegate:self];
    [NSURLConnection connectionWithRequest:request delegate:self];

    
//    NSURLConnection * connection = [[NSURLConnection alloc]
//                                    initWithRequest:request
//                                    delegate:self startImmediately:NO];
//    
//    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
//                          forMode:NSDefaultRunLoopMode];
//    [connection start];

    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue currentQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
////         NSError *error1;
////         self.responseDictionary = [NSJSONSerialization
////                                    JSONObjectWithData:data options:kNilOptions error:&error1];
////         [self addData:self.responseDictionary];
////         [self addAboutUs:self.responseDictionary];
//         
//         if ([delegate respondsToSelector:selectorSaveData]) {
//             
//             [delegate performSelector:selectorSaveData withObject:data afterDelay:0.0];
//         }
//         
//     }
//     ];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
 
    [self.urldata appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [settingView.gifImageView removeFromSuperview];
    settingView.downloadLable.text=@"Downloading Updates...";

    [self downloaddata:self.urldata];

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (error) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error in downloading data" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
  //  [settingView progress:totalBytesWritten/totalBytesExpectedToWrite];
}

-(void)downloaddata:(NSData*)data2
{    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];

    [dict setObject:settingView forKey:@"progress"];
    [dict setValue:data2 forKey:@"data"];
    
    if ([delegate respondsToSelector:selectorSaveData])
    {
        [delegate performSelector:selectorSaveData withObject:dict afterDelay:0.0];
    }

}

#pragma Button Action Methods

-(IBAction)go_Clicked:(id)sender
{

    NSArray *appPaswordArray= [[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"AppsPassword" :@"appsId" :@"password" :password.text :self.managedObjectContext];

    if ([appPaswordArray count]!=0) {
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"signed" forKey:@"loginStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];    
    
        [password resignFirstResponder];
        if (hmvcobj) {
            hmvcobj = nil;
        }
        hmvcobj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [[self navigationController]pushViewController:hmvcobj animated:YES];

        password.text=@"";
    }
    else {
        NSLog(@"numberAttempts:%d",numberOfAttempts);
        numberOfAttempts++;
        if (numberOfAttempts>2) {
//            [password resignFirstResponder];
            [self updateOrShowAlert];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please Check your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
       
    }
    
    
    //this is another logic for update password.
    
    
//    numberOfAttempts++;
//    if (numberOfAttempts>2) {
//        if (numberOfAttempts==3) {
//            [password resignFirstResponder];
//            [self checkForUpdate];
//        }
//        else{
//            NSUserDefaults *defaultObj = [NSUserDefaults standardUserDefaults];
//            NSDate *currentDate = [NSDate date];
//            NSDate *lastTimeCheckedForUpdate = [defaultObj objectForKey:@"lastTimeCheckedForUpdate"];
//            int timeDiff = [currentDate timeIntervalSinceDate:lastTimeCheckedForUpdate];
//            if (timeDiff>7200) {
//                [password resignFirstResponder];
//                [self checkForUpdate];
//            }
//            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please Check your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//        
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please Check your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    
    
    
    
    
}
-(IBAction)abouttheLDC_Clicked:(id)sender
{
    AboutLdcViewController *aboutLDCViewobj=[[AboutLdcViewController alloc]initWithNibName:@"AboutLdcViewController" bundle:nil];
    [[self navigationController]pushViewController:aboutLDCViewobj animated:YES];

}
-(IBAction)memberDirectory_Clicked:(id)sender
{
    MembersCatalogPublicViewController*memberCatalogPublicViewObj=[[MembersCatalogPublicViewController alloc]init];
    [[self navigationController]pushViewController:memberCatalogPublicViewObj animated:YES];

}

-(IBAction)requestPassword_Clicked:(id)sender
{
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSArray *arrayOfEmailLinks=[[CoreDataOprations initObject]fetchRequestAccordingtoCategory:@"EmailLinks" :@"accessId" :@"type" :@"1" :appDelegate.managedObjectContext];
    
    if( [arrayOfEmailLinks count]!=0)
    {
        
        EmailLinks *emailLinksObj=[arrayOfEmailLinks objectAtIndex:0];

    
    //mail recipient and mail body is changed by Umesh on 04 March 2013
    NSArray *toArray=[[NSArray alloc]initWithObjects:emailLinksObj.email, nil];
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:toArray];
    [mailComposer setSubject:@"Membership Inquiry"]; // Use the document file name for the subject
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring = @"Hello, \n\nI am interested in learning about membership in the LDC. Please send me your information.\n\n Sincerely,\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
    }
    else {
        NSArray *toArray=[[NSArray alloc]initWithObjects:@"hello@leadersofdesign.com", nil];
        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
        [mailComposer setToRecipients:toArray];
        [mailComposer setSubject:@"Membership Inquiry"]; // Use the document file name for the subject
        
        mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        NSString *mailBOdySTring = @"Hello, \n\nI am interested in learning about membership in the LDC. Please send me your information.\n\n Sincerely,\n\nSent via the LDC iPad App";
        [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
        
        mailComposer.mailComposeDelegate = self; // Set the delegate
        [self presentViewController:mailComposer animated:YES completion:nil];

    }
}
-(IBAction)aboutRCButtonAction:(id)sender{
   
   self.aboutRcView.frame=CGRectMake(249,61, 526, 626);
   [self.view addSubview:self.aboutRcView];
    
    //    aboutRoundedCornerView=[[UIView alloc]initWithFrame:CGRectMake(249, 299,526, 626)];
    //    [self addSubview:aboutRoundedCornerView];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)requestAccess_Clicked:(id)sender
{
    HomeViewController *obj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self presentViewController:obj animated:YES completion:nil];
    [requestPasswordView removeFromSuperview];

//[self.navigationController pushViewController:obj animated:YES];
    
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
    [self.view addSubview:inAppbrowserObj];
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
    [self.view addSubview:inAppbrowserObj];
    
}
-(IBAction)shareButtonAction:(id)sender{
//    NSLog(@"shareclicked");
    
    if (!shareViewObj) {
        shareViewObj=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, 1024,748)];
        [shareViewObj setSelectorFaceBookAction:@selector(shareFaceBookForRC)];
        [shareViewObj setSelectorTwitterAction:@selector(shareTwitterForRC)];
        [shareViewObj setSelectorEmailAction:@selector(shareEmailForRC)];
    }
    shareViewObj.delegate=self;
    [self.view addSubview:shareViewObj];
    [self fadeView:shareViewObj fadein:YES timeAnimation:0.3];
    
}
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
            fbController = [SLComposeViewController
                             composeViewControllerForServiceType:SLServiceTypeFacebook];
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
            [fbController setCompletionHandler:completionHandler];
            [self presentViewController:fbController animated:YES completion:nil];
        
    }
    
}
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
    NSString *mailBOdySTring = @"Check out roundedcorners.com to build a custom iPad app for your portfolio or catalog.\n\n\n--\n\n\nRounded Corners is proud to have built the Leaders of Design Council iPhone and iPad apps.  We are an app-building platform that allows companies create and distribute apps faster and more easily than ever before. We specialize in well-designed catalog and portfolio apps.  Our mission is to build and distribute powerful apps that help brands enter a market where the norm is long and costly development.\n\nDiscover the power of the Rounded Corners app builder. Whether for your product line or portfolio, this is the only app creator designed for the luxury industry. This one-of-a-kind service allows you to personalize your app, upload your catalog and update your content quickly and easily.  Our catalog builder lets you create an elegant and accessible catalog of your products or projects.  Plus:  Instantly update your catalog when you have new products or collections.  The cost of distributing new product information to your clients through catalogs or sample books is virtually eliminated.\n\nWe also specialize in custom design work with Rounded Corners Bespoke.  That's what we did for the LDC. For custom design work or to interface with your existing platform, contact us.\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
-(IBAction)contactButtonAction:(id)sender{
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
    
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
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
    
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
    
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
    [self.view addSubview:inAppbrowserObj];
    
}
-(IBAction)closeButtonAction:(id)sender{
    [self.aboutRcView removeFromSuperview];
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


#pragma TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    requestPasswordView.frame=CGRectMake(15,-155,600, 594);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{     
    return YES;

}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{   [self go_Clicked:textField];
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField==fullName)
    {
        [emailAddress becomeFirstResponder];
    }
    else
    {
        
        requestPasswordView.frame=CGRectMake(15,170, 600, 594);
                
    }
    

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = ([touches count] == 1 ? [touches anyObject] : nil);
    
    if (touch.view==self.view)
    {
        [requestPasswordView removeFromSuperview];
    }
    
    
    if (touch.view==shareViewObj.shareBackgroundView)
    {
        [shareViewObj removeFromSuperview];
    }
}

- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        
        return NO;
    }
    return YES;
}

//- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
//{
//    NSString *totalbyte=[NSString stringWithFormat:@"%lld",totalBytesWritten];
//    
//    float totalBytedoublevalue=[totalbyte floatValue];
//    
//    NSString *totalbyteexpected=[NSString stringWithFormat:@"%lld",expectedTotalBytes];
//    
//    float totalbyteexpecteddoublevalue=[totalbyteexpected floatValue];
//
//    [settingView progress:totalBytedoublevalue/totalbyteexpecteddoublevalue];
//    
//    //=totalBytedoublevalue/totalbyteexpecteddoublevalue;
//
//}


//- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
//{
//    NSLog(@"data3");
//    
//}
//- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
//{
//   // NSLog(@"data6");
//    settingView.downloadLable.text=@"Download Completed";
//    [settingView.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
//
//}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
