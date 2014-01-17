//
//  MemberBioView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MemberBioView.h"
#import "Constants.h"
#import "Memebers.h"
#import "InAppBrowser.h"
#import "MembersGallery.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
@implementation MemberBioView
@synthesize titlenameLabel,addressLabel,summaryAbout,galleryLabel,nameLabel,facebookButton,twitterButton,pinterestButton,addToContactsButton,houzzButton,memberPhotoImageView,galleryPhotoArray,closeButton,selectorTwitterAction,selectorShareGalleryImageEmailAction,selectorFacbookAction;
@synthesize viewPageIndex;
@synthesize delegate,selectorLeftArrowAction,selectorRightArrowAction,selectorCloseAction,Status,arraySave,galleryPhotoScrollView,selectorScrolling,selectorEmailAction,selectorToHideOrShowBottomBar,isFromPublicView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
       
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"MemberBioView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
//        facebookButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];        
//        [facebookButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
//        
//        twitterButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
//        [twitterButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
//        
//        pinterestButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
//        [pinterestButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
//        
//        houzzButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
//        [houzzButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
//        
//        addToContactsButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
//        [addToContactsButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];

        nameLabel.font=[UIFont fontWithName:FontRegular size:14];
        [nameLabel setTextColor:kGrayColor];
        
        galleryLabel.font=[UIFont fontWithName:FontBold size:10];
        [galleryLabel setTextColor:kGrayColor];
        
        titlenameLabel.font=[UIFont fontWithName:FontRegular size:30];
        [titlenameLabel setTextColor:kGrayColor];
        
        addressLabel.font=[UIFont fontWithName:FontRegular size:14];
        [addressLabel setTextColor:kGrayColor];
        
        emailLabel.font = [UIFont fontWithName:FontRegular size:14];
        [emailLabel setTextColor:kGrayColor];
        
        websiteURLLabel.font = [UIFont fontWithName:FontRegular size:14];
        [websiteURLLabel setTextColor:kGrayColor];
                
        summaryAbout.font=[UIFont fontWithName:FontLight size:14];
        [summaryAbout setTextColor:kGrayColor];

        closeButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        [closeButton setTitleColor:kGrayColor forState:UIControlStateNormal];

        
//        galleryPhotoArray=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"],[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"], nil];
        
    }
    return self;
}

