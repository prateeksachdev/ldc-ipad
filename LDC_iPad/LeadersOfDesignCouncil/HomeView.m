//
//  HomeView.m
//  SampleLdc
//
//  Created by Mobikasa on 1/21/13.
//  Copyright (c) 2013 Mobikasa. All rights reserved.
//

#import "HomeView.h"
#import "Constants.h"
#import "AppDelegate.h"

#import "Favorites.h"
#import "MembersGallery.h"
#import "Events.h"
#import "Memebers.h"
#import "FavCategory.h"
#import "CoreDataOprations.h"
#import "InAppBrowser.h"
#import "GalleryView.h"
#import "EventView.h"
#import "EventMainView.h"
#import "MemberBioViewList.h"
#import "MemberBioView.h"
#import "HomeGallery.h"
#import "AboutLdcInfo.h"


@implementation HomeView

@synthesize delegate,selectorToBringToolBarInFront,selectorToHideUnhideToolBarView,selectorShareEmailAction,selectorTwitterAction,selectorFaceBookAction;

@synthesize theLDCLTemperatureLable,theLDCTimeLable,eventListMainArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
        
        ldcfavoriteLable.font=[UIFont fontWithName:FontLight size:20];
        galleryLable.font=[UIFont fontWithName:FontLight size:20];
        sponsorAdLable.font=[UIFont fontWithName:FontLight size:20];
        nextEventLable.font=[UIFont fontWithName:FontLight size:20];
        featuredDesignerLable.font=[UIFont fontWithName:FontLight size:20];
        theLDCTitleLable.font=[UIFont fontWithName:FontLight size:20];
        theLDCLTemperatureLable.font=[UIFont fontWithName:FontSemibd size:50];
        theLDCCityNameLable.font=[UIFont fontWithName:FontLight size:30];
        theLDCTimeLable.font=[UIFont fontWithName:FontLight size:20];
        
        //theLDCLTemperatureLable.text=@"42°";
        
        
    }
//    [self setHomeView];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)ldcFavoriteClicked:(id)sender {
//    NSLog(@"ldcFavoriteClicked");
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    inAppbrowserObj.alpha = 1;
//    [inAppbrowserObj setShowURL:[NSURL URLWithString:favoritesObj.url]];
//    [inAppbrowserObj loadWebRequest];
    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhideToolBarView:)];

    if (favoritesObj.url) {
        
        inAppbrowserObj.titleLabel.text=favoritesObj.favdescription;
        if ([favoritesObj.url hasPrefix:@"http://"]) {
            inAppbrowserObj.showURL= [NSURL URLWithString:favoritesObj.url];
        } else {
            inAppbrowserObj.showURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",favoritesObj.url]];
        }
        
        [inAppbrowserObj loadWebRequest];
        
        [self addSubview:inAppbrowserObj];
        
        [self hideUnhideToolBarView:@"True"];

    }
    else {
        
//            [inAppbrowserObj setShowURL:[NSURL URLWithString:@"http://google.com"]];
//            [inAppbrowserObj loadWebRequest];

    }
    
//    NSLog(@"favorite obj url %@",favoritesObj.url);
}

