//
//  AboutLdcViewController.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/4/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "AboutLdcViewController.h"
#import "Constants.h"
#import "Social/Social.h"
#import "CoreDataOprations.h"
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import "MemberBioViewList.h"
#import "MemberBioView.h"
#import "Memebers.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
@interface AboutLdcViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation AboutLdcViewController
@synthesize titleLabel,addressLabel,summaryAbout,galleryLabel,kiethLabel,meganLabel,foundersLabel,facebookButton,twitterButton,pinterestButton,addToContactsButton,houzzButton,galleryPhotoScrollView,backButton,delegate,selectorFaceBookAction,selectorTwitterAction,galleryPhotoArray,textViewScrollView,aboutLdcArray,arrayofFounders,meganImageView,kiethImageView,meganButton,kiethButton;

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

//    self.textViewScrollView.contentSize=CGSizeMake(590, newFrame.size.height);
    
[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    foundersLabel.font=[UIFont fontWithName:FontBold size:10];
    foundersLabel.textColor=kGrayColor;
    galleryLabel.font=[UIFont fontWithName:FontBold size:10];
    galleryLabel.textColor=kGrayColor;
    titleLabel.font=[UIFont fontWithName:FontRegular size:14];
    titleLabel.textColor=kGrayColor;
    addressLabel.font=[UIFont fontWithName:FontRegular size:14];
    addressLabel.textColor=kGrayColor;
    kiethLabel.font=[UIFont fontWithName:FontRegular size:10];
    kiethLabel.textColor=kGrayColor;
    meganLabel.font=[UIFont fontWithName:FontRegular size:10];
    meganLabel.textColor=kGrayColor;
    summaryAbout.font=[UIFont fontWithName:FontLight size:14];
    summaryAbout.textColor=kGrayColor;
    photoCreditsLabel.font=[UIFont fontWithName:FontBold size:10];
    photoCreditsLabel.textColor=kLightWhiteColor;
    
    emailLabel.font = [UIFont fontWithName:FontLight size:14];
    emailLabel.textColor = kGrayColor;
    
    photoCreditsTextView.textColor = kGrayColor;
    photoCreditsTextView.font=[UIFont fontWithName:FontLight size:14];
    
    websiteLabel.textColor = kGrayColor;
    websiteLabel.font =[UIFont fontWithName:FontLight size:14];
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequest:@"AbotLdcImageGallery":@"imageId" :appDelegate.managedObjectContext];
    
    
    self.arrayofFounders=[[CoreDataOprations initObject]fetchRequestAccordingtoFounderCategory:@"Memebers" :@"mId" :@"mFounder" :[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]]:appDelegate.managedObjectContext];
    
    //    NSLog(@"%@",[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]]);
    
    if ([self.arrayofFounders count]!=0) {
        
        Memebers *memberObj=[self.arrayofFounders objectAtIndex:0];
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mThumbImage];
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            kiethImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
            
        }
        else {
            
            kiethImageView.image=[UIImage imageNamed:memberObj.mThumbImage];
            
        }
        
        kiethLabel.text=memberObj.mName;
        
        if ([self.arrayofFounders count]>1) {
            
            Memebers *memberObj=[self.arrayofFounders objectAtIndex:1];
             NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mThumbImage];
            if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                
                meganImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
                
            }
            else {
                
                meganImageView.image=[UIImage imageNamed:memberObj.mThumbImage];
                
            }
            meganLabel.text=memberObj.mName;
            
        }
        else {
            
            meganImageView.hidden=YES;
            meganLabel.hidden=YES;
            meganButton.hidden=YES;
        }
    }
    
    
    if ([self.galleryPhotoArray count]==0) {
        self.galleryLabel.hidden=YES;
    }
    else{
        self.galleryLabel.hidden=NO;
    }
    int noOfRow = 0;
    
    if ([self.galleryPhotoArray count]%5==0)
    {
        noOfRow= [self.galleryPhotoArray count]/5;
    }
    else
    {
        noOfRow= [self.galleryPhotoArray count]/5;
        noOfRow=noOfRow+1;
    }
    
    galleryPhotoScrollView.contentSize=CGSizeMake(275,noOfRow*55);
    
    for (int i=0; i<[self.galleryPhotoArray count]; i++)
    {
        AbotLdcImageGallery *aboutLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
        
        int rowYPosition=i/5;
        
        UIButton *galleryPhotoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [galleryPhotoButton setFrame:CGRectMake((i%5)*60,rowYPosition*55, 42, 42)];
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",aboutLdcImageGalleryObj.imageName];
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            [galleryPhotoButton setBackgroundImage:[UIImage imageWithContentsOfFile:imageNameWithPath] forState:UIControlStateNormal];
            
        }
        else if ([UIImage imageNamed:aboutLdcImageGalleryObj.imageName] ){
            [galleryPhotoButton setBackgroundImage:[UIImage imageNamed:aboutLdcImageGalleryObj.imageName] forState:UIControlStateNormal];
        }
        else {
            
            [galleryPhotoButton setBackgroundImage:[UIImage imageNamed:@"thumb-background.png"] forState:UIControlStateNormal];
        }
        galleryPhotoButton.backgroundColor = [UIColor darkTextColor];
        galleryPhotoButton.contentMode = UIViewContentModeScaleAspectFit;
        [galleryPhotoButton addTarget:self action:@selector(galleryPhotoButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [galleryPhotoButton setTag:i];
        
        [galleryPhotoScrollView addSubview:galleryPhotoButton];
    }
    
    
    self.aboutLdcArray=[[CoreDataOprations initObject]fetchRequest:@"AboutLdcInfo":@"telephone":appDelegate.managedObjectContext];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    self.summaryAbout.text=aboutInfoObj.aboutDescription;
    CGSize newSize;
    CGRect newFrame;
    
    
    NSString *telephoneNumber= aboutInfoObj.telephone;
    telephoneNumber = [telephoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    telephoneNumber = [telephoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([telephoneNumber length]>9) {
        
        if (![[telephoneNumber substringToIndex:1] isEqualToString:@"("]) {
            telephoneNumber = [NSString stringWithFormat:@"(%@) %@.%@",[telephoneNumber substringToIndex:3],[[telephoneNumber substringFromIndex:3] substringToIndex:3],[telephoneNumber substringFromIndex:6]];
            //            dummyTelephoneNumber = [NSString stringWithFormat:@"(%@) %@",[dummyTelephoneNumber substringToIndex:3],[dummyTelephoneNumber substringFromIndex:3]];
        }
    }
    NSString *addressString = @"";
    if (aboutInfoObj.address && [aboutInfoObj.address length]>0 && ![aboutInfoObj.address isEqualToString:@"null"]) {
        addressString = aboutInfoObj.address;
    }
    
//    CGSize newSize;
//    CGRect newFrame;
    
    addressLabel.text = [NSString stringWithFormat:@"%@\nt %@",addressString,telephoneNumber];
    newSize =[addressLabel.text sizeWithFont:addressLabel.font constrainedToSize:addressLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = addressLabel.frame;
    //    newFrame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + 24;
    newFrame.size.height = newSize.height;
    
    addressLabel.frame = newFrame;
    
    
    emailLabel.text = aboutInfoObj.email;
    newFrame = emailLabel.frame;
    newFrame.origin.y = addressLabel.frame.origin.y + addressLabel.frame.size.height;
    emailLabel.frame = newFrame;
    emailButton.frame = emailLabel.frame;
    
    websiteLabel.text = aboutInfoObj.website;
    
    newFrame = websiteLabel.frame;
//    NSLog(@"emailLabel.frame.origin.y : %f",emailLabel.frame.origin.y);
//    NSLog(@" emailLabel.frame.size.height : %f", emailLabel.frame.size.height);
//    NSLog(@"emailButton.frame.origin.y : %f",emailButton.frame.origin.y);
//    NSLog(@" emailButton.frame.size.height : %f", emailButton.frame.size.height);
    newFrame.origin.y = emailLabel.frame.origin.y + emailLabel.frame.size.height + 5;
    websiteLabel.frame = newFrame;
    websiteButton.frame = websiteLabel.frame;
    
    
    
    newSize =[aboutInfoObj.aboutDescription sizeWithFont:self.summaryAbout.font constrainedToSize:CGSizeMake(500,1024) lineBreakMode:NSLineBreakByWordWrapping];
    self.summaryAbout.frame=CGRectMake(self.summaryAbout.frame.origin.x,self.summaryAbout.frame.origin.y,590,newSize.height);
    newFrame=self.summaryAbout.frame;
    
    photoCreditsLabel.frame=CGRectMake(5, newFrame.origin.y + newFrame.size.height+44,97, 21);
    newFrame.size.height=self.summaryAbout.frame.origin.y+newFrame.size.height+44+21+24;
    int yPos=newFrame.size.height;
    NSArray *arr=(NSArray *)aboutInfoObj.photoCredits;
    NSString *photoCreditesString = [arr objectAtIndex:0];
    if ([photoCreditesString length]<1) {
        photoCreditsLabel.hidden=YES;
         photoCreditsTextView.text = @"";
    }
    else{
        photoCreditsLabel.hidden=NO;
        photoCreditsTextView.text = [arr objectAtIndex:0];
        
        
        newSize =[photoCreditsTextView.text sizeWithFont:photoCreditsTextView.font constrainedToSize:CGSizeMake(500,1024) lineBreakMode:NSLineBreakByWordWrapping];
        photoCreditsTextView.frame=CGRectMake(photoCreditsTextView.frame.origin.x,yPos,590,newSize.height+30);
        yPos = yPos +newSize.height+30;
        
    }
    
    // Added if condition to check if object at index contain value or not
    //    for (int j=0; j<[arr count]; j++) {
    //        if ([[arr objectAtIndex:j] length]>0) {
    //            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, yPos,420, 28)];
    //            [textViewScrollView addSubview:label];
    //            label.text=[NSString stringWithFormat:@". %@",[arr objectAtIndex:j]];
    //            label.backgroundColor=[UIColor clearColor];
    //            label.textColor=kDarkGrayColor;
    //            label.font=[UIFont fontWithName:FontLight size:14];
    //            yPos=yPos+28+12;
    //        }
    //    }
    //increased the content size by 95 as increased the scroll view width and also moved the label to it.
    yPos += 95;
    self.textViewScrollView.contentSize=CGSizeMake(590, yPos);
    
    
    
    
    
    
    
    
    
    
    if ([aboutInfoObj.facebook isEqualToString:@""]){
        facebookButton.enabled=FALSE;
    }
    else{
        facebookButton.enabled=TRUE;
    }
    if ([aboutInfoObj.twitter isEqualToString:@""]){
        twitterButton.enabled=FALSE;
    }
    else{
        twitterButton.enabled=TRUE;
    }
    if ([aboutInfoObj.houzz isEqualToString:@""]){
        houzzButton.enabled=FALSE;
    }
    else{
        houzzButton.enabled=TRUE;
    }
    if ([aboutInfoObj.pinterest isEqualToString:@""]){
        pinterestButton.enabled=FALSE;
    }
    else{
        pinterestButton.enabled=TRUE;
    }
    if ([aboutInfoObj.telephone isEqualToString:@""]) {
        addToContactsButton.enabled=FALSE;
    }
    
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
-(IBAction)twitterButtonAction:(id)sender;
{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    if (aboutInfoObj.twitter) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.alpha=1.0;
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    
    inAppbrowserObj.titleLabel.text=@"Twitter";
    inAppbrowserObj.delegate=self;
   
    if ([aboutInfoObj.twitter hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.twitter];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.twitter]];
    }
    
    [inAppbrowserObj loadWebRequest];
    [self.view addSubview:inAppbrowserObj];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }
    
}
-(IBAction)faceButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil; 
        
    }
    if (aboutInfoObj.facebook) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    inAppbrowserObj.alpha=1.0;
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    inAppbrowserObj.titleLabel.text=@"FACEBOOK";
    inAppbrowserObj.delegate=self;
       if ([aboutInfoObj.facebook hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.facebook];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.facebook]];
    }
    [inAppbrowserObj loadWebRequest];
    [self.view addSubview:inAppbrowserObj];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }
    
}


