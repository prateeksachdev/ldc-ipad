//
//  AppDelegate.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#import "ViewController.h"
#import "HomeViewController.h"
#import "SettingsView.h"
#import "EventAgenda.h"
#import "Profession.h"
#import <sys/xattr.h>
#import "AppsPassword.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EmailLinks.h"
#import "EmailLinks.h"
#import "HomeGallery.h"
#import "Reachability.h"
#import "Sponsor.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize navigationController=_navigationController,responseDictionary,membersObj,contitentObj,countryObj,stateObj,eventsObj,aboutLdcInfoObj,aboutImageObj,aboutNewsObj,membersGalleryObj,queue,networkQueue,settingView,homeViewController;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"checkForUpdate"];
    [defaults synchronize];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
        self.viewController.managedObjectContext=self.managedObjectContext;
        self.viewController.delegate=self;
        [self.viewController setSelectorSaveData:@selector(datasave:)];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        self.viewController.managedObjectContext=self.managedObjectContext;
        self.viewController.delegate=self;
        [self.viewController setSelectorSaveData:@selector(datasave:)];

    }
    [FBProfilePictureView class];
    if (![self coreDataHasEntriesForEntityName:@"Memebers"])
    {
        
       queue = [NSOperationQueue new];
      
        if (!networkQueue)
        {
             networkQueue = [[ASINetworkQueue alloc] init];
            [networkQueue setDelegate:self];
            [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
            [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
            [networkQueue setQueueDidFinishSelector:@selector(imageFetchQeue:)];
            [networkQueue setShouldCancelAllRequestsOnFailure:NO];
        }

    }
    
    
    
    if (![[defaults valueForKey:@"loginStatus"] isEqualToString:@""]) {
       
//        NSLog(@"value:%@",[defaults valueForKey:@"loginStatus"]);
        
        if ([[defaults valueForKey:@"loginStatus"] isEqualToString:@"signed"]) {
            
            self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];

            
            _navigationController=[[UINavigationController alloc]initWithRootViewController:self.homeViewController];

        }
        
        else {
            
            _navigationController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
        }

    }
    else {
        
    _navigationController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    }
    _navigationController.navigationBarHidden=YES;
    
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    
//    2013-03-08 15:43:58.180               2013-03-29 04:50:44.180
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"Synchdate"])
    {
        NSString *timeStamp=[NSString stringWithFormat:@"%@",@"2013-05-22 09:50:12.057"];
        [defaults setValue:timeStamp forKey:@"Synchdate"];
        [defaults synchronize];
    }
        NSLog(@"synch time :%@",[defaults valueForKey:@"Synchdate"]);
    
    
//    NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",[defaults valueForKey:@"Synchdate"]];
    return YES;
}

