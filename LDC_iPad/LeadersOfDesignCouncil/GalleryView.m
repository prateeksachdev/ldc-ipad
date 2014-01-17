//
//  GalleryView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 23/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "GalleryView.h"
#import "Constants.h"
#import "EventsGallery.h"
#import "MembersGallery.h"
#import "AbotLdcImageGallery.h"
#import <QuartzCore/QuartzCore.h>

@implementation GalleryView
@synthesize galleryTextLable,galleryPhotoScrollView,galleryPhotoArray,delegate,selectorHandleLeft,selectorHandleRight,selectorScrollViewScrolling,selectorCloseGallery,pageIndex,selectorFaceBookAction,selectorTwitterAction,selectorEmailAction;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        // Initialization code
     
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"GalleryView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];

        galleryCloseButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        [galleryCloseButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        galleryShareButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        [galleryShareButton setTitleColor:kLightWhiteColor forState:UIControlStateNormal];
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
       
        [galleryTextLable setTextColor:kGrayColor];

        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeft)];
        swipeLeft.numberOfTouchesRequired = 1;
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
       // [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleRight)];
        swipeRight.numberOfTouchesRequired = 1;
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
      //  [self addGestureRecognizer:swipeRight];
        
}
    return self;
}
-(NSString*)documentCatchePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}
-(void)addMemberImageGallery:(int)pageIndexValue
{
//    for (int i=0; i<[self.galleryPhotoArray  count]; i++)
//    {
//        
//        MembersGallery *MembersGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
//        UIImageView *galleryPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*1024,0,1024,728)];
//        galleryPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;
//        
//        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",MembersGalleryObj.mgImagePath];
//        
//        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
//            
//        [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
//        
//        }
//        else if ([UIImage imageNamed:MembersGalleryObj.mgImagePath]){
//            
//            [galleryPhotoImageView setImage:[UIImage imageNamed:MembersGalleryObj.mgImagePath]];
//        }
//        else
//        {
//            
////            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
//
//        }
//        
//        
//        [self.galleryPhotoScrollView addSubview:galleryPhotoImageView];
//    }
    
    [self loadNextPage:pageIndexValue];
    
    if (pageIndexValue+1 <[galleryPhotoArray count]) {
        
                
        [self loadNextPage:pageIndexValue+1];
        
        if (pageIndexValue-1 >=0)
        {
        [self loadNextPage:pageIndexValue-1];
        }
    
    }
    else if (pageIndexValue-1 >=0)
    {
        
         [self loadNextPage:pageIndexValue-1];

    }


    MembersGallery *MembersGalleryObj1=[self.galleryPhotoArray objectAtIndex:pageIndexValue];
    
    galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
    
    [galleryTextLable setTextColor:kGrayColor];
    
    galleryTextLable.text=MembersGalleryObj1.mgCaption;
    
    
//    CGSize newSize;
//    CGRect newFrame;
//    
//    newSize =[MembersGalleryObj1.mgCaption sizeWithFont:galleryTextLable.font constrainedToSize:CGSizeMake(674,12) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    newFrame = galleryTextLable.frame;
//    newFrame.size.height = newSize.height;
//    newFrame.size.width=newSize.width;
//    // newFrame.origin.y=658-(newSize.height+11);
//    
//    newFrame.origin.x=galleryPhotoScrollView.center.x;
//    
//    galleryTextLable.frame = newFrame;

    
    [self.galleryPhotoScrollView scrollRectToVisible:CGRectMake(pageIndexValue*1024,0,1024,728) animated:NO];
    [self hideArrowButtonsForIndex:pageIndexValue];
    [self bringSubviewToFront:galleryCloseButton];
    [self bringSubviewToFront:galleryRightArrowButton];
    [self bringSubviewToFront:galleryLeftArrowButton];

}
-(void)addAboutLdcImageGallery:(int)pageIndexValue
{
  
//    for (int i=0; i<[self.galleryPhotoArray  count]; i++)
//    {
//       // NSLog(@"%@",[self.galleryPhotoArray objectAtIndex:0]);
//        
//        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
//        
//        UIImageView *galleryPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*1024,0,1024, 728)];
//        galleryPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;
//
//         NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",abotLdcImageGalleryObj.imageName];
//        
//        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
//            
//            [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
//            
//        }
//        else if ([UIImage imageNamed:abotLdcImageGalleryObj.imageName]){
//            
//            [galleryPhotoImageView setImage:[UIImage imageNamed:abotLdcImageGalleryObj.imageName]];
//        }
//        else {
//            
////            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
//            
//        }
//    
//        
//        [self.galleryPhotoScrollView addSubview:galleryPhotoImageView];
//    }
    
    [self loadNextPage:pageIndexValue];
    
    if (pageIndexValue+1 <[galleryPhotoArray count]) {
        
        
        [self loadNextPage:pageIndexValue+1];
        
        if (pageIndexValue-1 >=0)
        {
            [self loadNextPage:pageIndexValue-1];
        }
        
    }
    else if (pageIndexValue-1 >=0)
    {
        
        [self loadNextPage:pageIndexValue-1];
        
    }

    AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndexValue];
    
    galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
    
    [galleryTextLable setTextColor:kGrayColor];
    
    galleryTextLable.text=abotLdcImageGalleryObj.caption;
    
    
    [self.galleryPhotoScrollView scrollRectToVisible:CGRectMake(pageIndexValue*1024, 0, 1024 , 728) animated:NO];
    [self hideArrowButtonsForIndex:pageIndexValue];

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self hideArrowButtonsForIndex:currentPageIndex];
    
    CGFloat pageWidth = galleryPhotoScrollView.frame.size.width;
    float fractionalPage = galleryPhotoScrollView.contentOffset.x / pageWidth;
    
    pageIndex=fractionalPage;
    
    CGRect frame = self.galleryPhotoScrollView.frame;
    frame.origin.x = 1024 * pageIndex;
    frame.origin.y = 0;