-(IBAction)pinterestButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    if (aboutInfoObj.pinterest) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    inAppbrowserObj.alpha=1.0;
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    inAppbrowserObj.titleLabel.text=@"Pinterest";
    inAppbrowserObj.delegate=self;
    if ([aboutInfoObj.facebook hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.pinterest];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.pinterest]];
    }
    [inAppbrowserObj loadWebRequest];
    [self.view addSubview:inAppbrowserObj];
    }else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];

    }

}
-(IBAction)addContactButtonAction:(id)sender{
    float currentVersion = 6.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookRequestAccessWithCompletion != NULL) {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                    // First time access has been granted, add the contact
                    if (granted) {
                        [self addContanctInAddressBook];
                    }
                    else{
                        UIAlertView *alertContactCannotBeSaved = [[UIAlertView alloc] initWithTitle:@"Error Saving Contact" message:@"You cannot access contacts . Please change privacy setting in setting app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertContactCannotBeSaved show];
                    }
                    
                    
                    //                    [self _addContactToAddressBook];
                });
            }
            else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                // The user has previously given access, add the contact
                //                [self _addContactToAddressBook];
//                NSLog(@"add>>>");
                [self addContanctInAddressBook];
            }
            else {
                
//                NSLog(@"change settings>>>");
                UIAlertView *alertContactCannotBeSaved = [[UIAlertView alloc] initWithTitle:@"Error Saving Contact" message:@"You previously denied the access to contact. Please change privacy setting in setting app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertContactCannotBeSaved show];
                // The user has previously denied access
                // Send an alert telling user to change privacy setting in settings app
            }
        }
    }
    else{
        [self addContanctInAddressBook];
    }
}
 -(void)addContanctInAddressBook{
    CFErrorRef error = NULL;
    AboutLdcInfo *aboutLdcObj=[self.aboutLdcArray objectAtIndex:0];
     ABAddressBookRef iPhoneAddressBook ;
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
     {
         iPhoneAddressBook= ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
     }else{
         iPhoneAddressBook= ABAddressBookCreate();
     }
    ABRecordRef newPerson = ABPersonCreate();
//    ABRecordSetValue(newPerson, kABPersonFirstNameProperty,@"The Leaders Of Design Council", nil);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"The Leaders Of Design Council",nil);
     
     UIImage *im = [UIImage imageNamed:@"Icon.png"];
     NSData *dataRef = UIImagePNGRepresentation(im);
     ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);
     
     
    // ABRecordSetValue(newPerson, kABPersonPhoneProperty, @"9994686908", nil);
    CFStringRef phoneNumberValue = (CFStringRef) (__bridge CFTypeRef)(aboutLdcObj.telephone);
    CFStringRef phoneNumberLabel = (CFStringRef)@"mobile";
    
    ABMutableMultiValueRef phoneNumber = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    
    ABMultiValueAddValueAndLabel(phoneNumber, phoneNumberValue, phoneNumberLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, phoneNumber, NULL);
    CFRelease(phoneNumber);
    
    ABMutableMultiValueRef multiURL = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	ABMultiValueAddValueAndLabel(multiURL,(__bridge CFTypeRef)(aboutLdcObj.website), kABPersonHomePageLabel, NULL);
	ABRecordSetValue(newPerson, kABPersonURLProperty, multiURL, &error);
	CFRelease(multiURL);
    
	ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail,(__bridge CFTypeRef)(aboutLdcObj.email), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
	CFRelease(multiEmail);
    
    CFArrayRef people;
    people= ABAddressBookCopyPeopleWithName(iPhoneAddressBook, (CFStringRef)@"The Leaders Of Design Council");
    int exist_flag = 0;
    if ((people != nil) && (CFArrayGetCount(people) != 0))
    {
		for (int i=0; i<CFArrayGetCount(people); i++) {
			
			ABRecordRef person = CFArrayGetValueAtIndex(people, i);
			
			ABMultiValueRef exist_multiPhone = ABRecordCopyValue(person, kABPersonPhoneProperty);
			//CFTypeRef tmp_main_phone = ABRecordCopyValue (person, kABPersonPhoneMainLabel);
			
			NSString *tmp_telePhone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(exist_multiPhone, 0);
			
			//NSLog(@"%@ - %@", tmp_telePhone, telephoneLabel.titleLabel.text);
			
			if ([tmp_telePhone isEqualToString:aboutLdcObj.telephone]) {
				exist_flag = 1;
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@" Contact Already Exist in your contacts."
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
            }
			
		}
		
	}
    if (exist_flag == 0) {
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
        ABAddressBookSave(iPhoneAddressBook, &error);
        
        if (error != NULL)
        {
        }
        else {
            //ContactConfirmation *cc= [[ContactConfirmation alloc] init];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@" The Leaders Of Design Council has been added to your contacts."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
}
-(IBAction)houzzButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    if (aboutInfoObj.houzz) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    inAppbrowserObj.titleLabel.text=@"Houzz";
    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
       if ([aboutInfoObj.houzz hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.houzz];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.houzz]];
    }
    inAppbrowserObj.alpha=1.0;
    [inAppbrowserObj loadWebRequest];
    [inAppbrowserObj loadWebRequest];
    [self.view addSubview:inAppbrowserObj];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }
}
-(IBAction)backAction:(id)sender{
    [[self navigationController]popToRootViewControllerAnimated:YES];
 }

