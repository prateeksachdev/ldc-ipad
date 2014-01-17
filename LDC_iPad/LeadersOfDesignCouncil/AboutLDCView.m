//
//  AboutLDCView.m
//  SampleLdc
//
//  Created by Mobikasa on 1/21/13.
//  Copyright (c) 2013 Mobikasa. All rights reserved.
//

#import "AboutLDCView.h"
#import "Constants.h"
#import "GalleryView.h"
#import "HouzzView.h"
#import "AbotLdcImageGallery.h"
#import "AboutLdcNewsLetter.h"
#import "AboutLdcInfo.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import "InAppBrowser.h"
//#import "FacebookPostViewController.h"
#import <AddressBook/AddressBook.h>

#import "PdfReaderViewController.h"


//Xib changed by Umesh to make the whole left view scrollable


@implementation AboutLDCView
@synthesize titleLabel,addressLabel,summaryAbout,galleryLabel,kiethLabel,meganLabel,foundersLabel,facebookButton,twitterButton,pinterestButton,addToContactsButton,houzzButton,galleryPhotoScrollView,delegate,selectorFaceBookAction,selectorTwitterAction,newsLabels,newsLetterScrollview,galleryPhotoArray,textViewScrollView,photoCreditsLabel,selectorToHideUnhideToolBarView,newsLettersArray,aboutLdcArray,aboutLdcDictionary,selectorShareEmailAction,selectorNewsLetterAction,kiethImageView,kiethButton,meganButton,meganImageView,selectorFounderClicked,arrayofFounders;
@synthesize selectorShareImageViaEmailAction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"AboutLDCView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        

        
    }
   

    return self;
}


