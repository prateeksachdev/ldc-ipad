//
//  LDCFavoritesView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 04/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate,InAppBrowser;
@interface LDCFavoritesView : UIView

{
    
IBOutlet UIButton *allButton;
IBOutlet UIButton *toDOButton;
IBOutlet UIButton *toSeeButton;
IBOutlet UIButton *toEatButton;
IBOutlet UIButton *toReadButton;

IBOutlet UIScrollView *lDCFavoritesViewScrollView;
IBOutlet UIPageControl *lDCFavoritesViewPageControl;

IBOutlet UITextField *lDCFavoritesViewSearchTextField;
IBOutlet UIImageView *lDCFavoritesViewSearchTextFieldImageView;

IBOutlet UILabel *lDCFavoritesViewSearchTextLable;
IBOutlet UILabel *lDCFavoritesViewSearchResultLable;

NSMutableArray *FavoritesListArray;
NSMutableArray *searchArray;
NSMutableArray *dummyArray;

AppDelegate *appDelegate;
NSArray *arrayOfCategory;

InAppBrowser *inAppBrowserObj;
    BOOL isFavoriteSelected;    //Added By umesh to fix hanging of bottom bar in middle
    
}

@property(nonatomic,retain)IBOutlet UIScrollView *lDCFavoritesViewScrollView;
@property(nonatomic,retain)NSArray *arrayOfCategory;
@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) SEL selectorFavSearch;
@property (nonatomic,assign) SEL selectorFavDetail;

- (IBAction)changePage:(id)sender;
-(NSString*)documentCatchePath;

@end
