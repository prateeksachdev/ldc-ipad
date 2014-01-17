//
//  LDCFavoritesView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 04/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "LDCFavoritesView.h"
#import "Constants.h"
#import "CoreDataOprations.h"
#import "FavCategory.h"
#import "Favorites.h"
#import "AppDelegate.h"
#import "FavoriteView.h"
#import "InAppBrowser.h"

@implementation LDCFavoritesView
@synthesize lDCFavoritesViewScrollView,arrayOfCategory,delegate,selectorFavSearch,selectorFavDetail;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"LDCFavoritesView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
        
        allButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [allButton setTitleColor:kGrayColor forState:UIControlStateNormal];
      
        toDOButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

        toEatButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

        toSeeButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

        toReadButton.titleLabel.font=[UIFont fontWithName:FontBold size:10];
        
        [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];

        
        
        [lDCFavoritesViewSearchTextField setTextColor:kGrayColor];
        
        [lDCFavoritesViewSearchTextLable setFont:[UIFont fontWithName:FontRegular size:15]];
        
        [lDCFavoritesViewSearchTextLable setTextColor:kGrayColor];
        
        [lDCFavoritesViewSearchResultLable setFont:[UIFont fontWithName:FontRegular size:15]];
        
        [lDCFavoritesViewSearchResultLable setTextColor:kGrayColor];
        
        [lDCFavoritesViewSearchResultLable setText:@"No search results"];
        
        
        dummyArray=[[NSMutableArray alloc]initWithObjects:@"Stone Barns LeadershipWorkshop",@"Miami Meet and Greet Weekend",@"Berlin Leasership Conforence",@"Post Conforence US Recap",@"James Aztek",@"Trish Alberez",@"Kim Alanis", nil];

        appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
        arrayOfCategory=[[CoreDataOprations initObject] fetchRequest:@"FavCategory" :@"categoryId" :appDelegate.managedObjectContext];
        
        [self addFavoritesContentOnScrollView:arrayOfCategory];
        
