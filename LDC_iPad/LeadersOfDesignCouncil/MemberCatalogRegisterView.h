//
//  MemberCatalogRegisterView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 29/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;

@interface MemberCatalogRegisterView : UIView<UIScrollViewDelegate,UITextFieldDelegate>

{
    IBOutlet UIButton *memberCatalogAllButton;
    IBOutlet UIButton *memberCatalogByLocationButton;
    IBOutlet UIButton *memberCatalogByIndustryButton;
    IBOutlet UIButton *memberCatalogLocationDetailButton;

    IBOutlet UIScrollView *memberCatalogScrollView;
    IBOutlet UIPageControl *memberCatalogPageControl;
    
    IBOutlet UITextField *memberCatalogSearchTextField;
    IBOutlet UIImageView *memberCatalogSearchTextFieldImageView;
    
    IBOutlet UILabel *memberCatalogSearchTextLable;
    IBOutlet UILabel *memberCatalogSearchResultLable;

    NSMutableArray *memberListArray;
    NSArray *searchArray;
    NSMutableArray *dummyArray;
    NSArray *professionArray;
    
    NSMutableArray *professionArrayFixed;
    id delegate;
    SEL selectorMemberCatalogAction;
    SEL selectorMemberCatalogDetailAction;
    BOOL searchCheckFlage;
    
    BOOL isMemberSelected;  //Added by umesh to fix hanging of bottom bar in middle
}

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorMemberCatalogAction;
@property(nonatomic,assign)SEL selectorMemberCatalogDetailAction;
@property(nonatomic,retain)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain)IBOutlet UIScrollView *memberCatalogScrollView;
@property (nonatomic,retain)NSArray *continentArray;
@property (nonatomic,retain)NSArray *countryArray;
@property (nonatomic,retain)NSArray *stateArray;
@property (nonatomic,retain)NSArray *searchArray;
@property (nonatomic,retain)NSArray *memberListArray;
@property (nonatomic,retain)NSArray *professionArray;
- (IBAction)changePage:(id)sender;
-(void)cleareScrollViewContent;
-(void)addMemberContentOnScrollView:(NSArray*)memberArray;
-(void)addLocationContentOnScrollView:(NSArray*)locationArray;
-(void)addSearchResultOnScrollView:(int)rowCount:(int)columnCount:(NSArray*)searchContentArray;
-(void)continentButtonAction:(id)sender;
-(void)countryButtonAction:(id)sender;
-(void)stateButtonAction:(id)sender;
-(NSString*)documentCatchePath;
-(NSMutableArray *)getProfessionList;
@end
