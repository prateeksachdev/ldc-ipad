//
//  EventMainView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "EventMainView.h"
#import "EventView.h"
@implementation EventMainView

@synthesize eventMainViewScrollView;
@synthesize currentPage,nextPage,pageCount,selectorToHideUnhideToolBarView,delegate;
@synthesize selectorMailAction,selectorTwitterAction,selectorFacebookAction,selectorRegisterForEventAction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"EventMainView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
    }
    return self;
}

- (void)applyNewIndex:(NSInteger)newIndex totalCount:(NSInteger)pagecount pageController:(EventView *)pageController
{
	 pageCount = pagecount;
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = eventMainViewScrollView.frame.size.width * newIndex;
		pageController.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.frame;
		pageFrame.origin.y = eventMainViewScrollView.frame.size.height;
		pageController.frame = pageFrame;
	}
    
	pageController.eventViewPageIndex = newIndex;
    
    
   // [pageController setViewPageIndex:newIndex];
    
    if (newIndex<pagecount) {
        
        pageController.eventViewPageIndex = newIndex;
        
        [pageController setviewPageIndex1:newIndex];
        
    }
    else {
        
        pageController.eventViewPageIndex = pagecount;
        
        [pageController setviewPageIndex1:pagecount-1];
        
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = eventMainViewScrollView.frame.size.width;
    float fractionalPage = eventMainViewScrollView.contentOffset.x / pageWidth;
	
	NSInteger lowerNumber = floor(fractionalPage);
	NSInteger upperNumber = lowerNumber + 1;
	
	if (lowerNumber == currentPage.eventViewPageIndex)
	{
		if (upperNumber != nextPage.eventViewPageIndex)
		{
			[self applyNewIndex:upperNumber totalCount:pageCount pageController:nextPage];
		}
	}
	else if (upperNumber == currentPage.eventViewPageIndex)
	{
		if (lowerNumber != nextPage.eventViewPageIndex)
		{
			[self applyNewIndex:lowerNumber totalCount:pageCount pageController:nextPage];
		}
	}
	else
	{
		if (lowerNumber == nextPage.eventViewPageIndex)
		{
			[self applyNewIndex:upperNumber totalCount:pageCount pageController:currentPage];
		}
		else if (upperNumber == nextPage.eventViewPageIndex)
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
    CGFloat pageWidth = eventMainViewScrollView.frame.size.width;
    float fractionalPage = eventMainViewScrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
    
	if (currentPage.eventViewPageIndex != nearestNumber)
	{
		EventView *swapController = currentPage;
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

-(void)leftArrowAction:(EventView*)eventView
{
    NSInteger pageIndex;
    if (eventView.eventViewPageIndex==0) {
        
        pageIndex=0;
        
    }
    else {
        pageIndex = eventView.eventViewPageIndex-1 ;
    }
    //	// update the scroll view to the appropriate page
    CGRect frame = eventMainViewScrollView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    //
    [eventMainViewScrollView scrollRectToVisible:frame animated:YES];
    
}
-(void)rightArrowAction:(EventView*)eventView
{
    NSInteger pageIndex;
    if (eventView.eventViewPageIndex==pageCount) {
        
        pageIndex=pageCount;
        
    }
    else {
        pageIndex = eventView.eventViewPageIndex+1 ;
    }
    
    //	// update the scroll view to the appropriate page
    CGRect frame = eventMainViewScrollView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    //
    [eventMainViewScrollView scrollRectToVisible:frame animated:YES];
    
}

-(void)scrollingEnable:(NSString*)string
{
    if ([string isEqualToString:@"YES"]) {
        
        eventMainViewScrollView.scrollEnabled=YES;
        
    }
    else if ([string isEqualToString:@"NO"]) {
        
        eventMainViewScrollView.scrollEnabled=NO;
        
    }
}
//Added By Umesh to get the event of closed button clicked (of gallery view)
-(void)hideUnhdieBottomBar:(NSString *)doHideBottomBar{
 
    if ([delegate respondsToSelector:selectorToHideUnhideToolBarView]) {
        [delegate performSelector:selectorToHideUnhideToolBarView withObject:doHideBottomBar afterDelay:0.0];
    }
}

-(void)faceBookAction:(NSString*)str
{
    if ([delegate respondsToSelector:selectorFacebookAction]) {
        [delegate performSelector:selectorFacebookAction withObject:str afterDelay:0.0];
    }

}

-(void)twitterAction:(NSString*)str
{
    if ([delegate respondsToSelector:selectorTwitterAction]) {
        [delegate performSelector:selectorTwitterAction withObject:str afterDelay:0.0];
    }

}

-(void)emailAction:(NSArray*)array
{
    if ([delegate respondsToSelector:selectorMailAction]) {
        [delegate performSelector:selectorMailAction withObject:array afterDelay:0.0];
    }

}
-(void)registerForEvent:(NSDictionary *)emailDetailsDict{
    
    if ([delegate respondsToSelector:selectorRegisterForEventAction]) {
        [delegate performSelector:selectorRegisterForEventAction withObject:emailDetailsDict afterDelay:0.0];
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
