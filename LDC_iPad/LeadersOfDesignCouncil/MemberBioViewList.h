//
//  MemberBioVIewList.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberBioView;
@interface MemberBioViewList : UIView <UIScrollViewDelegate>

{
    IBOutlet UIScrollView *memberBioViewListScrollView;
    
    MemberBioView *currentPage;
    MemberBioView *nextPage;
    
    id delegate;
    SEL selectorToHideUnhideToolBarView;        //Added By Umesh : to hide and unhide tool bar view
    SEL selectorTotakeMeToHomeView;
    SEL selectorFacebookAction;
    SEL selectorTwitterAction;
    SEL selectorMailAction;
    
    IBOutlet UIButton *publicBackButton;
    IBOutlet UIImageView *publicBarImageView;
}

@property (nonatomic,retain) IBOutlet UIScrollView *memberBioViewListScrollView;
@property (nonatomic,retain) MemberBioView *currentPage;
@property (nonatomic,retain) MemberBioView *nextPage;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,retain) id delegate;
@property(nonatomic,assign)SEL selectorToHideUnhideToolBarView;
@property(nonatomic,assign)SEL selectorTotakeMeToHomeView;
@property(nonatomic,assign)SEL selectorFacebookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
@property(nonatomic,assign)SEL selectorMailAction;
@property (nonatomic,retain) IBOutlet UIButton *publicBackButton;
@property (nonatomic,retain) IBOutlet UIImageView *publicBarImageView;
- (void)applyNewIndex:(NSInteger)newIndex totalCount:(NSInteger)pagecount pageController:(MemberBioView *)pageController;
-(void)leftArrowAction:(MemberBioView*)memberBioView;
-(void)rightArrowAction:(MemberBioView*)memberBioView;
-(IBAction)closeAction:(id)sender;

@end