//    [self.galleryPhotoScrollView scrollRectToVisible:frame animated:YES];
//    [self hideArrowButtonsForIndex:pageIndex];
    
    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];
        
        galleryTextLable.text=eventsGalleryObj.egCaption;
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]]){
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];

        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        galleryTextLable.text=membersGalleryObj.mgCaption;
        
//        CGSize newSize;
//        CGRect newFrame;
//        
//        newSize =[membersGalleryObj.mgCaption sizeWithFont:galleryTextLable.font constrainedToSize:CGSizeMake(674,12) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        newFrame = galleryTextLable.frame;
//        newFrame.size.height = newSize.height;
//        newFrame.size.width=newSize.width;
//        // newFrame.origin.y=658-(newSize.height+11);
//        
//        newFrame.origin.x=galleryPhotoScrollView.center.x;
//        
//        galleryTextLable.frame = newFrame;
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]]){
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];
        
        galleryTextLable.text=abotLdcImageGalleryObj.caption;
        
    }

    
//NSLog(@"fractionalPage=%f",fractionalPage);

    [self bringSubviewToFront:galleryCloseButton];
    [self bringSubviewToFront:galleryRightArrowButton];
    [self bringSubviewToFront:galleryLeftArrowButton];

//    NSArray *array=[scrollView subviews];
//    //
//      NSLog(@"array===%@",array);
}
-(void)hideArrowButtonsForIndex:(NSInteger)currentPageIndex{
    if (currentPageIndex == 0) {
        galleryLeftArrowButton.hidden = TRUE;
    }
    else{
        galleryLeftArrowButton.hidden = FALSE;
    }
    
    if (currentPageIndex == ([self.galleryPhotoArray count]-1)) {
        galleryRightArrowButton.hidden = TRUE;
    }
    else{
        galleryRightArrowButton.hidden = FALSE;
    }
}
-(void)addEventImageGallery:(int)pageIndexValue
{
    
//    for (int i=0; i<[self.galleryPhotoArray  count]; i++)
//    {
//     //   NSLog(@"%@",[self.galleryPhotoArray objectAtIndex:0]);
//        
//        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
//        
//        UIImageView *galleryPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*1024,0,1024, 728)];
//        galleryPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;
//
//        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsGalleryObj.egImageName];
//        
////        NSLog(@"imageNameWithPath : %@",imageNameWithPath);
////        NSLog(@"eventsGalleryObj.egImageName: %@",eventsGalleryObj.egImageName);
//        
//        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
//            
//            [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
//            
//        }
//        else if ([UIImage imageNamed:eventsGalleryObj.egImageName]){
//            [galleryPhotoImageView setImage:[UIImage imageNamed:eventsGalleryObj.egImageName]];
//        }
//        else {
//            
////            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
//            
//        }
//        
//        [self.galleryPhotoScrollView addSubview:galleryPhotoImageView];
//    }
    
    [self loadNextPage:pageIndexValue];
    
    if (pageIndexValue+1 <[galleryPhotoArray count]) {
        
        
        [self loadNextPage:pageIndexValue+1];
        
        if (pageIndexValue-1 >=0)
        {
            [self loadNextPage:pageIndexValue-1];
        }
        
    }
    else if (pageIndexValue-1 >=0)
    {
        
        [self loadNextPage:pageIndexValue-1];
        
    }

    EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndexValue];
    
    galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
    
    [galleryTextLable setTextColor:kGrayColor];
    
    galleryTextLable.text=eventsGalleryObj.egCaption;        //instead of caption we are using egRS field its saving the caption value
    
    [self.galleryPhotoScrollView scrollRectToVisible:CGRectMake(pageIndexValue*1024, 0, 1024 , 728) animated:NO];
    [self hideArrowButtonsForIndex:pageIndexValue];
    
}