-(void)datasave:(NSMutableDictionary*)data1
{
 //   [self preventFileFromBeingBackUpOniCloud:[NSURL fileURLWithPath:savedImagePath]];
    
  NSError *error1=nil;
  self.responseDictionary = [NSJSONSerialization
                             JSONObjectWithData:[data1 valueForKey:@"data"] options:NSJSONReadingAllowFragments error:&error1];


//    NSLog(@"%@ %@",self.responseDictionary,error1);
    
    if ([self.responseDictionary isEqual:[NSNull null]]) {
        
    }
    else {
        
        //  3/5/2013 4:47:39 AM

        settingView=(SettingsView*)[data1 valueForKey:@"progress"];
        
        [networkQueue setDownloadProgressDelegate:settingView.progressView];
        
        [networkQueue go];
    
    [self addHomeGallery];
  
    [self addData:self.responseDictionary :data1];
    
    [self addAboutUs:self.responseDictionary];
        
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
       
//                       NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//       
//                       [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//       
//                       NSDate *currentdate=[dateFormatter dateFromString:[self.responseDictionary valueForKey:@"SyncDateTime"]];
       
   [defaults setObject:[self.responseDictionary valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
   [[NSUserDefaults standardUserDefaults] synchronize];


    }
}
-(void)addAboutUs:(NSMutableDictionary *)reponseDict{
   
    NSError *error=nil;
    NSArray *aboutUsArray=[responseDictionary objectForKey:@"AboutInfo"];
   
    if ([aboutUsArray isEqual:[NSNull null]]) {
    }
    else {
    for (int i=0; i<[aboutUsArray count]; i++)
    {
        NSDictionary *aboutUsDictionary=[aboutUsArray objectAtIndex:i];
        aboutLdcInfoObj=[NSEntityDescription insertNewObjectForEntityForName:@"AboutLdcInfo" inManagedObjectContext:self.managedObjectContext];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Address"] forKey:@"address"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Description"] forKey:@"aboutDescription"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Email"] forKey:@"email"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Facebook"] forKey:@"facebook"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Houzz"] forKey:@"houzz"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Location"] forKey:@"location"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"PhotoCredit"] forKey:@"photoCredits"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Telephone"] forKey:@"telephone"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Twitter"] forKey:@"twitter"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Website"] forKey:@"website"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Pinterest"] forKey:@"pinterest"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"AboutInfoSyncDateTime"] forKey:@"aboutInfoSyncDateTime"];
        [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"StatusMessage"] forKey:@"statusMessage"];
        
        //Added By Umesh to save time zone and country for weather 
        NSUserDefaults *userDefaultObj = [NSUserDefaults standardUserDefaults];
        [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"Country"] forKey:KeyWeatherAPICountry];
        [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"TimeZone"] forKey:KeyWeatherAPITimeZone];
        [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"Location"] forKey:KeyWeatherAPICity];
        [userDefaultObj synchronize];
        
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self addAboutImage:responseDictionary];
}
- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
            
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            return (UIInterfaceOrientationMaskLandscape);
        }
        else{
            return NO;
}
    
}
-(void)addAboutImage:(NSMutableDictionary *)responseDict{
    NSError *error=nil;
    NSArray *aboutImageArray=[responseDictionary objectForKey:@"AboutImage"];
  
    if ([aboutImageArray isEqual:[NSNull null]]) {
    }
    else {

    
    for (int i=0; i<[aboutImageArray count]; i++) {
        NSDictionary *aboutImageDictionary=[aboutImageArray objectAtIndex:i];
//        NSArray *arrayofstring=[[memberDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
//        
//        NSArray *arrayofstring1=[[memberDictionary valueForKey:@"ThumbImage"] componentsSeparatedByString:@"."];
//        
//        NSString *path_to_file = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[memberDictionary objectForKey:@"MemberID"],[arrayofstring lastObject]]];
//        //
//        NSString *path_to_file1 = [NSString stringWithFormat:@"%@.%@",[memberDictionary objectForKey:@"MemberID"],[arrayofstring lastObject]];
//        
//        
//        NSString *path_to_thumbfile = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]]];
//        NSString *path_to_thumbfile1 = [NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]];
//        

        //Change Path Umesh
        NSString  *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[aboutImageDictionary valueForKey:@"ImgID"]]];
        NSString  *imagePath1 = [NSString stringWithFormat:@"%@.png",[aboutImageDictionary valueForKey:@"ImgID"]];
       
        aboutImageObj=[NSEntityDescription insertNewObjectForEntityForName:@"AbotLdcImageGallery" inManagedObjectContext:self.managedObjectContext];
        [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"Caption"] forKey:@"caption"];
        [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"ImgID"] forKey:@"imageId"];
        [aboutImageObj setValue:imagePath1 forKey:@"imageName"];
        [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
        [aboutImageObj setValue:[NSNumber numberWithInt:[[aboutImageDictionary valueForKey:@"Position"] intValue]] forKey:@"imagePosition"];
        [aboutImageObj setValue:[responseDictionary valueForKey:@"AboutImageSyncDateTime"] forKey:@"aboutImageSyncDateTime"];
      

        
        if ([[aboutImageDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
//            NSLog(@"not ableto download aboutImageObj 239: %@",[aboutImageDictionary valueForKey:@"ImgID"]);
            
        }
        else {

        ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutImageDictionary valueForKey:@"ImageName"]]];
        [requesthttp setDownloadDestinationPath:imagePath];
        [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"ImageName"]];
        [requesthttp setShouldContinueWhenAppEntersBackground:YES];
        [requesthttp setAllowResumeForFileDownloads:YES];
        [requesthttp setTimeOutSeconds:1500];
        [requesthttp setShowAccurateProgress:YES];
        [networkQueue addOperation:requesthttp];

        }
        
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
 
    }
    }
    [self addAboutNewLetter:responseDictionary];
}
-(void)addAboutNewLetter:(NSMutableDictionary *)responseDict{
  
    NSError *error=nil;
    NSArray *aboutNewsLetterArray=[responseDictionary objectForKey:@"AboutNewsLetter"];
   
    if ([aboutNewsLetterArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[aboutNewsLetterArray count]; i++) {
        
        NSDictionary *aboutNewsLetterDictionary=[aboutNewsLetterArray objectAtIndex:i];
     //Change Path Umesh
        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"]]];
        
        NSString *imagePath1 = [NSString stringWithFormat:@"%@.pdf",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"]];

        
        aboutNewsObj=[NSEntityDescription insertNewObjectForEntityForName:@"AboutLdcNewsLetter" inManagedObjectContext:self.managedObjectContext];
        [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:@"newsletterId"];
        [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Month"] forKey:@"month"];
        [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Year"] forKey:@"year"];
        [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"RS"] forKey:@"aboutLdcRS"];
        [aboutNewsObj setValue:imagePath1 forKey:@"newsletterName"];
        
        
        if ([[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download NewsLetterName 292: %@",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"]);
        }
        else {
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"]]];
            [requesthttp setDownloadDestinationPath:imagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
            
        }

        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
 
}
-(void)addData:(NSMutableDictionary *)responseDict:(NSMutableDictionary *)dictionary{
   

    
    NSArray *memberArray=[responseDictionary objectForKey:@"Member"];
    NSArray *memberGalleryArray=[responseDictionary objectForKey:@"MemberImageGallery"];
    
    NSError *error=nil;
    
    if ([memberArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[memberArray count]; i++) {
        
        NSDictionary *memberDictionary=[memberArray objectAtIndex:i];
        
//        NSString  *imagePath1=[NSHomeDirectory() stringByAppendingString:@"/Library/Caches/%@.png",[memberDictionary valueForKey:@"MemberID"]];
//        
//        NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Library/Caches/%@.png",[memberDictionary valueForKey:@"MemberID"]]];
//        NSString  *thumbImagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Library/Caches/thumb%@.png",[memberDictionary valueForKey:@"MemberID"]]];
        
        
        //Change Path Umesh
        
        
        NSArray *arrayofstring=[[memberDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];

        NSArray *arrayofstring1=[[memberDictionary valueForKey:@"ThumbImage"] componentsSeparatedByString:@"."];

        NSString *path_to_file = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[memberDictionary objectForKey:@"MemberID"],[arrayofstring lastObject]]];
//
        NSString *path_to_file1 = [NSString stringWithFormat:@"%@.%@",[memberDictionary objectForKey:@"MemberID"],[arrayofstring lastObject]];
        

        NSString *path_to_thumbfile = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]]];
        NSString *path_to_thumbfile1 = [NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]];
        

         membersObj= [NSEntityDescription
                     insertNewObjectForEntityForName:@"Memebers"
                     inManagedObjectContext:self.managedObjectContext];
        
        
        
        [membersObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mId"];
        [membersObj setValue:[memberDictionary valueForKey:@"Name"] forKey:@"mName"];
        [membersObj setValue:[memberDictionary valueForKey:@"LastName"] forKey:@"mLastName"];
        [membersObj setValue:[memberDictionary valueForKey:@"Address"] forKey:@"mAddress"];
        [membersObj setValue:[memberDictionary valueForKey:@"Bio"] forKey:@"mDescription"];
        [membersObj setValue:[memberDictionary valueForKey:@"ContinentID"] forKey:@"mContinentId"];
        [membersObj setValue:[memberDictionary valueForKey:@"CountryID"] forKey:@"mCountryId"];
        [membersObj setValue:[memberDictionary valueForKey:@"StateID"] forKey:@"mStateId"];
        [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mProfessionId"];        
        [membersObj setValue:[memberDictionary valueForKey:@"Facebook"] forKey:@"mFacebook"];
        [membersObj setValue:[memberDictionary valueForKey:@"Twitter"] forKey:@"mTwitter"];
        [membersObj setValue:[memberDictionary valueForKey:@"Pinterest"] forKey:@"mPinterest"];
        [membersObj setValue:[memberDictionary valueForKey:@"Houzz"] forKey:@"mHouzz"];
        [membersObj setValue:[memberDictionary valueForKey:@"AppUrl"] forKey:@"mAppUrl"];
        [membersObj setValue:[memberDictionary valueForKey:@"AppUrlIPhone"] forKey:@"mAppURliphone"];
        [membersObj setValue:[memberDictionary valueForKey:@"Website"] forKey:@"mWebsite"];
        [membersObj setValue:[memberDictionary valueForKey:@"Email"] forKey:@"mEmail"];
        [membersObj setValue:[memberDictionary valueForKey:@"Telephone"] forKey:@"mTelephone"];
        [membersObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mRS"];
        [membersObj setValue:path_to_thumbfile1 forKey:@"mThumbImage"];
        [membersObj setValue:path_to_file1 forKey:@"mProfileImage"];
        [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mSyncDateTime"];
        membersObj.mFounder=[NSString stringWithFormat:@"%@",[memberDictionary valueForKey:@"Founder"]];
        membersObj.mCompany=[memberDictionary valueForKey:@"Company"];
        
        if ([[memberDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download memberDictionary 387: %@",[memberDictionary valueForKey:@"Name"]);
            
        }
        else {
        
        ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"Image"]]];
        [requesthttp setDownloadDestinationPath:path_to_file];
        [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:path_to_file forKey:@"name"]];
        [requesthttp setShouldContinueWhenAppEntersBackground:YES];
        [requesthttp setAllowResumeForFileDownloads:YES];
        [requesthttp setTimeOutSeconds:1500];
        [requesthttp setShowAccurateProgress:YES];
        [networkQueue addOperation:requesthttp];

        }
        if ([[memberDictionary valueForKey:@"ThumbImage"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download ThumbImage  memberDictionary 403: %@",[memberDictionary valueForKey:@"Name"]);
        }
        else {
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ThumbImage"]]];
            [requesthttp setDownloadDestinationPath:path_to_thumbfile];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:path_to_thumbfile forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
            
        }

        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self addMembersGallery:memberGalleryArray :dictionary];
    
    [self addLocationData:memberArray];

}

-(void)addMembersGallery :(NSArray*)memberGalleryArray:(NSMutableDictionary*)dictionary
{
    

    NSError *error=nil;
    if ([memberGalleryArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[memberGalleryArray count]; i++) {
        
        membersGalleryObj= [NSEntityDescription
                     insertNewObjectForEntityForName:@"MembersGallery"
                     inManagedObjectContext:self.managedObjectContext];

        
        NSDictionary *memberDictionary=[memberGalleryArray objectAtIndex:i];
        
        //Change Path Umesh
        
        NSArray *arrayofstring=[[memberDictionary valueForKey:@"ImagePath"] componentsSeparatedByString:@"."];
        
        NSArray *arrayofstring1=[[memberDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];

        
        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
        NSString *imagePath1 = [NSString stringWithFormat:@"%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
        
        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath1 = [NSString stringWithFormat:@"thumb%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];
        
        [membersGalleryObj setValue:imagePath1 forKey:@"mgImagePath"];
        [membersGalleryObj setValue:[memberDictionary valueForKey:@"Caption"] forKey:@"mgCaption"];
        [membersGalleryObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mgMembersId"];
        [membersGalleryObj setValue:[memberDictionary valueForKey:@"ImageID"] forKey:@"mgImageId"];
        [membersGalleryObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mgRS"];
        [membersGalleryObj setValue:[NSNumber numberWithInt:[[memberDictionary valueForKey:@"Position"] intValue]] forKey:@"mgImagePosition"];

        membersGalleryObj.mgImageThumb=thumbImagePath1;
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        [dict setObject:imagePath forKey:@"path"];
        
        [dict setObject:[memberDictionary valueForKey:@"ImagePath"] forKey:@"url"];
        
        
        if ([[memberDictionary valueForKey:@"ImagePath"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download   MembersGallery 479: %@",[memberDictionary valueForKey:@"ImageID"]);
    
        }
        else {
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImagePath"]]];
            [requesthttp setDownloadDestinationPath:imagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];

        }
        
        if ([[memberDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
//         NSLog(@"not ableto download ImageThumbnail  MembersGallery 496: %@",[memberDictionary valueForKey:@"ImageID"]);   
        }
        else {
            
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImageThumbnail"]]];
            [requesthttp setDownloadDestinationPath:thumbImagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
        }

        
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }
    }
}

- (void)loadImage:(NSMutableDictionary*)url {
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url valueForKey:@"url"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
  BOOL check = [UIImagePNGRepresentation(image) writeToFile:[url valueForKey:@"path"] atomically:YES];
    
    if (check) {
        
        NSLog(@"successfull");
    }
    else {
        
        NSLog(@"Fail");

    }
}


-(void)addLocationData:(NSArray*)locationArray
{
    NSError *error=nil;
    
    NSArray *contitentArray=[responseDictionary objectForKey:@"Continents"];
    if ([contitentArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[contitentArray count]; i++)
    {
        contitentObj= [NSEntityDescription
                       insertNewObjectForEntityForName:@"Contitent"
                       inManagedObjectContext:self.managedObjectContext];
        
        
        NSDictionary *contitentDictionary=[contitentArray objectAtIndex:i];
        NSString *contitentId=[contitentDictionary objectForKey:@"ContinentID"];
        NSString *contitentName=[contitentDictionary objectForKey:@"Name"];
        


        [contitentObj setValue:contitentId forKey:@"contitentId"];
        [contitentObj setValue:contitentName forKey:@"contitentName"];
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    }
    NSArray *countryArray1=[responseDictionary objectForKey:@"Country"];

    if ([countryArray1 isEqual:[NSNull null]]) {
    }
    else {
        
        for (int j=0; j<[countryArray1 count]; j++)
        {
            
            NSDictionary *countryDictionary=[countryArray1 objectAtIndex:j];
                            
                countryObj= [NSEntityDescription
                             insertNewObjectForEntityForName:@"Country"
                             inManagedObjectContext:self.managedObjectContext];
                
                
              //  NSLog(@"state:%@",countryDictionary);
                
                [countryObj setValue:[countryDictionary objectForKey:@"ContinentID"] forKey:@"contitentId"];
                [countryObj setValue:[countryDictionary objectForKey:@"Name"] forKey:@"countryName"];
                [countryObj setValue:[countryDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            
            if (![defaults valueForKey:@"Synchdate"]) {
                
                [defaults setObject:[countryDictionary valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
            }
            else {
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                
                NSDate *currentdate=[dateFormatter dateFromString:[countryDictionary valueForKey:@"SyncDateTime"]];
                NSDate *previousdate=[dateFormatter dateFromString:[defaults valueForKey:@"Synchdate"]];
                
                if ([currentdate compare:previousdate]==NSOrderedDescending) {
                    
                    [defaults setObject:currentdate forKey:@"Synchdate"];
                }
                
            }

            
                if (![self.managedObjectContext save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
    }
    
    NSArray *stateArray1=[responseDictionary objectForKey:@"State"];
  
    if ([stateArray1 isEqual:[NSNull null]]) {
    }
    else {
                for (int k=0;k<[stateArray1 count]; k++)
                {
                    NSDictionary *stateDictionary=[stateArray1 objectAtIndex:k];
                                            
                        stateObj= [NSEntityDescription
                                   insertNewObjectForEntityForName:@"State"
                                   inManagedObjectContext:self.managedObjectContext];
                                                
                        [stateObj setValue:[stateDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
                        [stateObj setValue:[stateDictionary objectForKey:@"StateID"] forKey:@"stateId"];
                        [stateObj setValue:[stateDictionary objectForKey:@"Name"] forKey:@"stateName"];
                    
                    
                    
                        if (![self.managedObjectContext save:&error])
                        {
                            
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }
                        
                    }
                    
                    
                }
                
            
        
        
        
    [self addProfession];
}

-(void)addProfession
{
    NSError *error=nil;
    
    NSArray *professionArray=[responseDictionary objectForKey:@"Profession"];
    if ([professionArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[professionArray count]; i++){
        
        NSDictionary *professionDictionary=[professionArray objectAtIndex:i];
        
        Profession *professionObj= [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Profession"
                                          inManagedObjectContext:self.managedObjectContext];
        
        
        professionObj.professionId=[professionDictionary valueForKey:@"ProfessionID"];
        
        professionObj.professionName=[professionDictionary valueForKey:@"Name"];
        
        professionObj.professionRS=[professionDictionary valueForKey:@"RS"];
        
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self addEventData];

}

-(void)addEventData
{
    NSError *error=nil;

    NSArray *eventArray=[responseDictionary objectForKey:@"Events"];
    if ([eventArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[eventArray count]; i++){
        
        NSDictionary *eventDictionary=[eventArray objectAtIndex:i];
        
        eventsObj= [NSEntityDescription
                    insertNewObjectForEntityForName:@"Events"
                    inManagedObjectContext:self.managedObjectContext];
        
        //change path Umesh
        
        NSArray *arrayofstring=[[eventDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
        
        NSArray *arrayofstring1=[[eventDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];

        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring lastObject]]];
         NSString *imagePath1 = [NSString stringWithFormat:@"%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring lastObject]];
        
         NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath1 = [NSString stringWithFormat:@"thumb%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring1 lastObject]];
        
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];

       
        [eventsObj setValue:[eventDictionary valueForKey:@"EventID"] forKey:@"eId"];
       
        [eventsObj setValue:[eventDictionary valueForKey:@"EventName"] forKey:@"eName"];
        
        [eventsObj setValue:imagePath1 forKey:@"eImage"];
        [eventsObj setValue:thumbImagePath1 forKey:@"eThumbImage"];

        [eventsObj setValue:[eventDictionary valueForKey:@"Place"] forKey:@"ePlace"];
        [eventsObj setValue:[eventDictionary valueForKey:@"Place2"] forKey:@"ePlace2"];
        [eventsObj setValue:[eventDictionary valueForKey:@"Place3"] forKey:@"ePlace3"];
        [eventsObj setValue:[eventDictionary valueForKey:@"ZipCode"] forKey:@"eZipCode"];

        [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventFrom"]] forKey:@"eFromDate"];
        
        [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventTO"]] forKey:@"eToDate"];
        
        [eventsObj setValue:[eventDictionary valueForKey:@"comment"] forKey:@"eComment"];
        
        [eventsObj setValue:[eventDictionary valueForKey:@"Lat"] forKey:@"eLat"];
        [eventsObj setValue:[eventDictionary valueForKey:@"Long"] forKey:@"eLong"];

        [eventsObj setValue:[eventDictionary valueForKey:@"RS"] forKey:@"eRS"];
        [eventsObj setValue:[eventDictionary valueForKey:@"LongName"] forKey:@"eLongName"];
        
        
        if ([[eventDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
//            NSLog(@"not ableto download Image  MembersGallery 761: %@",[eventDictionary valueForKey:@"EventName"]);
        }
        else {
        
        ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"Image"]]];
        
        [requesthttp setDownloadDestinationPath:imagePath];
        [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"ename"]];
        [requesthttp setShouldContinueWhenAppEntersBackground:YES];
        [requesthttp setAllowResumeForFileDownloads:YES];
        [requesthttp setTimeOutSeconds:1500];
        [requesthttp setShowAccurateProgress:YES];
        [networkQueue addOperation:requesthttp];
        }
        if ([[eventDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
//            NSLog(@"not ableto download ImageThumbnail  MembersGallery 776: %@",[eventDictionary valueForKey:@"EventName"]);
        }
        else {
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"ImageThumbnail"]]];
            
            [requesthttp setDownloadDestinationPath:thumbImagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"ename"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
        }
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self saveEventsGallery];
}

-(void)saveEventsGallery
{
    NSError *error=nil;
    
    NSArray *eventGalleryArray=[responseDictionary objectForKey:@"EventImage"];
    if ([eventGalleryArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[eventGalleryArray count]; i++){
        
        NSDictionary *eventGalleryDictionary=[eventGalleryArray objectAtIndex:i];
        
        EventsGallery *eventsGalleryObj= [NSEntityDescription
                    insertNewObjectForEntityForName:@"EventsGallery"
                    inManagedObjectContext:self.managedObjectContext];
        
        //change Path Umesh
        
        NSArray *arrayofstring=[[eventGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
        
        NSArray *arrayofstring1=[[eventGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];

        
        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
        NSString *imagePath1 = [NSString stringWithFormat:@"%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
        
        NSString *thumbImagePath=[[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath1=[NSString stringWithFormat:@"thumb%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];
        
        
        if ([[eventGalleryDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download ImageName  eventGalleryDictionary 832: %@",[eventGalleryDictionary valueForKey:@"EventID"]);
        }
        else {

        ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"Image"]]];
        [requesthttp setDownloadDestinationPath:imagePath];
        [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
        [requesthttp setShouldContinueWhenAppEntersBackground:YES];
        [requesthttp setAllowResumeForFileDownloads:YES];
        [requesthttp setTimeOutSeconds:1500];
        [requesthttp setShowAccurateProgress:YES];
        [networkQueue addOperation:requesthttp];

        }
        
        if ([[eventGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
//             NSLog(@"not ableto download ImageThumb  eventGalleryDictionary 848: %@",[eventGalleryDictionary valueForKey:@"EventID"]);
        }
        else {
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"ImageThumb"]]];
            [requesthttp setDownloadDestinationPath:thumbImagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
            
        }

        eventsGalleryObj.egEventID=[eventGalleryDictionary valueForKey:@"EventID"];
        
        eventsGalleryObj.egImageName=imagePath1;
        
        eventsGalleryObj.egImageId=[eventGalleryDictionary valueForKey:@"ImageID"];
        
        eventsGalleryObj.egCaption=[eventGalleryDictionary valueForKey:@"Caption"];
        
        eventsGalleryObj.egImageThumb=thumbImagePath1;
        eventsGalleryObj.egImagePosition = [NSNumber numberWithInt:[[eventGalleryDictionary valueForKey:@"Position"] intValue]];
        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        
//        
//        if (![defaults valueForKey:@"Synchdate"]) {
//            
//            [defaults setObject:[eventGalleryDictionary valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
//        }
//        else {
//            
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            
//            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//            
//            NSDate *currentdate=[dateFormatter dateFromString:[eventGalleryDictionary valueForKey:@"SyncDateTime"]];
//            NSDate *previousdate=[dateFormatter dateFromString:[defaults valueForKey:@"Synchdate"]];
//            
//            if ([currentdate compare:previousdate]==NSOrderedDescending) {
//                
//                [defaults setObject:currentdate forKey:@"Synchdate"];
//            }
//            
//        }

        
        // [eventsObj setValue:@"" forKey:@"eGallery"];
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self saveEventAgenda];

}

-(void)saveEventAgenda
{
    NSError *error=nil;
    
    NSArray *eventAgendaArray=[responseDictionary objectForKey:@"EventAgenda"];
    if ([eventAgendaArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[eventAgendaArray count]; i++){
        
        NSDictionary *eventAgendaDictionary=[eventAgendaArray objectAtIndex:i];
        
        EventAgenda *eventAgendaObj= [NSEntityDescription
                                          insertNewObjectForEntityForName:@"EventAgenda"
                                          inManagedObjectContext:self.managedObjectContext];
                
        eventAgendaObj.eaEventID=[eventAgendaDictionary valueForKey:@"EventID"];
        
        eventAgendaObj.eaAgendaName=[eventAgendaDictionary valueForKey:@"AgendaName"];
        eventAgendaObj.eaId=[eventAgendaDictionary valueForKey:@"AgendaID"];
        eventAgendaObj.eaDescription1=[eventAgendaDictionary valueForKey:@"Description1"];
        eventAgendaObj.eaDescription2=[eventAgendaDictionary valueForKey:@"Description2"];
        eventAgendaObj.eaDate=[eventAgendaDictionary valueForKey:@"Date"];
        eventAgendaObj.eaLocation=[eventAgendaDictionary valueForKey:@"Location"];

//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        
//        
//        if (![defaults valueForKey:@"Synchdate"]) {
//            
//            [defaults setObject:[eventAgendaDictionary valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
//        }
//        else {
//            
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            
//            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//            
//            NSDate *currentdate=[dateFormatter dateFromString:[eventAgendaDictionary valueForKey:@"SyncDateTime"]];
//            NSDate *previousdate=[dateFormatter dateFromString:[defaults valueForKey:@"Synchdate"]];
//            
//            if ([currentdate compare:previousdate]==NSOrderedDescending) {
//                
//                [defaults setObject:currentdate forKey:@"Synchdate"];
//            }
//            
//        }

        
        // [eventsObj setValue:@"" forKey:@"eGallery"];
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self saveFavoirates];
    
}


-(void)saveFavoirates
{
    NSError *error=nil;
    
    NSArray *favoiratesArray=[responseDictionary objectForKey:@"Favority"];
    if ([favoiratesArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[favoiratesArray count]; i++){
        
        NSDictionary *favoirateDictionary=[favoiratesArray objectAtIndex:i];
        
        Favorites *favoritesObj= [NSEntityDescription
                    insertNewObjectForEntityForName:@"Favorites"
                    inManagedObjectContext:self.managedObjectContext];
        //change Path Umesh
        
        NSArray *arrayofstring=[[favoirateDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
        
        NSArray *arrayofstring1=[[favoirateDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];

        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring lastObject]]];
        NSString *imagePath1 = [NSString stringWithFormat:@"%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring lastObject]];
        
        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath1 = [NSString stringWithFormat:@"thumb%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring1 lastObject]];
        
//        [favoritesObj setValue:imagePath1 forKey:@"favImage"];
//        [favoritesObj setValue:thumbImagePath1 forKey:@"favThumbImage"];
        
        favoritesObj.favThumbImage = thumbImagePath1;
        favoritesObj.favImage = imagePath1;
        favoritesObj.favoriteId=[favoirateDictionary valueForKey:@"FavorityID"];
        favoritesObj.url=[favoirateDictionary valueForKey:@"Url"];
        favoritesObj.categoryId=[favoirateDictionary valueForKey:@"CategoryID"];
        favoritesObj.favdescription=[favoirateDictionary valueForKey:@"Description"];
        favoritesObj.latitude=[favoirateDictionary valueForKey:@"Lat"];
        favoritesObj.longitude=[favoirateDictionary valueForKey:@"Long"];
        favoritesObj.favSubTitle=[favoirateDictionary valueForKey:@"SubTittle"];
        favoritesObj.favRS=[favoirateDictionary valueForKey:@"RS"];

        if ([[favoirateDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
//            NSLog(@"not ableto download Image  eventGalleryDictionary 1019: %@",[favoirateDictionary valueForKey:@"SubTittle"]);
        }
        else {
            
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"Image"]]];
            
            [requesthttp setDownloadDestinationPath:imagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
        }
        if ([[favoirateDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
//         NSLog(@"not ableto download ImageThumbnail  eventGalleryDictionary 1034: %@",[favoirateDictionary valueForKey:@"SubTittle"]);   
        }
        else {
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"ImageThumbnail"]]];
            
            [requesthttp setDownloadDestinationPath:thumbImagePath];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
        }


        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    }
    [self saveCategory];

}

-(void)saveCategory
{
    NSError *error=nil;
    
    NSArray *categoryArray=[responseDictionary objectForKey:@"Category"];
    if ([categoryArray isEqual:[NSNull null]]) {
    }
    else {

    for (int i=0; i<[categoryArray count]; i++){
        
        NSDictionary *eventDictionary=[categoryArray objectAtIndex:i];
        
        FavCategory *categoryObj= [NSEntityDescription
                                  insertNewObjectForEntityForName:@"FavCategory"
                                  inManagedObjectContext:self.managedObjectContext];
        
        categoryObj.categoryId=[eventDictionary valueForKey:@"CategoryID"];
        categoryObj.categoryName=[eventDictionary valueForKey:@"CategoryName"];
        categoryObj.categoryRS=[eventDictionary valueForKey:@"RS"];
        
        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        
//        
//        if (![defaults valueForKey:@"Synchdate"]) {
//            
//            [defaults setObject:[eventDictionary valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
//        }
//        else {
//            
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            
//            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//            
//            NSDate *currentdate=[dateFormatter dateFromString:[eventDictionary valueForKey:@"SyncDateTime"]];
//            NSDate *previousdate=[dateFormatter dateFromString:[defaults valueForKey:@"Synchdate"]];
//            
//            if ([currentdate compare:previousdate]==NSOrderedDescending) {
//                
//                [defaults setObject:currentdate forKey:@"Synchdate"];
//            }
//            
//        }

        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    }
    
    [self saveAppPassword];
    [self addSponsors];
}
-(void)addSponsors{
    NSError *error=nil;
    
    NSArray *sponsorsArray=[responseDictionary objectForKey:@"Sponser"];
    if ([sponsorsArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[sponsorsArray count]; i++){
            
            NSDictionary *sponsorDictionary=[sponsorsArray objectAtIndex:i];
            
            Sponsor *sponsorObj= [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Sponsor"
                                      inManagedObjectContext:self.managedObjectContext];
            
            NSArray *arrayofstring=[[sponsorDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            
            NSArray *arrayofstring1=[[sponsorDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
            
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring lastObject]]];
            NSString *imagePath1 = [NSString stringWithFormat:@"%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring lastObject]];
            
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring1 lastObject]]];
            NSString *thumbImagePath1 = [NSString stringWithFormat:@"thumb%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring1 lastObject]];
            
            
            sponsorObj.sThumbImageName = thumbImagePath1;
            sponsorObj.sImageName = imagePath1;
            sponsorObj.sponsorId=[sponsorDictionary valueForKey:@"SponserID"];
            sponsorObj.sUrl=[sponsorDictionary valueForKey:@"Url"];
            sponsorObj.sDescription=[sponsorDictionary valueForKey:@"Description"];
            if ([[sponsorDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                //            NSLog(@"not ableto download Image  eventGalleryDictionary 1019: %@",[favoirateDictionary valueForKey:@"SubTittle"]);
            }
            else {
                
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"Image"]]];
                
                [requesthttp setDownloadDestinationPath:imagePath];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
            }
            if ([[sponsorDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                //         NSLog(@"not ableto download ImageThumbnail  eventGalleryDictionary 1034: %@",[favoirateDictionary valueForKey:@"SubTittle"]);
            }
            else {
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"ImageThumb"]]];
                
                [requesthttp setDownloadDestinationPath:thumbImagePath];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
            }
            
            
            
            if (![self.managedObjectContext save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
        }
    }
}
-(void)saveAppPassword
{
    NSError *error=nil;
    
    NSArray *appsPasswordArray=[responseDictionary objectForKey:@"AppsPassword"];
    if ([appsPasswordArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[appsPasswordArray count]; i++){
            
            NSDictionary *appsPasswordDictionary=[appsPasswordArray objectAtIndex:i];
            
             AppsPassword*appsPasswordObj= [NSEntityDescription
                                       insertNewObjectForEntityForName:@"AppsPassword"
                                       inManagedObjectContext:self.managedObjectContext];
            
            appsPasswordObj.appsId=[appsPasswordDictionary valueForKey:@"AppsID"];
            appsPasswordObj.title=[appsPasswordDictionary valueForKey:@"Tittle"];
            appsPasswordObj.password=[appsPasswordDictionary valueForKey:@"Password"];
            appsPasswordObj.dateAdded=[appsPasswordDictionary valueForKey:@"DateAdded"];
         
            
            if (![self.managedObjectContext save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    
    [self saveEmailLinks];
    
}

-(void)saveEmailLinks
{
    NSError *error=nil;
    
    NSArray *emailLinksArray=[responseDictionary objectForKey:@"EmailLink"];
    if ([emailLinksArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[emailLinksArray count]; i++){
            
            NSDictionary *emailLinksDictionary=[emailLinksArray objectAtIndex:i];
            
            EmailLinks*emailLinksObj= [NSEntityDescription
                                           insertNewObjectForEntityForName:@"EmailLinks"
                                           inManagedObjectContext:self.managedObjectContext];
            
            emailLinksObj.accessId =[emailLinksDictionary valueForKey:@"AccessID"];
            emailLinksObj.email=[emailLinksDictionary valueForKey:@"Email"];
            emailLinksObj.type=[emailLinksDictionary valueForKey:@"Type"];
            
            if (![self.managedObjectContext save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }

}

-(void)addHomeGallery
{
    NSError *error=nil;
    
    NSArray *homeGalleryArray=[self.responseDictionary objectForKey:@"HomeGallery"];
    if ([homeGalleryArray isEqual:[NSNull null]])
    {
        
    }
    else
    {
        for (int i=0; i<[homeGalleryArray count]; i++){
            
            NSDictionary *homeGalleryDictionary=[homeGalleryArray objectAtIndex:i];
            
            
            
                                        
                HomeGallery*homeGalleryObj= [NSEntityDescription
                                             insertNewObjectForEntityForName:@"HomeGallery"
                                             inManagedObjectContext:self.managedObjectContext];
            
            
            
            NSArray *arrayofstring=[[homeGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            NSArray *arrayofstring1=[[homeGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];

            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
            NSString *imagePath1 = [NSString stringWithFormat:@"%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
            NSString *thumbImagePath1 = [NSString stringWithFormat:@"thumb%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];

            
//            NSLog(@"%@",arrayofstring);
            
                homeGalleryObj.imageId =[homeGalleryDictionary valueForKey:@"ImageID"];
                homeGalleryObj.image=imagePath1;
                homeGalleryObj.imageThumb=thumbImagePath1;
                
                
                if ([[homeGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
//                     NSLog(@"not ableto download Image  eventGalleryDictionary 1225: %@",[homeGalleryDictionary valueForKey:@"ImageID"]); 
                }
                else {
                    
                //    NSLog(@"%@",[homeGalleryDictionary valueForKey:@"Image"]);
                        ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"Image"]]];
                        
                        [requesthttp setDownloadDestinationPath:imagePath];
                        [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                        [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                        [requesthttp setAllowResumeForFileDownloads:YES];
                        [requesthttp setTimeOutSeconds:1500];
                        [requesthttp setShowAccurateProgress:YES];
                        [networkQueue addOperation:requesthttp];
                    
                }
                if ([[homeGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
//                    NSLog(@"not ableto download ImageThumb  eventGalleryDictionary 1242: %@",[homeGalleryDictionary valueForKey:@"ImageID"]);
                }
                else {
                    
                //    NSLog(@"%@",[homeGalleryDictionary valueForKey:@"ImageThumb"]);

                    
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"ImageThumb"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                
                
                if (![self.managedObjectContext save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
                
        
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

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    [self preventFileFromBeingBackUpOniCloud:[NSURL fileURLWithPath:[request downloadDestinationPath]]];
    
    NSLog(@"downloadcomnpleted");
    
}
- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"url=%@",[request url]);
//    NSLog(@"url=%@",[request userInfo]);
    
    NSLog(@"downloadfail");
    
    
}
- (void)imageFetchQeue:(ASIHTTPRequest *)request
{
    settingView.downloadLable.text=@"Download Complete";
    [settingView.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
    [settingView progress:1.0];    
    settingView.userInteractionEnabled=TRUE;
    self.viewController.view.userInteractionEnabled=TRUE;
     NSLog(@"download");
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

-(void)preventFileFromBeingBackUpOniCloud:(NSURL *)fileUrl{
    // Added By Umesh to add do not back up attribute to a file
    
    float currentVersion = 5.1;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion){
        [self addSkipBackupAttributeToItemAtURL:fileUrl];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 5.1){
        [self addSkipBackupAttributeToItemAtURLBelowiOS5_1:fileUrl];
    }
    
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    else
        NSLog(@"excluding from backup done ");
    return success;
}

- (BOOL)addSkipBackupAttributeToItemAtURLBelowiOS5_1:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaultObj = [NSUserDefaults standardUserDefaults];
    [defaultObj valueForKey:@"Synchdate"];
    NSLog(@"synch date: %@",[defaultObj valueForKey:@"Synchdate"]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults *defaultObj = [NSUserDefaults standardUserDefaults];
    [defaultObj valueForKey:@"Synchdate"];
//    NSLog(@"synch date: %@",[[defaultObj valueForKey:@"Synchdate"] substringToIndex:19]);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    @"2013-03-14 01:05:52.613"
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *synchDate = [dateFormatter dateFromString:[[defaultObj valueForKey:@"Synchdate"] substringToIndex:19]];
//     NSLog(@"synch date>>>: %@",synchDate);
    NSDate *currentDate = [NSDate date];
     NSLog(@"currentDate date>>>: %@",currentDate);
    
    NSDate *lastTimeCheckedForUpdate = [defaultObj objectForKey:@"lastTimeCheckedForUpdate"];
//    [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
    
    int timeDiff = [currentDate timeIntervalSinceDate:lastTimeCheckedForUpdate];
    NSLog(@"timeDiff: %d",timeDiff);
    
    
    Reachability *hostReach1 = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReach1 currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        
        
        if (timeDiff>7200) {
            
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            
            NSString *timeStamp=[NSString stringWithFormat:@"syncdatetime=%@",[defaults valueForKey:@"Synchdate"]];
            
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
                 NSDictionary *responsedict = [NSJSONSerialization
                                               JSONObjectWithData:data options:kNilOptions error:&error1];
                 
                 NSLog(@"responc=%@   %d",responsedict,[responsedict count]);
                 NSLog(@"status: %@",[responsedict valueForKey:@"status"]);
                 
                 if (responsedict) {
                     if (![[responsedict valueForKey:@"status"] isEqualToString:@"FALSE"]) {
                         [defaults setObject:[NSDate date] forKey:@"lastTimeCheckedForUpdate"];
                         
                         [defaultObj setBool:TRUE forKey:@"checkForUpdate"];
                         [defaultObj synchronize];
                         
                         if (![[defaultObj valueForKey:@"loginStatus"] isEqualToString:@""]) {
                             
                             //        NSLog(@"value:%@",[defaults valueForKey:@"loginStatus"]);
                             
                             if ([[defaultObj valueForKey:@"loginStatus"] isEqualToString:@"signed"]) {
                                 
                                 //                self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                                 [self.homeViewController simulateSettingButtonClikced];
                                 
                             }
                             
                             else {
                                 [self.viewController checkForUpdate];
                                 //                _navigationController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
                             }
                             
                         }
                         else {
                             [self.viewController checkForUpdate];
                             //            _navigationController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
                         }
                     }
                     
                 }
                 
             }
             
             ];
            
            
        }
    }
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
-(void)deleteExistingCoredataManagedObject{
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    
}
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LdcCoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    [self createEditableCopyOfDatabaseIfNeeded];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by: 
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
    
    NSUserDefaults *userDefaultObj = [NSUserDefaults standardUserDefaults];
    [userDefaultObj setValue:@"United States" forKey:KeyWeatherAPICountry];
    [userDefaultObj setValue:@"Eastern Standard Time" forKey:KeyWeatherAPITimeZone];
    [userDefaultObj setValue:@"Berlin" forKey:KeyWeatherAPICity];
    [userDefaultObj synchronize];
    
	if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
        
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
	}
}
- (void)createTemporaryEditableCopyOfDatabaseIfNeeded{
    
    
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel_Temp.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
        
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
	}
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
