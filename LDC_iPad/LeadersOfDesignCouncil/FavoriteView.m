//
//  FavoriteView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "FavoriteView.h"
#import "Constants.h"
@implementation FavoriteView
@synthesize thumbImageView,delegate,selectorButtonAction,tittleLable,subTittleLable,viewActionButton,urlString,titleString;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"FavoriteView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
    }
    return self;
}
-(IBAction)viewActionButton_Clicked:(id)sender
{
    if ([delegate respondsToSelector:selectorButtonAction]) {
        
        [delegate performSelector:selectorButtonAction withObject:self afterDelay:0.0];
    }
}
-(void)setlabelHieght{
    
    CGSize newSize;
    CGRect newFrame;
    
    newSize =[tittleLable.text sizeWithFont:tittleLable.font constrainedToSize:CGSizeMake(211, 42) lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = tittleLable.frame;
    newFrame.size.height = newSize.height;
    tittleLable.frame = newFrame;
    
    CGSize newSize1;
    CGRect newFrame1;
    
    newSize1 =[subTittleLable.text sizeWithFont:subTittleLable.font constrainedToSize:CGSizeMake(211, 21) lineBreakMode:NSLineBreakByWordWrapping];
    newFrame1 = subTittleLable.frame;
    newFrame1.size.height = newSize1.height;
    if (newSize.height>2) {
        newFrame1.origin.y =  newSize.height+3;
    }
    else{
        newFrame1.origin.y = 0;
    }
    subTittleLable.frame = newFrame1;
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
