//
//  AboutLDCView.h
//  SampleLdc
//
//  Created by Mobikasa on 1/21/13.
//  Copyright (c) 2013 Mobikasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryView.h"
#import "HouzzView.h"
#import "PinterestView.h"
#import "AboutLdcInfo.h"
#import "InAppBrowser.h"
#import "PdfReaderNaviagtionController.h"
@class AppDelegate,PdfReaderViewController;
@interface AboutLDCView : UIView
{
    //UILABELS
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *foundersLabel;
    IBOutlet UILabel *kiethLabel;
    IBOutlet UILabel *meganLabel;
    IBOutlet UILabel *galleryLabel;
    IBOutlet UILabel *newsLabels;
    IBOutlet UILabel *photoCreditsLabel;
    IBOutlet UILabel *photodescriptonLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *websiteLabel;
    
    //UIBUTTONS
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *pinterestButton;
    IBOutlet UIButton *houzzButton;
    IBOutlet UIButton *addToContactsButton;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *websiteButton;
    
    //UITEXTVIEW
    IBOutlet UITextView *summaryAbout;
    IBOutlet UITextView *photoCreditsTextView;
    
    // UISCROLLVIEW
    IBOutlet UIScrollView *galleryPhotoScrollView;
    IBOutlet UIScrollView *newsLetterScrollview;
    IBOutlet UIScrollView *textViewScrollView;
    
    id delegate;
    SEL selectorFaceBookAction;
    SEL selectorTwitterAction;
    SEL selectorShareImageViaEmailAction;
    SEL selectorShareEmailAction;
    SEL selectorBackButtonAction;
    SEL selectorNewsLetterAction;
    SEL selectorToHideUnhideToolBarView;
    SEL selectorFounderClicked;
    //Added By Umesh : to hide and unhide tool bar view
    NSArray *galleryPhotoArray;
    int pageIndex;
    
    GalleryView *galleryViewObj;
    HouzzView *houzzViewObj;
    PinterestView *pinterestViewObj;
    AppDelegate *appDelegate;
    AboutLdcInfo *aboutInfoObj;
    InAppBrowser *inAppbrowserObj;
   
    
    
}
-(IBAction)faceButtonAction:(id)sender;
-(IBAction)twitterButtonAction:(id)sender;
-(IBAction)pinterestButtonAction:(id)sender;
-(IBAction)addContactButtonAction:(id)sender;
-(IBAction)houzzButtonAction:(id)sender;
-(IBAction)emailButtonClicked:(id)sender;
-(IBAction)websiteButtonClicked:(id)sender;

@property(nonatomic,strong)NSArray *galleryPhotoArray;
@property(nonatomic,strong)NSArray *newsLettersArray;
@property(nonatomic,strong)NSArray *aboutLdcArray;
@property(nonatomic,strong)NSMutableDictionary *aboutLdcDictionary;

@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)IBOutlet UILabel *addressLabel;
@property(nonatomic,retain)IBOutlet UILabel *foundersLabel;
@property(nonatomic,retain)IBOutlet UILabel *kiethLabel;
@property(nonatomic,retain)IBOutlet UILabel *meganLabel;
@property(nonatomic,retain)IBOutlet UILabel *galleryLabel;
@property(nonatomic,retain)IBOutlet UILabel *newsLabels;
@property(nonatomic,retain)IBOutlet UILabel *photoCreditsLabel;
@property(nonatomic,retain)IBOutlet UIImageView *meganImageView;
@property(nonatomic,retain)IBOutlet UIImageView *kiethImageView;
@property(nonatomic,retain)IBOutlet UIButton *meganButton;
@property(nonatomic,retain)IBOutlet UIButton *kiethButton;

@property(nonatomic,retain)IBOutlet UIButton *facebookButton;
@property(nonatomic,retain)IBOutlet UIButton *twitterButton;
@property(nonatomic,retain)IBOutlet UIButton *pinterestButton;
@property(nonatomic,retain)IBOutlet UIButton *houzzButton;
@property(nonatomic,retain)IBOutlet UIButton *addToContactsButton;

@property(nonatomic,retain)IBOutlet UIScrollView *galleryPhotoScrollView;
@property(nonatomic,retain)IBOutlet UIScrollView *newsLetterScrollview;
@property(nonatomic,retain)IBOutlet UIScrollView *textViewScrollView;

@property(nonatomic,retain)IBOutlet UITextView *summaryAbout;
@property(nonatomic,strong)NSArray *arrayofFounders;

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorFaceBookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
@property(nonatomic,assign) SEL selectorShareEmailAction;
@property(nonatomic,assign)SEL selectorToHideUnhideToolBarView;
@property(nonatomic,assign)SEL selectorNewsLetterAction;
@property(nonatomic,assign)SEL selectorFounderClicked;
@property(nonatomic,assign)SEL selectorShareImageViaEmailAction;
-(IBAction)founderClicked:(id)sender;
-(void)setAboutLDCView;
-(NSString*)documentCatchePath;
@end
