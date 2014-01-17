//
//  MemberCatalogPublicView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 24/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MemberCatalogPublicView.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "State.h"
#import "Contitent.h"
#import "Country.h"
#import "CoreDataOprations.h"
#import "Profession.h"
@implementation MemberCatalogPublicView
@synthesize memberCatalogAllButton,searchCheckFlage,memberCatalogScrollView,selectorBackAction,delegate,membersObj,managedObjectContext,memberListArray,searchArray;
@synthesize continentArray,countryArray,stateArray,professionArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"MemberCatalogPublicView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];

        
        memberCatalogTitleLable.font=[UIFont fontWithName:FontLight size:20];
        [memberCatalogTitleLable setTextColor:kGrayColor];
        
        self.memberCatalogAllButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [self.memberCatalogAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        
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
        
        searchArray = [[NSMutableArray alloc] init];
        
        dummyArray=[[NSMutableArray alloc]initWithObjects:@"Henry Agree",@"Kim Alanis",@"Ruth Allen",@"Tera Alvarez",@"James Aztek",@"Trish Alberez",@"Nancy Bird", nil];
        
    
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
       
        self.managedObjectContext=appDelegate.managedObjectContext;
        
  
//        self.memberListArray=[[CoreDataOprations initObject]fetchRequestAccordingtoFounderCategory:@"Memebers" :@"mId" :@"mFounder" :[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]]:self.managedObjectContext];
        
        self.memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:self.managedObjectContext];

        [self addMemberContentOnScrollView:self.memberListArray];
        
    }
    

    return self;
}

