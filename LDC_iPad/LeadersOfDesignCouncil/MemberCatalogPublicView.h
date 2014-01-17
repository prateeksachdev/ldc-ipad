//
//  MemberCatalogPublicView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 24/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberBioView.h"
#import "MemberBioViewList.h"
#import "Memebers.h"

#import "State.h"
#import "Contitent.h"
#import "Country.h"

@interface MemberCatalogPublicView : UIView<UIScrollViewDelegate,UITextFieldDelegate>
{
   IBOutlet UIButton *memberCatalogBackButton;
   IBOutlet UILabel *memberCatalogTitleLable;
    
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

   NSArray *memberListArray;
   NSArray *searchArray;
   NSMutableArray *dummyArray;
 
   BOOL searchCheckFlage;
    
    MemberBioView *memberBioViewObj;
    MemberBioViewList*memberBioViewListObj;
    id delegate;
    SEL selectorBackAction;
    Memebers *membersObj;
    Contitent *contitentObj;
    Country *countryObj;
    State *stateObj;
    
    NSArray *continentArray;
    NSArray *countryArray;
    NSArray *stateArray;
    NSArray *professionArray;
    NSMutableArray *professionArrayFixed;
    
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain)Memebers *membersObj;
@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectorBackAction;
@property(nonatomic,retain)IBOutlet UIButton *memberCatalogAllButton;
@property(nonatomic,assign)BOOL searchCheckFlage;
@property(nonatomic,retain)IBOutlet UIScrollView *memberCatalogScrollView;
@property(nonatomic,retain)NSArray *memberListArray;
@property(nonatomic,retain)NSArray *searchArray;
@property(nonatomic,retain)NSArray *continentArray;
@property(nonatomic,retain)NSArray *countryArray;
@property(nonatomic,retain)NSArray *stateArray;
@property(nonatomic,retain)NSArray *professionArray;
- (IBAction)changePage:(id)sender;
-(IBAction)MemberByLocation_Clicked:(id)sender;
-(IBAction)MemberAll_Clicked:(id)sender;
-(IBAction)MemberSearch_Clicked:(id)sender;
-(IBAction)MemberSearchTextField_ValueChanged:(id)sender;
-(IBAction)MemberBack_Clicked:(id)sender;
-(NSString*)documentCatchePath;
-(NSMutableArray *)getProfessionList;
@end
