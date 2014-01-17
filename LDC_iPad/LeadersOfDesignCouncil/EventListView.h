//
//  EventListView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 01/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
@class AppDelegate;
@interface EventListView : UIView<UITextFieldDelegate>
{
    IBOutlet UIButton *eventListAllButton;
    IBOutlet UIButton *eventListUpcomingButton;
    IBOutlet UIButton *eventListPastButton;
    IBOutlet UIButton *eventListSearchButton;
    
    IBOutlet UIScrollView *eventListScrollView;
    IBOutlet UIPageControl *eventListPageControl;
    
    IBOutlet UITextField *eventListSearchTextField;
    IBOutlet UIImageView *eventListSearchTextFieldImageView;
    
    IBOutlet UILabel *eventListSearchTextLable;
    IBOutlet UILabel *eventListSearchResultLable;
    
    NSArray *eventListMainArray;
    NSMutableArray *searchArray;
    NSMutableArray *dummyArray;
    
    id delegate;
    SEL selectoreventListAction;
    SEL selectorEventListSearchAction;
    BOOL searchCheckFlage;

    NSArray *arraywithObjects;
    
    BOOL isEventSelected;       //Added By Umesh to fix bottom bar hanging in middle
}

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL selectoreventListAction;
@property(nonatomic,assign)SEL selectorEventListSearchAction;
@property(nonatomic,retain) NSArray *eventListMainArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain)Events *eventsObj;

-(IBAction)eventSearchTextField_ValueChanged:(id)sender;
-(NSString*)documentCatchePath;
@end