- (IBAction)galleryClicked:(id)sender {
//    NSLog(@"galleryClicked");
//    
//    NSLog(@"featuredDesigmerClicked");
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
//    NSArray *galleryImageArray = [[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"MembersGallery" :@"mgMembersId" :@"mgMembersId" :membersGalleryObj.mgMembersId :managedObjectContext];
    NSArray *galleryImageArray = [[CoreDataOprations initObject] fetchRequestAccordingtoCategoryForEntity:@"MembersGallery" withSortDescriptor:@"mgImagePosition" withCategoryName:@"mgMembersId" withCategoryValue:membersGalleryObj.mgMembersId andManagedObject:managedObjectContext];
    if ([galleryImageArray count]<1) {
        return;
    }
    
    
    
    if (memberBioViewListObj) {
        
        memberBioViewListObj=nil;
    }
    memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    memberBioViewListObj.publicBackButton.hidden=TRUE;
    memberBioViewListObj.publicBarImageView.hidden=TRUE;
    memberBioViewListObj.memberBioViewListScrollView.frame=CGRectMake(0, 0, 1024, 748);
    
    [memberBioViewListObj setDelegate:delegate];        //Added By Umesh
    [memberBioViewListObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    [memberBioViewListObj setSelectorFacebookAction:@selector(facebookActionForMembers:)];
    [memberBioViewListObj setSelectorTwitterAction:@selector(twitterButtonActionForMember:)];

    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    //    NSDictionary *dictionary=(NSMutableDictionary*)sender;
    
    MemberBioViewObj1.Status=YES;
    MemberBioViewObj2.Status=YES;
    
//    NSArray *memberListArray=[self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:nil];;
    NSArray *memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:managedObjectContext];
    
    MemberBioViewObj1.arraySave=memberListArray;
    MemberBioViewObj2.arraySave=memberListArray;
    
    //    UIButton *buttonTag=[dictionary valueForKey:@"membertag"];
    
    NSPredicate *predicateObj = [NSPredicate predicateWithFormat:@"mId == %@",membersGalleryObj.mgMembersId];
    //get member name of the gallery that will be visible
    Memebers *membersObj1 = (Memebers*) [[self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:predicateObj] lastObject];

    
    int selectIndex=[memberListArray indexOfObject:membersObj1];
//    NSLog(@"selectIndex:%d",selectIndex);
    
    int widthCount=[memberListArray count];
    
    MemberBioViewObj1.closeButton.hidden=TRUE;
    MemberBioViewObj2.closeButton.hidden=TRUE;
    
    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj1 setSelectorShareGalleryImageEmailAction:@selector(shareEmailAction:)];
    [MemberBioViewObj1 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
//    [MemberBioViewObj1 setSelectorEmailAction:@selector(shareEmailAction:)];     //Added By Umesh
    [MemberBioViewObj1 setSelectorTwitterAction:@selector(twitterAction:)];
    [MemberBioViewObj1 setSelectorFacbookAction:@selector(facebookAction:)];
    
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj2 setSelectorShareGalleryImageEmailAction:@selector(shareEmailAction:)];
    [MemberBioViewObj2 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
//    [MemberBioViewObj2 setSelectorEmailAction:@selector(shareEmailAction:)];     //Added By Umesh
    [MemberBioViewObj2 setSelectorTwitterAction:@selector(twitterAction:)];
    [MemberBioViewObj2 setSelectorFacbookAction:@selector(facebookAction:)];
    //    memberBioViewListObj.currentPage=MemberBioViewObj1;
    //    memberBioViewListObj.nextPage=MemberBioViewObj2;
    
    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
    memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
    
    //  [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
    
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
    
    
    //    [memberBioViewListObj applyNewIndex:0 totalCount:widthCount pageController:MemberBioViewObj1];
    //    [memberBioViewListObj applyNewIndex:1 totalCount:widthCount pageController:MemberBioViewObj2];
    
    //    toolBarView.frame=CGRectMake(0,663, 1024, 85);
    
    //    [homeViewObj removeFromSuperview];
    //    [settingViewObj removeFromSuperview];
    //    [aboutLdcViewObj removeFromSuperview];
    //    [memberCatalogViewObj removeFromSuperview];
    //    [eventListViewObj removeFromSuperview];
    
    //    toolBarView.frame=CGRectMake(0,663, 1024, 85);
    
    [self addSubview:memberBioViewListObj];
   
    int indexVal = [galleryImageArray indexOfObject:membersGalleryObj];
    UIButton *buttonObject = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonObject.tag = indexVal;
    [MemberBioViewObj1 galleryPhotoButton_ClickedSimulation:buttonObject];
    if ([delegate respondsToSelector:selectorToBringToolBarInFront]) {
        //changed by Umesh passed object is changed from self to @"member"
        [delegate performSelector:selectorToBringToolBarInFront withObject:@"member" afterDelay:0.0];
    }
    

//    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
//
//    NSPredicate *predicateObj = [NSPredicate predicateWithFormat:@"mId == %@",membersGalleryObj.mgMembersId];
//    //get member name of the gallery that will be visible
//    Memebers *membersObj1 = (Memebers*) [[self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:predicateObj] lastObject];
//    
//     NSArray *memberListArray=[self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:nil];
//    NSLog(@"index of object : %d",[memberListArray indexOfObject:membersObj1]);
//    NSLog(@"index of object : %@",memberListArray);
//    NSLog(@"membersObj1 : %@",membersObj1);
//    NSArray *arrayGalleryContent = [NSKeyedUnarchiver unarchiveObjectWithData:membersObj1.mGallery];
//    NSLog(@"arrayGalleryContent :%d",[arrayGalleryContent count]);
//    
//    galleryViewObj = [[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
//    NSArray *galleryImageArray = [[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"MembersGallery" :@"mgMembersId" :@"mgMembersId" :membersGalleryObj.mgMembersId :managedObjectContext];
//    galleryViewObj.galleryPhotoArray = galleryImageArray;
//    
//    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([galleryImageArray count]*914,728);
//    [galleryViewObj setDelegate:self];
//    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
//    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
//    [galleryViewObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
//    [galleryViewObj setSelectorCloseGallery:@selector(hideUnhideToolBarView:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
//    [galleryViewObj setSelectorFaceBookAction:@selector(shareFaceBook)];
//    [galleryViewObj setSelectorTwitterAction:@selector(shareTwitterAction)];
//    [galleryViewObj setSelectorEmailAction:@selector(shareEmailAction)];
//    int indexVal = [galleryImageArray indexOfObject:membersGalleryObj];
//    galleryViewObj.pageIndex=indexVal;
//    [galleryViewObj addMemberImageGallery:indexVal];
//    
//    
//    
//    [self addSubview:galleryViewObj];
//    [self hideUnhideToolBarView:@"True"];
//    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView])
//    {
//        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
//    }
    
    
    
//    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([[arrayGalleryContent objectAtIndex:0] count]*573,728);
//    [galleryViewObj setDelegate:self];
////    [galleryViewObj setDelegate1:delegate];
//    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
//    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
//    [galleryViewObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
//    [galleryViewObj setSelectorCloseGallery:@selector(hideUnhdieBottomBar:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
}
-(void)shareFaceBook{
    if ([delegate respondsToSelector:selectorFacebookAction])
    {
        [delegate performSelector:selectorFacebookAction withObject:nil afterDelay:0.0];
    }
    
}
-(void)shareTwitterAction{
    if ([delegate respondsToSelector:selectorTwitterAction])
    {
        [delegate performSelector:selectorTwitterAction withObject:nil afterDelay:0.0];
    }
    
}
-(void)shareEmailAction{
    if ([delegate respondsToSelector:selectorShareEmailAction])
    {
        [delegate performSelector:selectorShareEmailAction withObject:nil afterDelay:0.0];
    }
    
}

