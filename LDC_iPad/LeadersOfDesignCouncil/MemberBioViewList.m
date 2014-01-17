//
//  MemberBioVIewList.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MemberBioViewList.h"
#import "MemberBioView.h"

@implementation MemberBioViewList
@synthesize memberBioViewListScrollView,currentPage,nextPage,delegate,pageCount;
@synthesize selectorToHideUnhideToolBarView,selectorTotakeMeToHomeView,selectorFacebookAction,selectorTwitterAction,selectorMailAction,publicBackButton,publicBarImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"MemberBioViewList" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];

    }
    return self;
}

- (void)applyNewIndex:(NSInteger)newIndex totalCount:(NSInteger)pagecount pageController:(MemberBioView *)pageController
{
    pageCount=pagecount;
    BOOL outOfBounds = newIndex >= pagecount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = memberBioViewListScrollView.frame.size.width * newIndex;
		pageController.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.frame;
		pageFrame.origin.y = memberBioViewListScrollView.frame.size.height;
		pageController.frame = pageFrame;
	}
    
    [pageController setViewPageIndex:newIndex];
    
    if (newIndex<pagecount) {
    
        pageController.viewPageIndex = newIndex;

        [pageController setviewPageIndex1:newIndex];

    }
    else {
        
        pageController.viewPageIndex = pagecount;
        
        [pageController setviewPageIndex1:pagecount-1];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = memberBioViewListScrollView.frame.size.width;
    float fractionalPage = memberBioViewListScrollView.contentOffset.x / pageWidth;
	
	NSInteger lowerNumber = floor(fractionalPage);
	NSInteger upperNumber = lowerNumber + 1;
	
	if (lowerNumber == currentPage.viewPageIndex)
	{
		if (upperNumber != nextPage.viewPageIndex)
		{
			[self applyNewIndex:upperNumber totalCount:pageCount pageController:nextPage];
		}
	}
	else if (upperNumber == currentPage.viewPageIndex)
	{
		if (lowerNumber != nextPage.viewPageIndex)
		{
			[self applyNewIndex:lowerNumber totalCount:pageCount pageController:nextPage];
		}
	}
	else
	{
		if (lowerNumber == nextPage.viewPageIndex)
		{
			[self applyNewIndex:upperNumber totalCount:pageCount pageController:currentPage];
		}
		else if (upperNumber == nextPage.viewPageIndex)
		{
			[self applyNewIndex:lowerNumber totalCount:pageCount pageController:currentPage];
		}
		else
		{
			[self applyNewIndex:lowerNumber totalCount:pageCount pageController:currentPage];
			[self applyNewIndex:upperNumber totalCount:pageCount pageController:nextPage];
		}
	}
	
	//[currentPage updateTextViews:NO];
	//[nextPage updateTextViews:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    CGFloat pageWidth = memberBioViewListScrollView.frame.size.width;
    float fractionalPage = memberBioViewListScrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
    
	if (currentPage.viewPageIndex != nearestNumber)
	{
		MemberBioView *swapController = currentPage;
		currentPage = nextPage;
		nextPage = swapController;
	}
    
//	[currentPage updateTextViews:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
//	pageControl.currentPage = currentPage.pageIndex;
}

-(void)leftArrowAction:(MemberBioView*)memberBioView
{
    NSInteger pageIndex;
    if (memberBioView.viewPageIndex==0) {
        
         pageIndex=0;

    }
    else {
         pageIndex = memberBioView.viewPageIndex-1 ;
    }
    //	// update the scroll view to the appropriate page
        CGRect frame = memberBioViewListScrollView.frame;
        frame.origin.x = frame.size.width * pageIndex;
        frame.origin.y = 0;
    //
        [memberBioViewListScrollView scrollRectToVisible:frame animated:YES];

}
-(void)rightArrowAction:(MemberBioView*)memberBioView

{
    NSInteger pageIndex;
    if (memberBioView.viewPageIndex==pageCount) {
        
        pageIndex=pageCount;
        
    }
    else {
        pageIndex = memberBioView.viewPageIndex+1 ;
    }

        //	// update the scroll view to the appropriate page
    CGRect frame = memberBioViewListScrollView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    //
    [memberBioViewListScrollView scrollRectToVisible:frame animated:YES];

}
-(void)facebookAction:(NSDictionary*)sharedDataDict{
  
//    NSLog(@"facebookAction >>>>>");
    if ([delegate respondsToSelector:selectorFacebookAction]) {
        [delegate performSelector:selectorFacebookAction withObject:sharedDataDict afterDelay:0.0];
    }
}

-(void)twitterAction:(NSDictionary*)sharedDataDict{
//    NSLog(@"twitterAction >>>>>");
    if ([delegate respondsToSelector:selectorTwitterAction]) {
        [delegate performSelector:selectorTwitterAction withObject:sharedDataDict afterDelay:0.0];
    }
}
-(void)shareEmailAction:(NSDictionary*)sharedDataDict{
//    NSLog(@"EmailAction >>>>>");
//    if ([delegate respondsToSelector:selectorMailAction]) {
//        [delegate performSelector:selectorMailAction withObject:str afterDelay:0.0];
//    }
    
    if ([delegate respondsToSelector:@selector(ShareEmailForMember:)]) {
        [delegate performSelector:@selector(ShareEmailForMember:) withObject:sharedDataDict afterDelay:0.0];
    }

}

-(IBAction)closeAction:(id)sender
{
  //  [self removeFromSuperview];
    
    [self fadeView:self fadein:NO timeAnimation:0.3];
}

//Added By Umesh to pass the email button action to the controller to make email pop over appear on 21 Feb 2013

-(void)emailAction:(NSArray *)emailIDArray{
    
    //from here I have passed the controll to MembersCatalogPublicViewController Class to make mail pop over visible
    
    if ([delegate respondsToSelector:@selector(showEmailPopOvew:)]) {
        [delegate performSelector:@selector(showEmailPopOvew:) withObject:emailIDArray afterDelay:0.0];
    }
    
    
}


//Added By Umesh to get the event of closed button clicked (of gallery view)
-(void)hideUnhdieBottomBar:(NSString *)doHideBottomBar{
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:doHideBottomBar afterDelay:0.0];
    }
}
//-(void)hideBottomToolBar{
//    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
//        [delegate performSelector:selectorToHideUnhideToolBarView withObject:@"True" afterDelay:0.0];
//    }
//}

#pragma Fade In and fade Out Animation Method


-(void)fadeView:(UIView *)view fadein:(BOOL)fade timeAnimation:(NSTimeInterval)timeAnim
{
    if(fade){
        view.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:timeAnim];
        [UIView setAnimationDelegate:self];
        view.alpha =1;
        [UIView commitAnimations];
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:timeAnim];
        [UIView setAnimationDelegate:self];
        view.alpha = 0;
        [UIView commitAnimations];
    }
    
}

-(void)scrollingEnable:(NSString*)string
{
    if ([string isEqualToString:@"YES"]) {
        
        memberBioViewListScrollView.scrollEnabled=YES;

    }
    else if ([string isEqualToString:@"NO"]) {
        
        memberBioViewListScrollView.scrollEnabled=NO;

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
