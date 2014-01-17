//
//  AboutLdcViewController.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/4/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryView.h"
#import "HouzzView.h"
#import "PinterestView.h"
#import "InAppBrowser.h"
#import "AboutLdcInfo.h"
@class MemberBioViewList;
@interface AboutLdcViewController : UIViewController
{
    //UILABELS
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *foundersLabel;
    IBOutlet UILabel *kiethLabel;
    IBOutlet UILabel *meganLabel;
    IBOutlet UILabel *galleryLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *websiteLabel;
    IBOutlet UILabel *photoCreditsLabel;
    
    //UIBUTTONS
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *pinterestButton;
    IBOutlet UIButton *houzzButton;
    IBOutlet UIButton *addToContactsButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *websiteButton;
    
    //UITEXTVIEW
    IBOutlet UITextView *summaryAbout;
    IBOutlet UITextView *photoCreditsTextView;
    
    // UISCROLLVIEW
    IBOutlet UIScrollView *galleryPhotoScrollView;
    
    
    id delegate;
    SEL selectorFaceBookAction;
    SEL selectorTwitterAction;
    SEL selectorBackButtonAction;
    NSMutableArray *galleryPhotoArray;
    int pageIndex;
    
    GalleryView *galleryViewObj;
    HouzzView *houzzViewObj;
    PinterestView *pinterestViewObj;
    AboutLdcInfo *aboutInfoObj;
    InAppBrowser *inAppbrowserObj;

    MemberBioViewList *memberBioViewListObj;

}
-(IBAction)faceButtonAction:(id)sender;
-(IBAction)twitterButtonAction:(id)sender;
-(IBAction)pinterestButtonAction:(id)sender;
-(IBAction)addContactButtonAction:(id)sender;
-(IBAction)houzzButtonAction:(id)sender;
-(IBAction)backAction:(id)sender;
-(IBAction)emailButtonClicked:(id)sender;
-(IBAction)websiteButtonClicked:(id)sender;

@property(nonatomic,retain)NSArray *galleryPhotoArray;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)IBOutlet UILabel *addressLabel;
@property(nonatomic,retain)IBOutlet UILabel *foundersLabel;
@property(nonatomic,retain)IBOutlet UILabel *kiethLabel;
@property(nonatomic,retain)IBOutlet UILabel *meganLabel;
@property(nonatomic,retain)IBOutlet UILabel *galleryLabel;
@property(nonatomic,retain)IBOutlet UIImageView *meganImageView;
@property(nonatomic,retain)IBOutlet UIImageView *kiethImageView;
@property(nonatomic,retain)IBOutlet UIButton *meganButton;
@property(nonatomic,retain)IBOutlet UIButton *kiethButton;


@property(nonatomic,retain)IBOutlet UIButton *facebookButton;
@property(nonatomic,retain)IBOutlet UIButton *twitterButton;
@property(nonatomic,retain)IBOutlet UIButton *pinterestButton;
@property(nonatomic,retain)IBOutlet UIButton *houzzButton;
@property(nonatomic,retain)IBOutlet UIButton *addToContactsButton;
@property(nonatomic,retain)IBOutlet UIButton *backButton;

@property(nonatomic,strong)NSArray *aboutLdcArray;
@property(nonatomic,strong)NSArray *arrayofFounders;

@property(nonatomic,retain)IBOutlet UIScrollView *galleryPhotoScrollView;
@property(nonatomic,retain)IBOutlet UIScrollView *textViewScrollView;
@property(nonatomic,retain)IBOutlet UITextView *summaryAbout;

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorFaceBookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
-(IBAction)memberFounderButtonAction:(id)sender;

-(NSString*)documentCatchePath;
@end