- (IBAction)ldcTemperatureClicked:(id)sender {
//    NSLog(@"ldcTemperatureClicked");
    [self setCitythumb];
}

- (IBAction)sponsorClicked:(id)sender {
    if (inAppbrowserObj) {
        inAppbrowserObj=nil;
    }
    inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    if (sponsorObj) {
        inAppbrowserObj.titleLabel.text=sponsorObj.sDescription;
        [inAppbrowserObj setShowURL:[NSURL URLWithString:sponsorObj.sUrl]];
    }
    else{
        inAppbrowserObj.titleLabel.text=@"Rounded Corners";
        [inAppbrowserObj setShowURL:[NSURL URLWithString:@"https://www.roundedcorners.com/"]];
    }
    inAppbrowserObj.alpha = 1;
    [inAppbrowserObj loadWebRequest];
    inAppbrowserObj.delegate=self;
    [inAppbrowserObj setSelectorClose:@selector(hideUnhideToolBarView:)];

    [self addSubview:inAppbrowserObj];

    [self hideUnhideToolBarView:@"True"];

}

- (IBAction)nextEventClicked:(id)sender {
//    NSLog(@"nextEventClicked");
    
//    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    //eventListMainArray=[[CoreDataOprations initObject]fetchRequestUpcoming:@"Events":@"eFromDate":@"eToDate":managedObjectContext];
    
    if (eventMainViewObj) {
        
        eventMainViewObj=nil;
    }
    
    eventMainViewObj=[[EventMainView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    //   }
//    [eventMainViewObj setDelegate:self];        //Added By Umesh
//    [eventMainViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
////    [eventMainViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    
    [eventMainViewObj setDelegate:self];        //Added By Umesh
    [eventMainViewObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    [eventMainViewObj setSelectorTwitterAction:@selector(twitterButtonAction:)];
    [eventMainViewObj setSelectorFacebookAction:@selector(facebookAction:)];
    [eventMainViewObj setSelectorMailAction:@selector(ShareEmail:)];
    [eventMainViewObj setSelectorRegisterForEventAction:@selector(registerForEvent:)];
    
    
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
    
//    NSDictionary *dictionary=(NSMutableDictionary*)sender;
    
    NSArray *eventListArray=eventListMainArray;
    
//    UIButton *eventButton=(UIButton*)[dictionary valueForKey:@"EventTag"];
    
    int widthCount=[eventListArray count];
    
    int selectedIndex=[eventListMainArray indexOfObject:eventsObj];
    
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
    //
    
    [eventMainViewObj.eventMainViewScrollView scrollRectToVisible:frame animated:NO];
    
//    toolBarView.frame=CGRectMake(0,663, 1024, 85);
    
    //    [homeViewObj removeFromSuperview];
    //    [settingViewObj removeFromSuperview];
    //    [aboutLdcViewObj removeFromSuperview];
    //    [memberCatalogViewObj removeFromSuperview];
    //    [eventListViewObj removeFromSuperview];
    
    [self addSubview:eventMainViewObj];
    if ([delegate respondsToSelector:selectorToBringToolBarInFront]) {
        //changed by Umesh passed object is changed from self to @"event"
        [delegate performSelector:selectorToBringToolBarInFront withObject:@"event" afterDelay:0.0];
    }
//    [self.view addSubview:toolBarView];
    
}
- (IBAction)featuredDesigmerClicked:(id)sender {
//    NSLog(@"featuredDesigmerClicked");
    
     if (memberBioViewListObj) {
    
         memberBioViewListObj=nil;
     }
    memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    memberBioViewListObj.publicBackButton.hidden=TRUE;
    memberBioViewListObj.publicBarImageView.hidden=TRUE;
    memberBioViewListObj.memberBioViewListScrollView.frame=CGRectMake(0, 0, 1024, 748);

    
    
    [memberBioViewListObj setDelegate:self];        //Added By Umesh
    [memberBioViewListObj setSelectorToHideUnhideToolBarView:@selector(hideUnhideToolBarView:)];
    
    
    
    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
//    NSDictionary *dictionary=(NSMutableDictionary*)sender;
    
    MemberBioViewObj1.Status=YES;
    MemberBioViewObj2.Status=YES;
    
    NSArray *memberListArray=[self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:nil];;
    
    MemberBioViewObj1.arraySave=memberListArray;
    MemberBioViewObj2.arraySave=memberListArray;
    
//    UIButton *buttonTag=[dictionary valueForKey:@"membertag"];
    
    int selectIndex=[memberListArray indexOfObject:membersObj];
    
    int widthCount=[memberListArray count];
    
    MemberBioViewObj1.closeButton.hidden=TRUE;
    MemberBioViewObj2.closeButton.hidden=TRUE;
    
    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj1 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    [MemberBioViewObj2 setSelectorToHideOrShowBottomBar:@selector(hideUnhdieBottomBar:)];       //Added By Umesh
    
    //    memberBioViewListObj.currentPage=MemberBioViewObj1;
    //    memberBioViewListObj.nextPage=MemberBioViewObj2;
    
    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
    memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
    
    //  [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
    
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
    
    
    //    [memberBioViewListObj applyNewIndex:0 totalCount:widthCount pageController:MemberBioViewObj1];
    //    [memberBioViewListObj applyNewIndex:1 totalCount:widthCount pageController:MemberBioViewObj2];
    
    //    toolBarView.frame=CGRectMake(0,663, 1024, 85);
    
    //    [homeViewObj removeFromSuperview];
    //    [settingViewObj removeFromSuperview];
    //    [aboutLdcViewObj removeFromSuperview];
    //    [memberCatalogViewObj removeFromSuperview];
    //    [eventListViewObj removeFromSuperview];
    
//    toolBarView.frame=CGRectMake(0,663, 1024, 85);
    
    [self addSubview:memberBioViewListObj];
    if ([delegate respondsToSelector:selectorToBringToolBarInFront]) {
        //changed by Umesh passed object is changed from self to @"member"
        [delegate performSelector:selectorToBringToolBarInFront withObject:@"member" afterDelay:0.0];
    }
//    [self.view addSubview:toolBarView];
}
-(void)hideUnhideToolBarView:(NSString *)hideToolBarView{
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:hideToolBarView afterDelay:0.0];
    }
}
-(void)removeAddedViews{
    [eventMainViewObj removeFromSuperview];
    [inAppbrowserObj removeFromSuperview];
    [memberBioViewListObj removeFromSuperview];
    [galleryViewObj removeFromSuperview];
}
-(void)setHomeView{
    [self setSponsorView];
    [self setFavoriteView];
    [self setMemberGalleryView];
    [self setEventView];
    [self setMemberView];
    [self setCitythumb];
}
-(void)setSponsorView{
    NSArray *results = [self coreDataHasEntriesForEntityName:@"Sponsor" forPredicate:nil];
    
    if ([results count]!=0) {
        
        int randomNumber = arc4random()%[results count];
        
        sponsorObj = (Sponsor *) [results objectAtIndex:randomNumber];
        sponsorAdLable.text=sponsorObj.sDescription;
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",sponsorObj.sImageName];
        UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:sponsorObj.sImageName];
        }
        if (imageObj) {
            sponsorAdImageView.image=imageObj;
        }
        else{
            sponsorAdImageView.image=[UIImage imageNamed:@"img_04.png"];
        }
        NSLog(@"sponsor:%@",sponsorObj.sponsorId);
        NSLog(@"sponsorDecr:%@",sponsorObj.sDescription);
        NSLog(@"path=%@",sponsorObj.sImageName);

}
}
-(void)setCitythumb
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
     NSArray *aboutInfoArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"AboutLdcInfo" withSortDecs:@"telephone" forManagedObj:appDelegate.managedObjectContext];
    NSArray *arrayOfhomeBackground = [self coreDataHasEntriesForEntityName:@"HomeGallery" forPredicate:nil];
    
    AboutLdcInfo *aboutInfoObj=[aboutInfoArray objectAtIndex:0];
