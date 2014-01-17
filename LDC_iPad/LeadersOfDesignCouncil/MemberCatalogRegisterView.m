//
//  MemberCatalogRegisterView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 29/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MemberCatalogRegisterView.h"
#import "Constants.h"
#import "Memebers.h"
#import "CoreDataOprations.h"
#import "AppDelegate.h"
#import "Profession.h"

@implementation MemberCatalogRegisterView

@synthesize delegate,selectorMemberCatalogAction,memberCatalogScrollView,selectorMemberCatalogDetailAction,managedObjectContext,continentArray,countryArray,stateArray,searchArray,memberListArray,professionArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"MemberCatalogRegisterView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
        memberCatalogAllButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [memberCatalogAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
        memberCatalogByLocationButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        memberCatalogLocationDetailButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];

        memberCatalogByIndustryButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [memberCatalogSearchTextField setTextColor:kGrayColor];
        
        [memberCatalogSearchTextLable setTextColor:kGrayColor];
       
        [memberCatalogSearchResultLable setTextColor:kGrayColor];
        
        [memberCatalogSearchResultLable setFont:[UIFont fontWithName:FontRegular size:15]];
        
        [memberCatalogSearchResultLable setText:@"No search results"];

        memberListArray =[[NSMutableArray alloc]init];
        self.searchArray = [[NSArray alloc] init];
        self.memberListArray=[[NSArray alloc]init];
        
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        //
        self.managedObjectContext=appDelegate.managedObjectContext;

//        self.memberListArray=[[CoreDataOprations initObject] fetchRequest:@"Memebers" :@"mId" :self.managedObjectContext];
        self.memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:self.managedObjectContext];
        
        [self addMemberContentOnScrollView:self.memberListArray];
    }

    return self;
}