-(void)setAboutLDCView{
    
    foundersLabel.font=[UIFont fontWithName:FontBold size:10];
    foundersLabel.textColor=kGrayColor;
    galleryLabel.font=[UIFont fontWithName:FontBold size:10];
    galleryLabel.textColor=kGrayColor;
    newsLabels.font=[UIFont fontWithName:FontBold size:10];
    newsLabels.textColor=kGrayColor;
    titleLabel.font=[UIFont fontWithName:FontRegular size:14];
    titleLabel.textColor=kGrayColor;
    addressLabel.font=[UIFont fontWithName:FontRegular size:14];
    addressLabel.textColor=kGrayColor;
    kiethLabel.font=[UIFont fontWithName:FontRegular size:14];
    kiethLabel.textColor=kGrayColor;
    meganLabel.font=[UIFont fontWithName:FontRegular size:14];
    meganLabel.textColor=kGrayColor;
    photoCreditsLabel.font=[UIFont fontWithName:FontBold size:10];
    photoCreditsLabel.textColor=kLightWhiteColor;
    summaryAbout.font=[UIFont fontWithName:FontLight size:14];
    summaryAbout.textColor=kGrayColor;
    emailLabel.font = [UIFont fontWithName:FontLight size:14];
    emailLabel.textColor = kGrayColor;
    
    websiteLabel.textColor = kGrayColor;
    websiteLabel.font =[UIFont fontWithName:FontLight size:14];
    
    photoCreditsTextView.textColor = kGrayColor;
    photoCreditsTextView.font=[UIFont fontWithName:FontLight size:14];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
//    self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequest:@"AbotLdcImageGallery":@"imageId" :appDelegate.managedObjectContext];
    self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequestForEntity:@"AbotLdcImageGallery" withSortDecs:@"imagePosition" forManagedObj:appDelegate.managedObjectContext];
    
    self.arrayofFounders=[[CoreDataOprations initObject]fetchRequestAccordingtoFounderCategory:@"Memebers" :@"mId" :@"mFounder" :[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:TRUE]]:appDelegate.managedObjectContext];
    if ([self.arrayofFounders count]!=0) {
        
        Memebers *memberObj=[self.arrayofFounders objectAtIndex:0];
        
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mThumbImage];
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            kiethImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
            
        }
        else {
            
            kiethImageView.image=[UIImage imageNamed:memberObj.mThumbImage];
            
        }
        
        kiethLabel.text=[NSString stringWithFormat:@"%@ %@", memberObj.mName,memberObj.mLastName];;
        
        if ([self.arrayofFounders count]>1) {
            
            Memebers *memberObj=[self.arrayofFounders objectAtIndex:1];
            
            NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mThumbImage];
            if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                
                meganImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
                
            }
            else if([UIImage imageNamed:memberObj.mThumbImage]){
                
                meganImageView.image=[UIImage imageNamed:memberObj.mThumbImage];
                
            }
            else{
                meganImageView.image=[UIImage imageNamed:@"thumb-background.png"];
            }
            meganLabel.text=[NSString stringWithFormat:@"%@ %@", memberObj.mName,memberObj.mLastName];
            
        }
        else {
            
            meganImageView.hidden=YES;
            meganLabel.hidden=YES;
            meganButton.hidden=YES;
        }
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
        else if ([UIImage imageNamed:aboutLdcImageGalleryObj.imageName]) {
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
    
    
    
    self.newsLettersArray=[[CoreDataOprations initObject] fetchRequest:@"AboutLdcNewsLetter":@"newsletterId" :appDelegate.managedObjectContext];
    
    int noOfRows = 0;
    
    if ([self.newsLettersArray count]%3==0)
    {
        noOfRows= [self.newsLettersArray count]/3;
    }
    else
    {
        noOfRows= [self.newsLettersArray count]/3;
        noOfRows=noOfRows+1;
    }
    
    newsLetterScrollview.contentSize=CGSizeMake(222,noOfRows*101);
    
    for (int i=0; i<[self.newsLettersArray count]; i++)
    {
        AboutLdcNewsLetter *aboutLdcNewsLetterObj=[self.newsLettersArray objectAtIndex:i];
        
        int rowYPosition=i/3;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake((i%3)*76,rowYPosition*101, 46, 89)];
        UIButton *newsLetterButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [newsLetterButton setFrame:CGRectMake(0,0, 42, 55)];
        NSArray *tempArray = [aboutLdcNewsLetterObj.newsletterName componentsSeparatedByString:@"."];
        
        NSString *path =   [[NSBundle mainBundle] pathForResource:[tempArray objectAtIndex:0] ofType:@"pdf"];
//        UIImage *tempImage = [UIImage imageWithContentsOfFile:path];
         NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",aboutLdcNewsLetterObj.newsletterName];
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            [newsLetterButton setBackgroundImage:[UIImage imageWithContentsOfFile:imageNameWithPath] forState:UIControlStateNormal];
            
        }
        else if ([UIImage imageWithContentsOfFile:path]) {
            [newsLetterButton setBackgroundImage:[UIImage imageNamed:aboutLdcNewsLetterObj.newsletterName] forState:UIControlStateNormal];
        }
        else {
            
            [newsLetterButton setBackgroundImage:[UIImage imageNamed:@"ldcpng.png"] forState:UIControlStateNormal];
            
        }
        
        [newsLetterButton addTarget:self action:@selector(newLetterButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [newsLetterButton setTag:i];
        UILabel *newDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, 70, 21)];
        newDateLabel.font=[UIFont fontWithName:FontBold size:10];
        newDateLabel.textColor=kGrayColor;
        NSDateFormatter *dateFormatterObj = [[NSDateFormatter alloc] init];
        [dateFormatterObj setDateFormat:@"MMMM"];
        NSDate *month = [dateFormatterObj dateFromString:aboutLdcNewsLetterObj.month];
        [dateFormatterObj setDateFormat:@"MMM"];
        NSString *monthStr = [dateFormatterObj stringFromDate:month];
//        NSLog(@"Umesh month hai ye:%@",monthStr);
        //NSString *str=aboutLdcNewsLetterObj.month;
        newDateLabel.text=[NSString stringWithFormat:@"%@ %@",[monthStr uppercaseString],aboutLdcNewsLetterObj.year];
        newDateLabel.backgroundColor=[UIColor clearColor];
        [view addSubview:newsLetterButton];
        [view addSubview:newDateLabel];
        [newsLetterScrollview addSubview:view];
    }