-(void)memberGalleryThumb
{
    [self cleareScrollViewContent];
    
    if ([self.galleryPhotoArray count]==0) {
        
        
        galleryLabel.hidden=YES;
    }
    else {
        
        if (self.galleryPhotoScrollView.hidden) {
            
            galleryLabel.hidden=YES;

        }
        else {
        
        galleryLabel.hidden=NO;
            
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
    
    self.galleryPhotoScrollView.contentSize=CGSizeMake(275,noOfRow*55);
    
    for (int i=0; i<[self.galleryPhotoArray count]; i++)
    {
        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
        
        int rowYPosition=i/5;
        
        UIButton *galleryPhotoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [galleryPhotoButton setFrame:CGRectMake((i%5)*55,rowYPosition*55, 42, 42)];
      
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",membersGalleryObj.mgImageThumb];
//        NSLog(@"imageNameWithPath : %@",imageNameWithPath);
//        NSLog(@"membersGalleryObj.mgImageThumb : %@",membersGalleryObj.mgImageThumb);
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            [galleryPhotoButton setBackgroundImage:[UIImage imageWithContentsOfFile:imageNameWithPath] forState:UIControlStateNormal];
            
        }
        else if ([UIImage  imageNamed:membersGalleryObj.mgImageThumb]) {
            
            [galleryPhotoButton setBackgroundImage:[UIImage  imageNamed:membersGalleryObj.mgImageThumb] forState:UIControlStateNormal];
            
        }
        else{
                [galleryPhotoButton setBackgroundImage:[UIImage imageNamed:@"thumb-background.png"] forState:UIControlStateNormal];                 
        }
        
        
        [galleryPhotoButton addTarget:self action:@selector(galleryPhotoButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
              
        [galleryPhotoButton setTag:i];
        
        [self.galleryPhotoScrollView addSubview:galleryPhotoButton];
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

-(void)cleareScrollViewContent
{
    for (UIView __strong *subview in self.galleryPhotoScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
        subview = nil;
    }
    
}

-(IBAction)faceButtonAction:(id)sender{
//    NSLog(@"faceBookClicked");
   
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    if (memObj.mFacebook) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.titleLabel.text=@"FACEBOOK";
//    NSLog(@"memObj.mFacebook URL: %@",memObj.mFacebook);
    if ([memObj.mFacebook hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:memObj.mFacebook];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",memObj.mFacebook]];
    }

    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
    [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
    [inAppbrowserObj loadWebRequest];
 
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
    {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
    }
    
    if ([delegate respondsToSelector:selectorScrolling])
    {
        [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
        
    }
    
    [self addSubview:inAppbrowserObj];

    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }

  //  [self addSubview:inAppbrowserObj];
}
-(IBAction)twitterButtonAction:(id)sender{
//    NSLog(@"twitterclicked");
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
   
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    if (memObj.mTwitter) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.titleLabel.text=@"TWITTER";

    if ([memObj.mTwitter hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:memObj.mTwitter];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",memObj.mTwitter]];
    }

    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
    [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];

    [inAppbrowserObj loadWebRequest];
  
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
    {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
    }
    
    if ([delegate respondsToSelector:selectorScrolling])
    {
        [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
        
    }
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
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    if (memObj.mPinterest) {
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    inAppbrowserObj.titleLabel.text=@"PINTEREST";

    
    inAppbrowserObj.showURL=[NSURL URLWithString:memObj.mPinterest];
    if ([memObj.mPinterest hasPrefix:@"http://"]) {
        inAppbrowserObj.showURL= [NSURL URLWithString:memObj.mPinterest];
    } else {
        inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",memObj.mPinterest]];
    }

    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
    [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];

    [inAppbrowserObj loadWebRequest];
 
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
    {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
    }
    
    if ([delegate respondsToSelector:selectorScrolling])
    {
        [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
        
    }
    
    [self addSubview:inAppbrowserObj];

    
    [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }

 //   [self addSubview:inAppbrowserObj];
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
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    ABAddressBookRef iPhoneAddressBook ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        iPhoneAddressBook= ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
    }else{
        iPhoneAddressBook= ABAddressBookCreate();
    }
    ABRecordRef newPerson = ABPersonCreate();
   // NSString *contactPersonName =[NSString stringWithFormat:@"%@ %@",memObj.mName,memObj.mLastName];
   // ABRecordSetValue(newPerson, kABPersonFirstNameProperty,(__bridge CFTypeRef)(contactPersonName), nil);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty,(__bridge CFTypeRef)(memObj.mLastName), nil);
    ABRecordSetValue(newPerson, kABGroupNameProperty,(__bridge CFTypeRef)(memObj.mName), nil);

    ABRecordSetValue(newPerson, kABPersonOrganizationProperty,(__bridge CFTypeRef)(memObj.mCompany), nil);
    //ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"Mocha.co",nil);
    // ABRecordSetValue(newPerson, kABPersonPhoneProperty, @"9994686908", nil);
    CFStringRef phoneNumberValue = (CFStringRef) (__bridge CFTypeRef)(memObj.mTelephone);
    CFStringRef phoneNumberLabel = (CFStringRef)@"mobile";
    
    
    NSString *thumnailPath = [NSString stringWithFormat:@"%@/%@",[self documentCatchePath],memObj.mThumbImage];
    UIImage *imageObj = [UIImage imageWithContentsOfFile:thumnailPath];
    if (!imageObj) {
        imageObj = [UIImage imageNamed:memObj.mThumbImage];
    }
//    NSLog(@"imageObj  :%@",imageObj);
    NSData *dataRef = UIImagePNGRepresentation(imageObj);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);
    
    
    ABMutableMultiValueRef phoneNumber = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    
    ABMultiValueAddValueAndLabel(phoneNumber, phoneNumberValue, phoneNumberLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, phoneNumber, NULL);
    CFRelease(phoneNumber);
    
    ABMutableMultiValueRef multiURL = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	ABMultiValueAddValueAndLabel(multiURL,(__bridge CFTypeRef)(memObj.mWebsite), kABPersonHomePageLabel, NULL);
	ABRecordSetValue(newPerson, kABPersonURLProperty, multiURL, &error);
	CFRelease(multiURL);
    
	ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail,(__bridge CFTypeRef)(memObj.mEmail), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
	CFRelease(multiEmail);
    
    CFArrayRef people;
    people= ABAddressBookCopyPeopleWithName(iPhoneAddressBook, (__bridge CFStringRef)memObj.mLastName);
    int exist_flag = 0;
    if ((people != nil) && (CFArrayGetCount(people) != 0))
    {
		for (int i=0; i<CFArrayGetCount(people); i++) {
			
			ABRecordRef person = CFArrayGetValueAtIndex(people, i);
			
			ABMultiValueRef exist_multiPhone = ABRecordCopyValue(person, kABPersonPhoneProperty);
			//CFTypeRef tmp_main_phone = ABRecordCopyValue (person, kABPersonPhoneMainLabel);
			
			NSString *tmp_telePhone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(exist_multiPhone, 0);
			
			//NSLog(@"%@ - %@", tmp_telePhone, telephoneLabel.titleLabel.text);
			
			if ([tmp_telePhone isEqualToString:memObj.mTelephone]) {
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
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Added to contacts successfully."
                                                         delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }

    
    newPerson = nil;
}

-(IBAction)houzzButtonAction:(id)sender{
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    if (memObj.mHouzz) {
        inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
        inAppbrowserObj.titleLabel.text=@"HOUZZ";
        
        inAppbrowserObj.showURL=[NSURL URLWithString:memObj.mHouzz];
        if ([memObj.mHouzz hasPrefix:@"http://"]) {
            inAppbrowserObj.showURL= [NSURL URLWithString:memObj.mHouzz];
        } else {
            inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",memObj.mHouzz]];
        }
        inAppbrowserObj.delegate=self;
        [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
        [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
        
        [inAppbrowserObj loadWebRequest];
        
        if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
        {
            [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
        }
        
        if ([delegate respondsToSelector:selectorScrolling])
        {
            [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
            
        }
        
        
        [self addSubview:inAppbrowserObj];
        
        [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }
   // [self addSubview:inAppbrowserObj];
}

- (void)setviewPageIndex1:(NSInteger)newPageIndex
{
//    NSLog(@"call=%d",newPageIndex);
//    NSLog(@"self.arraySave : %d",[self.arraySave count]);
    if (newPageIndex == 0) {
        leftArrowImageView.hidden =TRUE;
        leftArrowButton.hidden = TRUE;
    }
    else{
        leftArrowImageView.hidden =FALSE;
        leftArrowButton.hidden = FALSE;
    }
    
    if (newPageIndex == ([self.arraySave count]-1)) {
        rightArrowImageView.hidden = TRUE;
        rightArrowButton.hidden = TRUE;
    }
    else{
        rightArrowImageView.hidden = FALSE;
        rightArrowButton.hidden = FALSE;
    }
    
    if (Status) {
        
        Memebers *memObj=[self.arraySave objectAtIndex:newPageIndex];
        if ([memObj.mFacebook isEqualToString:@""]){
            facebookButton.enabled=FALSE;
        }else{
            facebookButton.enabled=TRUE;
        }
        if ([memObj.mTwitter isEqualToString:@""]){
            twitterButton.enabled=FALSE;
        }
        else{
         twitterButton.enabled=TRUE;
        }
        if ([memObj.mHouzz isEqualToString:@""]){
            houzzButton.enabled=FALSE;
        }
        else{
            houzzButton.enabled=TRUE;
        }
        if ([memObj.mPinterest isEqualToString:@""]){
            pinterestButton.enabled=FALSE;
        }
        else{
            pinterestButton.enabled=TRUE;
        }
        if ([memObj.mTelephone isEqualToString:@""]) {
            addToContactsButton.enabled=FALSE;
        }
        else{
            addToContactsButton.enabled=TRUE;
        }
        if ([memObj.mAppUrl isEqualToString:@""]) {
            appURLButton.enabled = FALSE;
        }
        else{
            appURLButton.enabled = TRUE;
        }

        
        AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
//        self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"MembersGallery" :@"mgMembersId" :@"mgMembersId" :memObj.mId :appDelegate.managedObjectContext];
        self.galleryPhotoArray =  [[CoreDataOprations initObject] fetchRequestAccordingtoCategoryForEntity:@"MembersGallery" withSortDescriptor:@"mgImagePosition" withCategoryName:@"mgMembersId" withCategoryValue:memObj.mId andManagedObject:appDelegate.managedObjectContext];

        [self memberGalleryThumb];
        
        CGSize newSize;
        CGRect newFrame;
        
//        CGSize newSize =[memObj.mName sizeWithFont:titlenameLabel.font constrainedToSize:titlenameLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
//        CGRect newFrame = titlenameLabel.frame;
//        newFrame.size.height = newSize.height;
//        titlenameLabel.frame = newFrame;
        
        titlenameLabel.text=[NSString stringWithFormat:@"%@ %@",memObj.mName,memObj.mLastName];
        
        NSString *dummyData = [NSString stringWithFormat:@"%@ %@\n%@",memObj.mName,memObj.mLastName,memObj.mCompany];        //Added by Umesh, replace dummy data with actual data
        NSString *dummyTelephoneNumber = memObj.mTelephone;
        nameLabel.text=dummyData;
        newSize =[nameLabel.text sizeWithFont:nameLabel.font constrainedToSize:CGSizeMake(215, 100) lineBreakMode:NSLineBreakByCharWrapping];
        newFrame = nameLabel.frame;
        newFrame.size.height = newSize.height;
        nameLabel.frame = newFrame;
        
        nameLabel.text=dummyData;
//        nameLabel.text=memObj.mName;
            
      dummyTelephoneNumber =  [dummyTelephoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
      dummyTelephoneNumber = [dummyTelephoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if ([dummyTelephoneNumber length]>9) {

        if (![[dummyTelephoneNumber substringToIndex:1] isEqualToString:@"("]) {
            dummyTelephoneNumber = [NSString stringWithFormat:@"(%@) %@.%@",[dummyTelephoneNumber substringToIndex:3],[[dummyTelephoneNumber substringFromIndex:3] substringToIndex:3],[dummyTelephoneNumber substringFromIndex:6]];
//            dummyTelephoneNumber = [NSString stringWithFormat:@"(%@) %@",[dummyTelephoneNumber substringToIndex:3],[dummyTelephoneNumber substringFromIndex:3]];
        }
        }
        dummyData = @"";
        if (memObj.mAddress && [memObj.mAddress length]>0 && ![memObj.mAddress isEqualToString:@"null"]) {
            dummyData = memObj.mAddress;
        }
        
//        //Uncomment below code when address2 is availbale
//        if (memObj.mAddress1 && [memObj.mAddress1 length]>0 && ![memObj.mAddress1 isEqualToString:@"null"] && [dummyData length]>0) {
//            dummyData = [NSString stringWithFormat:@"%@\n%@",dummyData,memObj.mAddress1];;
//        }
//        else{
//            dummyData = memObj.mAddress1;
//        }
//        NSString *cityStateZip;
////        cityStateZip = [NSString stringWithFormat:@"%@ %@ %@",memObj.city,memObj.state,memObj.zip];
//        
//        if ([cityStateZip length]>0) {
//            dummyData = [NSString stringWithFormat:@"%@\n%@",dummyData,cityStateZip];
//        }
        if ([dummyTelephoneNumber length]>9) {
            
            dummyData = [NSString stringWithFormat:@"%@\nt %@",dummyData,dummyTelephoneNumber];

        }
        else {
        dummyData = [NSString stringWithFormat:@"%@\n",dummyData];
        }
        newSize =[dummyData sizeWithFont:addressLabel.font constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        newFrame = addressLabel.frame;
        newFrame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + 24;
        newFrame.size.height = newSize.height;
       
        addressLabel.frame = newFrame;
        
        addressLabel.text=dummyData;
//         addressLabel.text=memObj.mAddress;
        
        CGRect emailFrame = emailLabel.frame;
        emailFrame.origin.y = addressLabel.frame.origin.y + addressLabel.frame.size.height;
        emailLabel.frame = emailFrame;
        emailFrame.origin.y -=2;
        emailButton.frame = emailFrame;
        if (memObj.mEmail) {
            emailLabel.text = memObj.mEmail;
        }
        
        
        CGRect webSiteFrame = websiteURLLabel.frame;
        webSiteFrame.origin.y = emailButton.frame.origin.y + emailButton.frame.size.height+5;
        websiteURLLabel.frame = webSiteFrame;
        webSiteFrame.origin.y -=2;
        websiteURLButton.frame = webSiteFrame;
        
        
        if (memObj.mWebsite) {
            websiteURLLabel.text = memObj.mWebsite;
        }
        
        newSize =[memObj.mDescription sizeWithFont:summaryAbout.font constrainedToSize:CGSizeMake(560, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        newFrame = summaryAbout.frame;
        newFrame.origin.y = websiteURLLabel.frame.origin.y + websiteURLLabel.frame.size.height + 40;
        newFrame.size.height = newSize.height+20;
        summaryAbout.userInteractionEnabled = FALSE;
//        NSLog(@"memObj.mDescription : %@",memObj.mDescription);
//        NSLog(@"newFrame.size.height : %f",newFrame.size.height);
        if (newFrame.size.height>390) {
            
             summaryAbout.userInteractionEnabled = TRUE;
        }
        newFrame.size.height = 390;
//         NSLog(@"newFrame.size.height>>>> : %f",newFrame.size.height);
        summaryAbout.frame = newFrame;
        
        summaryAbout.text=memObj.mDescription;
        
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memObj.mProfileImage];

        if ([UIImage imageWithContentsOfFile:imageNameWithPath])
        {
            memberPhotoImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
//            memberPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;
        }
        else if ([UIImage imageNamed:memObj.mProfileImage]){
            
            memberPhotoImageView.image=[UIImage imageNamed:memObj.mProfileImage];
        }
        else {
            
            memberPhotoImageView.image=[UIImage imageNamed:@""];
            memberPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;

        }
        dummyData = nil;
        dummyTelephoneNumber = nil;
    
    addToContactsButton.hidden = self.isFromPublicView;
    }
}
-(IBAction)AppURLClicked:(id)sender{
    //Added By Umesh on 20-3-12
    
    //code here to open app URL here
     Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
//    NSLog(@"AppURLClicked");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:memObj.mAppUrl]];
    
}
-(void)galleryPhotoButton_ClickedSimulation:(id)sender{
    
    pageIndex=0;
    
    UIButton *button=(UIButton *)sender;
    
    if (galleryViewObj) {
        
        galleryViewObj=nil;
    }
    
    galleryViewObj=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    galleryViewObj.galleryPhotoArray=self.galleryPhotoArray;
    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([self.galleryPhotoArray count]*1024,728);
    [galleryViewObj setDelegate:self];
    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
    [galleryViewObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
    [galleryViewObj setSelectorCloseGallery:@selector(hideUnhdieBottomBar:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
    [galleryViewObj setSelectorFaceBookAction:@selector(shareFaceBook:)];
    [galleryViewObj setSelectorTwitterAction:@selector(shareTwitterAction:)];
    [galleryViewObj setSelectorEmailAction:@selector(shareEmailAction:)];
    galleryViewObj.pageIndex=button.tag;
    [galleryViewObj addMemberImageGallery:button.tag];
    
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
    {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
    }
    
    if ([delegate respondsToSelector:selectorScrolling])
    {
        [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
        
    }
    
    [self addSubview:galleryViewObj];
    
//    [self fadeView:galleryViewObj fadein:YES timeAnimation:0.3];
    
}
-(void)galleryPhotoButton_Clicked:(id)sender
{   
    pageIndex=0;
       
    UIButton *button=(UIButton *)sender;
    
    if (galleryViewObj) {
        
        galleryViewObj=nil;
    }
    
    galleryViewObj=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    galleryViewObj.galleryPhotoArray=self.galleryPhotoArray;
    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([self.galleryPhotoArray count]*1024,728);
    [galleryViewObj setDelegate:self];
    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
    [galleryViewObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
    [galleryViewObj setSelectorCloseGallery:@selector(hideUnhdieBottomBar:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
    [galleryViewObj setSelectorFaceBookAction:@selector(shareFaceBook:)];
    [galleryViewObj setSelectorTwitterAction:@selector(shareTwitterAction:)];
    [galleryViewObj setSelectorEmailAction:@selector(shareEmailAction:)];
    galleryViewObj.pageIndex=button.tag;
    [galleryViewObj addMemberImageGallery:button.tag];

    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
    {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
    }
 
    if ([delegate respondsToSelector:selectorScrolling])
    {
      [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];

    }
    
    [self addSubview:galleryViewObj];
    
    [self fadeView:galleryViewObj fadein:YES timeAnimation:0.3];
        
}
-(IBAction)websiteButtonClicked:(id)sender{ //Added By Umesh on 13-03-13
    
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    if (memObj.mFacebook) {
        inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
        inAppbrowserObj.titleLabel.text=memObj.mWebsite;
        if ([memObj.mWebsite hasPrefix:@"http://"]) {
            inAppbrowserObj.showURL= [NSURL URLWithString:memObj.mWebsite];
        } else {
            inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",memObj.mWebsite]];
        }
        
        inAppbrowserObj.delegate=self;
        [inAppbrowserObj setSelectorClose:@selector(hideUnhdieBottomBar:)];
        [inAppbrowserObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
        [inAppbrowserObj loadWebRequest];
        
        if ([delegate respondsToSelector:selectorToHideOrShowBottomBar])
        {
            [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"True" afterDelay:0.0];
        }
        
        if ([delegate respondsToSelector:selectorScrolling])
        {
            [delegate performSelector:selectorScrolling withObject:@"NO" afterDelay:0.0];
            
        }
        
        [self addSubview:inAppbrowserObj];
        
        [self fadeView:inAppbrowserObj fadein:YES timeAnimation:0.3];
    }
    else{
        UIAlertView *alertUrl = [[UIAlertView alloc] initWithTitle:@"No url" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertUrl show];
    }
    
}

-(void)shareFaceBook:(NSString *)str {
//    NSLog(@"showEmailPopOvew : ");
    NSDictionary *sharedDataDict = [NSDictionary dictionaryWithObjectsAndKeys:titlenameLabel.text,@"memberName",str,@"imageName", nil];
    if ([delegate respondsToSelector:selectorFacbookAction])
    {
        [delegate performSelector:selectorFacbookAction withObject:sharedDataDict afterDelay:0.0];
    }
    
}
-(void)shareTwitterAction:(NSString*)str{
    NSDictionary *sharedDataDict = [NSDictionary dictionaryWithObjectsAndKeys:titlenameLabel.text,@"memberName",str,@"imageName", nil];
    if ([delegate respondsToSelector:selectorTwitterAction])
    {
        [delegate performSelector:selectorTwitterAction withObject:sharedDataDict afterDelay:0.0];
    }
    
}
-(void)shareEmailAction:(NSArray*)array{
  NSDictionary *sharedDataDict = [NSDictionary dictionaryWithObjectsAndKeys:titlenameLabel.text,@"memberName",array,@"imageName", nil];
    if ([delegate respondsToSelector:selectorShareGalleryImageEmailAction])
    {
        [delegate performSelector:selectorShareGalleryImageEmailAction withObject:sharedDataDict afterDelay:0.0];
    }
    
}
-(void)scrollingEnable:(id)sender
{
    if ([delegate respondsToSelector:selectorScrolling])
    {
        [delegate performSelector:selectorScrolling withObject:@"YES" afterDelay:0.0];
        
    }

}
-(void)galleryHandleLeft{
    
    Memebers *memObj=[self.arraySave objectAtIndex:viewPageIndex];
    
    NSArray *arrayGalleryContent=[NSKeyedUnarchiver unarchiveObjectWithData:memObj.mGallery];

    if (galleryViewObj) {
        
        if (pageIndex==[[arrayGalleryContent objectAtIndex:0] count]) {
            
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
        
        if (pageIndex==0) {
            
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

-(IBAction)LeftMethod:(id)sender
{

    if ([delegate respondsToSelector:selectorLeftArrowAction]) {
        [delegate performSelector:selectorLeftArrowAction withObject:self afterDelay:0.0];
    }

}

-(IBAction)RightMethod:(id)sender
{
    if ([delegate respondsToSelector:selectorRightArrowAction]) {
        [delegate performSelector:selectorRightArrowAction withObject:self afterDelay:0.0];
    }

}


-(IBAction)closeButtonAction:(id)sender
{
    
    if ([delegate respondsToSelector:selectorCloseAction]) {
        [delegate performSelector:selectorCloseAction withObject:sender afterDelay:0.0];
    }

}
-(IBAction)emailButtonAction:(id)sender{
    //Added By Umesh on 20-2-13
//    NSLog(@"email button clicked");
//     NSDictionary *sharedDataDict = [NSDictionary dictionaryWithObjectsAndKeys:titlenameLabel.text,@"memberName",[NSArray arrayWithObjects:emailLabel.text, nil],@"imageName", nil];
    if ([delegate respondsToSelector:selectorEmailAction]) {
        [delegate performSelector:selectorEmailAction withObject:[NSArray arrayWithObjects:emailLabel.text, nil] afterDelay:0.0];
    }
    
}
-(void)hideUnhdieBottomBar:(NSString *)doHideBottomBar{
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar]) {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:@"False" afterDelay:0.0];
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
