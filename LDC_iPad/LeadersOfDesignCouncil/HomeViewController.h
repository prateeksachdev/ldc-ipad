//
//  HomeView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
#import "SettingsView.h"
#import "EventView.h"
#import "MemberCatalogRegisterView.h"
#import "AboutLDCView.h"
#import "EventListView.h"
#import "MemberBioView.h"
#import "LDCFavoritesView.h"
#import "MemberBioViewList.h"
#import "EventMainView.h"
#import "PdfReaderNaviagtionController.h"
#import "PdfReaderViewController.h"
@class MemberBioView,LDCFavoritesView,InAppBrowser,UpdateDatabase;

@interface HomeViewController : UIViewController
{
    
    IBOutlet UIView *toolBarView;
    
    IBOutlet UIButton *ledearsOfDesignButton;
    IBOutlet UIImageView *ledearsOfDesignselectedImageView;
    IBOutlet UIButton *homeButton;
    IBOutlet UIImageView *lhomeselectedImageView;

    IBOutlet UIButton *membersButton;
    IBOutlet UIImageView *membersselectedImageView;

    IBOutlet UIButton *eventsButton;
    IBOutlet UIImageView *eventsselectedImageView;

    IBOutlet UIButton *ldcFavoritesButton;
    IBOutlet UIImageView *ldcFavoritesselectedImageView;


    IBOutlet UIButton *settingButton;
    IBOutlet UIImageView *settingselectedImageView;
    
    UIView *bottomViewBackground;       //Added By Umesh on 19 Feb 2013, to solve the issue of home view visible suring transition of bottom views.
    UIView *TopView;
    
    HomeView *homeViewObj;
    SettingsView *settingViewObj;
    EventView *eventViewObj;
    MemberCatalogRegisterView *memberCatalogViewObj;
    AboutLDCView *aboutLdcViewObj;
    EventListView *eventListViewObj;
    MemberBioView *memberBioViewObj;
    LDCFavoritesView*ldcFavoritesViewObj;
    MemberBioViewList *memberBioViewListObj;
    EventMainView *eventMainViewObj;
    InAppBrowser *inAppBrowserObj;
    UpdateDatabase *updatedata;

    AppDelegate *appDelegate;
    PdfReaderViewController *pdfReaderViewControllerObj;
    UINavigationController *pdfReaderViewControllerNavObj;
    

    NSDictionary *responsedict;
    BOOL isHomeClicked;     //to cancel the responce when bring tool bar back to middle when home button is tapped;
}
-(IBAction)setttingButtonAction:(id)sender;
-(IBAction)aboutLdcButtonAction:(id)sender;
-(IBAction)homeButtonAction:(id)sender;
-(IBAction)membersButtonAction:(id)sender;
-(IBAction)eventButtonAction:(id)sender;
-(IBAction)ldcFavoritesAction:(id)sender;

//Added By Umesh on 19 Feb 2013 :  to hide the tool bar view (to show a view, galleryview, in full screen mode)
-(void)hideToolBarView;
//Added By Umesh on 19 Feb 2013 :  to show the tool bar view (to show tool bar on exiting full screen mode.)
-(void)showToolBarView;
-(void)removeAllViews;
-(void)downloadUpdate;
-(void)cancelUpdate;

-(void)simulateSettingButtonClikced;

@end
