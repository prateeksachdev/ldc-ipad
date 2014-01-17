//
//  EventListView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 01/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "EventListView.h"
#import "Constants.h"
#import "EventView.h"
#import "AppDelegate.h"
#import "CoreDataOprations.h"
#import "Events.h"

@implementation EventListView
@synthesize delegate,selectoreventListAction,managedObjectContext,eventsObj,selectorEventListSearchAction,eventListMainArray;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"EventListView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
        eventListAllButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [eventListAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        eventListUpcomingButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [eventListUpcomingButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        
        eventListPastButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [eventListPastButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [eventListSearchTextField setFont:[UIFont fontWithName:FontRegular size:15]];

        [eventListSearchTextField setTextColor:kGrayColor];
        
        [eventListSearchTextLable setTextColor:kGrayColor];
        
        
        [eventListSearchResultLable setFont:[UIFont fontWithName:FontRegular size:15]];

        [eventListSearchResultLable setTextColor:kGrayColor];
        
        [eventListSearchResultLable setText:@"No search results"];
        
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

        self.managedObjectContext=appDelegate.managedObjectContext;
       

        
//        self.eventListMainArray=[[NSArray alloc]init];
        
//        self.eventListMainArray=[[CoreDataOprations initObject]fetchRequest:@"Events":@"eFromDate":self.managedObjectContext];
        
//        [self addEventContentOnScrollView:self.eventListMainArray];
        [self eventUpcomingButtonAction:nil];

    }
    return self;
}


-(void)addEventContentOnScrollView:(NSArray*)eventlistArray
{
        
    if ([eventlistArray count]!=0) {
        
    eventListSearchResultLable.hidden=TRUE;
        
    Events *eventObj=[eventlistArray objectAtIndex:0];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
   
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
//    NSDate* eventfromDate = [NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eFromDate];
        NSDate* eventfromDate = eventObj.eFromDate;

    [dateFormatter setDateFormat:@"MMMM-yyyy"];
   
    NSString* eventfromDateString = [dateFormatter stringFromDate:eventfromDate];

    NSDate* eventFromDateComapare = [dateFormatter dateFromString:eventfromDateString];


    
    int eventCount=[eventlistArray count]/3;
    
    if ([eventlistArray count]%3!=0) {
        
        eventCount=eventCount+1;
        
    }
    int index=0;
    
    int xpos=0;
    
    int yPos=33;
    
    int position=0;
    
    for (int j=0; j<[eventlistArray count]; j++) {
        
        Events *eventObj=[eventlistArray objectAtIndex:j];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        
//        NSDate* eventFromDate = [NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eFromDate];
        NSDate* eventFromDate = eventObj.eFromDate;
        
//        NSDate* eventToDate = [NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eToDate];
         NSDate* eventToDate = eventObj.eToDate;

        [dateFormatter setDateFormat:@"MMMM, yyyy"];
        
        NSString* eventFromDateString = [dateFormatter stringFromDate:eventFromDate];
                
        NSDate *eventFromDateStringToCheck=[dateFormatter dateFromString:eventFromDateString];
        
        [dateFormatter setDateFormat:@"MMM"];

        NSString* monthStringFromDate = [dateFormatter stringFromDate:eventFromDate];

        [dateFormatter setDateFormat:@"dd"];

        NSString* dateStringFromDate;
        
         dateStringFromDate = [dateFormatter stringFromDate:eventFromDate];
       
        if ([dateStringFromDate hasPrefix:@"0"]) {
            
            [dateFormatter setDateFormat:@"d"];
            dateStringFromDate = [dateFormatter stringFromDate:eventFromDate];
        }
        
        [dateFormatter setDateFormat:@"dd"];

        NSString* dateStringToDate;
        
         dateStringToDate = [dateFormatter stringFromDate:eventToDate];

        if ([dateStringToDate hasPrefix:@"0"]) {
          
            [dateFormatter setDateFormat:@"d"];

            dateStringToDate = [dateFormatter stringFromDate:eventToDate];

        }
        [dateFormatter setDateFormat:@"dd"];

        if (position==0) {
            
            UILabel* label12=[[UILabel alloc]init];
            label12.frame=CGRectMake(355*xpos+52+29,0,110,18);
            label12.numberOfLines=3;
            label12.font=[UIFont fontWithName:FontBold size:10];
            label12.textColor=kSkyBlueColor;
            label12.backgroundColor=[UIColor clearColor];

            label12.text=[eventFromDateString uppercaseString];
            
            [eventListScrollView addSubview:label12];

        }
        
        if ([eventFromDateStringToCheck isEqualToDate:eventFromDateComapare])
        {
            if (position>0 && position%3==0) {
                
                xpos=xpos+1;
                
                yPos=33;
            }
            else if (position>0) {
               
                yPos=90+yPos;
            }
            
            position++;
        }
        else
        {
        
            position=1;
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                        
//            NSDate* myDate1 = [NSDate dateWithTimeIntervalSinceReferenceDate:eventObj.eFromDate];
            NSDate* myDate1 = eventObj.eFromDate;
            
            [dateFormatter setDateFormat:@"MMMM, yyyy"];
            
            NSString* myDate2 = [dateFormatter stringFromDate:myDate1];
            
            eventFromDateComapare = [dateFormatter dateFromString:myDate2];
            
            xpos=xpos+1;
            yPos=33;
                        
            UILabel* label12=[[UILabel alloc]init];
            label12.frame=CGRectMake(355*xpos+42,0,110,18);
            label12.numberOfLines=3;
            label12.font=[UIFont fontWithName:FontBold size:10];
            label12.textColor=kSkyBlueColor;
            label12.backgroundColor=[UIColor clearColor];
            label12.text=[myDate2 uppercaseString];
            
            [eventListScrollView addSubview:label12];

        }
            
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(341*xpos+29,yPos,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
//            NSLog(@"eventObj:%@",eventObj.eThumbImage);
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventObj.eThumbImage];
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
        }
        else if([UIImage imageNamed:eventObj.eThumbImage]){
            customeImageView.image=[UIImage imageNamed:eventObj.eThumbImage];
        }
        else{
            customeImageView.image = [UIImage imageNamed:@"thumb-background.png"];
        }
        
//            customeImageView.image=[UIImage imageWithContentsOfFile:eventObj.eThumbImage];
          customeImageView.contentMode=UIViewContentModeScaleAspectFit;

            UILabel* label=[[UILabel alloc]init];
            label.frame=CGRectMake(341*xpos+52+29,yPos,240,42);
            label.numberOfLines=2;
            label.font=[UIFont fontWithName:FontLight size:20];
            label.textColor=kGrayColor;
            label.backgroundColor=[UIColor clearColor];
        
        
        label.text=eventObj.eName;
        
        
        CGSize newSize;
        CGRect newFrame;
        newSize =[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(240, 42) lineBreakMode:NSLineBreakByWordWrapping];
        newFrame = label.frame;
        newFrame.size.height = newSize.height;
        label.frame = newFrame;
        
        
        
            UILabel* label1=[[UILabel alloc]init];
            label1.frame=CGRectMake(341*xpos+52+29,yPos+newSize.height+2,110,15);
            label1.numberOfLines=1;
            label1.font=[UIFont fontWithName:FontBold size:10];
            label1.textColor=kGrayColor;
        //Added BY Umesh to fix issue showing same date if are same 05 March 2013
            if ([eventFromDate timeIntervalSinceDate:eventToDate] == 0) {
                label1.text=[[NSString stringWithFormat:@"%@ %@",monthStringFromDate,dateStringFromDate] uppercaseString];
            }
            else{
                label1.text=[[NSString stringWithFormat:@"%@ %@ - %@",monthStringFromDate,dateStringFromDate,dateStringToDate] uppercaseString];
            }
        
            
            label1.backgroundColor=[UIColor clearColor];
            
            UILabel* label2=[[UILabel alloc]init];
            label2.frame=CGRectMake(341*xpos+52+29,yPos+newSize.height+17,221,15);
            label2.numberOfLines=1;
            label2.font=[UIFont fontWithName:FontBold size:10];
            label2.textColor=kGrayColor;
            label2.text=[eventObj.ePlace uppercaseString];
            label2.backgroundColor=[UIColor clearColor];
            
            UIButton *eventButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [eventButton setFrame:CGRectMake(341*xpos+29,yPos,261,80)];
            
            [eventButton setBackgroundColor:[UIColor clearColor]];
            
            [eventButton addTarget:self action:@selector(eventListBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            eventButton.tag=index;
        
            index=index+1;
                
            [eventListScrollView addSubview:customeImageView];
            [eventListScrollView addSubview:label];
            [eventListScrollView addSubview:label1];
            [eventListScrollView addSubview:label2];
            [eventListScrollView addSubview:eventButton];
    }
        
        int count=xpos+1;
        
        if (count%3==0) {
            
            int pageCount=count/3;
            
            eventListScrollView.contentSize=CGSizeMake(1024*pageCount,317);
            
            eventListPageControl.numberOfPages=pageCount;
            
        }
        else {
            
            int pageCount=count/3;
            
            eventListScrollView.contentSize=CGSizeMake(1024*(pageCount+1),317);
            
            eventListPageControl.numberOfPages=pageCount+1;
            
        }

    }
    
    else
    {
        eventListSearchResultLable.hidden=FALSE;
        
        [eventListSearchResultLable setText:@"There are no events"];
    }
    
    
}

-(void)addEventContentOnScrollViewUpcoming:(NSArray*)memberArray
{
    
    //    memberListArray=[NSMutableArray array];
    
    //    NSArray *arraywithObjects=[[NSArray alloc]initWithObjects:@"JANUARY,2012",@"JANUARY,2013",@"FEBRUARY,2013", @"MARCH,2013",nil];
    
    NSArray *arraycoreDataOpration=[[CoreDataOprations initObject]fetchRequest:@"Events":@"eFromDate":self.managedObjectContext];
    
    if ([arraycoreDataOpration count]!=0) {

    Events *eventObj=[arraycoreDataOpration objectAtIndex:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
    NSString *currentdate=[dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *currentdatetoCompare=[dateFormatter dateFromString:currentdate];

    
//    NSDate* eventfromDate = [NSDate dateWithTimeIntervalSinceNow:eventObj.eFromDate];
        NSDate* eventfromDate = eventObj.eFromDate;
    
    [dateFormatter setDateFormat:@"MMMM-yyyy"];
    
    NSString* eventfromDateString = [dateFormatter stringFromDate:eventfromDate];
    
    NSDate* eventFromDateComapare = [dateFormatter dateFromString:eventfromDateString];
    
    
    eventListScrollView.contentSize=CGSizeMake(1024*2,317);
    
    eventListPageControl.numberOfPages=2;
    
    int eventCount=[arraycoreDataOpration count]/3;
    
    if ([arraycoreDataOpration count]%3!=0) {
        
        eventCount=eventCount+1;
        
    }
    int index=0;
    
    int xpos=0;
    
    int yPos=33;
    
    int position=0;
    
    for (int j=0; j<[arraycoreDataOpration count]; j++) {
        
        Events *eventObj=[arraycoreDataOpration objectAtIndex:j];
        
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        
//        NSDate* eventFromDate = [NSDate dateWithTimeIntervalSinceNow:eventObj.eFromDate];
//        
//        NSDate* eventToDate = [NSDate dateWithTimeIntervalSinceNow:eventObj.eToDate];
        
        NSDate* eventFromDate=eventObj.eFromDate;
        NSDate* eventToDate=eventObj.eToDate;
        
        [dateFormatter setDateFormat:@"MMMM-yyyy"];
        
        NSString* eventFromDateString = [dateFormatter stringFromDate:eventFromDate];
        
        NSDate *eventFromDateStringToCheck=[dateFormatter dateFromString:eventFromDateString];
        
        [dateFormatter setDateFormat:@"MMM"];
        
        NSString* monthStringFromDate = [dateFormatter stringFromDate:eventFromDate];
        
        //  NSString* monthStringToDate = [dateFormatter stringFromDate:eventToDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString* dateStringFromDate = [dateFormatter stringFromDate:eventFromDate];
        
        NSString* dateStringToDate = [dateFormatter stringFromDate:eventToDate];
        
        
        if ([currentdatetoCompare compare:eventToDate]==NSOrderedAscending)
        {
            
            if ([eventFromDateStringToCheck isEqualToDate:eventFromDateComapare])
            {
                
                if (position==0) {
                    
                    UILabel* label12=[[UILabel alloc]init];
                    label12.frame=CGRectMake(355*xpos+52+29,0,110,18);
                    label12.numberOfLines=3;
                    label12.font=[UIFont fontWithName:FontBold size:10];
                    label12.textColor=kSkyBlueColor;
                    label12.backgroundColor=[UIColor clearColor];
                    
                    label12.text=[eventFromDateString uppercaseString];
                    
                    [eventListScrollView addSubview:label12];
                    
                }

                
                if (position>0 && position%3==0) {
                    
                    xpos=xpos+1;
                    
                    yPos=33;
                }
                else if (position>0) {
                    
                    yPos=90+yPos;
                }
//                NSLog(@"isEqualToDate");
                
                position++;
            }
            else
            {
                
                position=1;
                
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                
                //  NSString *currentdate=[dateFormatter stringFromDate:[NSDate date]];
                
                //  NSDate *currentdate1=[dateFormatter dateFromString:eventObj.eFromDate];
                
//                NSDate* myDate1 = [NSDate dateWithTimeIntervalSinceNow:eventObj.eFromDate];
                NSDate* myDate1 = eventObj.eFromDate;
                
                [dateFormatter setDateFormat:@"MMMM-yyyy"];
                
                NSString* myDate2 = [dateFormatter stringFromDate:myDate1];
                
                eventFromDateComapare = [dateFormatter dateFromString:myDate2];
                
                //            myDate = [dateFormatter dateFromString:eventObj.eFromDate];
                
                xpos=xpos+1;
                yPos=33;
                
              //  NSLog(@"NO");
                
                UILabel* label12=[[UILabel alloc]init];
                label12.frame=CGRectMake(355*xpos+52+29,0,110,18);
                label12.numberOfLines=3;
                label12.font=[UIFont fontWithName:FontBold size:10];
                label12.textColor=kSkyBlueColor;
                label12.backgroundColor=[UIColor clearColor];
                
                label12.text=[myDate2 uppercaseString];
                
                [eventListScrollView addSubview:label12];
                
            }

        
//            if (position>0 && position%3==0) {
//                
//                xpos=xpos+1;
//                
//                yPos=33;
//            }
//            else if (position>0) {
//                
//                yPos=90+yPos;
//            }
//            NSLog(@"isEqualToDate");
//            
//            position++;
            
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(341*xpos+29,yPos,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
//            NSLog(@"eventObj:%@",eventObj.eThumbImage);
            
            NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventObj.eThumbImage];
            
            if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
            }
            else if([UIImage imageNamed:eventObj.eThumbImage]){
                customeImageView.image=[UIImage imageNamed:eventObj.eThumbImage];
            }
            else{
                customeImageView.image = [UIImage imageNamed:@"thumb-background.png"];
            }
//            customeImageView.image=[UIImage imageWithContentsOfFile:eventObj.eThumbImage];
            customeImageView.contentMode=UIViewContentModeScaleAspectFit;

            
            
            UILabel* label=[[UILabel alloc]init];
            label.frame=CGRectMake(341*xpos+52+29,yPos,211,42);
            label.numberOfLines=2;
            label.font=[UIFont fontWithName:FontLight size:20];
            label.textColor=kGrayColor;
            label.backgroundColor=[UIColor clearColor];
            
            UILabel* label1=[[UILabel alloc]init];
            label1.frame=CGRectMake(341*xpos+52+29,yPos+42,110,18);
            label1.numberOfLines=1;
            label1.font=[UIFont fontWithName:FontBold size:10];
            label1.textColor=kGrayColor;
            label1.text=[NSString stringWithFormat:@"%@ %@-%@",monthStringFromDate,dateStringFromDate,dateStringToDate];
            
            label1.backgroundColor=[UIColor clearColor];
            
            UILabel* label2=[[UILabel alloc]init];
            label2.frame=CGRectMake(341*xpos+52+29,yPos+42+18,221,20);
            label2.numberOfLines=1;
            label2.font=[UIFont fontWithName:FontBold size:10];
            label2.textColor=kGrayColor;
            label2.text=eventObj.ePlace;
            label2.backgroundColor=[UIColor clearColor];
            
            UIButton *eventButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [eventButton setFrame:CGRectMake(341*xpos+52+29,yPos+33,211,80)];
            
            [eventButton setBackgroundColor:[UIColor clearColor]];
            
            [eventButton addTarget:self action:@selector(eventListBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            eventButton.tag=index;

            label.text=eventObj.eName;
            index=index+1;
            
            [eventListScrollView addSubview:customeImageView];
            [eventListScrollView addSubview:label];
            [eventListScrollView addSubview:label1];
            [eventListScrollView addSubview:label2];
            [eventListScrollView addSubview:eventButton];

            
        }
        else
        {
//            NSLog(@"NO");
//            position=1;
//            
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
//            
//            //  NSString *currentdate=[dateFormatter stringFromDate:[NSDate date]];
//            
//            //  NSDate *currentdate1=[dateFormatter dateFromString:eventObj.eFromDate];
//            
//            NSDate* myDate1 = [dateFormatter dateFromString:eventObj.eFromDate];
//            
//            [dateFormatter setDateFormat:@"MMMM-yyyy"];
//            
//            NSString* myDate2 = [dateFormatter stringFromDate:myDate1];
//            
//           // eventFromDateComapare = [dateFormatter dateFromString:myDate2];
//            
//            //            myDate = [dateFormatter dateFromString:eventObj.eFromDate];
//            
//            xpos=xpos+1;
//            yPos=33;
//            
//            NSLog(@"NO");
//            
//            UILabel* label12=[[UILabel alloc]init];
//            label12.frame=CGRectMake(355*xpos+52+29,0,110,18);
//            label12.numberOfLines=3;
//            label12.font=[UIFont fontWithName:FontBold size:10];
//            label12.textColor=kSkyBlueColor;
//            label12.backgroundColor=[UIColor clearColor];
//            
//            label12.text=myDate2;
//            
//            [eventListScrollView addSubview:label12];
            
        }
        
    }
        
        
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
-(void)addSearchEventContentOnScrollView:(NSArray*)eventlistArray
{
        
    [self cleareScrollViewContent];
    
    if ([eventlistArray count]==0) {
        
        eventListSearchResultLable.hidden=FALSE;
        
        [eventListSearchResultLable setText:@"No search results"];

    }
    else {
        
        eventListSearchResultLable.hidden=TRUE;

        
//    Events *eventObj=[eventlistArray objectAtIndex:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
//    NSDate* eventfromDate = [dateFormatter dateFromString:eventObj.eFromDate];
    
    [dateFormatter setDateFormat:@"MMMM-yyyy"];
    
//    NSString* eventfromDateString = [dateFormatter stringFromDate:eventfromDate];
    
   // NSDate* eventFromDateComapare = [dateFormatter dateFromString:eventfromDateString];
    
    if ([eventlistArray count]%9==0) {
        
        
        int pageCount=[eventlistArray count]/9;
        
        eventListScrollView.contentSize=CGSizeMake(1024*pageCount,317);
        
        eventListPageControl.numberOfPages=pageCount;
        
    }
    else {
        
        int pageCount=[eventlistArray count]/9;
        
        eventListScrollView.contentSize=CGSizeMake(1024*pageCount+1,317);
        
        eventListPageControl.numberOfPages=pageCount+1;
        
    }
    
    int eventCount=[eventlistArray count]/3;
    
    if ([eventlistArray count]%3!=0) {
        
        eventCount=eventCount+1;
        
    }
    int index=0;
    
    int xpos=0;
    
    int yPos=0;
    
    int position=0;
    
    for (int j=0; j<[eventlistArray count]; j++) {
        
        Events *eventObj=[eventlistArray objectAtIndex:j];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        
//        NSDate* eventFromDate = [NSDate dateWithTimeIntervalSince1970:eventObj.eFromDate];
        
//        NSDate* eventToDate = [NSDate dateWithTimeIntervalSince1970:eventObj.eToDate];
        
        NSDate* eventFromDate=eventObj.eFromDate;
        NSDate* eventToDate=eventObj.eToDate;
        
        [dateFormatter setDateFormat:@"MMMM-yyyy"];
        
        NSString* eventFromDateString = [dateFormatter stringFromDate:eventFromDate];
        
//        NSDate *eventFromDateStringToCheck=[dateFormatter dateFromString:eventFromDateString];
        
        [dateFormatter setDateFormat:@"MMM"];
        
        NSString* monthStringFromDate = [dateFormatter stringFromDate:eventFromDate];
        
        //  NSString* monthStringToDate = [dateFormatter stringFromDate:eventToDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString* dateStringFromDate = [dateFormatter stringFromDate:eventFromDate];
        
        NSString* dateStringToDate = [dateFormatter stringFromDate:eventToDate];
        
        
        if (position==0) {
            
            UILabel* label12=[[UILabel alloc]init];
            label12.frame=CGRectMake(355*xpos+52+29,0,110,18);
            label12.numberOfLines=3;
            label12.font=[UIFont fontWithName:FontBold size:10];
            label12.textColor=kSkyBlueColor;
            label12.backgroundColor=[UIColor clearColor];
            
            label12.text=[eventFromDateString uppercaseString];
            
           // [eventListScrollView addSubview:label12];
            
        }
        
     //   if ([eventFromDateStringToCheck isEqualToDate:eventFromDateComapare])
        {
            if (position>0 && position%3==0) {
                
                xpos=xpos+1;
                
                yPos=0;
            }
            else if (position>0) {
                
                yPos=90+yPos;
            }
//            NSLog(@"isEqualToDate");
            
            position++;
        }
//        else
//        {
//            
//            position=1;
//            
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
//            
//            //  NSString *currentdate=[dateFormatter stringFromDate:[NSDate date]];
//            
//            //  NSDate *currentdate1=[dateFormatter dateFromString:eventObj.eFromDate];
//            
//            NSDate* myDate1 = [dateFormatter dateFromString:eventObj.eFromDate];
//            
//            [dateFormatter setDateFormat:@"MMMM-yyyy"];
//            
//            NSString* myDate2 = [dateFormatter stringFromDate:myDate1];
//            
//            eventFromDateComapare = [dateFormatter dateFromString:myDate2];
//            
//            //            myDate = [dateFormatter dateFromString:eventObj.eFromDate];
//            
//            xpos=xpos+1;
//            yPos=33;
//            
//            NSLog(@"NO");
//            
//            UILabel* label12=[[UILabel alloc]init];
//            label12.frame=CGRectMake(355*xpos+42,0,110,18);
//            label12.numberOfLines=3;
//            label12.font=[UIFont fontWithName:FontBold size:10];
//            label12.textColor=kSkyBlueColor;
//            label12.backgroundColor=[UIColor clearColor];
//            label12.text=myDate2;
//            
//            [eventListScrollView addSubview:label12];
//            
//        }
        
        UIImageView*customeImageView=[[UIImageView alloc]init];
        customeImageView.frame=CGRectMake(341*xpos+29,yPos,42,42);
        customeImageView.backgroundColor=[UIColor darkTextColor];
//        NSLog(@"eventObj:%@",eventObj.eThumbImage);
        
        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventObj.eThumbImage];
        
        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
            customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
        }
        else if([UIImage imageNamed:eventObj.eThumbImage]){
            customeImageView.image=[UIImage imageNamed:eventObj.eThumbImage];
        }
        else{
            customeImageView.image = [UIImage imageNamed:@"thumb-background.png"];
        }
//        customeImageView.image=[UIImage imageWithContentsOfFile:eventObj.eThumbImage];
        customeImageView.contentMode=UIViewContentModeScaleAspectFit;

        
        UILabel* label=[[UILabel alloc]init];
        label.frame=CGRectMake(341*xpos+52+29,yPos,211,42);
        label.numberOfLines=2;
        label.font=[UIFont fontWithName:FontLight size:20];
        label.textColor=kGrayColor;
        label.backgroundColor=[UIColor clearColor];
        
        UILabel* label1=[[UILabel alloc]init];
        label1.frame=CGRectMake(341*xpos+52+29,yPos+42,110,18);
        label1.numberOfLines=1;
        label1.font=[UIFont fontWithName:FontBold size:10];
        label1.textColor=kGrayColor;
        label1.text=[NSString stringWithFormat:@"%@ %@-%@",monthStringFromDate,dateStringFromDate,dateStringToDate];
        
        label1.backgroundColor=[UIColor clearColor];
        
        UILabel* label2=[[UILabel alloc]init];
        label2.frame=CGRectMake(341*xpos+52+29,yPos+42+18,221,20);
        label2.numberOfLines=1;
        label2.font=[UIFont fontWithName:FontBold size:10];
        label2.textColor=kGrayColor;
        label2.text=eventObj.ePlace;
        label2.backgroundColor=[UIColor clearColor];
        
        UIButton *eventButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [eventButton setFrame:CGRectMake(341*xpos+52+29,yPos,211,80)];
        
        [eventButton setBackgroundColor:[UIColor clearColor]];
        
        [eventButton addTarget:self action:@selector(eventListBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        eventButton.tag=index;

        
        label.text=eventObj.eName;
        index=index+1;
        
        [eventListScrollView addSubview:customeImageView];
        [eventListScrollView addSubview:label];
        [eventListScrollView addSubview:label1];
        [eventListScrollView addSubview:label2];
        [eventListScrollView addSubview:eventButton];
        
        
        
    }
    }
}

-(void)eventListBUttonAction:(id)sender
{
    if ([delegate respondsToSelector:selectoreventListAction]) {
        
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setValue:self.eventListMainArray forKey:@"Array"];
        [dictionary setValue:sender forKey:@"EventTag"];
        
        [delegate performSelector:selectoreventListAction withObject:dictionary afterDelay:0.0];
        
    }
    isEventSelected = TRUE;
    [eventListSearchTextField resignFirstResponder];
    
//    NSLog(@"event Clicked");
    
}
- (IBAction)changePage:(id)sender {
    
    int page = eventListPageControl.currentPage;
	CGRect frame = eventListScrollView.frame;
    frame.origin.x = 1024 * page;
    frame.origin.y = 0;
    [eventListScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrolView
{
	CGFloat pageWidth = 1024;
    int page = floor((scrolView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    eventListPageControl.currentPage = page;
}
-(void)cleareScrollViewContent
{
    for (UIView *subview in eventListScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }
    
}

-(IBAction)eventAllButtonAction:(id)sender
{
    [eventListAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventListUpcomingButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [eventListPastButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];
  
    self.eventListMainArray=[[CoreDataOprations initObject]fetchRequest:@"Events":@"eFromDate":self.managedObjectContext];
    
    [self addEventContentOnScrollView:self.eventListMainArray];

}

-(IBAction)eventSearchButtonAction:(id)sender
{
//    if ([delegate respondsToSelector:selectorEventListSearchAction]) {
//        
//        [delegate performSelector:selectorEventListSearchAction withObject:@"YES" afterDelay:0.0];
//    }
    if ([(UIButton*)sender currentImage]==[UIImage imageNamed:@"search.png"])
    {
    eventListSearchTextField.hidden=FALSE;
    eventListSearchTextFieldImageView.hidden=FALSE;
    
    [eventListSearchTextField becomeFirstResponder];
    
    [(UIButton*)sender setImage:[UIImage imageNamed:@"cancel-1.png"] forState:UIControlStateNormal];
   
    }
    else
    {
        eventListSearchTextField.hidden=TRUE;
        eventListSearchTextFieldImageView.hidden=TRUE;
      
        eventListAllButton.hidden=NO;
        eventListUpcomingButton.hidden=NO;
        eventListPastButton.hidden=NO;
        eventListSearchTextLable.hidden=YES;
        eventListSearchResultLable.hidden=YES;
        [eventListSearchTextField resignFirstResponder];
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        
        [eventListAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [eventListUpcomingButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [eventListPastButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [self cleareScrollViewContent];
        
        self.eventListMainArray=[[CoreDataOprations initObject]fetchRequest:@"Events":@"eFromDate":self.managedObjectContext];
        
        [self addEventContentOnScrollView:self.eventListMainArray];

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:selectorEventListSearchAction]) {
        
        [delegate performSelector:selectorEventListSearchAction withObject:@"YES" afterDelay:0.0];
        
    }
    
}

-(IBAction)eventUpcomingButtonAction:(id)sender
{
    [eventListAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [eventListUpcomingButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [eventListPastButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];
    
    self.eventListMainArray=[[CoreDataOprations initObject]fetchRequestUpcoming:@"Events":@"eFromDate":@"eToDate":self.managedObjectContext];
    
    [self addEventContentOnScrollView:self.eventListMainArray];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"resig");
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"resign");
    
    if (!isEventSelected) {
        if ([delegate respondsToSelector:selectorEventListSearchAction]) {
            
            [delegate performSelector:selectorEventListSearchAction withObject:@"NO" afterDelay:0.0];
            
        }
    }
    isEventSelected = FALSE;
    
    //[self cleareScrollViewContent];
}
-(IBAction)eventPastButtonAction:(id)sender
{
    [eventListAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [eventListUpcomingButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [eventListPastButton setTitleColor:kGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];
        
    self.eventListMainArray=[[CoreDataOprations initObject]fetchRequestPast:@"Events":@"eFromDate":@"eToDate":self.managedObjectContext];
    
    [self addEventContentOnScrollView:self.eventListMainArray];

}

-(IBAction)eventSearchTextField_ValueChanged:(id)sender
{
    eventListAllButton.hidden=YES;
    eventListUpcomingButton.hidden=YES;
    eventListPastButton.hidden=YES;
    eventListSearchTextLable.hidden=NO;
    eventListScrollView.frame=CGRectMake(0, 53, 1024, 317);
    eventListSearchTextLable.text=[NSString stringWithFormat:@"Results of ''%@''",eventListSearchTextField.text];
    
    NSString *searchText = eventListSearchTextField.text;

    self.eventListMainArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Events" :@"eFromDate" :@"eName" :searchText:self.managedObjectContext];
    
    [self addSearchEventContentOnScrollView:self.eventListMainArray];
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