//    self.aboutLdcArray=[[CoreDataOprations initObject]fetchRequest:@"AboutLdcInfo":@"telephone":appDelegate.managedObjectContext];
    self.aboutLdcArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"AboutLdcInfo" withSortDecs:@"telephone" forManagedObj:appDelegate.managedObjectContext];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    self.summaryAbout.text=aboutInfoObj.aboutDescription;
    
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
    
    CGSize newSize;
    CGRect newFrame;
    
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
    newFrame.origin.y = emailButton.frame.origin.y + emailButton.frame.size.height + 5;
    websiteLabel.frame = newFrame;
    websiteButton.frame = websiteLabel.frame;
    
    
//    CGSize newSize;
//    CGRect newFrame;
    
    newSize =[aboutInfoObj.aboutDescription sizeWithFont:self.summaryAbout.font constrainedToSize:CGSizeMake(500,1024) lineBreakMode:NSLineBreakByWordWrapping];
    self.summaryAbout.frame=CGRectMake(self.summaryAbout.frame.origin.x,websiteLabel.frame.origin.y + websiteLabel.frame.size.height + 27,590,newSize.height);
    newFrame=self.summaryAbout.frame;
    
    self.photoCreditsLabel.frame=CGRectMake(5, newFrame.origin.y + newFrame.size.height+44,97, 21);
    newFrame.size.height=self.summaryAbout.frame.origin.y+newFrame.size.height+44+21+24;
    int yPos=newFrame.size.height;
    NSArray *arr=(NSArray *)aboutInfoObj.photoCredits;
    NSString *photoCreditesString = [arr objectAtIndex:0];
    if ([photoCreditesString length]<1) {
        self.photoCreditsLabel.hidden=YES;
        photoCreditsTextView.text = @"";
    }
    else{
        self.photoCreditsLabel.hidden=NO;
        photoCreditsTextView.text = [arr objectAtIndex:0];
        
        
        newSize =[photoCreditsTextView.text sizeWithFont:photoCreditsTextView.font constrainedToSize:CGSizeMake(500,1024) lineBreakMode:NSLineBreakByWordWrapping];
        photoCreditsTextView.frame=CGRectMake(photoCreditsTextView.frame.origin.x,yPos,590,newSize.height+30);
        yPos = yPos +newSize.height+30;
        
    }
    
   
    //        newFrame=photoCreditsLabel.frame;
    
    
    // Added if condition to check if object at index contain value or not
    //        for (int j=0; j<[arr count]; j++) {
    //            if ([[arr objectAtIndex:j] length]>0) {
    //                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, yPos,420, 28)];
    //                [textViewScrollView addSubview:label];
    //                label.text=[NSString stringWithFormat:@". %@",[arr objectAtIndex:j]];
    //                label.backgroundColor=[UIColor clearColor];
    //                label.textColor=kDarkGrayColor;
    //                label.font=[UIFont fontWithName:FontLight size:14];
    //                yPos=yPos+28+12;
    //            }
    //        }
    
    //increased the content size by 95 as increased the scroll view width and also moved the label to it.
    yPos += 95;
    self.textViewScrollView.contentSize=CGSizeMake(590, yPos);
//    NSLog(@"aboutInfoObj.twitter %@", aboutInfoObj.twitter);
    
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
    if ([aboutInfoObj.telephone isEqualToString:@""]) {
        addToContactsButton.enabled=FALSE;
    }
    else{
         addToContactsButton.enabled=TRUE;
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

-(IBAction)faceButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    if (![aboutInfoObj.facebook isEqualToString:@""]) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    inAppbrowserObj.titleLabel.text=@"FACEBOOK";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.alpha=1.0;
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
    {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
    }
    if ([aboutInfoObj.facebook hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.facebook];
    } else {
       inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.facebook]];
    }
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }


}
-(IBAction)twitterButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
//    NSLog(@"showurl:%@",aboutInfoObj.twitter);
    if (aboutInfoObj.twitter) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    
    inAppbrowserObj.titleLabel.text=@"Twitter";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.alpha=1.0;
       if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
    {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
    }
    if ([aboutInfoObj.twitter hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.twitter];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.twitter]];
    }

    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
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
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
    inAppbrowserObj.titleLabel.text=@"Pinterest";
    inAppbrowserObj.delegate=self;
    inAppbrowserObj.alpha=1.0;
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
    {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
    }
    if ([aboutInfoObj.pinterest hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.pinterest];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.pinterest]];
    }
