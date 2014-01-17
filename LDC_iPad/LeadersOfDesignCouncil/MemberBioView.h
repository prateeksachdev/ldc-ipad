//
//  MemberBioView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryView.h"
#import "InAppBrowser.h"

@interface MemberBioView : UIView
{
    //UILABELS
    IBOutlet UILabel *titlenameLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *galleryLabel;
    IBOutlet UILabel *emailLabel;       //Added By Umesh save email address on 20-2-13
    IBOutlet UILabel *websiteURLLabel;
    
    //UIBUTTONS
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *pinterestButton;
    IBOutlet UIButton *houzzButton;
    IBOutlet UIButton *addToContactsButton;
    IBOutlet UIButton *emailButton;     //Added by Umesh to make email address working on 20-2-13
    IBOutlet UIButton *appURLButton;
    IBOutlet UIButton *websiteURLButton;
    
    //UITEXTVIEW
    IBOutlet UITextView *summaryAbout;

    IBOutlet UIScrollView *galleryPhotoScrollView;
    
    IBOutlet UIImageView *memberPhotoImageView;
    
    IBOutlet UIButton *closeButton;
    
    //Added By umesh to hide left and right arrow button whne needed
    
    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UIImageView *leftArrowImageView;
    IBOutlet UIImageView *rightArrowImageView;

    
    NSArray *galleryPhotoArray;
   
    int pageIndex;

    GalleryView *galleryViewObj;
    
    NSInteger viewPageIndex;
    
    id delegate;

    SEL selectorLeftArrowAction;
    SEL selectorRightArrowAction;
    SEL selectorCloseAction;
    SEL selectorScrolling;
    SEL selectorEmailAction;
    SEL selectorToHideOrShowBottomBar;      //Added By Umesh on 22 Feb 2013
    SEL selectorFacbookAction;
    SEL selectorTwitterAction;
    SEL selectorShareGalleryImageEmailAction;
    InAppBrowser *inAppbrowserObj;
    
    BOOL isFromPublicView;          //Added By Umesh on 04 March 2013
}

@property(nonatomic,retain) id delegate;

@property(nonatomic,assign) SEL selectorLeftArrowAction;
@property(nonatomic,assign) SEL selectorRightArrowAction;
@property(nonatomic,assign) SEL selectorCloseAction;
@property(nonatomic,assign) SEL selectorScrolling;
@property(nonatomic,assign) SEL selectorEmailAction;
@property(nonatomic,assign) SEL selectorToHideOrShowBottomBar;
@property(nonatomic,assign) SEL selectorFacbookAction;
@property(nonatomic,assign) SEL selectorTwitterAction;
@property(nonatomic,assign) SEL selectorShareGalleryImageEmailAction;
@property(nonatomic,assign) BOOL isFromPublicView;

@property (nonatomic,assign) NSInteger viewPageIndex;
@property(nonatomic,assign) BOOL Status;
-(IBAction)faceButtonAction:(id)sender;
-(IBAction)twitterButtonAction:(id)sender;
-(IBAction)pinterestButtonAction:(id)sender;
-(IBAction)addContactButtonAction:(id)sender;
-(IBAction)houzzButtonAction:(id)sender;
-(IBAction)emailButtonAction:(id)sender;        //Added By Umesh on 20-2-13
-(IBAction)AppURLClicked:(id)sender;        //Added By Umesh on 12-3-13
-(IBAction)websiteButtonClicked:(id)sender; //Added By Umesh on 13-03-13

@property(nonatomic,strong)NSArray *galleryPhotoArray;
@property(nonatomic,retain)IBOutlet UILabel *titlenameLabel;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel;
@property(nonatomic,retain)IBOutlet UILabel *addressLabel;
@property(nonatomic,retain)IBOutlet UILabel *galleryLabel;
@property(nonatomic,retain)IBOutlet UIButton *facebookButton;
@property(nonatomic,retain)IBOutlet UIButton *twitterButton;
@property(nonatomic,retain)IBOutlet UIButton *pinterestButton;
@property(nonatomic,retain)IBOutlet UIButton *houzzButton;
@property(nonatomic,retain)IBOutlet UIButton *addToContactsButton;
@property(nonatomic,retain)IBOutlet UIButton *closeButton;
@property(nonatomic,retain)IBOutlet UITextView *summaryAbout;
@property(nonatomic,retain)IBOutlet UIImageView *memberPhotoImageView;
@property(nonatomic,retain)IBOutlet UIScrollView *galleryPhotoScrollView;

@property(nonatomic,retain)NSArray *arraySave;
-(void)galleryPhotoButton_Clicked:(id)sender;
//Adde By Umesh to make gallery work from home
-(void)galleryPhotoButton_ClickedSimulation:(id)sender;
- (void)setviewPageIndex1:(NSInteger)newPageIndex;
-(void)memberGalleryThumb;
-(NSString*)documentCatchePath;
@end