-(void)galleryPhotoButton_Clicked:(id)sender
{
    pageIndex=0;
    UIButton *button=(UIButton *)sender;
    if (galleryViewObj)
    {
        galleryViewObj=nil;
    }
    
    galleryViewObj=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    galleryViewObj.galleryPhotoArray=self.galleryPhotoArray;
    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([self.galleryPhotoArray count]*1024,728);
    [galleryViewObj setDelegate:self];
    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
    [galleryViewObj setSelectorCloseGallery:@selector(showBottomToolBar)];  //Added By Umesh to show bottom tool bar when gallery view is removed
    [galleryViewObj setSelectorFaceBookAction:@selector(shareFaceBook:)];
    [galleryViewObj setSelectorTwitterAction:@selector(shareTwitterAction:)];
    [galleryViewObj setSelectorEmailAction:@selector(shareEmailAction:)];
    galleryViewObj.pageIndex=button.tag;
    [galleryViewObj addAboutLdcImageGallery:button.tag];
    [self.view addSubview:galleryViewObj];
    
}
-(void)shareEmailAction:(NSArray *)emailIDArray{
    
//    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray array]];
    [mailComposer setSubject:@"Shared via the Leaders of Design Council"];
    
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
    
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
-(IBAction)emailButtonClicked:(id)sender{
    
//    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:[NSArray arrayWithObject:emailLabel.text]];
    [mailComposer setSubject:@""];
    
    // Use the document file name for the subject
    // [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[emailIDArray objectAtIndex:0]] mimeType:@".png" fileName:@"ShareImage"];
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
-(IBAction)websiteButtonClicked:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.titleLabel.text=websiteLabel.text;
    inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://leadersofdesign.com/"]];
    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
    [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
    [inAppbrowserObj loadWebRequest];
    [self.view addSubview:inAppbrowserObj];
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)shareTwitterAction:(NSString *)str{
    float currentVersion = 6.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
            SLComposeViewController *twController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//            {
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
        
                
                [twController setInitialText:@"Shared via the Leaders of Design Council"];
                UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
                if (!imageObj) {
                    imageObj = [UIImage imageNamed:str];
                }
                [twController addImage:imageObj];
                
                
//                [twController setInitialText:@"Check out this article."];
//                [twController addURL:[NSURL URLWithString:@"http://www.mobikasa.com/"]];
               [twController setCompletionHandler:completionHandler];
                [self presentViewController:twController animated:YES completion:nil];
            }
    else{
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:@"Shared via the Leaders of Design Council"];
            
            UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
            if (!imageObj) {
                imageObj = [UIImage imageNamed:str];
            }
             [tweetSheet addImage:imageObj];
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
}
-(void)shareFaceBook:(NSString *)str{
    float currentVersion = 6.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        //                        NSLog(@"Running in IOS-6");
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    //                                    NSLog(@"Cancelled<><><><<>><>>>><><><><><<><><>,");
                    //                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MESSAGE" message:@"You cancelled posting the status." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    //
                    //                                    [alert show];
                    //                                    [alert release];
                    
                } else
                    
                {
                    //                                    NSLog(@"Done><><><<>><>>>><><><><><<");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MESSAGE" message:@"Successfully Posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alert show];
                }
                
            };
            fbSheet.completionHandler = myBlock;
