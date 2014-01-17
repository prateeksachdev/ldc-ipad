//
//  EventMainView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventView;
@interface EventMainView : UIView<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *eventMainViewScrollView;
    
    EventView *currentPage;
    EventView *nextPage;
    id delegate;
    SEL selectorToHideUnhideToolBarView;        //Added By Umesh : to hide and unhide tool bar view
    SEL selectorFacebookAction;
    SEL selectorTwitterAction;
    SEL selectorMailAction;
    SEL selectorRegisterForEventAction;     //Added By Umesh on 04 March 2013

}
@property (nonatomic,retain) IBOutlet UIScrollView *eventMainViewScrollView;
@property(nonatomic,retain)EventView *currentPage;
@property(nonatomic,retain)EventView *nextPage;
@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) SEL selectorToHideUnhideToolBarView;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,assign) SEL selectorFacebookAction;
@property (nonatomic,assign) SEL selectorTwitterAction;
@property (nonatomic,assign) SEL selectorMailAction;
@property (nonatomic,assign) SEL selectorRegisterForEventAction;

- (void)applyNewIndex:(NSInteger)newIndex totalCount:(NSInteger)pagecount pageController:(EventView *)pageController;
-(void)scrollingEnable:(NSString*)string;
-(void)leftArrowAction:(EventView*)eventView;
-(void)rightArrowAction:(EventView*)eventView;
@end