//    NSLog(@"aboutInfoObj.statusMessage : %@",aboutInfoObj.statusMessage);
    theLDCTitleLable.text = aboutInfoObj.statusMessage;
    theLDCCityNameLable.text = aboutInfoObj.location;
    
    CGSize newSize;
    CGRect newFrame;
    
    newSize =[theLDCTitleLable.text sizeWithFont:theLDCTitleLable.font constrainedToSize:CGSizeMake(275, 45) lineBreakMode:NSLineBreakByWordWrapping];
    
    newFrame = theLDCTitleLable.frame;
    newFrame.size.height = newSize.height;
    newFrame.origin.y=220-(newSize.height+8);
    theLDCTitleLable.frame = newFrame;
    
    
    if ([arrayOfhomeBackground count]!=0) {
        
        int randomNumber = arc4random()%[arrayOfhomeBackground count];
        
        HomeGallery *homeGalleryObj=[arrayOfhomeBackground objectAtIndex:randomNumber];
        
        
//        CGSize newSize;
//        CGRect newFrame;
         NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",homeGalleryObj.image];
        
        UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        
        if (!imageObj) {
            imageObj = [UIImage imageNamed:homeGalleryObj.image];
        }
        if (imageObj) {
            //        galleryImageView.image = imageObj;
            
            float ratioVal = 0.0;
            CGSize imageNewSize;
            int xPos = 0;
            int yPos = 0;
            
            if (imageObj) {
                
                //                NSLog(@"imageObj : %@",imageObj);
                //
                //                NSLog(@"imageObj frame widght %f",imageObj.size.width);
                //                NSLog(@"imageObj frame height %f",imageObj.size.height);
                
                if ((imageObj.size.width/imageObj.size.height) < (1.38182)) {
                    ratioVal = imageObj.size.height /imageObj.size.width;
                    //                    NSLog(@"ratioVal  :%f",ratioVal);
                    imageNewSize.width = 304;
                    imageNewSize.height = ratioVal*304;
                    yPos = 0 - ((imageNewSize.height-220)/2);
                    //                    NSLog(@"yPos  :%d",yPos);
                }
                else{
                    ratioVal = imageObj.size.width /imageObj.size.height;
                    //                    NSLog(@"ratioVal  :%f",ratioVal);
                    imageNewSize.height = 220;
                    imageNewSize.width = ratioVal*220;
                    xPos = 0 - ((imageNewSize.width-304)/2);
                    //                    NSLog(@"xPos  :%d",xPos);
                    
                }
                
                //                NSLog(@"imageNewSize frame widght %f",imageNewSize.width);
                //                NSLog(@"imageNewSize frame height %f",imageNewSize.height);
                CGRect newImageFrame = ldcfavoriteImageView.frame;
                newImageFrame.size.width = imageNewSize.width;
                newImageFrame.size.height = imageNewSize.height;
                
                
                
                temperatureContainerScrollView.contentSize = newImageFrame.size;
                temperatureContainerScrollView.contentOffset = CGPointMake(-xPos, -yPos);
                ldcCityImageView.image = imageObj;
                ldcCityImageView.frame = CGRectMake(0, 0, newImageFrame.size.width, newImageFrame.size.height);
                //        featuredDesignerImageView.center = featuredDesignerContainerView.center;
            }
            
        }
    else{
        ldcCityImageView.image = [UIImage imageNamed:@"img_03.png"];
        ldcCityImageView.frame = CGRectMake(0, 0, 304, 220);
        temperatureContainerScrollView.contentSize = ldcCityImageView.frame.size;
        temperatureContainerScrollView.contentOffset = CGPointZero;
    }
    
    
    
    
    
        
//        if ([UIImage imageWithContentsOfFile:homeGalleryObj.image]) {
//            
//            ldcCityImageView.image=[UIImage imageWithContentsOfFile:homeGalleryObj.image];
//            ldcCityImageView.clipsToBounds=YES;
//            ldcCityImageView.contentMode = UIViewContentModeCenter;
//        }
//        else {
//            
//            ldcCityImageView.image=[UIImage imageNamed:@"img_03.png"];
//        }
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
-(void)setFavoriteView{
    //get Random favorite item
    NSArray *results = [self coreDataHasEntriesForEntityName:@"Favorites" forPredicate:nil];
  
    if ([results count]!=0) {

    int randomNumber = arc4random()%[results count];
    
    favoritesObj = (Favorites *) [results objectAtIndex:randomNumber];
    NSPredicate *predicateObj = [NSPredicate predicateWithFormat:@"categoryId == %@",favoritesObj.categoryId];
    //get category for the favorite
    
    FavCategory *categoryObj = (FavCategory *)[[self coreDataHasEntriesForEntityName:@"FavCategory" forPredicate:predicateObj] lastObject];
    ldcfavoriteLable.text = [NSString stringWithFormat:@"%@\n%@",categoryObj.categoryName,favoritesObj.favdescription];
//        NSLog(@"ldcfavoriteLable.text %@",ldcfavoriteLable.text);
    ldcfavoriteLable.numberOfLines=0;
    CGSize newSize;
    CGRect newFrame;
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",favoritesObj.favImage];
        UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:favoritesObj.favImage];
        }
        if (imageObj) {
            //        galleryImageView.image = imageObj;
            
            float ratioVal = 0.0;
            CGSize imageNewSize;
            int xPos = 0;
            int yPos = 0;
            
            if (imageObj) {
                
//                NSLog(@"imageObj : %@",imageObj);
//                
//                NSLog(@"imageObj frame widght %f",imageObj.size.width);
//                NSLog(@"imageObj frame height %f",imageObj.size.height);
                
                if ((imageObj.size.width/imageObj.size.height) < (1.19497)) {
                    ratioVal = imageObj.size.height /imageObj.size.width;
//                    NSLog(@"ratioVal  :%f",ratioVal);
                    imageNewSize.width = 380;
                    imageNewSize.height = ratioVal*380;
                    yPos = 0 - ((imageNewSize.height-318)/2);
//                    NSLog(@"yPos  :%d",yPos);
                }
                else{
                    ratioVal = imageObj.size.width /imageObj.size.height;
//                    NSLog(@"ratioVal  :%f",ratioVal);
                    imageNewSize.height = 318;
                    imageNewSize.width = ratioVal*318;
                    xPos = 0 - ((imageNewSize.width-380)/2);
//                    NSLog(@"xPos  :%d",xPos);
                    
                }
                
//                NSLog(@"imageNewSize frame widght %f",imageNewSize.width);
//                NSLog(@"imageNewSize frame height %f",imageNewSize.height);
                CGRect newImageFrame = ldcfavoriteImageView.frame;
                newImageFrame.size.width = imageNewSize.width;
                newImageFrame.size.height = imageNewSize.height;
                
                
                
                ldcFavoritesContainerScrollView.contentSize = newImageFrame.size;
                ldcFavoritesContainerScrollView.contentOffset = CGPointMake(-xPos, -yPos);
                ldcfavoriteImageView.image = imageObj;
                ldcfavoriteImageView.frame = CGRectMake(0, 0, newImageFrame.size.width, newImageFrame.size.height);
                //        featuredDesignerImageView.center = featuredDesignerContainerView.center;
            }
            else{
                ldcfavoriteImageView.image = [UIImage imageNamed:@"img_06.png"];
                ldcfavoriteImageView.frame = CGRectMake(0, 0, 380, 318);
                ldcFavoritesContainerScrollView.contentSize = nextEventImageView.frame.size;
                ldcFavoritesContainerScrollView.contentOffset = CGPointZero;
            }
            
            
//            NSLog(@"nextEventImageView x : %f",ldcfavoriteImageView.frame.origin.x);
//            NSLog(@"nextEventImageView  y: %f",ldcfavoriteImageView.frame.origin.y);
//            NSLog(@"nextEventImageView w : %f",ldcfavoriteImageView.frame.size.width);
//            NSLog(@"nextEventImageView  h: %f",ldcfavoriteImageView.frame.size.height);
        }
    
    newSize =[ldcfavoriteLable.text sizeWithFont:ldcfavoriteLable.font constrainedToSize:CGSizeMake(352, 95) lineBreakMode:NSLineBreakByWordWrapping];
    
    newFrame = ldcfavoriteLable.frame;
    newFrame.size.height = newSize.height;
    newFrame.origin.y=318-(newSize.height+8);
    ldcfavoriteLable.frame = newFrame;
    }
    
}
-(void)setMemberGalleryView{
    //get random galeery for a member
    
    NSArray *results = [self coreDataHasEntriesForEntityName:@"MembersGallery" forPredicate:nil];
    
    if ([results count]!=0) {
        
    int randomNumber = arc4random()%[results count];
 
    membersGalleryObj = (MembersGallery *)[results objectAtIndex:randomNumber];
//         NSLog(@"membersGalleryObj : %@",membersGalleryObj);
//        NSLog(@"membersGalleryObj : %@",membersGalleryObj.mgMembersId);
//        NSLog(@"membersGalleryObj : %@",membersGalleryObj.mgImageId);
    NSPredicate *predicateObj = [NSPredicate predicateWithFormat:@"mId == %@",membersGalleryObj.mgMembersId];
    //get member name of the gallery that will be visible
    NSArray *resultsMember = [self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:predicateObj];
//        NSLog(@"resultsMember : %@",resultsMember);
        while (!resultsMember) {
            randomNumber = arc4random()%[results count];
            
            membersGalleryObj = (MembersGallery *)[results objectAtIndex:randomNumber];
//            NSLog(@"membersGalleryObj>>> : %@",membersGalleryObj);
//            NSLog(@"membersGalleryObj >>>: %@",membersGalleryObj.mgMembersId);
//            NSLog(@"membersGalleryObj>>> : %@",membersGalleryObj.mgImageId);
            predicateObj = [NSPredicate predicateWithFormat:@"mId == %@",membersGalleryObj.mgMembersId];
            //get member name of the gallery that will be visible
            resultsMember = [self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:predicateObj];
        }
    Memebers *membersObj1 = (Memebers*) [resultsMember lastObject];
//        NSLog(@"membersObj1 : %@",membersObj1.mName);
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",membersGalleryObj.mgImagePath];
        
    UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:membersGalleryObj.mgImagePath];
        }
    if (imageObj) {
//        galleryImageView.image = imageObj;
        
        float ratioVal = 0.0;
        CGSize imageNewSize;
        int xPos = 0;
        int yPos = 0;
        
        if (imageObj) {
            
//            NSLog(@"imageObj : %@",imageObj);
//            
//            NSLog(@"imageObj frame widght %f",imageObj.size.width);
//            NSLog(@"imageObj frame height %f",imageObj.size.height);
            
            if ((imageObj.size.width/imageObj.size.height) < (1.0062)) {
                ratioVal = imageObj.size.height /imageObj.size.width;
//                NSLog(@"ratioVal  :%f",ratioVal);
                imageNewSize.width = 320;
                imageNewSize.height = ratioVal*320;
                yPos = 0 - ((imageNewSize.height-318)/2);
//                NSLog(@"yPos  :%d",yPos);
            }
            else{
                ratioVal = imageObj.size.width /imageObj.size.height;
//                NSLog(@"ratioVal  :%f",ratioVal);
                imageNewSize.height = 318;
                imageNewSize.width = ratioVal*318;
                xPos = 0 - ((imageNewSize.width-320)/2);
//                NSLog(@"xPos  :%d",xPos);
                
            }
            
//            NSLog(@"imageNewSize frame widght %f",imageNewSize.width);
//            NSLog(@"imageNewSize frame height %f",imageNewSize.height);
            CGRect newImageFrame = galleryImageView.frame;
            newImageFrame.size.width = imageNewSize.width;
            newImageFrame.size.height = imageNewSize.height;
            
            
            
            galleryContainerScrollView.contentSize = newImageFrame.size;
            galleryContainerScrollView.contentOffset = CGPointMake(-xPos, -yPos);
            galleryImageView.image = imageObj;
            galleryImageView.frame = CGRectMake(0, 0, newImageFrame.size.width, newImageFrame.size.height);
            //        featuredDesignerImageView.center = featuredDesignerContainerView.center;
        }
        
        
        
//        NSLog(@"nextEventImageView x : %f",galleryImageView.frame.origin.x);
//        NSLog(@"nextEventImageView  y: %f",galleryImageView.frame.origin.y);
//        NSLog(@"nextEventImageView w : %f",galleryImageView.frame.size.width);
//        NSLog(@"nextEventImageView  h: %f",galleryImageView.frame.size.height);
        
        
        
    }
    else{
        galleryImageView.image = [UIImage imageNamed:@"img_02.png"];
        galleryImageView.frame = CGRectMake(0, 0, 320, 318);
        galleryContainerScrollView.contentSize = nextEventImageView.frame.size;
        galleryContainerScrollView.contentOffset = CGPointZero;
    }
    galleryLable.text = [NSString stringWithFormat:@"From %@ %@'s gallery",membersObj1.mName,membersObj1.mLastName];
    galleryLable.numberOfLines=0;
    
    CGSize newSize;
    CGRect newFrame;
    
    newSize =[galleryLable.text sizeWithFont:galleryLable.font constrainedToSize:CGSizeMake(288, 95) lineBreakMode:NSLineBreakByWordWrapping];
    
    newFrame = galleryLable.frame;
    newFrame.size.height = newSize.height;
    newFrame.origin.y=318-(newSize.height + 8);
    galleryLable.frame = newFrame;
    }
    else{
        galleryLable.text = [NSString stringWithFormat:@"No Gallery available"];
        galleryLable.numberOfLines=0;
        
        CGSize newSize;
        CGRect newFrame;
        
        newSize =[galleryLable.text sizeWithFont:galleryLable.font constrainedToSize:CGSizeMake(286, 95) lineBreakMode:NSLineBreakByWordWrapping];
        
        newFrame = galleryLable.frame;
        newFrame.size.height = newSize.height;
        newFrame.origin.y=318-(newSize.height + 8);
        galleryLable.frame = newFrame;
    }