//            [fbSheet setInitialText:@""];
            [fbSheet setInitialText:@"Shared via the Leaders of Design Council"];
            UIImage *imageObj = [UIImage imageWithContentsOfFile:str];
            if (!imageObj) {
                imageObj = [UIImage imageNamed:str];
            }
            [fbSheet addImage:imageObj];
            
            
//            if (shareImage)
//            {
//                [fbSheet addImage:shareImage];
//            }
//            
//            //                        if (self.FbString)
//            //                        {
//            //                            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
//            //                        }
//            if (!homeViewControllerObject) {
//                homeViewControllerObject = [HomeViewController sharedMaster];
//            }
//            [homeViewControllerObject removeOtherViews];
//            
//            //                            [homeViewControllerObject.middleView addSubview:fbSheet.view];
//            [homeViewControllerObject presentViewController:fbSheet animated:YES completion:nil];
                   [self presentViewController:fbSheet animated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
//    else{
//        
//        FacebookPostViewController *faceBookObject = [[FacebookPostViewController alloc]init];
//        faceBookObject.postString =FbString;
//        if (isImageAllowed) {
//            faceBookObject.shareImage = shareImage;
//            faceBookObject.isImageAllowed = YES;
//            
//        }

}

-(void)galleryHandleLeft{
    if (galleryViewObj) {
        
        if (pageIndex==[self.galleryPhotoArray count]) {
            
        }
        else {
            
            pageIndex++;
            
        }
        CGRect frame = galleryViewObj.galleryPhotoScrollView.frame;
        frame.origin.x = 573 * pageIndex;
        frame.origin.y = 0;
        [galleryViewObj.galleryPhotoScrollView scrollRectToVisible:frame animated:YES];
    }
}
-(void)galleryHandleRight{
    if (galleryViewObj) {
        
        if (pageIndex==[self.galleryPhotoArray count]) {
            
        }
        else {
            
            pageIndex--;
            
        }
        CGRect frame = galleryViewObj.galleryPhotoScrollView.frame;
        frame.origin.x = 573 * pageIndex;
        frame.origin.y = 0;
        [galleryViewObj.galleryPhotoScrollView scrollRectToVisible:frame animated:YES];
}
}
-(void)newLetterButton_Clicked:(id)sender{
    
}

