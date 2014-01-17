//
//  FavoriteView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 22/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteView : UIView
@property (nonatomic,retain)IBOutlet UIImageView *thumbImageView;
@property (nonatomic,retain)IBOutlet UILabel *tittleLable;
@property (nonatomic,retain)IBOutlet UILabel *subTittleLable;
@property (nonatomic,retain)IBOutlet UIButton *viewActionButton;
@property (nonatomic,retain)NSString *urlString;
@property (nonatomic,retain)NSString *titleString;
@property (nonatomic,retain)id delegate;
@property (nonatomic,assign)SEL selectorButtonAction;
-(IBAction)viewActionButton_Clicked:(id)sender;
-(void)setlabelHieght;
@end
