//
//  GalleryView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 23/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
@interface GalleryView : UIView<UIScrollViewDelegate>
{
    IBOutlet UILabel *galleryTextLable;
    IBOutlet UIButton *galleryShareButton;
    IBOutlet UIButton *galleryCloseButton;
    IBOutlet UIButton *galleryRightArrowButton;
    IBOutlet UIButton *galleryLeftArrowButton;

    IBOutlet UIScrollView *galleryPhotoScrollView;
    
    
    
    NSArray *galleryPhotoArray;
    id delegate;
    id delegate1;

    SEL selectorHandleLeft;
    SEL selectorHandleRight;
    SEL selectorCloseGallery;
    SEL selectorFaceBookAction;
    SEL selectorTwitterAction;
    SEL selectorEmailAction;
    ShareView *shareViewObj;
    
    int pageOnScrollView;

}
@property(nonatomic,retain) id delegate;
@property(nonatomic,assign) SEL selectorHandleLeft;
@property(nonatomic,assign) SEL selectorHandleRight;
@property (nonatomic,assign) SEL selectorScrollViewScrolling;
@property (nonatomic,assign) SEL selectorCloseGallery;
@property (nonatomic,assign) SEL selectorFaceBookAction;
@property (nonatomic,assign) SEL selectorTwitterAction;
@property (nonatomic,assign) SEL selectorEmailAction;
@property(nonatomic,assign) int pageIndex;

@property(nonatomic,retain) IBOutlet UILabel *galleryTextLable;
@property(nonatomic,retain) IBOutlet UIScrollView *galleryPhotoScrollView;
@property(nonatomic,retain) NSArray *galleryPhotoArray;

-(IBAction)galleryLeftArrow_Clicked:(id)sender;
-(IBAction)galleryRightArrow_Clicked:(id)sender;
-(IBAction)galleryClose_Clicked:(id)sender;
-(IBAction)shareImageAction:(id)sender;
-(void)addMemberImageGallery:(int)pageIndexValue;
-(void)addEventImageGallery:(int)pageIndexValue;
-(void)addAboutLdcImageGallery:(int)pageIndexValue;
-(void)hideArrowButtonsForIndex:(NSInteger)currentPageIndex;
-(NSString*)documentCatchePath;
@end
