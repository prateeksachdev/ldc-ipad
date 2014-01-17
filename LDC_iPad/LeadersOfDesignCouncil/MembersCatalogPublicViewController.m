//
//  MembersCatalogPublicViewController.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 2/4/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MembersCatalogPublicViewController.h"
#import "MemberCatalogPublicView.h"
#import <MessageUI/MessageUI.h>
@interface MembersCatalogPublicViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation MembersCatalogPublicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
- (void)viewDidLoad
{
    
    MemberCatalogPublicView*memberCatalogPublicViewObj=[[MemberCatalogPublicView alloc]initWithFrame:CGRectMake(0,0,1024,748)];
    [memberCatalogPublicViewObj setDelegate:self];
    [memberCatalogPublicViewObj setSelectorBackAction:@selector(backButtonAction)];
    [self.view addSubview:memberCatalogPublicViewObj];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)backButtonAction{
[[self navigationController]popToRootViewControllerAnimated:YES];
}
//Added bY Umesh to make Email button work on memberBio view on 22 Feb 2013
-(void)showEmailPopOvew:(NSArray *)emailIDArray{
//    NSLog(@"showEmailPopOvew?>>>>");
    
    MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
    [mailComposer setToRecipients:emailIDArray];
    [mailComposer setSubject:@""]; // Use the document file name for the subject
    
    mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
    NSString *mailBOdySTring =@"\n\nSent via the LDC iPad App";
    [mailComposer setMessageBody:mailBOdySTring isHTML:FALSE];
    mailComposer.mailComposeDelegate = self; // Set the delegate
    [self presentViewController:mailComposer animated:YES completion:nil];
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
