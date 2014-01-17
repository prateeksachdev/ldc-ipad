//
//  ShareView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/25/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView{
    id delegate;
    SEL selectorFaceBookAction;
    SEL selectorTwitterAction;
    SEL selectorEmailAction;
}
@property(nonatomic,assign)SEL selectorEmailAction;
@property(nonatomic,assign)SEL selectorFaceBookAction;
@property(nonatomic,assign)SEL selectorTwitterAction;
@property(nonatomic,retain)id delegate;
@property (nonatomic,retain)IBOutlet UIView *shareBackgroundView;
-(IBAction)faceBookAction:(id)sender;
-(IBAction)twitterAction:(id)sender;
-(IBAction)pinterestAction:(id)sender;
-(IBAction)emailAction:(id)sender;
-(IBAction)closeAction:(id)sender;
@end