//    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
}
-(void)setEventView{
    //get upcoming recent event and show it : still needs to be done
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    eventListMainArray=[[CoreDataOprations initObject]fetchRequestUpcoming:@"Events":@"eFromDate":@"eToDate":managedObjectContext];
    
    if ([eventListMainArray count]!=0) {
        //    int randomNumber = arc4random()%[eventListMainArray count];
        eventsObj =  (Events *)[eventListMainArray objectAtIndex:0];
        //converting string into date
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
        //        NSDate *dateVal = [NSDate dateWithTimeIntervalSinceReferenceDate:eventsObj.eFromDate];
        NSDate *dateVal = eventsObj.eFromDate;
        //converting date into string in Feb 02, 2013 06:30 PM formate
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *dataStrinVal = [dateFormatter stringFromDate:dateVal];
        
        nextEventLable.text = [NSString stringWithFormat:@"Next Event:\n%@\n%@",eventsObj.eName,dataStrinVal];
    }
    else{
        eventListMainArray=[[CoreDataOprations initObject]fetchRequest:@"Events":@"eFromDate" :managedObjectContext];
        eventsObj =  (Events *)[eventListMainArray lastObject];
        //converting string into date
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
        //        NSDate *dateVal = [NSDate dateWithTimeIntervalSinceReferenceDate:eventsObj.eFromDate];
        NSDate *dateVal = eventsObj.eFromDate;
        //converting date into string in Feb 02, 2013 06:30 PM formate
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *dataStrinVal = [dateFormatter stringFromDate:dateVal];
        
        nextEventLable.text = [NSString stringWithFormat:@"Last Event:\n%@\n%@",eventsObj.eName,dataStrinVal];
    }
    
    
    nextEventLable.numberOfLines=0;
    CGSize newSize;
    CGRect newFrame;

    newSize =[nextEventLable.text sizeWithFont:nextEventLable.font constrainedToSize:nextEventLable.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = nextEventLable.frame;
    newFrame.size.height = newSize.height;
    newFrame.origin.y=330 -(newSize.height + 8);
    nextEventLable.frame = newFrame;
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsObj.eImage];
        
        UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        if (!imageObj) {
            imageObj = [UIImage imageNamed:eventsObj.eImage];
        }
    if (imageObj) {
        
         NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsObj.eImage];
        
        nextEventImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
        
        
        float ratioVal = 0.0;
        CGSize imageNewSize;
        int xPos = 0;
        int yPos = 0;
        
        if (imageObj) {
            
//            NSLog(@"imageObj : %@",imageObj);
//            
//            NSLog(@"imageObj frame widght %f",imageObj.size.width);
//            NSLog(@"imageObj frame height %f",imageObj.size.height);
            
            if ((imageObj.size.width/imageObj.size.height) < (1.363636)) {
                ratioVal = imageObj.size.height /imageObj.size.width;
//                NSLog(@"ratioVal  :%f",ratioVal);
                imageNewSize.width = 450;
                imageNewSize.height = ratioVal*450;
                yPos = 0 - ((imageNewSize.height-330)/2);
//                NSLog(@"yPos  :%d",yPos);
            }
            else{
                ratioVal = imageObj.size.width /imageObj.size.height;
//                NSLog(@"ratioVal  :%f",ratioVal);
                imageNewSize.height = 330;
                imageNewSize.width = ratioVal*330;
                xPos = 0 - ((imageNewSize.width-450)/2);
//                NSLog(@"xPos  :%d",xPos);
                
            }
            
//            NSLog(@"imageNewSize frame widght %f",imageNewSize.width);
//            NSLog(@"imageNewSize frame height %f",imageNewSize.height);
            CGRect newImageFrame = featuredDesignerImageView.frame;
            newImageFrame.size.width = imageNewSize.width;
            newImageFrame.size.height = imageNewSize.height;
            
            
            nextEventContainerScrollView.contentSize = newImageFrame.size;
            nextEventContainerScrollView.contentOffset = CGPointMake(-xPos, -yPos);
            nextEventImageView.image = imageObj;
            nextEventImageView.frame = CGRectMake(0, 0, newImageFrame.size.width, newImageFrame.size.height);
            //        featuredDesignerImageView.center = featuredDesignerContainerView.center;
        }
        else{
            nextEventImageView.image = [UIImage imageNamed:@"img_05.png"];
            nextEventImageView.frame = CGRectMake(0, 0, 450, 330);
            nextEventContainerScrollView.contentSize = nextEventImageView.frame.size;
            nextEventContainerScrollView.contentOffset = CGPointZero;
        }
        
        
//        NSLog(@"nextEventImageView x : %f",nextEventImageView.frame.origin.x);
//        NSLog(@"nextEventImageView  y: %f",nextEventImageView.frame.origin.y);
//        NSLog(@"nextEventImageView w : %f",nextEventImageView.frame.size.width);
//        NSLog(@"nextEventImageView  h: %f",nextEventImageView.frame.size.height);
        
        
        
        

    }
    }