-(void)handleRight
{    
    if (pageIndex<=0) {
        
    }
    else {
        
        pageIndex--;
        
    }
    CGRect frame = self.galleryPhotoScrollView.frame;
    frame.origin.x = 1024 * pageIndex;
    frame.origin.y = 0;
    [self.galleryPhotoScrollView scrollRectToVisible:frame animated:YES];
    [self hideArrowButtonsForIndex:pageIndex];

    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        [galleryTextLable setTextColor:kGrayColor];
        galleryTextLable.text=eventsGalleryObj.egCaption;

    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]]){
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];

        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];

        galleryTextLable.text=membersGalleryObj.mgCaption;
        
//        CGSize newSize;
//        CGRect newFrame;
//        
//        newSize =[membersGalleryObj.mgCaption sizeWithFont:galleryTextLable.font constrainedToSize:CGSizeMake(674,12) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        newFrame = galleryTextLable.frame;
//        newFrame.size.height = newSize.height;
//        newFrame.size.width=newSize.width;
//        // newFrame.origin.y=658-(newSize.height+11);
//        
//        newFrame.origin.x=galleryPhotoScrollView.center.x;
//        
//        galleryTextLable.frame = newFrame;

    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]]){
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];
        
        galleryTextLable.text=abotLdcImageGalleryObj.caption;
        
    }
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint scrollOffset=scrollView.contentOffset;
    
    ///at any time, it will have only 3 pages loaded- previous, current and next
    if(pageOnScrollView < ((int)scrollOffset.x/1024))
    {
        //unload
        if(pageOnScrollView>1)[self unloadPreviousPage:pageOnScrollView-1];
        
        //load the next page
        [self loadNextPage:((int)scrollOffset.x/1024)+1];
    }
    else if(pageOnScrollView > ((int)scrollOffset.x/1024))
    {
     //   NSLog(@"%d",[self.galleryPhotoArray  count]);
        //unload
        if(pageOnScrollView<([self.galleryPhotoArray  count]-1))[self unloadPreviousPage:pageOnScrollView+1];
        
        //load back the previous page
        [self loadNextPage:((int)scrollOffset.x/1024)-1];
    }
    
    pageOnScrollView=scrollOffset.x/1024;
}

