//
//  PdfReaderNaviagtionController.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 3/5/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "PdfReaderNaviagtionController.h"

@interface PdfReaderNaviagtionController ()

@end

@implementation PdfReaderNaviagtionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
