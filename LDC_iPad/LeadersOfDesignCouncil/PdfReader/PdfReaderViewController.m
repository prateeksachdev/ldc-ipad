//
//  PdfReaderViewController.m
//  Pollack
//
//  Created by kapil bansal on 12/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PdfReaderViewController.h"
#import "ReaderViewController.h"

@interface PdfReaderViewController ()<ReaderViewControllerDelegate>

@end

@implementation PdfReaderViewController
@synthesize pdfFileName;
@synthesize delegate;
@synthesize selectorToRemovePdfReaderView;
@synthesize addPreAndPostFix;

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
    [super viewDidLoad];
    [self loadPdfReader];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
-(void)loadPdfReader{
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
//	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath;
    if (addPreAndPostFix) {
        filePath = [[NSBundle mainBundle] pathForResource:pdfFileName ofType:@"pdf"];
    }
    else{
        filePath = pdfFileName;
    }
    
//	NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfFileName ofType:@"pdf"];
    if (!filePath) {
//        NSLog(@"Not found>>>");
        
        if ([delegate respondsToSelector:selectorToRemovePdfReaderView]) {
            [delegate performSelector:selectorToRemovePdfReaderView withObject:nil afterDelay:0.0];
        }
    }
    else{
        assert(filePath != nil); // Path to last PDF file
//        NSLog(@"filePath : %@",filePath);
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
        if (!document) {
                NSArray *fileName = [pdfFileName componentsSeparatedByString:@"."];
                filePath = [[NSBundle mainBundle] pathForResource:[fileName objectAtIndex:0] ofType:@"pdf"];
            document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
        }
        
        
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.view.frame = self.view.bounds;
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
//             NSLog(@"self.navigationController : %@",self.navigationController);
            [self.navigationController pushViewController:readerViewController animated:YES];
            
#else // present in a modal view controller
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self.view addSubview:readerViewController.view];
      //      [self presentViewController:readerViewController animated:YES completion:nil];
//            NSLog(@"self.navigationController : %@",self.navigationController);
            [self presentModalViewController:readerViewController animated:YES];
//            [self presentedViewController:readerViewController animated:YES];
            
#endif // DEMO_VIEW_CONTROLLER_PUSH
        }
    }
    
    
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
//	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
    if ([delegate respondsToSelector:selectorToRemovePdfReaderView]) {
        [delegate performSelector:selectorToRemovePdfReaderView withObject:nil afterDelay:0.0];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end