-(void)loadNextPage:(int)index
{
    // int countFlag=0;
    // for(int i=index;i<(index+1);i++)
    {
        //  NSLog(@"index=%d",index);
        
        if (index==-1) {
            
            index=0;
        }
        
        UIImageView *galleryPhotoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(index*1024,0,1024,728)];

      //  UIImageView* imageView=[[UIImageView alloc]init];
      //  imageView.frame=CGRectMake((768*index),0, 768, 1004);
        galleryPhotoImageView.tag=index+1;
        // [imageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        //  [imageView.layer setBorderWidth:1.0f];
        //  imageView.contentMode=UIViewContentModeRedraw;
        self.layer.shouldRasterize = YES;
        galleryPhotoImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        galleryPhotoImageView.layer.masksToBounds = NO;
        self.galleryPhotoScrollView.delaysContentTouches=NO;
        //    NSLog(@"%f",[[UIScreen mainScreen] scale]);
          if (index>=0 && index<[self.galleryPhotoArray count])
        {
            galleryPhotoImageView.contentMode=UIViewContentModeScaleAspectFit;
            
           if ([[self.galleryPhotoArray objectAtIndex:index] isKindOfClass:[AbotLdcImageGallery class]])
           {
               AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:index];
               
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",abotLdcImageGalleryObj.imageName];
               
               if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                   
                   [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
                   
               }
               else if ([UIImage imageNamed:abotLdcImageGalleryObj.imageName]){
                   
                   [galleryPhotoImageView setImage:[UIImage imageNamed:abotLdcImageGalleryObj.imageName]];
               }
               else {
                   
                   //            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
                   
               }

           }
            else if ([[self.galleryPhotoArray objectAtIndex:index] isKindOfClass:[MembersGallery class]])
            {
                MembersGallery *MembersGalleryObj=[self.galleryPhotoArray objectAtIndex:index];
                
                
                
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",MembersGalleryObj.mgImagePath];
                
                if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                    
                    [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
                    
                }
                else if ([UIImage imageNamed:MembersGalleryObj.mgImagePath]){
                    
                    [galleryPhotoImageView setImage:[UIImage imageNamed:MembersGalleryObj.mgImagePath]];
                }
                else
                {
                    
                    //            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
                    
                }

            }
           else  if ([[self.galleryPhotoArray objectAtIndex:index] isKindOfClass:[EventsGallery class]])
           {
               EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:index];
               
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsGalleryObj.egImageName];
               
               //        NSLog(@"imageNameWithPath : %@",imageNameWithPath);
               //        NSLog(@"eventsGalleryObj.egImageName: %@",eventsGalleryObj.egImageName);
               
               if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                   
                   [galleryPhotoImageView setImage:[UIImage imageWithContentsOfFile:imageNameWithPath]];
                   
               }
               else if ([UIImage imageNamed:eventsGalleryObj.egImageName]){
                   [galleryPhotoImageView setImage:[UIImage imageNamed:eventsGalleryObj.egImageName]];
               }
               else {
                   
                   //            [galleryPhotoImageView setImage:[UIImage imageNamed:@"gallery_02_detail_view.png"]];
                   
               }


            }

            

         //   [imageView setImage:[UIImage imageNamed:@"image_02.png"]];
            
            
            UIImageView *imageViewToRemove=(UIImageView*)[self.galleryPhotoScrollView viewWithTag:index+1];
            
            if ((index+1)>=0)
            {
                if (imageViewToRemove)
                {
                    [imageViewToRemove removeFromSuperview];
                    imageViewToRemove=nil;
                    
                }
                
            }
            
            [self.galleryPhotoScrollView addSubview:galleryPhotoImageView];
            
        }
        
      //   NSLog(@"imageView=%@",galleryPhotoImageView);
        
        //countFlag++;
    }
  //  [self.view bringSubviewToFront:topView];
  //  [self.view bringSubviewToFront:sideView];
}
-(void)unloadPreviousPage:(int)index
{
    // NSLog(@"index1=%d",index);
    
    //    for(int i=index;i<(index+1);i++)
    //    {
    UIImageView *imageView=(UIImageView*)[self.galleryPhotoScrollView viewWithTag:index+1];
    NSLog(@"%@",imageView);

    if (imageView) {
        [imageView removeFromSuperview];
        imageView=nil;
    }
    //    }
    
}
-(void)handleLeft
{    
    if (pageIndex+1<[self.galleryPhotoArray count]) {
        
        pageIndex++;

    }
    else {
        
        
    }
    CGRect frame = self.galleryPhotoScrollView.frame;
    frame.origin.x = 1024 * pageIndex;
    frame.origin.y = 0;
    [self.galleryPhotoScrollView scrollRectToVisible:frame animated:YES];
    [self hideArrowButtonsForIndex:pageIndex];
    
    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        [galleryTextLable setTextColor:kGrayColor];
        galleryTextLable.text=eventsGalleryObj.egCaption;
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]]){
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];

        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        galleryTextLable.text=membersGalleryObj.mgCaption;
        
//        CGSize newSize;
//        CGRect newFrame;
//        
//        newSize =[membersGalleryObj.mgCaption sizeWithFont:galleryTextLable.font constrainedToSize:CGSizeMake(674,12) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        newFrame = galleryTextLable.frame;
//        
//        newFrame.size.height = newSize.height;
//        newFrame.size.width=newSize.width;
//        
//        newFrame.origin.x=galleryPhotoScrollView.center.x;
//        
//        galleryTextLable.frame = newFrame;

    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]]){
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        galleryTextLable.font=[UIFont fontWithName:FontLight size:12];
        
        [galleryTextLable setTextColor:kGrayColor];
        
        galleryTextLable.text=abotLdcImageGalleryObj.caption;
        
    }

}