- (void)loadImage:(NSMutableDictionary*)url {
   
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url valueForKey:@"url"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [UIImagePNGRepresentation(image) writeToFile:[url valueForKey:@"path"] atomically:YES];

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
{
    memberCatalogSearchResultLable.hidden=YES;

    [self.memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    if (sender==memberCatalogLocationDetailButton) {
        
        searchCheckFlage=FALSE;
        
        memberCatalogLocationDetailButton.hidden=TRUE;
        
        [self.memberCatalogAllButton setFrame:CGRectMake(29,74.0,30.0,20.0)];
        
        memberCatalogByIndustryButton.frame=CGRectMake(261,74,71,20);
        
        memberCatalogByLocationButton.frame=CGRectMake(126,74,70,20);

    }
   
    [self fadeView:memberCatalogScrollView fadein:YES timeAnimation:0.3];
    
    [self cleareScrollViewContent];
    [self addLocationContentOnScrollView:dummyArray];
     self.memberCatalogScrollView.contentOffset = CGPointZero;
}

-(void)continentlocation_Clicked:(UIButton*)sender
{
    [self.memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

    [self cleareScrollViewContent];

    self.memberListArray=[NSArray array];
       
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
       
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    float wid=(size.width)+126.0+64.0;
    float wid1=(size.width)+29.0+64.0;
    float wid2=(size.width)+261.0+64.0;

    memberCatalogLocationDetailButton.frame=CGRectMake(29,74,size.width,20);
        
    [self.memberCatalogAllButton setFrame:CGRectMake(wid1,74.0,30.0,20.0)];

    memberCatalogByIndustryButton.frame=CGRectMake(wid2,74,71,20);
   
    memberCatalogByLocationButton.frame=CGRectMake(wid,74,70,20);
   
    
    Contitent *contitentobj=[self.continentArray objectAtIndex:[sender tag]];
    
    self.memberListArray=[self searchByLocation:contitentobj.contitentId :@"mContinentId"];

    [self addMemberContentOnScrollView:self.memberListArray];
    
}

-(void)statelocation_Clicked:(UIButton*)sender
{
    [self.memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    
    self.memberListArray=[NSArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    float wid=(size.width)+126.0+64.0;
    float wid1=(size.width)+29.0+64.0;
    float wid2=(size.width)+261.0+64.0;
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,74,size.width,20);
    
    [self.memberCatalogAllButton setFrame:CGRectMake(wid1,74.0,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake(wid2,74,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake(wid,74,70,20);

    State *stateobj=[self.stateArray objectAtIndex:[sender tag]];
            
    self.memberListArray=[self searchByLocation:stateobj.stateId :@"mStateId"];

    [self addMemberContentOnScrollView:self.memberListArray];
    
}
-(void)countrylocation_Clicked:(UIButton*)sender
{
    [self.memberCatalogAllButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    
    self.memberListArray=[NSArray array];
    
    memberCatalogLocationDetailButton.hidden=FALSE;
    
    [memberCatalogLocationDetailButton setTitle:[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    
    CGSize size = [[NSString stringWithFormat:@"X %@",[(UIButton*)sender titleForState:UIControlStateNormal]] sizeWithFont:[UIFont fontWithName:FontBold size:10]];
    
    float wid=(size.width)+126.0+64.0;
    float wid1=(size.width)+29.0+64.0;
    float wid2=(size.width)+261.0+64.0;
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,74,size.width,20);
    
    [self.memberCatalogAllButton setFrame:CGRectMake(wid1,74.0,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake(wid2,74,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake(wid,74,70,20);

    
    Country *countryobj=[self.countryArray objectAtIndex:[sender tag]];
    
    self.memberListArray=[self searchByLocation:countryobj.countryId :@"mCountryId"];
    
    [self addMemberContentOnScrollView:self.memberListArray];

}
-(IBAction)MemberAll_Clicked:(UIButton*)sender
{
    memberCatalogSearchResultLable.hidden=YES;
    self.memberListArray=[NSArray array];
    
    [self.memberCatalogAllButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [memberCatalogByLocationButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogLocationDetailButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [memberCatalogByIndustryButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
   
    [self fadeView:memberCatalogScrollView fadein:YES timeAnimation:0.3];
    
    [self cleareScrollViewContent];

//    self.memberListArray=[[CoreDataOprations initObject]fetchRequestAccordingtoFounderCategory:@"Memebers" :@"mId" :@"mFounder" :[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]]:self.managedObjectContext];
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestAccordingtoFounderCategoryForEntity:@"Memebers" withSortDesc:@"mLastName" withCategoryName:@"mFounder" withCategoryVal:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]] andManagedBoj:self.managedObjectContext];
;
    
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
{    memberCatalogSearchResultLable.hidden=YES;

    
    if (searchCheckFlage) {
        
    }
    else {
    
    if (!memberCatalogLocationDetailButton.hidden) {
       
        searchCheckFlage=TRUE;
    }
    else {
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
        memberCatalogSearchTextField.hidden=TRUE;
        memberCatalogSearchTextFieldImageView.hidden=TRUE;
        memberCatalogSearchTextField.text=@"";
        [memberCatalogSearchTextField resignFirstResponder];
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        
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
            
            [self.memberCatalogAllButton setFrame:CGRectMake(29,74.0,30.0,20.0)];
            
            memberCatalogByIndustryButton.frame=CGRectMake(261,74,71,20);
            
            memberCatalogByLocationButton.frame=CGRectMake(126,74,70,20);
            
        }
        
//        self.memberListArray=[[CoreDataOprations initObject]fetchRequestAccordingtoFounderCategory:@"Memebers" :@"mId" :@"mFounder" :[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]]:self.managedObjectContext];
        self.memberListArray = [[CoreDataOprations initObject] fetchRequestAccordingtoFounderCategoryForEntity:@"Memebers" withSortDesc:@"mLastName" withCategoryName:@"mFounder" withCategoryVal:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:FALSE]] andManagedBoj:self.managedObjectContext];

        
        [self addMemberContentOnScrollView:self.memberListArray];
    }
}


-(IBAction)MemberSearchTextField_ValueChanged:(id)sender
{
    memberCatalogAllButton.hidden=YES;
    memberCatalogByLocationButton.hidden=YES;
    memberCatalogByIndustryButton.hidden=YES;
    memberCatalogLocationDetailButton.hidden=YES;
    memberCatalogSearchTextLable.hidden=NO;
    memberCatalogSearchTextLable.text=[NSString stringWithFormat:@"Results of ''%@''",memberCatalogSearchTextField.text];
 
//    self.memberListArray = [[CoreDataOprations initObject]fetchRequestSearch:@"Memebers" :@"mId" :@"mName" :memberCatalogSearchTextField.text :self.managedObjectContext];
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mName" withSearchVal:memberCatalogSearchTextField.text andWithManagedObj:self.managedObjectContext];

    
    [self cleareScrollViewContent];

    if ([self.memberListArray count]==0) {
        
        memberCatalogSearchResultLable.hidden=NO;
    }
    else {
        
        memberCatalogSearchResultLable.hidden=YES;

    }
    
    if ([self.memberListArray count]%5 == 0)
    {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*([self.memberListArray count]/5)/5, 592);
        
        memberCatalogPageControl.numberOfPages=([self.memberListArray count]/5)/5;

    }
    
    else
    {
       
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*((([self.memberListArray count]/5)/5)+1), 592);
        
        memberCatalogPageControl.numberOfPages=((([self.memberListArray count]/5)/5)+1);

    }

    int x=0;
    
    if ([self.memberListArray count]%5==0)
    {
        x=[self.memberListArray count]/5;
    }
    else
    {
        x=([self.memberListArray count]/5)+1;
    }

    [self addSearchResultOnScrollView:5 :x :self.memberListArray];

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
    
    [self cleareScrollViewContent];
    
    if ([self.memberListArray count]==0) {
        
        memberCatalogSearchResultLable.hidden=NO;
    }
    else {
        
        memberCatalogSearchResultLable.hidden=YES;
        
    }

        
    if (([self.memberListArray count]/11)%5 == 0) {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*([self.memberListArray count]/11)/5, 592);
        
        memberCatalogPageControl.numberOfPages=([self.memberListArray count]/11)/5;
        
    }
    
    else {
        
        self.memberCatalogScrollView.contentSize=CGSizeMake(1024*((([self.memberListArray count]/11)/5)+1), 592);
        
        memberCatalogPageControl.numberOfPages=((([self.memberListArray count]/11)/5)+1);
        
    }
    
    int x=0;
    
    if ([self.memberListArray count]%11==0)
    {
        x=[self.memberListArray count]/11;
    }
    else
    {
        x=([self.memberListArray count]/11)+1;
    }
    
    [self addSearchResultOnScrollView:11 :x :self.memberListArray];

}

-(void)memberCatalogListButtonAction:(id)sender
{
    [memberCatalogSearchTextField resignFirstResponder];
    int selectIndex=[sender tag];
    
//    NSLog(@"tag=%d",[sender tag]);
    
    if (memberBioViewListObj) {
        
        memberBioViewListObj=nil;
        [memberBioViewListObj removeFromSuperview];
    }
        memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
       memberBioViewListObj.memberBioViewListScrollView.frame=CGRectMake(0, 54, 1024, 694);
      [memberBioViewListObj setDelegate:self];
      memberBioViewListObj.publicBackButton.hidden=FALSE;
      memberBioViewListObj.publicBarImageView.hidden=FALSE;
    
    for (UIView *subview in memberBioViewListObj.memberBioViewListScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }

    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 54, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 54, 1024, 748)];
    
    MemberBioViewObj1.Status=YES;
    MemberBioViewObj2.Status=YES;
    
    MemberBioViewObj1.arraySave=self.memberListArray;
    MemberBioViewObj2.arraySave=self.memberListArray;

    MemberBioViewObj1.galleryLabel.hidden=TRUE;
    MemberBioViewObj2.galleryLabel.hidden=TRUE;

    MemberBioViewObj1.closeButton.hidden=TRUE;
    MemberBioViewObj2.closeButton.hidden=TRUE;
    
    MemberBioViewObj1.galleryPhotoScrollView.hidden=YES;
    MemberBioViewObj2.galleryPhotoScrollView.hidden=YES;

    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj1 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];
    [MemberBioViewObj1 setIsFromPublicView:TRUE];

    int widthCount=[self.memberListArray count];    
    
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj2 setSelectorScrolling:@selector(scrollingEnable:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];
    [MemberBioViewObj2 setIsFromPublicView:TRUE];

    
    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
    memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
    
    
    [memberBioViewListObj applyNewIndex:selectIndex totalCount:widthCount  pageController:MemberBioViewObj1];
    
    memberBioViewListObj.pageCount=[self.memberListArray count]-1;
    
    memberBioViewListObj.currentPage=MemberBioViewObj1;
    memberBioViewListObj.nextPage=MemberBioViewObj2;

    if ([sender tag]+1 <[self.memberListArray count]) {
        
        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex+1 totalCount:widthCount pageController:MemberBioViewObj2];
        
    }
    else if ([sender tag]-1 >=0)
    {
        
        [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
        
        [memberBioViewListObj applyNewIndex:selectIndex-1 totalCount:widthCount pageController:MemberBioViewObj2];
        
    }

    CGRect frame = memberBioViewListObj.memberBioViewListScrollView.frame;
    frame.origin.x = frame.size.width *selectIndex;
    frame.origin.y = 0;
    //
    [memberBioViewListObj.memberBioViewListScrollView scrollRectToVisible:frame animated:NO];

    [self addSubview:memberBioViewListObj];
    
    [self fadeView:memberBioViewListObj fadein:YES timeAnimation:0.3];

}




-(void)memberCatalogSearchListButtonAction:(id)sender
{
    
    if (memberBioViewListObj) {
        memberBioViewListObj=nil;
        [memberBioViewListObj removeFromSuperview];
    }
        memberBioViewListObj=[[MemberBioViewList alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
        
    
    [memberBioViewListObj setDelegate:self];
    
    int widthCount=5;
    
    MemberBioView *MemberBioViewObj1=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    MemberBioView *MemberBioViewObj2=[[MemberBioView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    MemberBioViewObj1.closeButton.hidden=FALSE;
    MemberBioViewObj2.closeButton.hidden=FALSE;
    
    MemberBioViewObj1.delegate=memberBioViewListObj;
    [MemberBioViewObj1 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj1 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj1 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj1 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    
    MemberBioViewObj2.delegate=memberBioViewListObj;
    [MemberBioViewObj2 setSelectorLeftArrowAction:@selector(leftArrowAction:)];
    [MemberBioViewObj2 setSelectorRightArrowAction:@selector(rightArrowAction:)];
    [MemberBioViewObj2 setSelectorCloseAction:@selector(closeAction:)];
    [MemberBioViewObj2 setSelectorEmailAction:@selector(emailAction:)];     //Added By Umesh
    
    memberBioViewListObj.currentPage=MemberBioViewObj1;
    memberBioViewListObj.nextPage=MemberBioViewObj2;
    
    memberBioViewListObj.memberBioViewListScrollView.contentSize =CGSizeMake(
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.width * widthCount,
                                                                             memberBioViewListObj.memberBioViewListScrollView.frame.size.height);
	
    memberBioViewListObj.memberBioViewListScrollView.contentOffset = CGPointMake(0, 0);
    
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj1];
    
    [memberBioViewListObj.memberBioViewListScrollView addSubview:MemberBioViewObj2];
    
    [memberBioViewListObj applyNewIndex:0 totalCount:widthCount pageController:MemberBioViewObj1];
    [memberBioViewListObj applyNewIndex:1 totalCount:widthCount pageController:MemberBioViewObj2];
    [self addSubview:memberBioViewListObj];
    [self fadeView:memberBioViewListObj fadein:YES timeAnimation:0.3];
    
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
    if ([memberArray count]%55==0)
    {
        y=[memberArray count]/55;
    }
    else
    {
        y=([memberArray count]/55)+1;
    }

    self.memberCatalogScrollView.contentSize=CGSizeMake(1024*y, 592);
    
    memberCatalogPageControl.numberOfPages=y;
    int x=0;
    
    if ([memberArray count]%11==0)
    {
        x=[memberArray count]/11;
    }
    else
    {
        x=([memberArray count]/11)+1;
    }
    int index=0;

    for (int j=0; j<x; j++) {

        for (int i=0; i<11; i++) {
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(205*j+29,55*i,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
            customeImageView.image=[UIImage imageNamed:@"henry_agee_pic_frame.png"];
            customeImageView.contentMode = UIViewContentModeScaleAspectFit;
            
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
                
                label.text=[NSString stringWithFormat:@"%@ %@", memObj.mName,memObj.mLastName];;

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
    self.continentArray=[[CoreDataOprations initObject] fetchRequest:@"Contitent" :@"contitentId" :self.managedObjectContext];
    //    countryArray=[[CoreDataOprations initObject] fetchRequest:@"Country" :@"countryId" :self.managedObjectContext];
    countryArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Country" withSortDecs:@"countryName" forManagedObj:self.managedObjectContext];
    //    stateArray=[[CoreDataOprations initObject] fetchRequest:@"State" :@"stateId" :self.managedObjectContext];
    stateArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"State" withSortDecs:@"stateName" forManagedObj:self.managedObjectContext];

    int index=0;
    
    int xPos=80;
    
    int yPos=0;

    for (int i=0; i<[self.continentArray count]; i++)
    {
       
        Contitent *contitentobj=[self.continentArray objectAtIndex:i];
        
        if (i>0) {
            
            xPos=xPos+205;
        }
        
        UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        continentButton.frame=CGRectMake(xPos,0,110,25);
        
        [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
        [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [continentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [continentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [continentButton setTitle:contitentobj.contitentName forState:UIControlStateNormal];
        [continentButton setBackgroundColor:[UIColor clearColor]];
        continentButton.tag=i;
        [continentButton addTarget:self action:@selector(continentlocation_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.memberCatalogScrollView addSubview:continentButton];
        
        yPos=60;    //70

        
    for (int j=0; j<[self.countryArray count]; j++)
    {
        
        Country *countryobj=[self.countryArray objectAtIndex:j];
        
    
           if ([countryobj.contitentId isEqualToString:contitentobj.contitentId])
           {               
               if (yPos>=480) {         
                   
                   xPos=xPos+205;
                   
                   yPos=0;
               }
               else if (yPos>60)
               {
                   yPos=yPos+25;            //+45
               }
               
               UIButton *countryButton=[UIButton buttonWithType:UIButtonTypeCustom];
               countryButton.frame=CGRectMake(xPos,yPos,110,25);
               [countryButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
               [countryButton setTitleColor:kGrayColor forState:UIControlStateNormal];
               [countryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
               [countryButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
               [countryButton setTitle:countryobj.countryName forState:UIControlStateNormal];
               countryButton.tag=j;
               [countryButton addTarget:self action:@selector(countrylocation_Clicked:) forControlEvents:UIControlEventTouchUpInside];
               [countryButton setBackgroundColor:[UIColor clearColor]];
               
               [self.memberCatalogScrollView addSubview:countryButton];
               
               yPos = yPos+17.5+25;
               
    for (int k=0;k<[self.stateArray count]; k++)
    {
        State *stateobj=[self.stateArray objectAtIndex:k];
                
        if ([stateobj.countryId isEqualToString:countryobj.countryId])
        {
        
            index=index+1;
            
            UIButton *cityButton=[UIButton buttonWithType:UIButtonTypeCustom];
            cityButton.frame=CGRectMake(xPos,yPos,110,25);
            [cityButton.titleLabel setFont:[UIFont fontWithName:FontRegular size:14]];
            [cityButton setTitleColor:kGrayColor forState:UIControlStateNormal];
            [cityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [cityButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            cityButton.tag=k;
            [cityButton setTitle:stateobj.stateName forState:UIControlStateNormal];
            [cityButton addTarget:self action:@selector(statelocation_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cityButton setBackgroundColor:[UIColor clearColor]];
            [self.memberCatalogScrollView addSubview:cityButton];
            
            if (yPos>=500) {
                
                xPos=xPos+205;
                
                yPos=0;
            }
            
            else {
                
                yPos=yPos+17.5+25;
                
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
        memberCatalogScrollView.contentSize=CGSizeMake(1024*numberofPages,592);
        
    }
    else {
        
        numberofPages=(scrollviewwidth/1024);
        
        memberCatalogPageControl.numberOfPages=numberofPages;
        memberCatalogScrollView.contentSize=CGSizeMake(numberofPages,592);
        
    }

//    self.memberCatalogScrollView.contentSize=CGSizeMake(xPos+110,592);
//    
//    CGSize size=self.memberCatalogScrollView.contentSize;
//
//    int pagecount=floorf(size.width/1024);
//
//    memberCatalogPageControl.numberOfPages=pagecount+1;

}
-(void)addSearchResultOnScrollView:(int)rowCount:(int)columnCount:(NSArray*)searchContentArray;
{
    int index=0;
    
    for (int j=0; j<columnCount; j++) {
        
        for (int i=0; i<rowCount; i++) {
            
            index=index+1;
            
            UIImageView*customeImageView=[[UIImageView alloc]init];
            customeImageView.frame=CGRectMake(205*j+29,55*i,42,42);
            customeImageView.backgroundColor=[UIColor darkTextColor];
            customeImageView.image=[UIImage imageNamed:@"henry_agee_pic_frame.png"];
            customeImageView.contentMode = UIViewContentModeScaleAspectFit;
            
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
            
            int index=0;
            index=(0*25)+i+j*5;
            
            if (index>=[searchContentArray count])
            {
                
            }
            
            else {
                
                Memebers *memObj=[searchContentArray objectAtIndex:index];
                memberButton.tag=index;
                
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memObj.mThumbImage];
                
                if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                    customeImageView.image=[UIImage imageWithContentsOfFile:imageNameWithPath];
                }
                else if ([UIImage imageNamed:memObj.mThumbImage]){
                    customeImageView.image=[UIImage imageNamed:memObj.mThumbImage];
                    
                }
                else{
                    customeImageView.image=[UIImage imageNamed:@"henry_agee_pic_frame.png"];;
                }

                label.text=[NSString stringWithFormat:@"%@ %@", memObj.mName,memObj.mLastName];
                
                
                [self.memberCatalogScrollView addSubview:customeImageView];
                [self.memberCatalogScrollView addSubview:label];
                [self.memberCatalogScrollView addSubview:memberButton];

            }
            
        }
    }

}

-(IBAction)MemberBack_Clicked:(id)sender
{
    if ([delegate respondsToSelector:selectorBackAction]) {
        [delegate performSelector:selectorBackAction withObject:@"back" afterDelay:0.0];
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

-(void)addLocationContentOnDatabase:(NSDictionary*)responseDictionary
{
    
    /*
     
     NSMutableArray *arraycont=[[NSMutableArray alloc]initWithObjects:@"United States",@"Europ",nil];
     
     
     NSMutableArray *arraystate1=[[NSMutableArray alloc]initWithObjects:@"Arizona",@"California",@"Illinois",@"New York",@"Michigan",@"Arizona",@"California",@"Illinois",@"New York",@"Michigan",nil];
     
     
     NSMutableDictionary *dictionaryCity1=[[NSMutableDictionary alloc]init];
     
     [dictionaryCity1 setObject:@"Phoenix" forKey:@"Arizona0"];
     
     NSMutableDictionary *dictionaryCity2=[[NSMutableDictionary alloc]init];
     
     [dictionaryCity2 setObject:@"Los Angeles" forKey:@"California0"];
     [dictionaryCity2 setObject:@"San Francisco" forKey:@"California1"];
     [dictionaryCity2 setObject:@"San Diego" forKey:@"California2"];
     
     NSMutableDictionary *dictionaryCity3=[[NSMutableDictionary alloc]init];
     
     [dictionaryCity3 setObject:@"Chicago" forKey:@"Illinois0"];
     
     NSMutableDictionary *dictionaryCity4=[[NSMutableDictionary alloc]init];
     
     [dictionaryCity4 setObject:@"Buffalo" forKey:@"New York0"];
     
     NSMutableDictionary *dictionaryCity5=[[NSMutableDictionary alloc]init];
     
     [dictionaryCity5 setObject:@"New York City" forKey:@"Michigan0"];
     [dictionaryCity5 setObject:@"Detroit" forKey:@"Michigan1"];
     
     
     NSMutableArray *arraystate2=[[NSMutableArray alloc]initWithObjects:dictionaryCity1,dictionaryCity2,dictionaryCity3,dictionaryCity4,dictionaryCity5,dictionaryCity1,dictionaryCity2,dictionaryCity3,dictionaryCity4,dictionaryCity5,nil];
     
     */
    
    
  //  self.managedObjectContext=appDelegate.managedObjectContext;
    
    NSError *error=nil;
    
//    for (int i=0; i<7; i++) {
//       
//        membersObj= [NSEntityDescription
//                     insertNewObjectForEntityForName:@"Memebers"
//                     inManagedObjectContext:self.managedObjectContext];
//        
//        // NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
//        [membersObj setValue:[arrayId objectAtIndex:i] forKey:@"mId"];
//        [membersObj setValue:[dummyArray objectAtIndex:i] forKey:@"mName"];
//        
//        [membersObj setValue:[arrayComapanyName objectAtIndex:i] forKey:@"mCompanyName"];
//        
//        [membersObj setValue:[arrayaddress objectAtIndex:i] forKey:@"mAddress"];
//        
//        [membersObj setValue:[arrayDescription objectAtIndex:i] forKey:@"mDescription"];
//        
//        [membersObj setValue:[arrayContinentid objectAtIndex:i] forKey:@"mContinentId"];
//        
//        [membersObj setValue:[arrayCountryid objectAtIndex:i] forKey:@"mCountryId"];
//        
//        [membersObj setValue:[arrayStatesid objectAtIndex:i] forKey:@"mStateId"];
//        [membersObj setValue:[arrayProfession objectAtIndex:i] forKey:@"mProfession"];
//        
//        //    [membersObj setValue:@"" forKey:@"mGallery"];
//        
//        if (![self.managedObjectContext save:&error]) {
//            
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }

    
//    self.memberCatalogScrollView.contentSize=CGSizeMake(1024,592);
//    
//    memberCatalogPageControl.numberOfPages=1;
    
    
    int index=0;
    
    int xPos=80;
    
    int yPos=0;
    
    
//    NSString *Period1String = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"Json" ofType: @"txt"] usedEncoding:nil error:nil];
//    NSData *data = [Period1String dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseDictionary= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *contitentArray1=[responseDictionary objectForKey:@"Continents"];
    
    for (int i=0; i<[contitentArray1 count]; i++)
    {
        
        contitentObj= [NSEntityDescription
                     insertNewObjectForEntityForName:@"Contitent"
                     inManagedObjectContext:self.managedObjectContext];

        
        NSDictionary *contitentDictionary=[contitentArray1 objectAtIndex:i];
        NSString *contitentId=[contitentDictionary objectForKey:@"ContinentID"];
        NSString *contitentName=[contitentDictionary objectForKey:@"Name"];
        NSArray *countryArray1=[responseDictionary objectForKey:@"Country"];
        
        
        if (i>0) {
            
            xPos=xPos+205;
        }
        
        UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        continentButton.frame=CGRectMake(xPos,0,110,25);
        
        [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
        [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [continentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [continentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [continentButton setTitle:contitentName forState:UIControlStateNormal];
        [continentButton setBackgroundColor:[UIColor clearColor]];
        [continentButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
      //  [self.memberCatalogScrollView addSubview:continentButton];
        
        [contitentObj setValue:contitentId forKey:@"contitentId"];
        [contitentObj setValue:contitentName forKey:@"contitentName"];

        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        
        yPos=70;
        
        
        for (int j=0; j<[countryArray1 count]; j++)
        {
            
            NSDictionary *countryDictionary=[countryArray1 objectAtIndex:j];
            
            if ([[countryDictionary objectForKey:@"ContinentID"]isEqualToString:contitentId])
            {
                
                countryObj= [NSEntityDescription
                               insertNewObjectForEntityForName:@"Country"
                               inManagedObjectContext:self.managedObjectContext];

                
//                NSLog(@"state:%@",countryDictionary);
                NSString *countryId=[countryDictionary objectForKey:@"CountryID"];
                NSArray *stateArray1=[responseDictionary objectForKey:@"State"];
                
                //
                
                if (yPos>=480) {
                    
                    xPos=xPos+205;
                    
                    yPos=0;
                }
                else if (yPos>70)
                {
                    yPos=yPos+45;
                }
                
                UIButton *countryButton=[UIButton buttonWithType:UIButtonTypeCustom];
                countryButton.frame=CGRectMake(xPos,yPos,110,25);
                [countryButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
                [countryButton setTitleColor:kGrayColor forState:UIControlStateNormal];
                [countryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [countryButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                
                [countryButton setTitle:[countryDictionary objectForKey:@"Name"] forState:UIControlStateNormal];
                [countryButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
                [countryButton setBackgroundColor:[UIColor clearColor]];
                
            //    [self.memberCatalogScrollView addSubview:countryButton];
                
                yPos = yPos+17.5+25;
                
                [countryObj setValue:contitentId forKey:@"contitentId"];
                [countryObj setValue:[countryDictionary objectForKey:@"Name"] forKey:@"countryName"];
                [countryObj setValue:[countryDictionary objectForKey:@"CountryID"] forKey:@"countryId"];

                if (![self.managedObjectContext save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

                
                for (int k=0;k<[stateArray1 count]; k++)
                {
                    NSDictionary *stateDictionary=[stateArray1 objectAtIndex:k];
                    
                    if ([[stateDictionary objectForKey:@"CountryID"]isEqualToString:countryId])
                    {
                        
                        stateObj= [NSEntityDescription
                                     insertNewObjectForEntityForName:@"State"
                                     inManagedObjectContext:self.managedObjectContext];

                        
                        index=index+1;
                        
                        UIButton *cityButton=[UIButton buttonWithType:UIButtonTypeCustom];
                        cityButton.frame=CGRectMake(xPos,yPos,110,25);
                        [cityButton.titleLabel setFont:[UIFont fontWithName:FontRegular size:14]];
                        [cityButton setTitleColor:kGrayColor forState:UIControlStateNormal];
                        [cityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                        [cityButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
                        
                        [cityButton setTitle:[stateDictionary objectForKey:@"Name"] forState:UIControlStateNormal];
                        [cityButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
                        [cityButton setBackgroundColor:[UIColor clearColor]];
                    //    [self.memberCatalogScrollView addSubview:cityButton];
                        
                        [stateObj setValue:contitentId forKey:@"contitentId"];
                        [stateObj setValue:[stateDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
                        [stateObj setValue:[stateDictionary objectForKey:@"StateID"] forKey:@"stateId"];
                        [stateObj setValue:[stateDictionary objectForKey:@"Name"] forKey:@"stateName"];

                        if (![self.managedObjectContext save:&error]) {
                            
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }

                        
                        if (yPos>=500) {
                            
                            xPos=xPos+205;
                            
                            yPos=0;
                        }
                        
                        else {
                            
                            yPos=yPos+17.5+25;
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            
        }
        
    }

/*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"State"
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //  [fetchRequest setFetchLimit:20];
    
    NSArray *array = [self.managedObjectContext
                            executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([array count] == 0)
    {
        NSLog(@"empty");
    }

    State *stateobj=[array objectAtIndex:0];
    
    NSLog(@"stateObj.stateName =%@  =%d",stateobj.stateName,[array count]);
*/
    /*
     
     for (int j=0; j<[arraycont count]; j++) {
     
     if (j>0) {
     
     xPos=xPos+205;
     }
     
     UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
     
     continentButton.frame=CGRectMake(xPos,0,110,25);
     
     [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
     [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
     [continentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [continentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
     [continentButton setTitle:[arraycont objectAtIndex:j] forState:UIControlStateNormal];
     [continentButton setBackgroundColor:[UIColor clearColor]];
     [continentButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
     
     [self.memberCatalogScrollView addSubview:continentButton];
     
     yPos=70;
     
     for (int k=0; k<[arraystate1 count]; k++) {
     
     if (yPos>=480) {
     
     xPos=xPos+205;
     
     yPos=0;
     }
     else if (k>0)
     {
     yPos=yPos+45;
     }
     
     UIButton *countryButton=[UIButton buttonWithType:UIButtonTypeCustom];
     countryButton.frame=CGRectMake(xPos,yPos,110,25);
     [countryButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
     [countryButton setTitleColor:kGrayColor forState:UIControlStateNormal];
     [countryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [countryButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
     
     [countryButton setTitle:[arraystate1 objectAtIndex:k] forState:UIControlStateNormal];
     [countryButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
     [countryButton setBackgroundColor:[UIColor clearColor]];
     
     [self.memberCatalogScrollView addSubview:countryButton];
     
     yPos = yPos+17.5+25;
     
     for (int i=0; i<[[arraystate2 objectAtIndex:k] count];i++) {
     
     index=index+1;
     
     UIButton *cityButton=[UIButton buttonWithType:UIButtonTypeCustom];
     cityButton.frame=CGRectMake(xPos,yPos,110,25);
     [cityButton.titleLabel setFont:[UIFont fontWithName:FontRegular size:14]];
     [cityButton setTitleColor:kGrayColor forState:UIControlStateNormal];
     [cityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [cityButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
     
     [cityButton setTitle:[[arraystate2 objectAtIndex:k] valueForKey:[NSString stringWithFormat:@"%@%d",[arraystate1 objectAtIndex:k],i]] forState:UIControlStateNormal];
     [cityButton addTarget:self action:@selector(location_Clicked:) forControlEvents:UIControlEventTouchUpInside];
     [cityButton setBackgroundColor:[UIColor clearColor]];
     [self.memberCatalogScrollView addSubview:cityButton];
     
     if (yPos>=500) {
     
     xPos=xPos+205;
     
     yPos=0;
     }
     
     else {
     
     yPos=yPos+17.5+25;
     
     }
     
     }
     
     }
     
     }
     
     */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)addMemberProfessionContentOnScrollView
{
   // self.memberCatalogScrollView.contentSize=CGSizeMake(1024,317);
    
    memberCatalogPageControl.numberOfPages=1;
    
    memberCatalogScrollView.contentSize=CGSizeMake(1024, 592);
    
//    self.professionArray=[[CoreDataOprations initObject]fetchRequest:@"Profession":@"professionId":self.managedObjectContext];
    self.professionArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Profession" withSortDecs:@"professionId" forManagedObj:self.managedObjectContext];
    
    [self getProfessionList];
//   NSLog(@"self.professionArray count %d",[professionArrayFixed count]);
//    NSArray *arrayOfProfession=[[NSArray alloc]initWithObjects:@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media",@"Architec",@"Interior Designer",@"Landscape Architech",@"Executive",@"Media", nil];
    
    int xPos=80;
    
    int yPos=0;
    
    for (int j=0; j<[professionArrayFixed count]; j++) {
        
        if (j%12==0 && j>0)
        {
            xPos=xPos+215;
            
            yPos=0;
        }
        
        UIButton *continentButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        continentButton.frame=CGRectMake(xPos,yPos,150,25);
        
        [continentButton.titleLabel setFont:[UIFont fontWithName:FontSemibd size:14]];
        [continentButton setTitleColor:kGrayColor forState:UIControlStateNormal];
      
//        Profession *professionObj=[self.professionArray objectAtIndex:j];
        NSDictionary *profDict = [professionArrayFixed objectAtIndex:j];
        
//        NSLog(@"professionObj.professionName %@",[profDict valueForKey:kProfessionName]);
        
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
    
    float wid=(size.width)+126.0+64.0;
    float wid1=(size.width)+29.0+64.0;
    float wid2=(size.width)+261.0+64.0;
    
    memberCatalogLocationDetailButton.frame=CGRectMake(29,74,size.width,20);
    
    [self.memberCatalogAllButton setFrame:CGRectMake(wid1,74.0,30.0,20.0)];
    
    memberCatalogByIndustryButton.frame=CGRectMake(wid2,74,71,20);
    
    memberCatalogByLocationButton.frame=CGRectMake(wid,74,70,20);
    
    [self getProfessionList];
    NSDictionary *profDict = [professionArrayFixed objectAtIndex:[sender tag]];
    
//    self.memberListArray=[[CoreDataOprations initObject] fetchRequest:@"Memebers" :@"mId" :self.managedObjectContext];
//    self.memberListArray = [[CoreDataOprations initObject] fetchRequestForEntity:@"Memebers" withSortDecs:@"mLastName" forManagedObj:self.managedObjectContext];
    self.memberListArray = [[CoreDataOprations initObject] fetchRequestSearchForEntity:@"Memebers" withSortDesc:@"mLastName" forAttribute:@"mProfessionId" withSearchVal:[profDict valueForKey:kProfessionID] andWithManagedObj:self.managedObjectContext];
    
    [self addMemberContentOnScrollView:self.memberListArray];
}

-(NSArray*)fetchREquest:(NSString*)Entity
{
    NSError *error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:Entity
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //  [fetchRequest setFetchLimit:20];
    
    NSArray *array = [self.managedObjectContext
                      executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }

    return array;
}

-(NSArray*)searchByLocation:(NSString*)attributeValue :(NSString*)attributeName
{
    NSError *error=nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",attributeName,attributeValue]; // dateInt is a unix time stamp for the current
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Memebers"
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mLastName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *array = [self.managedObjectContext
                            executeFetchRequest:fetchRequest error:&error];

    if (!array) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }

    return array;
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

@end