//    NSLog(@"in:%@",inAppbrowserObj.showURL);
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];

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
    inAppbrowserObj.alpha=1.0;
    [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
    {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
    }
    if ([aboutInfoObj.houzz hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:aboutInfoObj.houzz];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",aboutInfoObj.houzz]];
    }
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
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
//    ABRecordSetValue(newPerson, kABPersonFirstNameProperty,@"LDC", nil);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"The Leaders Of Design Council", nil);
//    ABRecordSetValue(newPerson, kABPersonImageFormatThumbnail, (__bridge CFTypeRef)([UIImage imageNamed:@"Icon.png"]), nil);
    //ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"Mocha.co",nil);
    // ABRecordSetValue(newPerson, kABPersonPhoneProperty, @"9994686908", nil);
    CFStringRef phoneNumberValue = (CFStringRef) (__bridge CFTypeRef)(aboutLdcObj.telephone);
    CFStringRef phoneNumberLabel = (CFStringRef)@"mobile";
    
    UIImage *im = [UIImage imageNamed:@"Icon.png"];
    NSData *dataRef = UIImagePNGRepresentation(im);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);
    
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
        
    }}


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
    
    //Added by Umesh to hide bottom tool bar when gallery view is added
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
    }
    [self addSubview:galleryViewObj];
}
-(void)shareFaceBook:(NSString *)str
{
    if ([delegate respondsToSelector:selectorFaceBookAction])
    {
        [delegate performSelector:selectorFaceBookAction withObject:str afterDelay:0.0];
    }
}
-(void)shareTwitterAction:(NSString *)str
{
    if ([delegate respondsToSelector:selectorTwitterAction])
    {
        [delegate performSelector:selectorTwitterAction withObject:str afterDelay:0.0];
    }    
}
-(void)shareEmailAction:(NSArray *)obj
{
    if ([delegate respondsToSelector:selectorShareImageViaEmailAction])
    {
        [delegate performSelector:selectorShareImageViaEmailAction withObject:obj afterDelay:0.0];
    }
    
}
-(IBAction)emailButtonClicked:(id)sender{
    if ([delegate respondsToSelector:selectorShareEmailAction])
    {
        [delegate performSelector:selectorShareEmailAction withObject:[NSArray arrayWithObject:emailLabel.text] afterDelay:0.0];
    }
    
}
-(IBAction)websiteButtonClicked:(id)sender{
    
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
        inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
        [inAppbrowserObj setSelectorClose:@selector(showBottomToolBar)];
        aboutInfoObj=[self.aboutLdcArray objectAtIndex:0];
        
    inAppbrowserObj.titleLabel.text=websiteLabel.text;
    inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://leadersofdesign.com/"]];
        inAppbrowserObj.delegate=self;
        inAppbrowserObj.alpha=1.0;
        if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
        {
            [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
        }        
        [inAppbrowserObj loadWebRequest];
        [self addSubview:inAppbrowserObj];
        [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    
}

-(void)galleryHandleLeft
{
    if (galleryViewObj)
    {

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
    if (galleryViewObj)
    {
        
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
//Added By Umesh to get the event of closed button clicked (of gallery view)
-(void)showBottomToolBar
{
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"False" afterDelay:0.0];
    }
}
-(void)newLetterButton_Clicked:(id)sender{
//    NSLog(@"pdf file name : %@",pdfFileName);
    AboutLdcNewsLetter *aboutNewsLetterObj=[self.newsLettersArray objectAtIndex:[sender tag]];
    if ([delegate respondsToSelector:selectorNewsLetterAction])
    {
        [delegate performSelector:selectorNewsLetterAction withObject:aboutNewsLetterObj.newsletterName
                       afterDelay:0.0];
    }
        
}

-(IBAction)founderClicked:(id)sender
{

    if ([delegate respondsToSelector:selectorFounderClicked]) {
        
    NSMutableDictionary *dictionOfObjects=[[NSMutableDictionary alloc]init];
    [dictionOfObjects setValue:self.arrayofFounders forKey:@"Array"];
    [dictionOfObjects setValue:sender forKey:@"membertag"];
        if ([delegate respondsToSelector:selectorFounderClicked]) {
            [delegate performSelector:selectorFounderClicked withObject:dictionOfObjects afterDelay:0.0];
        }
    }
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