- (IBAction)changePage:(id)sender {
    
    int page = memberCatalogPageControl.currentPage;
	CGRect frame = self.memberCatalogScrollView.frame;
    frame.origin.x = 1024 * page;
    frame.origin.y = 0;
    [self.memberCatalogScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrolView
{
	CGFloat pageWidth = 1024;
    int page = floor((scrolView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    memberCatalogPageControl.currentPage = page;
}

-(IBAction)MemberByLocation_Clicked:(id)sender
{    memberCatalogSearchResultLable.hidden=YES;

//    if (sender==memberCatalogLocationDetailButton)
//    {
//        searchCheckFlage=FALSE;
//        
//        memberCatalogLocationDetailButton.hidden=TRUE;
//        
//        [memberCatalogAllButton setFrame:CGRectMake(29,20.0,30.0,20.0)];
//        
//        memberCatalogByIndustryButton.frame=CGRectMake(261,20,71,20);
//        
//        memberCatalogByLocationButton.frame=CGRectMake(126,20,70,20);
//    }
    
    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];
    [self addLocationContentOnScrollView:self.searchArray];
    
}

-(void)continentButtonAction:(id)sender
{
    [self cleareScrollViewContent];
    
    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    memberListArray=[NSMutableArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,20,size.width,20);
    
    [memberCatalogAllButton setFrame:CGRectMake((size.width)+29.0+64.0,20,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake((size.width)+261.0+64.0,20,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake((size.width)+126.0+64.0,20,70,20);

    
    Contitent *contitentobj=[self.continentArray objectAtIndex:[sender tag]];
    
//    self.memberListArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mContinentId" :contitentobj.contitentId :self.managedObjectContext];

    
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mContinentId" withSearchVal:contitentobj.contitentId andWithManagedObj:self.managedObjectContext];
    
    [self addMemberContentOnScrollView:self.memberListArray];
    
}
-(void)countryButtonAction:(id)sender
{
    
    [self cleareScrollViewContent];
    
    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    memberListArray=[NSMutableArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,20,size.width,20);
    
    [memberCatalogAllButton setFrame:CGRectMake((size.width)+29.0+64.0,20,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake((size.width)+261.0+64.0,20,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake((size.width)+126.0+64.0,20,70,20);

    
    Country *countryobj=[self.countryArray objectAtIndex:[sender tag]];
    
//    self.memberListArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mCountryId" :countryobj.countryId :self.managedObjectContext];

    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mCountryId" withSearchVal:countryobj.countryId andWithManagedObj:self.managedObjectContext];
    
    [self addMemberContentOnScrollView:self.memberListArray];

}
-(void)stateButtonAction:(id)sender
{
    [self cleareScrollViewContent];
    
    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    memberListArray=[NSMutableArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,20,size.width,20);
    
    [memberCatalogAllButton setFrame:CGRectMake((size.width)+29.0+64.0,20,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake((size.width)+261.0+64.0,20,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake((size.width)+126.0+64.0,20,70,20);


    State *stateobj=[self.stateArray objectAtIndex:[sender tag]];
    
//    self.memberListArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mStateId" :stateobj.stateId :self.managedObjectContext];

    
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mStateId" withSearchVal:stateobj.stateId andWithManagedObj:self.managedObjectContext];
    
    [self addMemberContentOnScrollView:self.memberListArray];
}

-(IBAction)MemberAll_Clicked:(id)sender
{    memberCatalogSearchResultLable.hidden=YES;
    if (sender==memberCatalogLocationDetailButton)
    {
        searchCheckFlage=FALSE;
        
        memberCatalogLocationDetailButton.hidden=TRUE;
        
        [memberCatalogAllButton setFrame:CGRectMake(29,20.0,30.0,20.0)];
        
        memberCatalogByIndustryButton.frame=CGRectMake(261,20,71,20);
        
        memberCatalogByLocationButton.frame=CGRectMake(126,20,70,20);
    }

    [memberCatalogAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];
    
//    self.memberListArray=[[CoreDataOprations initObject] fetchRequest:@"Memebers" :@"mId" :self.managedObjectContext];
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:self.managedObjectContext];
    
    [self addMemberContentOnScrollView:self.memberListArray];
    self.memberCatalogScrollView.contentOffset = CGPointZero;
    
}

-(IBAction)memberProfession_CLicked:(id)sender
{    memberCatalogSearchResultLable.hidden=YES;

    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];

    [self addMemberProfessionContentOnScrollView];
    self.memberCatalogScrollView.contentOffset = CGPointZero;
}

-(IBAction)MemberSearch_Clicked:(id)sender
{
    memberCatalogSearchResultLable.hidden=YES;

    if (searchCheckFlage) {
        
    }
    else {
        
        if (!memberCatalogLocationDetailButton.hidden)
        {
            searchCheckFlage=TRUE;
        }
        else
        {
            searchCheckFlage=FALSE;
        }
        
    }
    if (memberCatalogSearchTextField.hidden)
    {
        memberCatalogSearchTextField.hidden=FALSE;
        memberCatalogSearchTextFieldImageView.hidden=FALSE;
        [memberCatalogSearchTextField becomeFirstResponder];
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"cancel-1.png"] forState:UIControlStateNormal];

        memberCatalogAllButton.hidden=YES;
        memberCatalogByLocationButton.hidden=YES;
        memberCatalogByIndustryButton.hidden=YES;
        memberCatalogLocationDetailButton.hidden=YES;

    }
    else
    {
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];

        if ([delegate respondsToSelector:selectorMemberCatalogAction]) {
            
            [delegate performSelector:selectorMemberCatalogAction withObject:@"NO" afterDelay:0.0];
            
        }

        memberCatalogSearchTextField.hidden=TRUE;
        memberCatalogSearchTextFieldImageView.hidden=TRUE;
        memberCatalogSearchTextField.text=@"";

        [memberCatalogSearchTextField resignFirstResponder];
        
        memberCatalogAllButton.hidden=NO;
        memberCatalogByLocationButton.hidden=NO;
        memberCatalogByIndustryButton.hidden=NO;
        memberCatalogSearchTextLable.hidden=YES;
        memberCatalogSearchResultLable.hidden=YES;

        [self cleareScrollViewContent];
        
        if (searchCheckFlage) {
            
            memberCatalogLocationDetailButton.hidden=FALSE;
            
        }
        else {
            memberCatalogLocationDetailButton.hidden=TRUE;
            
            [memberCatalogAllButton setFrame:CGRectMake(29,20.0,30.0,20.0)];
            
            memberCatalogByIndustryButton.frame=CGRectMake(261,20,71,20);
            
            memberCatalogByLocationButton.frame=CGRectMake(126,20,70,20);

        }
        
//        Profession *professionObj=[self.professionArray objectAtIndex:[sender tag]];
//        
//        self.memberListArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mProfessionId" :professionObj.professionId :self.managedObjectContext];
        
//        self.memberListArray=[[CoreDataOprations initObject] fetchRequest:@"Memebers" :@"mId" :self.managedObjectContext];
        self.memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:self.managedObjectContext];
        
//        self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mProfessionId" withSearchVal:professionObj.professionId andWithManagedObj:self.managedObjectContext];
        
        [self addMemberContentOnScrollView:self.memberListArray];

        
//        [self addMemberContentOnScrollView:self.memberListArray];

    }
}

-(IBAction)MemberSearchTextField_ValueChanged:(id)sender
{
    memberCatalogAllButton.hidden=YES;
    memberCatalogByLocationButton.hidden=YES;
    memberCatalogByIndustryButton.hidden=YES;
    memberCatalogLocationDetailButton.hidden=YES;
    memberCatalogSearchTextLable.hidden=NO;
    
   
    
//    self.searchArray = [[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mLastName" :@"mName" :memberCatalogSearchTextField.text :self.managedObjectContext];
//    NSLog(@"memberCatalogSearchTextField.text : %@",memberCatalogSearchTextField.text);
    
//    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mName" withSearchVal:memberCatalogSearchTextField.text andWithManagedObj:self.managedObjectContext];
     self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttributeArray:[NSArray arrayWithObjects:@"mLastName",@"mName", nil] withSearchVal:memberCatalogSearchTextField.text andWithManagedObj:self.managedObjectContext];
    
     memberCatalogSearchTextLable.text=[NSString stringWithFormat:@"Results of '%@'",memberCatalogSearchTextField.text];
    
    
//    self.memberListArray=self.searchArray;
    self.searchArray = self.memberListArray;
    
//    NSLog(@"%d",[self.searchArray count]);
    
    [self cleareScrollViewContent];
    
    if ([self.searchArray count]==0) {
        
        memberCatalogSearchResultLable.hidden=NO;
    }
    else {
        
        memberCatalogSearchResultLable.hidden=YES;
        
    }

    if ([self.searchArray count]%4 == 0)
    {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*([self.searchArray count]/4)/5, 317);
        
        memberCatalogPageControl.numberOfPages=([self.searchArray count]/4)/5;
        
    }
    
    else
    {
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*((([self.searchArray count]/4)/5)+1), 317);
        
        memberCatalogPageControl.numberOfPages=((([self.searchArray count]/4)/5)+1);
        
    }
    
    int x=0;
    
    if ([self.searchArray count]%4==0)
    {
        x=[self.searchArray count]/4;
    }
    else
    {
        x=([self.searchArray count]/4)+1;
    }
    
    [self addSearchResultOnScrollView:4 :x :self.searchArray];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"resig");
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:selectorMemberCatalogAction]) {
        
        [delegate performSelector:selectorMemberCatalogAction withObject:@"YES" afterDelay:0.0];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"resign");
    if (!isMemberSelected) {
        if ([delegate respondsToSelector:selectorMemberCatalogAction]) {
            
            [delegate performSelector:selectorMemberCatalogAction withObject:@"NO" afterDelay:0.0];
            
        }
    }
    isMemberSelected = FALSE;
    

    [self cleareScrollViewContent];
    
    if ([self.searchArray count]==0) {
        
        memberCatalogSearchResultLable.hidden=NO;
    }
    else {
        
        memberCatalogSearchResultLable.hidden=YES;
        
    }
    
    if (([self.searchArray count]/6)%5 == 0) {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*([self.searchArray count]/6)/5,317);
        
        memberCatalogPageControl.numberOfPages=([self.searchArray count]/6)/5;
        
    }
    
    else {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*((([self.searchArray count]/6)/5)+1),317);
        
        memberCatalogPageControl.numberOfPages=((([self.searchArray count]/6)/5)+1);
        
    }
    
    int x=0;
    
    if ([self.searchArray count]%6==0)
    {
        x=[self.searchArray count]/6;
    }
    else
    {
        x=([self.searchArray count]/6)+1;
    }
    
    [self addSearchResultOnScrollView:6 :x :self.searchArray];
    
}