//        [self addFavoritesContentOnScrollView:[[CoreDataOprations initObject]fetchRequestAccordingtoCategory:@"Favorites" :@"favoriteId" :@"catagoryName" :@"ALL" :appDelegate.managedObjectContext]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)categoryToDoAction:(id)sender
{
    
    [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toDOButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    [self addFavoritesContentOnScrollViewCategoryClicked:arrayOfCategory :sender];
}

-(IBAction)categoryToSeeAction:(id)sender
{
    
    [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toSeeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    [self addFavoritesContentOnScrollViewCategoryClicked:arrayOfCategory :sender];

}

-(IBAction)categoryToReadAction:(id)sender
{
    [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toReadButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    [self addFavoritesContentOnScrollViewCategoryClicked:arrayOfCategory :sender];

}

-(IBAction)categoryToEatAction:(id)sender
{
    [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toEatButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    [self addFavoritesContentOnScrollViewCategoryClicked:arrayOfCategory :sender];

}

-(IBAction)categoryAllAction:(id)sender
{
    [allButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [self cleareScrollViewContent];
    [self addFavoritesContentOnScrollView:arrayOfCategory];

}

-(IBAction)favSearchAction:(id)sender
{
    if ([(UIButton*)sender currentImage]==[UIImage imageNamed:@"search.png"])
    {
        lDCFavoritesViewSearchTextField.hidden=FALSE;
        lDCFavoritesViewSearchTextFieldImageView.hidden=FALSE;
        
        [lDCFavoritesViewSearchTextField becomeFirstResponder];
        
        lDCFavoritesViewSearchTextField.text=@"";
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"cancel-1.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        lDCFavoritesViewSearchTextField.hidden=TRUE;
        lDCFavoritesViewSearchTextFieldImageView.hidden=TRUE;
        
        allButton.hidden=NO;
        toDOButton.hidden=NO;
        toEatButton.hidden=NO;
        toSeeButton.hidden=NO;
        toReadButton.hidden=NO;
       
        lDCFavoritesViewSearchTextLable.hidden=YES;
        lDCFavoritesViewSearchResultLable.hidden=YES;
        [lDCFavoritesViewSearchTextField resignFirstResponder];
        
        [(UIButton*)sender setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        
        [allButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [toDOButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [toEatButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [toSeeButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [toReadButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [self cleareScrollViewContent];
        
        [self addFavoritesContentOnScrollView:arrayOfCategory];
        
    }
}

-(void)addFavoritesContentOnScrollView:(NSArray*)memberArray
{    
    int value=0;

    int scrollviewwidth=0;
    
    for (int k=0; k<[memberArray count]; k++) {

        int index=0;
      
        int list=0;

        FavCategory *favCategory=[memberArray objectAtIndex:k];
      
        NSArray *favListArray=[[CoreDataOprations initObject]fetchRequestAccordingtoCategory:@"Favorites":@"favoriteId":@"categoryId":favCategory.categoryId :appDelegate.managedObjectContext];

        if ([favListArray count]!=0) {
            
        UILabel* label12=[[UILabel alloc]init];
        label12.frame=CGRectMake(341*value+52+29,0,110,18);
        label12.numberOfLines=3;
        label12.font=[UIFont fontWithName:FontBold size:10];
        label12.textColor=kSkyBlueColor;
        label12.backgroundColor=[UIColor clearColor];
       
        label12.text=favCategory.categoryName;
        
        [lDCFavoritesViewScrollView addSubview:label12];

        
        if ([favListArray count]%3==0) {
            
            list=[favListArray count]/3;
        }
        
        else {
            
            list=[favListArray count]/3+1;
        }
        
        }
        
    for (int j=0; j<list; j++) {
                
        for (int i=0; i<3; i++) {

            
            if (index>=[favListArray count])
            {
                
                break;
            }
            else
            {
                Favorites *favorites=[favListArray objectAtIndex:index];

                FavoriteView *favoriteViewObj=[[FavoriteView alloc]initWithFrame:CGRectMake(341*value+29,90*i+33,266,72)];
                favoriteViewObj.delegate=self;
                [favoriteViewObj setSelectorButtonAction:@selector(favListButtonAction:)];
                
                favoriteViewObj.tittleLable.numberOfLines=2;
                favoriteViewObj.tittleLable.font=[UIFont fontWithName:FontLight size:20];
                favoriteViewObj.tittleLable.textColor=kGrayColor;
                favoriteViewObj.tittleLable.text=favorites.favdescription;
               
                favoriteViewObj.subTittleLable.numberOfLines=2;
                favoriteViewObj.subTittleLable.font=[UIFont fontWithName:FontLight size:10];
                favoriteViewObj.subTittleLable.textColor=kGrayColor;
                favoriteViewObj.subTittleLable.text=favorites.favSubTitle;
                
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",favorites.favThumbImage];
                
                if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                    favoriteViewObj.thumbImageView.image = [UIImage imageWithContentsOfFile:imageNameWithPath];
                }
                else if([UIImage imageNamed:favorites.favThumbImage]){
                    favoriteViewObj.thumbImageView.image = [UIImage imageNamed:favorites.favThumbImage];
                }
                else{
                   favoriteViewObj.thumbImageView.image = [UIImage imageNamed:@"thumb-background.png"];
                }
                
                favoriteViewObj.urlString=favorites.url;
                favoriteViewObj.titleString=favorites.favdescription;
                
                [favoriteViewObj setlabelHieght];
                index=index+1;
                                
            [lDCFavoritesViewScrollView addSubview:favoriteViewObj];
                
                scrollviewwidth=341*value+52+29+211;
            }
        }
        value++;
    }
   
    }
    
    int numberofPages=0;
    
    if (scrollviewwidth%1024!=0) {
        
         numberofPages=(scrollviewwidth/1024)+1;
        
        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(1024*numberofPages,317);

    }
    else {
        
        numberofPages=(scrollviewwidth/1024);

        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(numberofPages,317);

    }
   
    lDCFavoritesViewSearchResultLable.hidden=TRUE;

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
-(void)addFavoritesContentOnScrollViewCategoryClicked:(NSArray*)memberArray:(UIButton *)sender
{
    int value=0;
    int scrollviewwidth=0;

    for (int k=0; k<[memberArray count]; k++) {
        
        int index=0;
        int list=0;
        
        FavCategory *favCategory=[memberArray objectAtIndex:k];
        
        if ([favCategory.categoryName isEqualToString:[sender currentTitle]])
        {
            
        NSArray *favListArray=[[CoreDataOprations initObject]fetchRequestAccordingtoCategory:@"Favorites":@"favoriteId":@"categoryId":favCategory.categoryId :appDelegate.managedObjectContext];
        
        if ([favListArray count]!=0) {
            
            lDCFavoritesViewSearchResultLable.hidden=TRUE;
        
            UILabel* label12=[[UILabel alloc]init];
            label12.frame=CGRectMake(341*value+52+29,0,110,18);
            label12.numberOfLines=3;
            label12.font=[UIFont fontWithName:FontBold size:10];
            label12.textColor=kSkyBlueColor;
            label12.backgroundColor=[UIColor clearColor];
            
            label12.text=favCategory.categoryName;
            
            [lDCFavoritesViewScrollView addSubview:label12];
            
            
            if ([favListArray count]%3==0) {
                
                list=[favListArray count]/3;
            }
            
            else {
                
                list=[favListArray count]/3+1;
            }
            
        }
        else {
            
            lDCFavoritesViewSearchResultLable.hidden=FALSE;
            
            [lDCFavoritesViewSearchResultLable setText:@"There are no favorites"];

        }
            
        for (int j=0; j<list; j++) {
            
            for (int i=0; i<3; i++) {
                                
                if (index>=[favListArray count])
                {
                    
                    break;
                }
                else
                {
                    Favorites *favorites=[favListArray objectAtIndex:index];
                    
                    FavoriteView *favoriteViewObj=[[FavoriteView alloc]initWithFrame:CGRectMake(341*value+29,90*i+33,266,72)];
                    
                    favoriteViewObj.delegate=self;
                    [favoriteViewObj setSelectorButtonAction:@selector(favListButtonAction:)];
                    
                    favoriteViewObj.tittleLable.numberOfLines=2;
                    favoriteViewObj.tittleLable.font=[UIFont fontWithName:FontLight size:20];
                    favoriteViewObj.tittleLable.textColor=kGrayColor;
                    favoriteViewObj.tittleLable.text=favorites.favdescription;
                    
                    favoriteViewObj.subTittleLable.numberOfLines=2;
                    favoriteViewObj.subTittleLable.font=[UIFont fontWithName:FontLight size:10];
                    favoriteViewObj.subTittleLable.textColor=kGrayColor;
                    favoriteViewObj.subTittleLable.text=favorites.favSubTitle;
                    
                    NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",favorites.favThumbImage];
                    
                    if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                        favoriteViewObj.thumbImageView.image = [UIImage imageWithContentsOfFile:imageNameWithPath];
                    }
                    else if([UIImage imageNamed:favorites.favThumbImage]){
                        favoriteViewObj.thumbImageView.image = [UIImage imageNamed:favorites.favThumbImage];
                    }
                    else{
                        favoriteViewObj.thumbImageView.image = [UIImage imageNamed:@"thumb-background.png"];
                    }
                    
                    
                    favoriteViewObj.urlString=favorites.url;
                    favoriteViewObj.titleString=favorites.favdescription;

                    [lDCFavoritesViewScrollView addSubview:favoriteViewObj];
                    [favoriteViewObj setlabelHieght];
                    index=index+1;
                                        
                    scrollviewwidth=341*value+52+29+211;

                }
            }
            value++;
        }
        
            break;
        }
        else {
            
            lDCFavoritesViewSearchResultLable.hidden=FALSE;
            
            [lDCFavoritesViewSearchResultLable setText:@"There are no favorites"];
            
        }

    }
    int numberofPages=0;
    
    if (scrollviewwidth%1024!=0) {
        
        numberofPages=(scrollviewwidth/1024)+1;
        
        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(1024*numberofPages,317);
        
    }
    else {
        
        numberofPages=(scrollviewwidth/1024);
        
        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(numberofPages,317);
        
    }
    
}

-(void)addFavoritesSearchContentOnScrollView:(NSArray*)favListArray
{
    [self cleareScrollViewContent];

    int value=0;
    int scrollviewwidth=0;
    int index=0;
    int list=0;
        
            
            if ([favListArray count]!=0) {
                
                lDCFavoritesViewSearchResultLable.hidden=TRUE;
                
                UILabel* label12=[[UILabel alloc]init];
                label12.frame=CGRectMake(341*value+52+29,0,110,18);
                label12.numberOfLines=3;
                label12.font=[UIFont fontWithName:FontBold size:10];
                label12.textColor=kSkyBlueColor;
                label12.backgroundColor=[UIColor clearColor];
                                
                
                if ([favListArray count]%3==0) {
                    
                    list=[favListArray count]/3;
                }
                
                else {
                    
                    list=[favListArray count]/3+1;
                }
                
            }
            
            else {
                
                lDCFavoritesViewSearchResultLable.hidden=FALSE;
                
                [lDCFavoritesViewSearchResultLable setText:@"No search results"];

            }
            
            for (int j=0; j<list; j++) {
                
                for (int i=0; i<3; i++) {
                                        
                    if (index>=[favListArray count])
                    {
                        
                        break;
                    }
                    else
                    {
                        Favorites *favorites=[favListArray objectAtIndex:index];
                        
                        
                        FavoriteView *favoriteViewObj=[[FavoriteView alloc]initWithFrame:CGRectMake(341*value+29,90*i+33,266,72)];
                        
                        favoriteViewObj.delegate=self;
                        [favoriteViewObj setSelectorButtonAction:@selector(favListButtonAction:)];
                        
                        favoriteViewObj.tittleLable.numberOfLines=2;
                        favoriteViewObj.tittleLable.font=[UIFont fontWithName:FontLight size:20];
                        favoriteViewObj.tittleLable.textColor=kGrayColor;
                        favoriteViewObj.tittleLable.text=favorites.favdescription;
                        
                        favoriteViewObj.subTittleLable.numberOfLines=1;
                        favoriteViewObj.subTittleLable.font=[UIFont fontWithName:FontBold size:10];
                        favoriteViewObj.subTittleLable.textColor=kGrayColor;
                        favoriteViewObj.subTittleLable.text=favorites.favSubTitle;
                        
                        NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",favorites.favThumbImage];
                        
                        if ([UIImage imageWithContentsOfFile:imageNameWithPath]) {
                            favoriteViewObj.thumbImageView.image = [UIImage imageWithContentsOfFile:imageNameWithPath];
                        }
                        else{
                            favoriteViewObj.thumbImageView.image = [UIImage imageNamed:favorites.favThumbImage];
                        }
                        
                        favoriteViewObj.urlString=favorites.url;
                        favoriteViewObj.titleString=favorites.favdescription;
                        
                        [lDCFavoritesViewScrollView addSubview:favoriteViewObj];
                        
                        index=index+1;
                                                
                        scrollviewwidth=341*value+52+29+211;
                        
                    }
                }
                value++;
            }
        
    int numberofPages=0;
    
    if (scrollviewwidth%1024!=0) {
        
        numberofPages=(scrollviewwidth/1024)+1;
        
        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(1024*numberofPages,317);
        
    }
    else {
        
        numberofPages=(scrollviewwidth/1024);
        
        lDCFavoritesViewPageControl.numberOfPages=numberofPages;
        lDCFavoritesViewScrollView.contentSize=CGSizeMake(numberofPages,317);
        
    }
}

-(void)cleareScrollViewContent
{
    for (UIView *subview in self.lDCFavoritesViewScrollView.subviews) {
        // if([subview isKindOfClass:[UIImageView class]])
        [subview removeFromSuperview];
    }
}

-(void)favListButtonAction:(id)sender{

    isFavoriteSelected = TRUE;
//    [lDCFavoritesViewSearchTextField resignFirstResponder];
    [self favSearchAction:nil];
    
    if ([delegate respondsToSelector:selectorFavDetail]) {
        
        [delegate performSelector:selectorFavDetail withObject:sender afterDelay:0.0];
    }
//    [lDCFavoritesViewSearchTextField resignFirstResponder];
}

- (IBAction)changePage:(id)sender
{
    int page = lDCFavoritesViewPageControl.currentPage;
	CGRect frame = lDCFavoritesViewScrollView.frame;
    frame.origin.x = 1024 * page;
    frame.origin.y = 0;
    [lDCFavoritesViewScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrolView
{
	CGFloat pageWidth = 1024;
    int page = floor((scrolView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    lDCFavoritesViewPageControl.currentPage = page;
}


-(IBAction)eventSearchTextField_ValueChanged:(id)sender
{
    
    allButton.hidden=YES;
    toDOButton.hidden=YES;
    toEatButton.hidden=YES;
    toSeeButton.hidden=YES;
    toReadButton.hidden=YES;

    lDCFavoritesViewSearchTextField.hidden=NO;
    lDCFavoritesViewSearchTextLable.hidden=NO;
    lDCFavoritesViewScrollView.frame=CGRectMake(0,53, 1024, 317);
    lDCFavoritesViewSearchTextLable.text=[NSString stringWithFormat:@"Results of ''%@''",lDCFavoritesViewSearchTextField.text];
    
    NSString *searchText = lDCFavoritesViewSearchTextField.text;
   
    [self addFavoritesSearchContentOnScrollView:[[CoreDataOprations initObject]fetchRequestSearch:@"Favorites":@"favoriteId":@"favdescription":searchText:appDelegate.managedObjectContext]];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:selectorFavSearch]) {
        
        [delegate performSelector:selectorFavSearch withObject:@"YES" afterDelay:0.0];
        
    }
        
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
//    if (!isFavoriteSelected) {
        if ([delegate respondsToSelector:selectorFavSearch]) {
            
            [delegate performSelector:selectorFavSearch withObject:@"NO" afterDelay:0.0];
            
        }
//    }
    isFavoriteSelected = FALSE;
    
    //[self cleareScrollViewContent];
}


@end
