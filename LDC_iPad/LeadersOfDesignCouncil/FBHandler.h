//
//  FBHandler.h
//  FBTest
//
//  Created by User on 1/30/13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBHandler : UIView<FBLoginViewDelegate>{
    
    UIViewController *viewController;

    NSString *msg;
    
}
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;


//- (id)initWithFrame:(CGRect)frame :(UIViewController*)controller message:(NSString*)message;

+ (FBHandler *)sharedInstance;
-(void)controller:(UIViewController*)controller AndMessage:(NSString*)postMsg;

- (IBAction)postStatusUpdateClick:(id)sender;
- (IBAction)dismissFB:(id)sender;

@end