-(IBAction)memberFounderButtonAction:(id)sender
{
    int selectIndex=[sender tag];
    
//    NSLog(@"tag=%d",[sender tag]);
    
      if (memberBioViewListObj)
      {
          [memberBioViewListObj removeFromSuperview];
          memberBioViewListObj=nil;
      }
    memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    memberBioViewListObj.publicBackButton.hidden=FALSE;
    memberBioViewListObj.publicBarImageView.hidden=FALSE;
    memberBioViewListObj.memberBioViewListScrollView.frame=CGRectMake(0, 54, 1024, 694);
    //   }
    [memberBioViewListObj setDelegate:self];
    for (UIView *subview in memberBioViewListObj.memberBioViewListScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }
    
    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    MemberBioViewObj1.Status=YES;
    MemberBioViewObj2.Status=YES;
    
    MemberBioViewObj1.arraySave=self.arrayofFounders;
    MemberBioViewObj2.arraySave=self.arrayofFounders;
    
    MemberBioViewObj1.galleryLabel.hidden=YES;
    MemberBioViewObj2.galleryLabel.hidden=YES;
    
    MemberBioViewObj1.closeButton.hidden=TRUE;
    MemberBioViewObj2.closeButton.hidden=TRUE;
    
    MemberBioViewObj1.galleryPhotoScrollView.hidden=YES;
    MemberBioViewObj2.galleryPhotoScrollView.hidden=YES;
    
    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj1 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];
    [MemberBioViewObj1 setIsFromPublicView:TRUE];
    
    int widthCount=[self.arrayofFounders count];
    
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj2 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];
    [MemberBioViewObj2 setIsFromPublicView:TRUE];
    
    
    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
    memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
    
    
    [memberBioViewListObj applyNewIndex:selectIndex totalCount:widthCount  pageController:MemberBioViewObj1];
    
    memberBioViewListObj.pageCount=[self.arrayofFounders count]-1;
    
    memberBioViewListObj.currentPage=MemberBioViewObj1;
    memberBioViewListObj.nextPage=MemberBioViewObj2;
    
    if ([sender tag]+1 <[self.arrayofFounders count]) {
        
        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex+1 totalCount:widthCount pageController:MemberBioViewObj2];
        
        
    }
    else if ([sender tag]-1 >=0)
    {
        
        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex-1 totalCount:widthCount pageController:MemberBioViewObj2];
        
    }
    
    CGRect frame = memberBioViewListObj.memberBioViewListScrollView.frame;
    frame.origin.x = frame.size.width *selectIndex;
    frame.origin.y = 0;
    //
    [memberBioViewListObj.memberBioViewListScrollView scrollRectToVisible:frame animated:NO];
    
    [self.view addSubview:memberBioViewListObj];
    
    [self fadeView:memberBioViewListObj fadein:YES timeAnimation:0.3];
    
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
