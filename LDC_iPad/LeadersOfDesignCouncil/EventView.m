//
//  EventView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 23/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "EventView.h"
#import "Constants.h"
#import "GalleryView.h"
#import "MapView.h"
#import "Events.h"
#import "EventsGallery.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import "EventAgenda.h"
#import "SourcePin.h"
@implementation EventView

@synthesize titleEventNameLabel,eventAddressLabel,summaryAbout,galleryLabel,eventNameLabel,eventDateLable,eventPhotoImageView,eventDetailsView,delegate,selectorLeftEventAction,selectorRightEventAction,galleryPhotoArray;
@synthesize eventViewPageIndex,arraySave,Status,selectorScrollingEnable,selectorToHideOrShowBottomBar,agendaLable,eventAgendaArray,agendaView,selectorFaceBookAction,selectorTwitterAction,selectorShareEmailAction,selectorRegisterForEventAction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
        titleEventNameLabel.font=[UIFont fontWithName:FontRegular size:30];
        [titleEventNameLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        
        eventNameLabel.font=[UIFont fontWithName:FontLight size:20];
        [eventNameLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        
        eventDateLable.font=[UIFont fontWithName:FontRegular size:14];
        [eventDateLable setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
       
        eventAddressLabel.font=[UIFont fontWithName:FontRegular size:14];
        [eventAddressLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];

        summaryAbout.font=[UIFont fontWithName:FontLight size:14];
        [summaryAbout setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];

        galleryLabel.font=[UIFont fontWithName:FontBold size:10];
        [galleryLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        
        mapButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [mapButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:172.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];

        agendaLable.font=[UIFont fontWithName:FontLight size:20];
        [agendaLable setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeft)];
        swipeLeft.numberOfTouchesRequired = 1;
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      //  [self addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleRight)];
        swipeRight.numberOfTouchesRequired = 1;
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
      //  [self addGestureRecognizer:swipeRight];
        
   //     [leftEventButton addTarget:self action:@selector(handleLeft) forControlEvents:UIControlEventTouchUpInside];
        
   //     [rightEventButton addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchUpInside];

//        self.galleryPhotoArray=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"],[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"], nil];
        
        
//    galleryPhotoArray=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"],[UIImage imageNamed:@"gallery_01.png"],[UIImage imageNamed:@"gallery_02.png"],[UIImage imageNamed:@"gallery_03.png"],[UIImage imageNamed:@"gallery_04.png"],[UIImage imageNamed:@"gallery_05.png"],[UIImage imageNamed:@"gallery_06.png"],[UIImage imageNamed:@"gallery_07.png"], nil];

    }
    return self;
}

//-(void)galleryPhotoButton_Clicked:(id)sender
//{
//    NSLog(@"[sender tag]=%d",[sender tag]);
//}

-(IBAction)eventLeftButton_Clicked:(id)sender
{
    if ([delegate respondsToSelector:selectorLeftEventAction]) {
       
        [delegate performSelector:selectorLeftEventAction withObject:self afterDelay:0.0];
    }

}
-(IBAction)eventRightButton_Clicked:(id)sender;
{
    if ([delegate respondsToSelector:selectorRightEventAction])
    {
        [delegate performSelector:selectorRightEventAction withObject:self afterDelay:0.0];
    }

}

-(void)addEventGalleryThumb
{
    [self cleareScrollViewContent];
    
    if ([self.galleryPhotoArray count]==0) {
        
        galleryLabel.hidden=YES;
    }
    else {
        galleryLabel.hidden=NO;
    }
    int noOfRow = 0;
    
    if ([self.galleryPhotoArray count]%5==0)
    {
        noOfRow= [self.galleryPhotoArray count]/5;
    }
    else
    {
        noOfRow= [self.galleryPhotoArray count]/5;
        noOfRow=noOfRow+1;
    }
    
    galleryPhotoScrollView.contentSize=CGSizeMake(275,noOfRow*55);
//    NSLog(@"galleryPhotoScrollView : %f",galleryPhotoScrollView.frame.size.height);
    
    for (int i=0; i<[self.galleryPhotoArray count]; i++)
    {
        EventsGallery *eventsGalleryObj=[self.galleryPhotoArray objectAtIndex:i];
        
        int rowYPosition=i/5;
        
        UIButton *galleryPhotoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [galleryPhotoButton setFrame:CGRectMake((i%5)*55,rowYPosition*55, 42, 42)];
       
         NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsGalleryObj.egImageThumb];
        
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            
            [galleryPhotoButton setBackgroundImage:[UIImage imageWithContentsOfFile:imageNameWithPath] forState:UIControlStateNormal];

        }
        else if ([UIImage imageNamed:eventsGalleryObj.egImageThumb]){
            [galleryPhotoButton setBackgroundImage:[UIImage imageNamed:eventsGalleryObj.egImageThumb] forState:UIControlStateNormal];
        }
        else {
            
            [galleryPhotoButton setBackgroundImage:[UIImage imageNamed:@"thumb-background.png"] forState:UIControlStateNormal];

        }
        
        [galleryPhotoButton addTarget:self action:@selector(galleryPhotoButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [galleryPhotoButton setTag:i];
        
        [galleryPhotoScrollView addSubview:galleryPhotoButton];
    }

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
-(void)cleareScrollViewContent
{
    for (UIView *subview in galleryPhotoScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }
    
}


- (void)setviewPageIndex1:(NSInteger)newPageIndex
{
    if (newPageIndex == 0) {
        leftEventButton.hidden = TRUE;
    }
    else{
        leftEventButton.hidden = FALSE;
    }
    if (newPageIndex == ([self.arraySave count]-1)) {
        rightEventButton.hidden = TRUE;
    }
    else{
        rightEventButton.hidden = FALSE;
    }
    
    eventDetailScrollVIew.contentSize=CGSizeMake(512, 578);
    Events *eventObj=[self.arraySave objectAtIndex:newPageIndex];

    titleEventNameLabel.text=eventObj.eName;
    
    NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventObj.eImage];
    
    if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
        eventPhotoImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
    }
    else{
        eventPhotoImageView.image=[UIImage imageNamed:eventObj.eImage];
    }
//    eventPhotoImageView.image=[UIImage imageWithContentsOfFile:eventObj.eImage];
    CGSize newSize;
    CGRect newFrame;

//    NSLog(@"eventObj.eLongName :%@:",eventObj.eLongName);
//    NSLog(@"eName :%@:",eventObj.eName);
//    NSLog(@"eLat :%@:",eventObj.eLat);
//    NSLog(@"eLong :%@:",eventObj.eLong);
    if ([eventObj.eLat isEqualToString:@"Latitude"] && [eventObj.eLong isEqualToString:@"Longitude"]) {
        mapButton.hidden = TRUE;
    }
    else{
        mapButton.hidden = FALSE;
    }
//    NSLog(@"ePlace :%@:\n\n",eventObj.ePlace);
    if ([eventObj.eLongName length]>0) {
         eventNameLabel.hidden = FALSE;
        eventNameLabel.text=eventObj.eLongName;
        
    }else{
        eventNameLabel.hidden = TRUE;
     eventNameLabel.text = @"";
//        eventNameLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    newSize =[eventObj.eLongName sizeWithFont:eventNameLabel.font constrainedToSize:CGSizeMake(eventNameLabel.frame.size.width, 50) lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = eventNameLabel.frame;
    newFrame.size.height = newSize.height;
    eventNameLabel.frame = newFrame;
    
    
    newSize =[[NSString stringWithFormat:@"%@",eventObj.eFromDate]   sizeWithFont:eventDateLable.font constrainedToSize:eventDateLable.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = eventDateLable.frame;
    newFrame.origin.y = eventNameLabel.frame.origin.y + eventNameLabel.frame.size.height + 24;
    newFrame.size.height = newSize.height;
    eventDateLable.frame = newFrame;

    NSString *strAddress=[NSString stringWithFormat:@"%@\n%@\n%@,\t%@",eventObj.ePlace,eventObj.ePlace2,eventObj.ePlace3,eventObj.eZipCode];
    
    newSize =[strAddress sizeWithFont:eventAddressLabel.font constrainedToSize:eventAddressLabel.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = eventAddressLabel.frame;
    newFrame.origin.y = eventDateLable.frame.origin.y + eventDateLable.frame.size.height + 24;
    newFrame.size.height = newSize.height;
    eventAddressLabel.frame = newFrame;

    eventAddressLabel.text=strAddress;
    
    newSize =[mapButton.titleLabel.text sizeWithFont:mapButton.titleLabel.font constrainedToSize:mapButton.frame.size lineBreakMode:NSLineBreakByWordWrapping];

    newFrame = mapButton.frame;
    newFrame.origin.y = eventAddressLabel.frame.origin.y + eventAddressLabel.frame.size.height + 10;
    newFrame.size.height = newSize.height;
    [mapButton setFrame:newFrame];

    newSize =[eventObj.eComment sizeWithFont:summaryAbout.font constrainedToSize:CGSizeMake(470,500) lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = summaryAbout.frame;
    summaryAbout.numberOfLines=0;
    newFrame.origin.y = mapButton.frame.origin.y + mapButton.frame.size.height + 40;
    newFrame.size.height = newSize.height;
    summaryAbout.frame = newFrame;
    summaryAbout.text=eventObj.eComment;
    
    newSize =[agendaLable.text sizeWithFont:agendaLable.font constrainedToSize:CGSizeMake(470,500) lineBreakMode:NSLineBreakByWordWrapping];
    newFrame = agendaLable.frame;
    agendaLable.numberOfLines=0;
    newFrame.origin.y = summaryAbout.frame.origin.y + summaryAbout.frame.size.height + 37.5;
    newFrame.size.height = newSize.height;
    agendaLable.frame = newFrame;

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    
//    NSDate* eventToDate=[NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eToDate];
//    NSDate* eventFromDate=[NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eFromDate];
    NSDate* eventToDate=eventObj.eToDate;
    NSDate* eventFromDate=eventObj.eFromDate;
//    NSLog(@"eventToDate : %@",eventToDate);
//    NSLog(@"eventFromDate : %@",eventFromDate);
    NSDate *todaysDate = [NSDate date];
//    NSLog(@"todaysDate : %@",todaysDate);
//    NSLog(@"difference :%f",[eventToDate timeIntervalSinceDate:todaysDate]);
//     NSLog(@"difference>>> :%f",[eventToDate timeIntervalSinceDate:eventFromDate]);
    
    [dateFormatter setDateFormat:@"MMMM"];
//    NSString *eventMonth=[[dateFormatter stringFromDate:eventToDate] uppercaseString];
    NSString *eventMonth=[dateFormatter stringFromDate:eventToDate];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *eventYear=[dateFormatter stringFromDate:eventToDate];
    
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *eventTo;
    
   eventTo=[dateFormatter stringFromDate:eventToDate];
    
    
    if ([eventTo hasPrefix:@"0"]) {
        [dateFormatter setDateFormat:@"d"];
        eventTo=[dateFormatter stringFromDate:eventToDate];

    }
    else {
        [dateFormatter setDateFormat:@"dd"];
        eventTo=[dateFormatter stringFromDate:eventToDate];

    }

    [dateFormatter setDateFormat:@"dd"];

    
    NSString *eventFrom;
    
    eventFrom=[dateFormatter stringFromDate:eventFromDate];
    
    if ([eventFrom hasPrefix:@"0"]) {
        [dateFormatter setDateFormat:@"d"];
        eventFrom=[dateFormatter stringFromDate:eventFromDate];

    }
    else {
        [dateFormatter setDateFormat:@"dd"];
        eventFrom=[dateFormatter stringFromDate:eventFromDate];

    }

    
     //Added BY Umesh to fix issue showing same date if are same on 05 March 2013
    if ([eventToDate timeIntervalSinceDate:eventFromDate] == 0.0) {
        eventDateLable.text=[NSString stringWithFormat:@"%@ %@, %@",eventMonth,eventTo,eventYear];
    }
    else{
     eventDateLable.text=[NSString stringWithFormat:@"%@ %@ - %@, %@",eventMonth,eventFrom,eventTo,eventYear];   
    }
    

    
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
//    self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"EventsGallery" :@"egEventID" :@"egEventID" :eventObj.eId :appDelegate.managedObjectContext];
    self.galleryPhotoArray=[[CoreDataOprations initObject] fetchRequestAccordingtoCategoryForEntity:@"EventsGallery" withSortDescriptor:@"egImagePosition" withCategoryName:@"egEventID" withCategoryValue:eventObj.eId andManagedObject:appDelegate.managedObjectContext];
    
    [self addEventGalleryThumb];
    
    //Added by Umesh to show register button
    CGRect buttonFrame = registerForEventButton.frame;
    buttonFrame.origin.y =galleryPhotoScrollView.frame.size.height + galleryPhotoScrollView.frame.origin.y + 23;
    [registerForEventButton setFrame:buttonFrame];
    
    if ([eventToDate timeIntervalSinceDate:todaysDate]>0) {
        registerForEventButton.hidden = FALSE;
    }
    else{
     registerForEventButton.hidden = TRUE;
    }
    

    self.eventAgendaArray=[[CoreDataOprations initObject] fetchRequestAccordingtoCategory:@"EventAgenda" :@"eaDate" :@"eaEventID" :eventObj.eId :appDelegate.managedObjectContext];
    if (self.agendaView) {
        
        [agendaView removeFromSuperview];
        self.agendaView=nil;
    }
    agendaLable.hidden = TRUE;
    
    //if ([eventToDate timeIntervalSinceDate:todaysDate]>0)
    
    {
        
       if ([self.eventAgendaArray count]!=0) {
            
            
           agendaLable.hidden = FALSE;
           
           
            self.agendaView=[[UIView alloc]init];
            agendaLable.hidden=FALSE;
            
            
            //    UIView *agendaVIew=[[UIView alloc]initWithFrame:CGRectMake(508,(agendaLable.frame.origin.y + agendaLable.frame.size.height +30)-200,470, 400)];
            
            [self.agendaView setBackgroundColor:[UIColor clearColor]];
            
            EventAgenda *eventAgendaObj=[self.eventAgendaArray objectAtIndex:0];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            
            NSDate* eventDateDefault = [dateFormatter dateFromString:eventAgendaObj.eaDate];
            
            
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            
            NSString* eventDateDefaultString = [dateFormatter stringFromDate:eventDateDefault];
            
            NSDate* eventDateDefaultComapare = [dateFormatter dateFromString:eventDateDefaultString];
            
            
            int position=0;
            int yPos=0;
            
            for (int i=0; i<[self.eventAgendaArray count]; i++) {
                
                EventAgenda *eventAgendaObj=[self.eventAgendaArray objectAtIndex:i];
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                
                NSDate* eventFirstDate = [dateFormatter dateFromString:eventAgendaObj.eaDate];
                
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                
                NSString* eventFirstDateString = [dateFormatter stringFromDate:eventFirstDate];
                
//                NSLog(@"eventFirstDateString=%@",eventFirstDateString);
                
                NSDate* eventFirstDateComapare = [dateFormatter dateFromString:eventFirstDateString];
                
                if (position==0)
                {
                    
                    if ([eventFirstDateString hasPrefix:@"0"]) {
                        [dateFormatter setDateFormat:@"MMMM d, yyyy"];
                    }
                    else {
                    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
                    }
                    
                    NSString* eventdatetoshow = [[dateFormatter stringFromDate:eventFirstDate] uppercaseString];
                    
                    newSize =[eventdatetoshow sizeWithFont:[UIFont fontWithName:FontSemibd size:10] constrainedToSize:CGSizeMake(470,500) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    UILabel* dateLable;
                    if (dateLable) {
                        dateLable=nil;
                    }
                    dateLable=[[UILabel alloc]init];
                    dateLable.frame=CGRectMake(0,yPos,200,25);
                    dateLable.numberOfLines=3;
                    dateLable.font=[UIFont fontWithName:FontSemibd size:10];
                    dateLable.textColor=kGrayColor;
                    dateLable.backgroundColor=[UIColor clearColor];
                    dateLable.text=eventdatetoshow;
                    
                    [self.agendaView addSubview:dateLable];
                    
                    yPos=dateLable.frame.origin.y+dateLable.frame.size.height+24;
                    
                }
                
                if ([eventDateDefaultComapare isEqualToDate:eventFirstDateComapare])
                {
                    
                    
                }
                else
                {
                    eventDateDefaultComapare=eventFirstDateComapare;
                    
                    if ([eventFirstDateString hasPrefix:@"0"]) {
                        [dateFormatter setDateFormat:@"MMMM d, yyyy"];
                    }
                    else {
                        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
                    }
                    
                    NSString* eventdatetoshow = [[dateFormatter stringFromDate:eventFirstDate] uppercaseString];
                    
                    newSize =[eventdatetoshow sizeWithFont:[UIFont fontWithName:FontSemibd size:10] constrainedToSize:CGSizeMake(470,500) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    
                    UILabel* dateLable;
                    if (dateLable) {
                        dateLable=nil;
                    }
                    dateLable=[[UILabel alloc]init];
                    dateLable.frame=CGRectMake(0,yPos,200,25);
                    dateLable.numberOfLines=0;
                    dateLable.font=[UIFont fontWithName:FontSemibd size:10];
                    dateLable.textColor=kGrayColor;
                    dateLable.backgroundColor=[UIColor clearColor];
                    dateLable.text=eventdatetoshow;
                    
                    [self.agendaView addSubview:dateLable];
                    
                    yPos=dateLable.frame.origin.y+dateLable.frame.size.height+24;
                    
                    
                }
                
                [dateFormatter setDateFormat:@"hh:mm a"];
                NSString* eventtimetoshow;
                
                eventtimetoshow = [[dateFormatter stringFromDate:eventFirstDate] lowercaseString];
                
                
                if ([eventtimetoshow hasPrefix:@"0"]) {
                    
                    [dateFormatter setDateFormat:@"h:mm a"];
                    eventtimetoshow = [[dateFormatter stringFromDate:eventFirstDate] lowercaseString];

                }
                else {
                    
                    [dateFormatter setDateFormat:@"hh:mm a"];
                    eventtimetoshow = [[dateFormatter stringFromDate:eventFirstDate] lowercaseString];
                }
           
                newSize =[eventtimetoshow sizeWithFont:[UIFont fontWithName:FontLight size:14] constrainedToSize:CGSizeMake(470,500) lineBreakMode:NSLineBreakByWordWrapping];
                
                
                UILabel* timeLable;
                if (timeLable) {
                    timeLable=nil;
                }
                timeLable=[[UILabel alloc]init];
                timeLable.frame=CGRectMake(0,yPos,newSize.width,newSize.height);
                timeLable.numberOfLines=3;
                timeLable.font=[UIFont fontWithName:FontLight size:14];
                timeLable.textColor=kGrayColor;
                timeLable.backgroundColor=[UIColor clearColor];
                timeLable.text=eventtimetoshow;
                
                [self.agendaView addSubview:timeLable];
                
                CGSize newSize123 =[eventAgendaObj.eaAgendaName sizeWithFont:[UIFont fontWithName:FontLight size:14] constrainedToSize:CGSizeMake(180,500) lineBreakMode:NSLineBreakByWordWrapping];
                
                UILabel* timedetailLable=[[UILabel alloc]init];
                timedetailLable.frame=CGRectMake(85,yPos,newSize123.width,newSize123.height);
                timedetailLable.numberOfLines=2;
                timedetailLable.font=[UIFont fontWithName:FontLight size:14];
                timedetailLable.textColor=kGrayColor;
                timedetailLable.backgroundColor=[UIColor clearColor];
                timedetailLable.text=eventAgendaObj.eaAgendaName;
//                NSLog(@"timedetailLable x  :%f",timedetailLable.frame.origin.x);
                
                [self.agendaView addSubview:timedetailLable];
                
                NSString *dummytext=@"dummy Values Values Values Values Values Values Values";
                
                CGSize newSize1234 =[dummytext sizeWithFont:[UIFont fontWithName:FontLight size:10] constrainedToSize:CGSizeMake(180,50) lineBreakMode:NSLineBreakByWordWrapping];
                
                
                UILabel* timedetailPlaceLable;
                if (timedetailPlaceLable) {
                    timedetailPlaceLable=nil;
                }
                timedetailPlaceLable=[[UILabel alloc]init];
                timedetailPlaceLable.frame=CGRectMake(300,yPos,165,newSize1234.height);
                [timedetailPlaceLable setTextAlignment:NSTextAlignmentRight];
                timedetailPlaceLable.numberOfLines=2;
                timedetailPlaceLable.font=[UIFont fontWithName:FontLight size:10];
                timedetailPlaceLable.textColor=kGrayColor;
                timedetailPlaceLable.backgroundColor=[UIColor clearColor];
                timedetailPlaceLable.text=eventAgendaObj.eaLocation;
                
                [self.agendaView addSubview:timedetailPlaceLable];
                
                yPos=yPos+newSize123.height+24;
                
                position++;
                
            }
            
            self.agendaView.frame=CGRectMake(0,(agendaLable.frame.origin.y + agendaLable.frame.size.height +17),470, yPos);
            
            eventDetailScrollVIew.contentSize=CGSizeMake(512,yPos+(agendaLable.frame.origin.y + agendaLable.frame.size.height +30));
            
            //        for (UIView *view in eventDetailScrollVIew.subviews) {
            //            
            //            if ([view isKindOfClass:[UIView class]]) {
            //                
            //            }
            //
            //        }
            
            [eventDetailScrollVIew addSubview:self.agendaView];
            
        }
        else {
            if (self.agendaView) {
                [self.agendaView removeFromSuperview];
                self.agendaView=nil;
            }
            agendaLable.hidden=TRUE;
            eventDetailScrollVIew.contentSize=CGSizeMake(512, 578);
        }
        
        
        
    }
    

    if (eventPhotoImageView.image) {
        
    }
    else {
//        eventPhotoImageView.image=[UIImage imageNamed:@"img_05.png"];
    }
//    NSLog(@"Count %d",[self.eventAgendaArray count]);
    
}
-(IBAction)registerForEventButtonClicked:(id)sender{
    NSDictionary *registerForEventDetailsDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"I would like to register for %@",titleEventNameLabel.text],@"Subject",[NSString stringWithFormat:@"Hello, \n\nPlease register me for the %@ event.\n\nSincerely,", titleEventNameLabel.text],@"Body", nil];
//    NSLog(@"registerForEventDetailsDict : %@",registerForEventDetailsDict);
    
    if ([delegate respondsToSelector:selectorRegisterForEventAction]) {
        [delegate performSelector:selectorRegisterForEventAction withObject:registerForEventDetailsDict afterDelay:0.0];
    }
    
}
-(void)addEventAgenda:(NSArray*)eventAgenda
{
    
    
}

-(void)afterDelay
{
    [self fadeView:eventDetailsView fadein:YES timeAnimation:0.3];
}


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

-(void)galleryPhotoButton_Clicked:(id)sender
{
    pageIndex=0;
   
    UIButton *button=(UIButton *)sender;
    
    if(galleryViewObj)
    {
        galleryViewObj=nil;
    }
//    NSLog(@"self.galleryPhotoArray : %@",self.galleryPhotoArray);
    galleryViewObj=[[GalleryView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    galleryViewObj.galleryPhotoArray=self.galleryPhotoArray;
    galleryViewObj.galleryPhotoScrollView.contentSize=CGSizeMake([galleryPhotoArray count]*1024,728);
    [galleryViewObj setDelegate:self];
    [galleryViewObj setSelectorHandleLeft:@selector(galleryHandleLeft)];
    [galleryViewObj setSelectorHandleRight:@selector(galleryHandleRight)];
    [galleryViewObj setSelectorScrollViewScrolling:@selector(scrollingEnable:)];
    [galleryViewObj setSelectorCloseGallery:@selector(hideUnhdieBottomBar:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
    [galleryViewObj setSelectorFaceBookAction:@selector(shareFaceBook:)];
    [galleryViewObj setSelectorTwitterAction:@selector(shareTwitterAction:)];
    [galleryViewObj setSelectorEmailAction:@selector(shareEmailAction:)];
    galleryViewObj.pageIndex=button.tag;
    
    [galleryViewObj addEventImageGallery:button.tag];
    [self hideUnhdieBottomBar:@"True"];
   
    if ([delegate respondsToSelector:selectorScrollingEnable])
    {
        [delegate performSelector:selectorScrollingEnable withObject:@"NO" afterDelay:0.0];
    }
    
    [self addSubview:galleryViewObj];
}
-(void)shareFaceBook:(NSString*)str{
    if ([delegate respondsToSelector:selectorFaceBookAction])
    {
        [delegate performSelector:selectorFaceBookAction withObject:str afterDelay:0.0];
    }
    
}
-(void)shareTwitterAction:(NSString*)str{
    if ([delegate respondsToSelector:selectorTwitterAction])
    {
        [delegate performSelector:selectorTwitterAction withObject:str afterDelay:0.0];
    }
    
}
-(void)shareEmailAction:(NSArray*)array{
    if ([delegate respondsToSelector:selectorShareEmailAction])
    {
        [delegate performSelector:selectorShareEmailAction withObject:array afterDelay:0.0];
    }
    
}
-(void)hideUnhdieBottomBar:(NSString *)doHideBottomBar{
    if ([delegate respondsToSelector:selectorToHideOrShowBottomBar]) {
        [delegate performSelector:selectorToHideOrShowBottomBar withObject:doHideBottomBar afterDelay:0.0];
    }
}
-(IBAction)mapButtonClicked:(id)sender{
  
    [self hideUnhdieBottomBar:@"True"];
    
    MapView *mapViewObj=[[MapView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    Events *eventObj=[self.arraySave objectAtIndex:eventViewPageIndex];

    SourcePin *soPin=[[SourcePin alloc]init];
    mapViewObj.sorPin=soPin;
    mapViewObj.sorPin.latitude=[eventObj.eLat doubleValue];
    mapViewObj.sorPin.longitude=[eventObj.eLong doubleValue];
    mapViewObj.sorPin.title=eventObj.eName;
    mapViewObj.sorPin.subTitle=eventObj.ePlace;
    [mapViewObj setDelegate:self];
    mapViewObj.titleLabel.text=eventObj.eName;
    [mapViewObj setSelectorBackButtonClicked:@selector(hideUnhdieBottomBar:)];  //Added By Umesh to show bottom tool bar when gallery view is removed
    
    [mapViewObj addanotation];
    [self addSubview:mapViewObj];
    
}

-(void)scrollingEnable:(id)sender
{
    if ([delegate respondsToSelector:selectorScrollingEnable])
    {
        [delegate performSelector:selectorScrollingEnable withObject:@"YES" afterDelay:0.0];
        
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
