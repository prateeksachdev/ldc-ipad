//
//  PdfReaderViewController.h
//  Pollack
//
//  Created by kapil bansal on 12/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PdfReaderViewController : UIViewController{
    NSString *pdfFileName;
    id delegate;
    SEL selectorToRemovePdfReaderView;
    BOOL addPreAndPostFix;
}
//give the complete file path if its not in bundle or just the file name
@property(nonatomic, retain)NSString *pdfFileName;
@property(nonatomic, retain)id delegate;
@property(nonatomic, assign)SEL selectorToRemovePdfReaderView;
@property(nonatomic, assign)BOOL addPreAndPostFix;

-(void)loadPdfReader;
@end