-(void)setMemberView{
    //get random member detail
    NSArray *results = [self coreDataHasEntriesForEntityName:@"Memebers" forPredicate:nil];
    
    if ([results count]!=0) {

    
    int randomNumber = arc4random()%[results count];
    membersObj = (Memebers*) [results objectAtIndex:randomNumber];
    //the image is not loading right now when the image will be availble it will work
        
        
    NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",membersObj.mProfileImage];    
    UIImage *imageObj = [UIImage imageWithContentsOfFile:imageNameWithPath];
        
        //  widht : 304     hieght : 428
        float ratioVal = 0.0;
        CGSize imageNewSize;
        int xPos = 0;
        int yPos = 0;
        if (!imageObj) {
            imageObj = [UIImage imageNamed:membersObj.mProfileImage];
        }
        
    if (imageObj) {
        
//        NSLog(@"imageObj : %@",imageObj);
//        
//        NSLog(@"imageObj frame widght %f",imageObj.size.width);
//        NSLog(@"imageObj frame height %f",imageObj.size.height);
        
        if ((imageObj.size.width/imageObj.size.height) < (0.71)) {
            ratioVal = imageObj.size.height /imageObj.size.width;
//            NSLog(@"ratioVal  :%f",ratioVal);
            imageNewSize.width = 304;
            imageNewSize.height = ratioVal*304;
            yPos = 0 - ((imageNewSize.height-428)/2);
//            NSLog(@"yPos  :%d",yPos);
        }
        else{
            ratioVal = imageObj.size.width /imageObj.size.height;
//            NSLog(@"ratioVal  :%f",ratioVal);
            imageNewSize.height = 428;
            imageNewSize.width = ratioVal*428;
            xPos = 0 - ((imageNewSize.width-304)/2);
//            NSLog(@"xPos  :%d",xPos);
            
        }
        
//        NSLog(@"imageNewSize frame widght %f",imageNewSize.width);
//        NSLog(@"imageNewSize frame height %f",imageNewSize.height);
        CGRect newImageFrame = featuredDesignerImageView.frame;
        newImageFrame.size.width = imageNewSize.width;
        newImageFrame.size.height = imageNewSize.height;
        
        
        
        
        featuredDesignerContainerScrollView.contentSize = newImageFrame.size;
        featuredDesignerContainerScrollView.contentOffset = CGPointMake(-xPos, -yPos);
        featuredDesignerImageView.image = imageObj;
        featuredDesignerImageView.frame = CGRectMake(0, 0, newImageFrame.size.width, newImageFrame.size.height);
//        featuredDesignerImageView.center = featuredDesignerContainerView.center;
    }
    else{
        featuredDesignerImageView.image = [UIImage imageNamed:@""];
        featuredDesignerImageView.frame = CGRectMake(0, 0, 304, 428);
        featuredDesignerContainerScrollView.contentSize = featuredDesignerImageView.frame.size;
        featuredDesignerContainerScrollView.contentOffset = CGPointZero;
    }
        
        
//        NSLog(@"featuredDesignerImageView.frame : %f",featuredDesignerImageView.frame.origin.x);
//        NSLog(@"featuredDesignerImageView.frame.origin.y : %f",featuredDesignerImageView.frame.origin.y);
//        NSLog(@"featuredDesignerImageView.frame w : %f",featuredDesignerImageView.frame.size.width);
//        NSLog(@"featuredDesignerImageView.frame  h: %f",featuredDesignerImageView.frame.size.height);
    featuredDesignerLable.text = [NSString stringWithFormat:@"Featured Member:\n%@ %@",membersObj.mName,membersObj.mLastName];
    
    featuredDesignerLable.numberOfLines=0;
    
    CGSize newSize;
    CGRect newFrame;

    newSize =[featuredDesignerLable.text sizeWithFont:featuredDesignerLable.font constrainedToSize:featuredDesignerLable.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    
    newFrame = featuredDesignerLable.frame;
    newFrame.size.height = newSize.height;
    newFrame.origin.y=428 - (newSize.height + 8);
    featuredDesignerLable.frame = newFrame;
    }
//    [featuredDesignerImageView bringSubviewToFront:temperatureContainerView];
//    [featuredDesignerContainerView bringSubviewToFront:nextEventContainerView];
}
- (NSArray *)coreDataHasEntriesForEntityName:(NSString *)entityName forPredicate:(NSPredicate *)predicate{
    
    //this method get all data from the database and that pick a random object based on randomNumber variable and return it
    //if predicate is present it will get the data according to the predicate else fetch all data.
    //this method work for fetching member and category as the it will only return one record and the random number generted for it will be 0 only
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
//    int randomNumber = arc4random()%[results count];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        
        return nil;
    }
    return results;
}
//Added BY Umesh to make regoter, facebook, twitter and email of event work from home
-(void)registerForEvent:(NSDictionary *)emailDetailsDict{
    if ([delegate respondsToSelector:@selector(registerForEvent:)]) {
        [delegate performSelector:@selector(registerForEvent:) withObject:emailDetailsDict afterDelay:0.0];
    }
}
-(void)facebookAction:(NSString *)str{
    if ([delegate respondsToSelector:@selector(facebookAction:)]) {
        [delegate performSelector:@selector(facebookAction:) withObject:str afterDelay:0.0];
    }
}
-(void)twitterButtonAction:(NSString *)str{
    if ([delegate respondsToSelector:@selector(twitterButtonAction:)]) {
        [delegate performSelector:@selector(twitterButtonAction:) withObject:str afterDelay:0.0];
    }
}
-(void)ShareEmail:(NSArray *)emailIDArray{
    if ([delegate respondsToSelector:@selector(ShareEmail:)]) {
        [delegate performSelector:@selector(ShareEmail:) withObject:emailIDArray afterDelay:0.0];
    }
}
@end
