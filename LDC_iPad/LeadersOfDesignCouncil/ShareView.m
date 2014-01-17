//
//  ShareView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/25/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.


#import "ShareView.h"
#import "InAppBrowser.h"
#import "FBHandler.h"
@implementation ShareView

@synthesize shareBackgroundView,selectorFaceBookAction,delegate,selectorTwitterAction,selectorEmailAction;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
    }
    return self;
}
-(IBAction)faceBookAction:(id)sender{
    if ([delegate respondsToSelector:selectorFaceBookAction]) {
        [delegate performSelector:selectorFaceBookAction withObject:nil afterDelay:0.0];
    }
}
-(IBAction)twitterAction:(id)sender{
    if ([delegate respondsToSelector:selectorTwitterAction]) {
        [delegate performSelector:selectorTwitterAction withObject:nil afterDelay:0.0];
    }
}
-(IBAction)pinterestAction:(id)sender{
    InAppBrowser *inAppbrowserObj;
    if (!inAppbrowserObj) {
        inAppbrowserObj = [[InAppBrowser alloc] initWithFrame:CGRectMake(0, 0, 1024, 680)];
    }
    inAppbrowserObj.alpha = 1;
    inAppbrowserObj.titleLabel.text=@"Pinterest";
    [inAppbrowserObj setShowURL:[NSURL URLWithString:@"http://pinterest.com/"]];
    [inAppbrowserObj loadWebRequest];
    [self addSubview:inAppbrowserObj];

}
-(IBAction)emailAction:(id)sender{
    if ([delegate respondsToSelector:selectorEmailAction]) {
        [delegate performSelector:selectorEmailAction withObject:nil afterDelay:0.0];
    }
}
-(IBAction)closeAction:(id)sender{
    [self fadeView:self fadein:NO timeAnimation:0.3];
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end