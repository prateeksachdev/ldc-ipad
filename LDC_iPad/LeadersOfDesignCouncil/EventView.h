//
//  EventView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 23/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GalleryView;
@interface EventView : UIView
{

     IBOutlet UILabel *titleEventNameLabel;
     IBOutlet UILabel *eventNameLabel;
     IBOutlet UILabel *eventAddressLabel;
     IBOutlet UILabel *eventDateLable;
     IBOutlet UILabel *galleryLabel;
    IBOutlet UILabel *agendaLable;
    
    
     IBOutlet UIButton *mapButton;
    
     IBOutlet UILabel *summaryAbout;

     IBOutlet UIScrollView *galleryPhotoScrollView;

    IBOutlet UIScrollView *eventDetailScrollVIew;
    
     IBOutlet UIImageView *eventPhotoImageView;
    
    IBOutlet UIView *eventDetailsView;
    
    IBOutlet UIButton *leftEventButton;
    IBOutlet UIButton *rightEventButton;
    IBOutlet UIButton *registerForEventButton;        //Added bY Umesh
    
    id delegate;
    SEL selectorLeftEventAction;
    SEL selectorRightEventAction;
    SEL selectorScrollingEnable;
    SEL selectorToHideOrShowBottomBar;      //Added By Umesh on 22 Feb 2013
    SEL selectorFaceBookAction;
    SEL selectorTwitterAction;
    SEL selectorShareEmailAction;
    SEL selectorRegisterForEventAction;     //Added By Umesh on 04 March 2013

    NSMutableArray *galleryPhotoArray;
    int pageIndex;

    GalleryView *galleryViewObj;
    
    NSInteger eventViewPageIndex;
 
    NSArray *eventAgendaArray;
    
    UIView *agendaView;
}

@property(nonatomic)NSInteger eventViewPageIndex;

@property(nonatomic,strong)NSArray *galleryPhotoArray;
@property(nonatomic,strong)NSArray *eventAgendaArray;

@property(nonatomic,retain)IBOutlet UILabel *titleEventNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *eventNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *eventDateLable;
@property(nonatomic,retain)IBOutlet UILabel *eventAddressLabel;
@property(nonatomic,retain)IBOutlet UILabel *galleryLabel;
@property(nonatomic,retain)IBOutlet UILabel *agendaLable;

@property(nonatomic,retain)IBOutlet UIView *eventDetailsView;
@property(nonatomic,retain) UIView *agendaView;

@property(nonatomic,retain)IBOutlet UILabel *summaryAbout;
@property(nonatomic,retain)IBOutlet UIImageView *eventPhotoImageView;

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorLeftEventAction;
@property(nonatomic,assign)SEL selectorRightEventAction;
@property(nonatomic,assign)SEL selectorScrollingEnable;
@property(nonatomic,assign) SEL selectorToHideOrShowBottomBar;
@property(nonatomic,assign)SEL selectorFaceBookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
@property(nonatomic,assign) SEL selectorShareEmailAction;
@property(nonatomic,assign) SEL selectorRegisterForEventAction;


@property(nonatomic,retain)NSArray *arraySave;
@property(nonatomic,assign) BOOL Status;


-(IBAction)mapButtonClicked:(id)sender;
-(IBAction)registerForEventButtonClicked:(id)sender;

-(void)galleryPhotoButton_Clicked:(id)sender;
-(IBAction)eventLeftButton_Clicked:(id)sender;
-(IBAction)eventRightButton_Clicked:(id)sender;

- (void)setviewPageIndex1:(NSInteger)newPageIndex;
-(void)addEventGalleryThumb;

-(void)hideUnhdieBottomBar:(NSString *)doHideBottomBar;

-(NSString*)documentCatchePath;
@end