-(IBAction)galleryLeftArrow_Clicked:(id)sender
{
    [self handleRight];
}

-(IBAction)galleryRightArrow_Clicked:(id)sender
{
    [self handleLeft];

}

-(IBAction)galleryClose_Clicked:(id)sender
{
   
    if ([delegate respondsToSelector:selectorScrollViewScrolling]) {
        
        [delegate performSelector:selectorScrollViewScrolling withObject:nil afterDelay:0.0];
    }

    if ([delegate respondsToSelector:selectorCloseGallery]) {
        [delegate performSelector:selectorCloseGallery withObject:nil afterDelay:0.0];
    }
    
    [self fadeView:self fadein:NO timeAnimation:0.3];
}
-(IBAction)shareImageAction:(id)sender{
   
    if (!shareViewObj) {
        shareViewObj=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, 1024,748)];
        [shareViewObj setSelectorFaceBookAction:@selector(shareFaceBook)];
        [shareViewObj setSelectorTwitterAction:@selector(shareTwitter)];
        [shareViewObj setSelectorEmailAction:@selector(shareEmail)];
    }
    shareViewObj.delegate=self;
    [self addSubview:shareViewObj];
    [self fadeView:shareViewObj fadein:YES timeAnimation:0.3];
}
-(void)shareEmail{

    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        if ([delegate respondsToSelector:selectorEmailAction]) {
            
            NSArray *array=[[NSArray alloc]initWithObjects:eventsGalleryObj.egImageName,nil];
            
            [delegate performSelector:selectorEmailAction withObject:array afterDelay:0.0];
        }
        
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]])
    {
        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
    if ([delegate respondsToSelector:selectorEmailAction])
    {
        NSArray *array=[[NSArray alloc]initWithObjects:membersGalleryObj.mgImagePath,nil];

        [delegate performSelector:selectorEmailAction withObject:array afterDelay:0.0];
        
    }
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]])
    {
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];

        if ([delegate respondsToSelector:selectorEmailAction])
        {
            NSArray *array=[[NSArray alloc]initWithObjects:abotLdcImageGalleryObj.imageName,nil];
            
            [delegate performSelector:selectorEmailAction withObject:array afterDelay:0.0];
            
        }

    }

}
-(void)shareTwitter{

    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        if ([delegate respondsToSelector:selectorTwitterAction]) {
            [delegate performSelector:selectorTwitterAction withObject:eventsGalleryObj.egImageName afterDelay:0.0];
        }
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]])
    {
        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        if ([delegate respondsToSelector:selectorTwitterAction]) {
            [delegate performSelector:selectorTwitterAction withObject:membersGalleryObj.mgImagePath afterDelay:0.0];
        }
        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]])
    {
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];

        if ([delegate respondsToSelector:selectorTwitterAction]) {
            [delegate performSelector:selectorTwitterAction withObject:abotLdcImageGalleryObj.imageName afterDelay:0.0];
        }

    }

}
-(void)shareFaceBook{
    
    if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[EventsGallery class]]) {
        
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        if ([delegate respondsToSelector:selectorFaceBookAction]) {
            [delegate performSelector:selectorFaceBookAction withObject:eventsGalleryObj.egImageName afterDelay:0.0];
        }

        
    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[MembersGallery class]])
    {
        
        MembersGallery *membersGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];
        
        if ([delegate respondsToSelector:selectorFaceBookAction]) {
            [delegate performSelector:selectorFaceBookAction withObject:membersGalleryObj.mgImagePath afterDelay:0.0];
        }

    }
    else if ([[self.galleryPhotoArray objectAtIndex:pageIndex] isKindOfClass:[AbotLdcImageGallery class]])
    {
        AbotLdcImageGallery *abotLdcImageGalleryObj=[self.galleryPhotoArray objectAtIndex:pageIndex];

        if ([delegate respondsToSelector:selectorFaceBookAction]) {
            [delegate performSelector:selectorFaceBookAction withObject:abotLdcImageGalleryObj.imageName afterDelay:0.0];
        }

    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = ([touches count] == 1 ? [touches anyObject] : nil);
    
    if (touch.view==shareViewObj.shareBackgroundView)
    {
        [shareViewObj removeFromSuperview];
    }
}

#pragma Fade In and fade Out Animation Method

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
