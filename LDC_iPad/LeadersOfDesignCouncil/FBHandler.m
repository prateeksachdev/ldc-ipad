//
//  FBHandler.m
//  FBTest
//
//  Created by User on 1/30/13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import "FBHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation FBHandler

@synthesize loggedInUser = _loggedInUser;
@synthesize buttonPostStatus, labelFirstName, profilePic;

static FBHandler *sharedFB = nil;

+ (FBHandler *)sharedInstance {
    
    @synchronized(self) {
        if (sharedFB == nil) {
            sharedFB = [[self alloc] initWithFrame:CGRectMake(224,120 , 320, 420)];
        }
    }
    return sharedFB;
}


- (id)initWithFrame:(CGRect)frame // :(UIViewController*)controller message:(NSString*)message
{
    self = [super initWithFrame:frame];
    if (self) {

        FBLoginView *loginview = [[FBLoginView alloc] init];
        loginview.frame = CGRectOffset(loginview.frame, 5, 5);
        loginview.delegate = self;
        
        
        UIView *nibView = [[[NSBundle mainBundle] loadNibNamed:@"FBHandler" owner:self options:nil]objectAtIndex:0];
        [self addSubview:nibView];
        
        
        CALayer * l = [self layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        [l setBorderWidth:1];
        
        [loginview sizeToFit];
        [nibView addSubview:loginview];


    }
    return self;
}


-(void)controller:(UIViewController*)controller AndMessage:(NSString*)postMsg{
    
    viewController = controller;
    msg = postMsg;
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.buttonPostStatus.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
    self.buttonPostStatus.enabled = canShareAnyhow;
    if (canShareAnyhow) {
        self.buttonPostStatus.hidden = NO;
    }
    else{
        self.buttonPostStatus.hidden = NO;
    }
    
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
}




- (IBAction)postStatusUpdateClick:(id)sender{
    

    
//    NSString *name = self.loggedInUser.first_name;
    NSString *message = @"test"; //[NSString stringWithFormat:@"Updating status for %@ at %@",name != nil ? name : @"me" , [NSDate date]];
    
    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:viewController
                                                                    initialText:@"Test"
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            
                                            [self showAlert:@"TEst" result:result error:error];
                                            self.buttonPostStatus.enabled = YES;
                                            self.buttonPostStatus.hidden = NO;
                                        }];
            
                        self.buttonPostStatus.enabled = NO;
            self.buttonPostStatus.hidden = YES;
        }];
    }
    
}

- (IBAction)dismissFB:(id)sender {
    
    [self removeFromSuperview];
}

#pragma mark -

- (void) performPublishAction:(void (^)(void)) action {
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}


// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        //NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = @"Successfully posted on Facebook";//[NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@", message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