-(void)memberCatalogListButtonAction:(id)sender
{
    
    isMemberSelected = TRUE;
    if ([delegate respondsToSelector:selectorMemberCatalogDetailAction]) {
        
        NSMutableDictionary *dictionOfObjects=[[NSMutableDictionary alloc]init];
        [dictionOfObjects setValue:self.memberListArray forKey:@"Array"];
        [dictionOfObjects setValue:sender forKey:@"membertag"];
        
        [delegate performSelector:selectorMemberCatalogDetailAction withObject:dictionOfObjects afterDelay:0.0];
        
    }
    
//    NSLog(@"event Clicked");
}

-(void)cleareScrollViewContent
{
    for (UIView *subview in self.memberCatalogScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }

}

-(void)addMemberContentOnScrollView:(NSArray*)memberArray
{
    int y=0;
   
    if ([memberArray count]%30==0)
    {
        y=[memberArray count]/30;
    }
    else
    {
        y=([memberArray count]/30)+1;
    }
    
    self.memberCatalogScrollView.contentSize=CGSizeMake(1024*y,317);
    
    memberCatalogPageControl.numberOfPages=y;
    int x=0;
    
    if ([memberArray count]%6==0)
    {
        x=[memberArray count]/6;
    }
    else
    {
        x=([memberArray count]/6)+1;
    }
    int index=0;

    for (int j=0; j<x; j++) {
      
        for (int i=0; i<6; i++) {
                        
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(205*j+29,55*i,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
            customeImageView.image=[UIImage imageNamed:@"henry_agee_pic_frame.png"];
            customeImageView.contentMode=UIViewContentModeScaleAspectFit;

            UILabel* label=[[UILabel alloc]init];
            label.frame=CGRectMake(205*j+52+29,55*i,110,42);
            label.numberOfLines=3;
            label.font=[UIFont fontWithName:FontRegular size:14];
            label.textColor=kGrayColor;
            label.backgroundColor=[UIColor clearColor];
            
            UIButton *memberButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [memberButton setFrame:CGRectMake(205*j+29,55*i,162,80)];
            
            [memberButton setBackgroundColor:[UIColor clearColor]];
            
            [memberButton addTarget:self action:@selector(memberCatalogListButtonAction:) forControlEvents:UIControlEventTouchUpInside];

            
            if (index>=[memberArray count]) {
                
                break;
            }
            else {
                
                Memebers *memObj=[memberArray objectAtIndex:index];
                memberButton.tag=index;
                label.text=[NSString stringWithFormat:@"%@ %@", memObj.mName,memObj.mLastName];
//                NSLog(@"mthumb:%@",memObj.mThumbImage);
                
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memObj.mThumbImage];
                
                if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                    customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
                }
                else if ([UIImage imageNamed:memObj.mThumbImage]){
                    customeImageView.image=[UIImage imageNamed:memObj.mThumbImage];
                }
                else{
                    customeImageView.image=[UIImage imageNamed:@"thumb-background.png"];
                }
                
//                if ([UIImage imageWithContentsOfFile:memObj.mThumbImage]) {
//                    customeImageView.image=[UIImage imageWithContentsOfFile:memObj.mThumbImage];
//                }
//                else{
//                    customeImageView.image=[UIImage imageNamed:memObj.mThumbImage];
//                }
                
//                customeImageView.image=[UIImage imageWithContentsOfFile:memObj.mThumbImage];
                customeImageView.contentMode=UIViewContentModeScaleAspectFit;
                customeImageView.backgroundColor = [UIColor darkTextColor];
                index=index+1;

                [self.memberCatalogScrollView addSubview:customeImageView];
                [self.memberCatalogScrollView addSubview:label];
                [self.memberCatalogScrollView addSubview:memberButton];
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

-(void)addLocationContentOnScrollView:(NSMutableArray*)locationArray
{
    continentArray=[[CoreDataOprations initObject] fetchRequest:@"Contitent" :@"contitentId" :self.managedObjectContext];
//    countryArray=[[CoreDataOprations initObject] fetchRequest:@"Country" :@"countryId" :self.managedObjectContext];
    countryArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Country" withSortDecs:@"countryName" forManagedObj:self.managedObjectContext];
//    stateArray=[[CoreDataOprations initObject] fetchRequest:@"State" :@"stateId" :self.managedObjectContext];
    stateArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"State" withSortDecs:@"stateName" forManagedObj:self.managedObjectContext];
    
    int index=0;
    
    int xPos=80;
    
    int yPos=0;
    
    for (int i=0; i<[continentArray count]; i++) {
        
        
        Contitent *contitentobj=[continentArray objectAtIndex:i];

        
        if (i>0) {
            
            xPos=xPos+205;
        }
        
        UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        continentButton.frame=CGRectMake(xPos,0,110,25);
        
        [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
        [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [continentButton setTitle:contitentobj.contitentName forState:UIControlStateNormal];
        [continentButton setTag:i];
        
        // [continentButton setTitleEdgeInsets:UIEdgeInsetsMake(-12.5,-55, 0, 0)];
        
        [continentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [continentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [continentButton setBackgroundColor:[UIColor clearColor]];
        [continentButton addTarget:self action:@selector(continentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.memberCatalogScrollView addSubview:continentButton];
        
        yPos=60;   //70
        
        for (int j=0; j<[countryArray count]; j++) {
            
            Country *countryobj=[countryArray objectAtIndex:j];
            
            //   NSDictionary *countryDictionary=[countryArray objectAtIndex:j];
            
            if ([countryobj.contitentId isEqualToString:contitentobj.contitentId])
            {

            if (yPos>=250) {
                
                xPos=xPos+205;
                
                yPos=0;
            }
            else if (yPos>60)
            {
                yPos=yPos+25;
            }
            
            UIButton *countryButton=[UIButton buttonWithType:UIButtonTypeCustom];
            countryButton.frame=CGRectMake(xPos,yPos,110,25);
            [countryButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
            [countryButton setTitleColor:kGrayColor forState:UIControlStateNormal];
            // [countryButton setTitleEdgeInsets:UIEdgeInsetsMake(-12.5,-55, 0, 0)];
            
            [countryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [countryButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                [countryButton setTag:j];
            [countryButton setTitle:countryobj.countryName forState:UIControlStateNormal];
            [countryButton addTarget:self action:@selector(countryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [countryButton setBackgroundColor:[UIColor clearColor]];
            
            [self.memberCatalogScrollView addSubview:countryButton];
            
            yPos = yPos+17.5+20;
            
    for (int k=0;k<[stateArray count]; k++)
        {
                
        State *stateobj=[stateArray objectAtIndex:k];
                
                //   NSDictionary *stateDictionary=[stateArray objectAtIndex:k];
                
        if ([stateobj.countryId isEqualToString:countryobj.countryId])
        {
                index=index+1;
                
                UIButton *cityButton=[UIButton buttonWithType:UIButtonTypeCustom];
                cityButton.frame=CGRectMake(xPos,yPos,110,25);
                [cityButton.titleLabel setFont:[UIFont fontWithName:FontRegular size:14]];
                [cityButton setTitleColor:kGrayColor forState:UIControlStateNormal];
                // [cityButton setTitleEdgeInsets:UIEdgeInsetsMake(-12.5,-55, 0, 0)];
                
                [cityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [cityButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                
                [cityButton setTitle:stateobj.stateName forState:UIControlStateNormal];
                [cityButton setTag:k];
                [cityButton addTarget:self action:@selector(stateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [cityButton setBackgroundColor:[UIColor clearColor]];
            
                 [self.memberCatalogScrollView addSubview:cityButton];
                
                if (yPos>=290) {
                    
                    xPos=xPos+205;
                    
                    yPos=0;
                }
                
                else {
                    
                    yPos=yPos+17.5+15;
                    
                }
                }
            }
            }
        }
    }
    
    int scrollviewwidth=xPos+110;
    
    int numberofPages=0;
    
    if (scrollviewwidth%1024!=0) {
        
        numberofPages=(scrollviewwidth/1024)+1;
        
        memberCatalogPageControl.numberOfPages=numberofPages;
        memberCatalogScrollView.contentSize=CGSizeMake(1024*numberofPages,317);
        
    }
    else {
        
        numberofPages=(scrollviewwidth/1024);
        
        memberCatalogPageControl.numberOfPages=numberofPages;
        memberCatalogScrollView.contentSize=CGSizeMake(numberofPages,317);
        
    }

    
    self.memberCatalogScrollView.contentOffset = CGPointZero;
//    self.memberCatalogScrollView.contentSize=CGSizeMake(xPos+110,317);
//    
//    CGSize size=self.memberCatalogScrollView.contentSize;
//    
//    int pagecount=floorf(size.width/1024);
//    
//    memberCatalogPageControl.numberOfPages=pagecount+1;

}
-(void)addMemberProfessionContentOnScrollView
{
    self.memberCatalogScrollView.contentSize=CGSizeMake(1024,317);
    
    memberCatalogPageControl.numberOfPages=1;
  
//    self.professionArray=[[CoreDataOprations initObject]fetchRequest:@"Profession":@"professionId":self.managedObjectContext];
    
    self.professionArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Profession" withSortDecs:@"professionId" forManagedObj:self.managedObjectContext];
    
    [self getProfessionList];

    
    
//    NSLog(@"self.professionArray count %d",[professionArrayFixed count]);
    

    
//    NSArray *arrayOfProfession=[[NSArray alloc]initWithObjects:@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media", nil];
    
    int xPos=80;
    
    int yPos=0;
    
    for (int j=0; j<[professionArrayFixed count]; j++) {
        
//        NSLog(@"j %d",j);
       
        if (j%5==0 && j>0) {
            
            xPos=xPos+215;
            
            yPos=0;
        }

        UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        continentButton.frame=CGRectMake(xPos,yPos,150,25);
        
        [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
        [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
       
        //Profession *professionObj=[self.professionArray objectAtIndex:j];
        NSDictionary *profDict = [professionArrayFixed objectAtIndex:j];
        
//         NSLog(@"professionObj.professionName %@",[profDict valueForKey:kProfessionName]);
        
        [continentButton setTitle:[profDict valueForKey:kProfessionName] forState:UIControlStateNormal];
        
        // [continentButton setTitleEdgeInsets:UIEdgeInsetsMake(-12.5,-55, 0, 0)];
        
        [continentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [continentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [continentButton setBackgroundColor:[UIColor clearColor]];
        [continentButton addTarget:self action:@selector(profession_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [continentButton setTag:j];
        [continentButton sizeToFit];
        continentButton.frame = CGRectMake(continentButton.frame.origin.x, continentButton.frame.origin.y, continentButton.frame.size.width, 25);
        [self.memberCatalogScrollView addSubview:continentButton];
        
        yPos=yPos+45+25;
        
    }
}
-(void)profession_Clicked:(id)sender
{
    [self cleareScrollViewContent];
    
    [memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    memberListArray=[NSMutableArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,20,size.width,20);
    
    [memberCatalogAllButton setFrame:CGRectMake((size.width)+29.0+64.0,20,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake((size.width)+261.0+64.0,20,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake((size.width)+126.0+64.0,20,70,20);

//    Profession *professionObj=[self.professionArray objectAtIndex:[sender tag]];
    [self getProfessionList];
    NSDictionary *profDict = [professionArrayFixed objectAtIndex:[sender tag]];
    
//    self.memberListArray=[[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mProfessionId" :professionObj.professionId :self.managedObjectContext];
    

    
     self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mProfessionId" withSearchVal:[profDict valueForKey:kProfessionID] andWithManagedObj:self.managedObjectContext];
    [self addMemberContentOnScrollView:self.memberListArray];

}

-(void)addSearchResultOnScrollView:(int)rowCount:(int)columnCount:(NSArray*)searchContentArray
{
    int index=0;

    for (int j=0; j<columnCount; j++) {
        
        
        for (int i=0; i<rowCount; i++) {
                        
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(205*j+29,55*i,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
            customeImageView.image=[UIImage imageNamed:@"henry_agee_pic_frame.png"];
            customeImageView.contentMode=UIViewContentModeScaleAspectFit;

            UILabel* label=[[UILabel alloc]init];
            label.frame=CGRectMake(205*j+52+29,55*i,110,42);
            label.numberOfLines=3;
            label.font=[UIFont fontWithName:FontRegular size:14];
            label.textColor=kGrayColor;
            label.backgroundColor=[UIColor clearColor];
            
            UIButton *memberButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [memberButton setFrame:CGRectMake(205*j+29,55*i,162,80)];
            
            [memberButton setBackgroundColor:[UIColor clearColor]];
            
            [memberButton addTarget:self action:@selector(memberCatalogListButtonAction:) forControlEvents:UIControlEventTouchUpInside];

            
           // int index=0;
          //  index=(0*20)+i+j*5;
            
            if (index>=[self.searchArray count])
            {
                break;
            }
            else
            {
                Memebers *memObj=[self.searchArray objectAtIndex:index];
                memberButton.tag=index;
                label.text=[NSString stringWithFormat:@"%@ %@", memObj.mName,memObj.mLastName];
                index=index+1;
                
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memObj.mThumbImage];
              
                if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                    customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
                }
                else if ([UIImage imageNamed:memObj.mThumbImage]){
                    customeImageView.image=[UIImage imageNamed:memObj.mThumbImage];
                }
                else{
                    customeImageView.image=[UIImage imageNamed:@"thumb-background.png"];
                }

                
                [self.memberCatalogScrollView addSubview:customeImageView];
                [self.memberCatalogScrollView addSubview:label];
                
                [self.memberCatalogScrollView addSubview:memberButton];
            }
            
        }
    }
}

-(NSMutableArray *)getProfessionList{
    NSDictionary *profDict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Architect/Interior Designer",kProfessionName,@"29656241-5E03-4747-87DF-D5A86C329021",kProfessionID, nil];
    NSDictionary *profDict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Architect",kProfessionName,@"A8EA1D1C-529D-40D0-BB85-D2E9CFA54D25",kProfessionID, nil];
    
    NSDictionary *profDict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Interior Designer",kProfessionName,@"695D1C6E-D0EB-4E69-AA3B-05147DD51C34",kProfessionID, nil];
    NSDictionary *profDict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Landscape Designer",kProfessionName,@"8a9a6091-b4da-47fb-a479-90e36a7c6d03",kProfessionID, nil];
    NSDictionary *profDict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Media",kProfessionName,@"60C739E1-08AD-4682-B2D7-49D4F0869BB6",kProfessionID, nil];
    
    NSDictionary *profDict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Executive",kProfessionName,@"7DF6B1E7-D3ED-4AAB-85A0-56956C60BE66",kProfessionID, nil];
    
    if (!professionArrayFixed) {
        professionArrayFixed = [[NSMutableArray alloc] init];
    }
    [professionArrayFixed removeAllObjects];
    [professionArrayFixed addObject:profDict1];
    [professionArrayFixed addObject:profDict2];
    [professionArrayFixed addObject:profDict3];
    [professionArrayFixed addObject:profDict4];
    [professionArrayFixed addObject:profDict5];
    [professionArrayFixed addObject:profDict6];
    
    return professionArrayFixed;
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
