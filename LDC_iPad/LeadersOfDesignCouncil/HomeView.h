//
//  HomeView.h
//  SampleLdc
//
//  Created by Mobikasa on 1/21/13.
//  Copyright (c) 2013 Mobikasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sponsor.h"
@class Favorites,MembersGallery,Events,Memebers,EventMainView,InAppBrowser,MemberBioViewList,GalleryView,FavCategory;
@interface HomeView : UIView
{
    //changed the name of the image view outlets and label outlets.
    IBOutlet UIImageView *ldcfavoriteImageView;
    IBOutlet UIImageView *galleryImageView;
    IBOutlet UIImageView *ldcCityImageView;
    IBOutlet UIImageView *sponsorAdImageView;
    IBOutlet UIImageView *nextEventImageView;
    IBOutlet UIImageView *featuredDesignerImageView;

    IBOutlet UILabel *ldcfavoriteLable;
    IBOutlet UILabel *galleryLable;
    IBOutlet UILabel *sponsorAdLable;
    IBOutlet UILabel *nextEventLable;
    IBOutlet UILabel *featuredDesignerLable;

    IBOutlet UILabel *theLDCTitleLable;
    IBOutlet UILabel *theLDCLTemperatureLable;
    IBOutlet UILabel *theLDCCityNameLable;
    IBOutlet UILabel *theLDCTimeLable;
    
    //Added By Umesh on 23 feb 2013 to keep the record of the random object that have been selected.
    Favorites *favoritesObj;
    Sponsor *sponsorObj;
    MembersGallery *membersGalleryObj;
    Events *eventsObj;
    Memebers *membersObj;
    EventMainView *eventMainViewObj;
    InAppBrowser *inAppbrowserObj;
    MemberBioViewList *memberBioViewListObj;
    GalleryView *galleryViewObj;
    
    id delegate;
    SEL selectorToBringToolBarInFront;      //
    SEL selectorToHideUnhideToolBarView;
    SEL selectorFacebookAction;
    SEL selectorTwitterAction;
    SEL selectorShareEmailAction;
    
    IBOutlet UIView *ldcFavoritesContainerView;
    IBOutlet UIView *galleryContainerView;
    IBOutlet UIView *nextEventContainerView;
    IBOutlet UIView *featuredDesignerContainerView;
    IBOutlet UIView *temperatureContainerView;
    IBOutlet UIView *sponsersContainerView;
    
    IBOutlet UIScrollView *featuredDesignerContainerScrollView;
    IBOutlet UIScrollView *ldcFavoritesContainerScrollView;
    IBOutlet UIScrollView *galleryContainerScrollView;
    IBOutlet UIScrollView *nextEventContainerScrollView;
    IBOutlet UIScrollView *temperatureContainerScrollView;
    
    IBOutlet UIImageView *sponsorsImageView;
   
}

@property(nonatomic, retain)id delegate;
@property(nonatomic, assign)SEL selectorToBringToolBarInFront;
@property(nonatomic, assign)SEL selectorToHideUnhideToolBarView;
@property(nonatomic,assign)SEL selectorFaceBookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
@property(nonatomic,assign) SEL selectorShareEmailAction;

@property(nonatomic, retain)IBOutlet UILabel *theLDCLTemperatureLable;
@property(nonatomic, retain)IBOutlet UILabel *theLDCTimeLable;

@property(nonatomic, strong)NSArray *eventListMainArray;

- (IBAction)ldcFavoriteClicked:(id)sender;
- (IBAction)galleryClicked:(id)sender;
- (IBAction)ldcTemperatureClicked:(id)sender;
- (IBAction)sponsorClicked:(id)sender;
- (IBAction)nextEventClicked:(id)sender;
- (IBAction)featuredDesigmerClicked:(id)sender;

-(void)setHomeView;

-(void)setFavoriteView;
-(void)setMemberGalleryView;
-(void)setEventView;
-(void)setMemberView;

-(void)removeAddedViews;     //Method to remove view when home button is clicked
-(void)hideUnhideToolBarView:(NSString *)hideToolBarView;
- (NSArray *)coreDataHasEntriesForEntityName:(NSString *)entityName forPredicate:(NSPredicate *)predicate;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(NSString*)documentCatchePath;
@end
