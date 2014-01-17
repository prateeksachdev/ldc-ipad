//
//  UpdateDatabase.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/03/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "UpdateDatabase.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Memebers.h"
#import "MembersGallery.h"
#import "CoreDataOprations.h"
#import "Profession.h"
#import "Contitent.h"
#import "State.h"
#import "Country.h"
#import "Events.h"
#import "EventsGallery.h"
#import "EventAgenda.h"
#import "Favorites.h"
#import "AboutLdcInfo.h"
#import "AbotLdcImageGallery.h"
#import "AboutLdcNewsLetter.h"
#import "FavCategory.h"
#import "AppsPassword.h"
#import "SettingsView.h"
#import "EmailLinks.h"
#import "HomeGallery.h"
#import <sys/xattr.h>
#import "Sponsor.h"

#define kTableName @"tableName"
#define kAttributeName @"attributeName"
#define kAttributeValue @"atributeValue"
#define kDetailDictionary @"detailDict"



@implementation UpdateDatabase
@synthesize responceDict,appDelegate,networkQueue,settingObj;

@synthesize managedObjectContextTemp = _managedObjectContextTemp;
@synthesize managedObjectModelTemp = _managedObjectModelTemp;
@synthesize persistentStoreCoordinatorTemp = _persistentStoreCoordinatorTemp;

+(UpdateDatabase*)initObject
{
    return [[self alloc]init];
}

-(void)addFiles:(id)sender
{
    
    isCancelled = FALSE;
    isDownloadingImage = FALSE;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    settingObj=(SettingsView*)sender;
    [settingObj.gifImageView removeFromSuperview];
    settingObj.downloadLable.text=@"Downloading Updates...";

    
    if (networkQueue)
    {
        networkQueue=nil;

    }
        networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue setDelegate:self];
        [networkQueue setMyDelegate:self];
        [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete1:)];
        [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed1:)];
        [networkQueue setQueueDidFinishSelector:@selector(imageFetchQeue1:)];
        [networkQueue setShouldCancelAllRequestsOnFailure:NO];

        [networkQueue setDownloadProgressDelegate:settingObj.progressView];
    
        [networkQueue go];
    
    
//    NSLog(@"self.responceDict : %@",self.responceDict);
    
    [self deleteTableData];
     [self addMembers:@""];
     [self addMembersGallery:@""];
     [self addProfession:@""];
     [self addContinent:@""];
     [self addState:@""];
     [self addCountry:@""];
     [self addEvents:@""];
     [self addeventsGallery:@""];
     [self addeventsAgenda:@""];
     [self addAboutInfo:@""];
     [self addAboutImage:@""];
     [self addAboutNewsLetter:@""];
     [self addFavoriety:@""];
     [self addFavCategory:@""];
     [self addAppPassword:@""];
     [self addEmailLinks];
     [self addHomeGallery];
     [self addSponsor:@""];
    if (!isDownloadingImage) {
        if (!isCancelled) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[self.responceDict valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self replaceTheOldDatabaseFileWithNewOne];
            AppDelegate * appDelegateObl=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appDelegateObl deleteExistingCoredataManagedObject];
//            NSLog(@"not canceled so save it");
        }
        else{
            [self removeTempDatabase];
        }
    }
    
//    NSLog(@"networkcount=%d",networkQueue.requestsCount);
    
    
    if (networkQueue.requestsCount==0) {
        
        settingObj.downloadLable.text=@"Download Complete";
        [settingObj.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.responceDict valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [settingObj progress:1.0];
        settingObj.userInteractionEnabled=TRUE;

    }
    
}

-(void)cancelUpdate{
    
    isCancelled = TRUE;
    [networkQueue cancelAllOperations];
    
}

-(void)deleteTableData
{
    NSError *error=nil;
    
    NSArray *arrayOfDeletedTables=[self.responceDict objectForKey:@"DeleteRecord"];
    
    for (int i=0; i<[arrayOfDeletedTables count]; i++) {

        NSDictionary *deleteDict=[arrayOfDeletedTables objectAtIndex:i];
        
        if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Continent"]) {
            
            NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"Contitent" :@"contitentId" :@"contitentId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
            
            if ([arrayOfMembersList count]!=0) {
                
            Contitent *obj=[arrayOfMembersList objectAtIndex:0];
                
            [self.managedObjectContextTemp deleteObject:obj];
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Country"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"Country" :@"countryId" :@"countryId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
//           NSLog(@"arrayOfMembersList : %@",arrayOfMembersList);
           if ([arrayOfMembersList count]!=0) {

               Country *countryObj = (Country *)[arrayOfMembersList objectAtIndex:0];
//                NSLog(@"countryObj : %@",countryObj);
           
           [self.managedObjectContextTemp deleteObject:countryObj];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }


           }
        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"State"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"State" :@"stateId" :@"stateId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }


           }
        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Member"]) {
         
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"Memebers" :@"mId" :@"mId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

               Memebers *memberObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
                    NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mProfileImage];
               NSString *imageNameWithPath1 = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberObj.mThumbImage];
                [fileMgr removeItemAtPath:imageNameWithPath error:NULL];
                [fileMgr removeItemAtPath:imageNameWithPath1 error:NULL];


               
           [self.managedObjectContextTemp deleteObject:memberObj];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"MemberImageGallery"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"MembersGallery" :@"mgImageId" :@"mgImageId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

               MembersGallery *memberGalleryObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",memberGalleryObj.mgImagePath];
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];

               
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Event"]) {
           
//           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
//                                         fetchRequestAccordingtoCategory:@"Events" :@"eId" :@"eId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           NSArray *arrayOfMembersList = [[CoreDataOprations initObject] fetchRequestAccordingtoCategoryForEntity:@"Events" withSortDescriptor:@"eId" withCategoryName:@"eId" withCategoryValue:[deleteDict valueForKey:@"DeletedID"] andManagedObject:self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

               Events *eventsObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsObj.eImage];
               NSString *imageNameWithPath1 = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventsObj.eThumbImage];
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];
               [fileMgr removeItemAtPath:imageNameWithPath1 error:NULL];

               
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"EventGallery"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"EventsGallery" :@"egImageId" :@"egImageId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {

               EventsGallery *eventGalleryObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventGalleryObj.egImageName];
                NSString *imageNameWithPath1 = [[self documentCatchePath] stringByAppendingFormat:@"/%@",eventGalleryObj.egImageThumb];
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];
               [fileMgr removeItemAtPath:imageNameWithPath1 error:NULL];

               
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"EventAgenda"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"EventAgenda" :@"eaId" :@"eaId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Profession"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"Profession" :@"professionId" :@"professionId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {

           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

               
           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"AboutInfo"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"AboutLdcInfo" :@"mId" :@"mId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {

           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

               
           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"AboutImage"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"AbotLdcImageGallery" :@"imageId" :@"imageId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

               AbotLdcImageGallery *aboutImageGalleryObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",aboutImageGalleryObj.imageName];
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];

           
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"AboutNewsLetter"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                        fetchRequestAccordingtoCategory:@"AboutLdcNewsLetter" :@"newsletterId" :@"newsletterId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {

               AboutLdcNewsLetter *aboutNewsLetter=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
                NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",aboutNewsLetter.newsletterName];
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];

               
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

               
           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"AppsPassword"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"AppsPassword" :@"appsId" :@"appsId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {

           
           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }

        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"EmailLink"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"EmailLinks" :@"accessId" :@"accessId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {
               
               [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }
           
       }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"HomeGallery"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                        fetchRequestAccordingtoCategory:@"HomeGallery" :@"imageId" :@"imageId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {
               
               
               HomeGallery *homeGalleryObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",homeGalleryObj.image];
               NSString *imageNameWithPath1 = [[self documentCatchePath] stringByAppendingFormat:@"/%@",homeGalleryObj.imageThumb];
               
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];
               [fileMgr removeItemAtPath:imageNameWithPath1 error:NULL];

               [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

           }
           
       }

       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Category"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"FavCategory" :@"categoryId" :@"categoryId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {

           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

               
           }

        }
       else if ([[deleteDict objectForKey:@"TableName"] isEqualToString:@"Favority"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"Favorites" :@"favoriteId" :@"favoriteId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           
           if ([arrayOfMembersList count]!=0) {


           [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }

               
           }
        }
       else if ([[deleteDict objectForKey:@"TableName"]isEqualToString:@"Sponser"]) {
           
           NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"Sponsor" :@"sponsorId" :@"sponsorId" :[deleteDict valueForKey:@"DeletedID"] :self.managedObjectContextTemp];
           if ([arrayOfMembersList count]!=0) {
               
               
               Sponsor *sponsorObj=[arrayOfMembersList objectAtIndex:0];
               
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               
               NSString *imageNameWithPath = [[self documentCatchePath] stringByAppendingFormat:@"/%@",sponsorObj.sImageName];
               NSString *imageNameWithPath1 = [[self documentCatchePath] stringByAppendingFormat:@"/%@",sponsorObj.sThumbImageName];
               
               
               [fileMgr removeItemAtPath:imageNameWithPath error:NULL];
               [fileMgr removeItemAtPath:imageNameWithPath1 error:NULL];
               
               [self.managedObjectContextTemp deleteObject:[arrayOfMembersList objectAtIndex:0]];
               
               if (![self.managedObjectContextTemp save:&error]) {
                   
                   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                   abort();
               }
               
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
-(void)addUpdateRecord:(NSMutableDictionary *)downloadedImageDetail{
    
//    NSLog(@"downloadedImageDetail added or updated value: %@",downloadedImageDetail);
//    NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
//                                  fetchRequestAccordingtoCategory:@"Memebers" :@"mId" :@"mId" :[memberDictionary valueForKey:@"MemberID"] :self.managedObjectContextTemp];
    NSArray *recordArray = [[CoreDataOprations initObject] fetchRequestAccordingtoCategoryForEntity:[downloadedImageDetail valueForKey:kTableName] withSortDescriptor:[downloadedImageDetail valueForKey:kAttributeName] withCategoryName:[downloadedImageDetail valueForKey:kAttributeName] withCategoryValue:[downloadedImageDetail valueForKey:kAttributeValue] andManagedObject:self.managedObjectContextTemp];
    
    
    if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"Memebers"]) {
        
        NSDictionary *memberDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        
        
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        if ([[memberDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[memberDictionary valueForKey:@"ThumbImage"] isEqual:[NSNull null]]) {
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            
        }
        
        else {
            arrayofstring=[[memberDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[memberDictionary valueForKey:@"ThumbImage"] componentsSeparatedByString:@"."];
        }
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring lastObject]]];
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring lastObject]];
        
//        NSString *path_to_thumbfile = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]]];
        NSString *path_to_thumbfile = [NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]];
        
        Memebers* membersObj;
        if ([recordArray count]<1) {
            //add
            
            membersObj= [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Memebers"
                                   inManagedObjectContext:self.managedObjectContextTemp];
            [membersObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mId"];
            [membersObj setValue:[memberDictionary valueForKey:@"Name"] forKey:@"mName"];
            [membersObj setValue:[memberDictionary valueForKey:@"LastName"] forKey:@"mLastName"];
            [membersObj setValue:[memberDictionary valueForKey:@"Address"] forKey:@"mAddress"];
            [membersObj setValue:[memberDictionary valueForKey:@"Bio"] forKey:@"mDescription"];
            [membersObj setValue:[memberDictionary valueForKey:@"ContinentID"] forKey:@"mContinentId"];
            [membersObj setValue:[memberDictionary valueForKey:@"CountryID"] forKey:@"mCountryId"];
            [membersObj setValue:[memberDictionary valueForKey:@"StateID"] forKey:@"mStateId"];
            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mProfessionId"];
            [membersObj setValue:[memberDictionary valueForKey:@"Facebook"] forKey:@"mFacebook"];
            [membersObj setValue:[memberDictionary valueForKey:@"Twitter"] forKey:@"mTwitter"];
            [membersObj setValue:[memberDictionary valueForKey:@"Pinterest"] forKey:@"mPinterest"];
            [membersObj setValue:[memberDictionary valueForKey:@"Houzz"] forKey:@"mHouzz"];
            [membersObj setValue:[memberDictionary valueForKey:@"AppUrl"] forKey:@"mAppUrl"];
            [membersObj setValue:[memberDictionary valueForKey:@"AppUrlIPhone"] forKey:@"mAppURliphone"];
            [membersObj setValue:[memberDictionary valueForKey:@"Website"] forKey:@"mWebsite"];
            [membersObj setValue:[memberDictionary valueForKey:@"Email"] forKey:@"mEmail"];
            [membersObj setValue:[memberDictionary valueForKey:@"Telephone"] forKey:@"mTelephone"];
            [membersObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mRS"];
            [membersObj setValue:path_to_thumbfile forKey:@"mThumbImage"];
            [membersObj setValue:imagePath forKey:@"mProfileImage"];
            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mSyncDateTime"];
            membersObj.mFounder=[NSString stringWithFormat:@"%@",[memberDictionary valueForKey:@"Founder"]];
            membersObj.mCompany=[memberDictionary valueForKey:@"Company"];
        }
        else{
            //update
            
            membersObj=[recordArray objectAtIndex:0];
            [membersObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mId"];
            [membersObj setValue:[memberDictionary valueForKey:@"Name"] forKey:@"mName"];
            [membersObj setValue:[memberDictionary valueForKey:@"LastName"] forKey:@"mLastName"];
            [membersObj setValue:[memberDictionary valueForKey:@"Address"] forKey:@"mAddress"];
            [membersObj setValue:[memberDictionary valueForKey:@"Bio"] forKey:@"mDescription"];
            [membersObj setValue:[memberDictionary valueForKey:@"ContinentID"] forKey:@"mContinentId"];
            [membersObj setValue:[memberDictionary valueForKey:@"CountryID"] forKey:@"mCountryId"];
            [membersObj setValue:[memberDictionary valueForKey:@"StateID"] forKey:@"mStateId"];
            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mProfessionId"];
            [membersObj setValue:[memberDictionary valueForKey:@"Facebook"] forKey:@"mFacebook"];
            [membersObj setValue:[memberDictionary valueForKey:@"Twitter"] forKey:@"mTwitter"];
            [membersObj setValue:[memberDictionary valueForKey:@"Pinterest"] forKey:@"mPinterest"];
            [membersObj setValue:[memberDictionary valueForKey:@"Houzz"] forKey:@"mHouzz"];
            [membersObj setValue:[memberDictionary valueForKey:@"AppUrl"] forKey:@"mAppUrl"];
            [membersObj setValue:[memberDictionary valueForKey:@"AppUrlIPhone"] forKey:@"mAppURliphone"];
            [membersObj setValue:[memberDictionary valueForKey:@"Website"] forKey:@"mWebsite"];
            [membersObj setValue:[memberDictionary valueForKey:@"Email"] forKey:@"mEmail"];
            [membersObj setValue:[memberDictionary valueForKey:@"Telephone"] forKey:@"mTelephone"];
            [membersObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mRS"];
            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mSyncDateTime"];
            membersObj.mFounder=[NSString stringWithFormat:@"%@",[memberDictionary valueForKey:@"Founder"]];
            membersObj.mCompany=[memberDictionary valueForKey:@"Company"];
            [membersObj setValue:path_to_thumbfile forKey:@"mThumbImage"];
            [membersObj setValue:imagePath forKey:@"mProfileImage"];
            
        }
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"MembersGallery"]){
        
         NSDictionary *memberDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        if ([[memberDictionary valueForKey:@"ImagePath"] isEqual:[NSNull null]]||[[memberDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[memberDictionary valueForKey:@"ImagePath"] componentsSeparatedByString:@"."];
            arrayofstring1=[[memberDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
            
        }
        
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
        NSString *imagePath = [NSString stringWithFormat:@"%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
        
        
//        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];
        
        
        MembersGallery* membersGalleryObj;
        
        if ([recordArray count]<1) {
            //add
            
            
            membersGalleryObj= [NSEntityDescription
                                                insertNewObjectForEntityForName:@"MembersGallery"
                                                inManagedObjectContext:self.managedObjectContextTemp];
            
            
            [membersGalleryObj setValue:imagePath forKey:@"mgImagePath"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"Caption"] forKey:@"mgCaption"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mgMembersId"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"ImageID"] forKey:@"mgImageId"];
            [membersGalleryObj setValue:thumbImagePath forKey:@"mgImageThumb"];
            [membersGalleryObj setValue:[NSNumber numberWithInt:[[memberDictionary valueForKey:@"Position"] intValue]] forKey:@"mgImagePosition"];
        }
        else{
            //update
            membersGalleryObj=[recordArray objectAtIndex:0];
            [membersGalleryObj setValue:imagePath forKey:@"mgImagePath"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"Caption"] forKey:@"mgCaption"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mgMembersId"];
            [membersGalleryObj setValue:[memberDictionary valueForKey:@"ImageID"] forKey:@"mgImageId"];
            [membersGalleryObj setValue:thumbImagePath forKey:@"mgImageThumb"];
            [membersGalleryObj setValue:[NSNumber numberWithInt:[[memberDictionary valueForKey:@"Position"] intValue]] forKey:@"mgImagePosition"];
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"Events"]){
        
        NSDictionary *eventDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[eventDictionary valueForKey:@"Image"] isEqual:[NSNull null]]|| [[eventDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[eventDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[eventDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
        }
        
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring lastObject]]];
         NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring lastObject]];
        
//        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring1 lastObject]]];
        NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring1 lastObject]];
        Events* eventsObj;
        
        if ([recordArray count]<1) {
            //add
            
            eventsObj= [NSEntityDescription
                                insertNewObjectForEntityForName:@"Events"
                                inManagedObjectContext:self.managedObjectContextTemp];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            [eventsObj setValue:[eventDictionary valueForKey:@"EventID"] forKey:@"eId"];
            [eventsObj setValue:[eventDictionary valueForKey:@"EventName"] forKey:@"eName"];
            [eventsObj setValue:imagePath forKey:@"eImage"];
            [eventsObj setValue:thumbImagePath forKey:@"eThumbImage"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Place"] forKey:@"ePlace"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Place2"] forKey:@"ePlace2"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Place3"] forKey:@"ePlace3"];
            [eventsObj setValue:[eventDictionary valueForKey:@"ZipCode"] forKey:@"eZipCode"];
            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventFrom"]] forKey:@"eFromDate"];
            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventTO"]] forKey:@"eToDate"];
            [eventsObj setValue:[eventDictionary valueForKey:@"comment"] forKey:@"eComment"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Lat"] forKey:@"eLat"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Long"] forKey:@"eLong"];
            [eventsObj setValue:[eventDictionary valueForKey:@"LongName"] forKey:@"eLongName"];
            
        }
        else{
            //update
            
            
            eventsObj= [recordArray objectAtIndex:0];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
            
            [eventsObj setValue:[eventDictionary valueForKey:@"EventID"] forKey:@"eId"];
            
            [eventsObj setValue:[eventDictionary valueForKey:@"EventName"] forKey:@"eName"];
            
            [eventsObj setValue:[eventDictionary valueForKey:@"Place"] forKey:@"ePlace"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Place2"] forKey:@"ePlace2"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Place3"] forKey:@"ePlace3"];
            [eventsObj setValue:[eventDictionary valueForKey:@"ZipCode"] forKey:@"eZipCode"];
            
            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventFrom"]] forKey:@"eFromDate"];
            
            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventTO"]] forKey:@"eToDate"];
            
            [eventsObj setValue:[eventDictionary valueForKey:@"comment"] forKey:@"eComment"];
            
            [eventsObj setValue:[eventDictionary valueForKey:@"Lat"] forKey:@"eLat"];
            [eventsObj setValue:[eventDictionary valueForKey:@"Long"] forKey:@"eLong"];
            
            [eventsObj setValue:imagePath forKey:@"eImage"];
            [eventsObj setValue:thumbImagePath forKey:@"eThumbImage"];
            [eventsObj setValue:[eventDictionary valueForKey:@"LongName"] forKey:@"eLongName"];
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"EventsGallery"]){
    
        NSDictionary *eventGalleryDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[eventGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[eventGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[eventGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[eventGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
            
        }
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
        
//        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
        
         NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];
        
        EventsGallery *eventsGalleryObj;
        
        
        if ([recordArray count]<1) {
            //add
            
            eventsGalleryObj= [NSEntityDescription
                                              insertNewObjectForEntityForName:@"EventsGallery"
                                              inManagedObjectContext:self.managedObjectContextTemp];
            eventsGalleryObj.egEventID=[eventGalleryDictionary valueForKey:@"EventID"];
            eventsGalleryObj.egImageName=imagePath;
            eventsGalleryObj.egImageId=[eventGalleryDictionary valueForKey:@"ImageID"];
            eventsGalleryObj.egCaption=[eventGalleryDictionary valueForKey:@"Caption"];
            eventsGalleryObj.egImageThumb=thumbImagePath;
            eventsGalleryObj.egImagePosition = [NSNumber numberWithInt:[[eventGalleryDictionary valueForKey:@"Position"] intValue]];
            
        }
        else{
            //update
            
            eventsGalleryObj= [recordArray objectAtIndex:0];
            eventsGalleryObj.egEventID=[eventGalleryDictionary valueForKey:@"EventID"];
            eventsGalleryObj.egImageName=imagePath;
            eventsGalleryObj.egImageId=[eventGalleryDictionary valueForKey:@"ImageID"];
            eventsGalleryObj.egCaption=[eventGalleryDictionary valueForKey:@"Caption"];
            eventsGalleryObj.egImageThumb=thumbImagePath;
            eventsGalleryObj.egImagePosition = [NSNumber numberWithInt:[[eventGalleryDictionary valueForKey:@"Position"] intValue]];
            
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"AbotLdcImageGallery"]){
        
        NSDictionary *aboutImageDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[aboutImageDictionary valueForKey:@"ImageName"]isEqual:[NSNull null] ]||[[aboutImageDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[aboutImageDictionary valueForKey:@"ImageName"] componentsSeparatedByString:@"."];
            arrayofstring1=[[aboutImageDictionary valueForKey:@"ImageName"] componentsSeparatedByString:@"."];
        }
        
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[aboutImageDictionary valueForKey:@"ImgID"],[arrayofstring lastObject]]];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[aboutImageDictionary valueForKey:@"ImgID"],[arrayofstring lastObject]];
        
        AbotLdcImageGallery* aboutImageObj;
        
        if ([recordArray count]<1) {
        //add
            aboutImageObj=[NSEntityDescription insertNewObjectForEntityForName:@"AbotLdcImageGallery" inManagedObjectContext:self.managedObjectContextTemp];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"Caption"] forKey:@"caption"];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"ImgID"] forKey:@"imageId"];
            [aboutImageObj setValue:imagePath forKey:@"imageName"];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
            [aboutImageObj setValue:[NSNumber numberWithInt:[[aboutImageDictionary valueForKey:@"Position"] intValue]] forKey:@"imagePosition"];
        }
        else{
        //update
            
            aboutImageObj=[recordArray objectAtIndex:0];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"Caption"] forKey:@"caption"];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"ImgID"] forKey:@"imageId"];
            [aboutImageObj setValue:imagePath forKey:@"imageName"];
            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
            [aboutImageObj setValue:[NSNumber numberWithInt:[[aboutImageDictionary valueForKey:@"Position"] intValue]] forKey:@"imagePosition"];
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"AboutLdcNewsLetter"]){
        
        NSDictionary *aboutNewsLetterDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] componentsSeparatedByString:@"."];
            arrayofstring1=[[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] componentsSeparatedByString:@"."];
            
        }
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"],[arrayofstring lastObject]]];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"],[arrayofstring lastObject]];
        
        AboutLdcNewsLetter* aboutNewsObj;
        
        if ([recordArray count]<1) {
            //add
            
            aboutNewsObj=[NSEntityDescription insertNewObjectForEntityForName:@"AboutLdcNewsLetter" inManagedObjectContext:self.managedObjectContextTemp];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:@"newsletterId"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Month"] forKey:@"month"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Year"] forKey:@"year"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"RS"] forKey:@"aboutLdcRS"];
            [aboutNewsObj setValue:imagePath forKey:@"newsletterName"];
        }
        else{
            //update
            aboutNewsObj=[recordArray objectAtIndex:0];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:@"newsletterId"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Month"] forKey:@"month"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Year"] forKey:@"year"];
            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"RS"] forKey:@"aboutLdcRS"];
            [aboutNewsObj setValue:imagePath forKey:@"newsletterName"];
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"Favorites"]){
        NSDictionary *favoirateDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[favoirateDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[favoirateDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[favoirateDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[favoirateDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
        }
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring lastObject]]];
//        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring1 lastObject]]];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring lastObject]];
        NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring1 lastObject]];
        
        Favorites *favoritesObj;
        
        if ([recordArray count]<1) {
            //Add
            
            favoritesObj= [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Favorites"
                                      inManagedObjectContext:self.managedObjectContextTemp];
            
            
            
            
            
            favoritesObj.favoriteId=[favoirateDictionary valueForKey:@"FavorityID"];
            favoritesObj.url=[favoirateDictionary valueForKey:@"Url"];
            favoritesObj.categoryId=[favoirateDictionary valueForKey:@"CategoryID"];
            favoritesObj.favdescription=[favoirateDictionary valueForKey:@"Description"];
            favoritesObj.latitude=[favoirateDictionary valueForKey:@"Lat"];
            favoritesObj.longitude=[favoirateDictionary valueForKey:@"Long"];
            favoritesObj.favSubTitle=[favoirateDictionary valueForKey:@"SubTittle"];
            favoritesObj.favRS=[favoirateDictionary valueForKey:@"RS"];
            favoritesObj.favImage=imagePath;
            favoritesObj.favThumbImage=thumbImagePath;
        }
        else{
            //update
            
            favoritesObj= [recordArray objectAtIndex:0];
            favoritesObj.favoriteId=[favoirateDictionary valueForKey:@"FavorityID"];
            favoritesObj.url=[favoirateDictionary valueForKey:@"Url"];
            favoritesObj.categoryId=[favoirateDictionary valueForKey:@"CategoryID"];
            favoritesObj.favdescription=[favoirateDictionary valueForKey:@"Description"];
            favoritesObj.latitude=[favoirateDictionary valueForKey:@"Lat"];
            favoritesObj.longitude=[favoirateDictionary valueForKey:@"Long"];
            favoritesObj.favSubTitle=[favoirateDictionary valueForKey:@"SubTittle"];
            favoritesObj.favRS=[favoirateDictionary valueForKey:@"RS"];
            favoritesObj.favImage=imagePath;
            favoritesObj.favThumbImage=thumbImagePath;
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }        
        
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"HomeGallery"]){
        
        NSDictionary *homeGalleryDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[homeGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[homeGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[homeGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[homeGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
        }
        
//        NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
//        NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]];
        NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]];
        
        HomeGallery*homeGalleryObj;
        
        if ([recordArray count]<1) {
            //Add
            
            homeGalleryObj= [NSEntityDescription
                                         insertNewObjectForEntityForName:@"HomeGallery"
                                         inManagedObjectContext:self.managedObjectContextTemp];
            
            homeGalleryObj.imageId =[homeGalleryDictionary valueForKey:@"ImageID"];
            homeGalleryObj.image=imagePath;
            homeGalleryObj.imageThumb=thumbImagePath;
            
        }
        else{
            //update
            
            homeGalleryObj= [recordArray objectAtIndex:0]; 
            homeGalleryObj.imageId =[homeGalleryDictionary valueForKey:@"ImageID"];
            homeGalleryObj.image=imagePath;
            homeGalleryObj.imageThumb=thumbImagePath;
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else if ([[downloadedImageDetail valueForKey:kTableName] isEqualToString:@"Sponsor"]){
        
        NSDictionary *sponsorDictionary=[downloadedImageDetail valueForKey:kDetailDictionary];
        NSArray *arrayofstring;
        NSArray *arrayofstring1;
        
        if ([[sponsorDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[sponsorDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
            
            arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
            arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
        }
        else {
            arrayofstring=[[sponsorDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
            arrayofstring1=[[sponsorDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
            
        }        
        
        NSString *imagePath = [NSString stringWithFormat:@"%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring lastObject]];
        NSString *thumbImagePath = [NSString stringWithFormat:@"thumb%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring1 lastObject]];

                
        Sponsor *sponsorObj;
        
        
        if ([recordArray count]<1) {
            //add
            
            sponsorObj= [NSEntityDescription
                               insertNewObjectForEntityForName:@"Sponsor"
                               inManagedObjectContext:self.managedObjectContextTemp];
            sponsorObj.sponsorId=[sponsorDictionary valueForKey:@"SponserID"];
            sponsorObj.sImageName=imagePath;
            sponsorObj.sUrl=[sponsorDictionary valueForKey:@"Url"];
            sponsorObj.sDescription=[sponsorDictionary valueForKey:@"Description"];
            sponsorObj.sThumbImageName=thumbImagePath;
            
        }
        else{
            //update
            
            sponsorObj= [recordArray objectAtIndex:0];
            sponsorObj.sponsorId=[sponsorDictionary valueForKey:@"SponserID"];
            sponsorObj.sImageName=imagePath;
            sponsorObj.sUrl=[sponsorDictionary valueForKey:@"Url"];
            sponsorObj.sDescription=[sponsorDictionary valueForKey:@"Description"];
            sponsorObj.sThumbImageName=thumbImagePath;
            
        }
        
        NSError *error=nil;
        if (![self.managedObjectContextTemp save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }

    
    
    
}

-(void)addMembers:(NSString*)opration
{
    
    NSArray *memberArray=[self.responceDict objectForKey:@"Member"];
        
    
    if ([memberArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[memberArray count]; i++) {
            
            NSDictionary *memberDictionary=[memberArray objectAtIndex:i];
            
            
            NSArray *arrayOfMembersList= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"Memebers" :@"mId" :@"mId" :[memberDictionary valueForKey:@"MemberID"] :self.managedObjectContextTemp];
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            if ([[memberDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[memberDictionary valueForKey:@"ThumbImage"] isEqual:[NSNull null]]) {
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
                
            }
            
            else {
                arrayofstring=[[memberDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
                arrayofstring1=[[memberDictionary valueForKey:@"ThumbImage"] componentsSeparatedByString:@"."];
            }
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring lastObject]]];
            
            NSString *path_to_thumbfile = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[memberDictionary valueForKey:@"MemberID"],[arrayofstring1 lastObject]]];
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"Memebers" forKey:kTableName];
            [recordDetailDictionary setObject:@"mId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[memberDictionary valueForKey:@"MemberID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:memberDictionary forKey:kDetailDictionary];

            if ([arrayOfMembersList count]==0) {
                
               
   
//             Memebers* membersObj= [NSEntityDescription
//                         insertNewObjectForEntityForName:@"Memebers"
//                         inManagedObjectContext:self.managedObjectContextTemp];
//            [membersObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Name"] forKey:@"mName"];
//            [membersObj setValue:[memberDictionary valueForKey:@"LastName"] forKey:@"mLastName"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Address"] forKey:@"mAddress"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Bio"] forKey:@"mDescription"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ContinentID"] forKey:@"mContinentId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"CountryID"] forKey:@"mCountryId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"StateID"] forKey:@"mStateId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mProfessionId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Facebook"] forKey:@"mFacebook"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Twitter"] forKey:@"mTwitter"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Pinterest"] forKey:@"mPinterest"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Houzz"] forKey:@"mHouzz"];
//            [membersObj setValue:[memberDictionary valueForKey:@"AppUrl"] forKey:@"mAppUrl"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Website"] forKey:@"mWebsite"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Email"] forKey:@"mEmail"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Telephone"] forKey:@"mTelephone"];
//            [membersObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mRS"];
//            [membersObj setValue:path_to_thumbfile forKey:@"mThumbImage"];
//            [membersObj setValue:imagePath forKey:@"mProfileImage"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mSyncDateTime"];
//             membersObj.mFounder=[NSString stringWithFormat:@"%@",[memberDictionary valueForKey:@"Founder"]];
//             membersObj.mCompany=[memberDictionary valueForKey:@"Company"];

            if ([[memberDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                
            }
            else {
                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"Image"]]];
                [requesthttp setDownloadDestinationPath:imagePath];
                [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                
                [networkQueue addOperation:requesthttp];
                
            }
                
                if ([[memberDictionary valueForKey:@"ThumbImage"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ThumbImage"]]];
                    [requesthttp setDownloadDestinationPath:path_to_thumbfile];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:path_to_thumbfile forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                }
    
                
//            if (![self.managedObjectContextTemp save:&error])
//            {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
        }
        else {
            
//            Memebers* membersObj=[arrayOfMembersList objectAtIndex:0];
//            
////            NSString  *imagePath =membersObj.mProfileImage;
////            NSString *path_to_thumbfile=membersObj.mThumbImage;
//            
//            [membersObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Name"] forKey:@"mName"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Address"] forKey:@"mAddress"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Bio"] forKey:@"mDescription"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ContinentID"] forKey:@"mContinentId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"CountryID"] forKey:@"mCountryId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"StateID"] forKey:@"mStateId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mProfessionId"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Facebook"] forKey:@"mFacebook"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Twitter"] forKey:@"mTwitter"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Pinterest"] forKey:@"mPinterest"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Houzz"] forKey:@"mHouzz"];
//            [membersObj setValue:[memberDictionary valueForKey:@"AppUrl"] forKey:@"mAppUrl"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Website"] forKey:@"mWebsite"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Email"] forKey:@"mEmail"];
//            [membersObj setValue:[memberDictionary valueForKey:@"Telephone"] forKey:@"mTelephone"];
//            [membersObj setValue:[memberDictionary valueForKey:@"RS"] forKey:@"mRS"];
//            [membersObj setValue:[memberDictionary valueForKey:@"ProfessionID"] forKey:@"mSyncDateTime"];
//            membersObj.mFounder=[NSString stringWithFormat:@"%@",[memberDictionary valueForKey:@"Founder"]];
//             membersObj.mCompany=[memberDictionary valueForKey:@"Company"];
//            [membersObj setValue:path_to_thumbfile forKey:@"mThumbImage"];
//            [membersObj setValue:imagePath forKey:@"mProfileImage"];

            if ([[memberDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                
            }
            else {
                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"Image"]]];
                [requesthttp setDownloadDestinationPath:imagePath];
                [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
            }

            if ([[memberDictionary valueForKey:@"ThumbImage"] isEqual:[NSNull null]]) {
                
            }
            else {
                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ThumbImage"]]];
                [requesthttp setDownloadDestinationPath:path_to_thumbfile];
                [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:path_to_thumbfile forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
            }

//            if (![self.managedObjectContextTemp save:&error])
//            {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }

            }
        }
    }
}
-(void)addMembersGallery:(NSString*)opration
{
    NSArray *memberGalleryArray=[self.responceDict objectForKey:@"MemberImageGallery"];
    if ([memberGalleryArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[memberGalleryArray count]; i++) {
            
            NSDictionary *memberDictionary=[memberGalleryArray objectAtIndex:i];

            
            NSArray *arrayOfMembersGalleryList= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"MembersGallery" :@"mgImageId" :@"mgImageId" :[memberDictionary valueForKey:@"ImageID"] :self.managedObjectContextTemp];
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            if ([[memberDictionary valueForKey:@"ImagePath"] isEqual:[NSNull null]]||[[memberDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[memberDictionary valueForKey:@"ImagePath"] componentsSeparatedByString:@"."];
                arrayofstring1=[[memberDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
                
            }
            
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[memberDictionary valueForKey:@"MemberID"],[memberDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
            
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"MembersGallery" forKey:kTableName];
            [recordDetailDictionary setObject:@"mgImageId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[memberDictionary valueForKey:@"ImageID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:memberDictionary forKey:kDetailDictionary];
            
            if ([arrayOfMembersGalleryList count]==0) {

            
//           MembersGallery* membersGalleryObj= [NSEntityDescription
//                                insertNewObjectForEntityForName:@"MembersGallery"
//                                inManagedObjectContext:self.managedObjectContextTemp];
//                
//
//            [membersGalleryObj setValue:imagePath forKey:@"mgImagePath"];
//            [membersGalleryObj setValue:[memberDictionary valueForKey:@"Caption"] forKey:@"mgCaption"];
//            [membersGalleryObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mgMembersId"];
//            [membersGalleryObj setValue:[memberDictionary valueForKey:@"ImageID"] forKey:@"mgImageId"];
//            [membersGalleryObj setValue:thumbImagePath forKey:@"mgImageThumb"];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            [dict setObject:imagePath forKey:@"path"];
            
            [dict setObject:[memberDictionary valueForKey:@"ImagePath"] forKey:@"url"];
            
                if ([[memberDictionary valueForKey:@"ImagePath"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImagePath"]]];
            [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
                }
                
                if ([[memberDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {

                isDownloadingImage = TRUE;
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImageThumbnail"]]];
                [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                }
                
                
//            if (![self.managedObjectContextTemp save:&error])
//            {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            }
            else {
                
//                MembersGallery *membersGalleryObj=[arrayOfMembersGalleryList objectAtIndex:0];
//                
////                NSString  *imagePath = membersGalleryObj.mgImagePath;
////                NSString  *thumbImagePath=membersGalleryObj.mgImageThumb;
//                
//                
//                [membersGalleryObj setValue:imagePath forKey:@"mgImagePath"];
//                [membersGalleryObj setValue:[memberDictionary valueForKey:@"Caption"] forKey:@"mgCaption"];
//                [membersGalleryObj setValue:[memberDictionary valueForKey:@"MemberID"] forKey:@"mgMembersId"];
//                [membersGalleryObj setValue:[memberDictionary valueForKey:@"ImageID"] forKey:@"mgImageId"];
//                [membersGalleryObj setValue:thumbImagePath forKey:@"mgImageThumb"];
                
                
                if ([[memberDictionary valueForKey:@"ImagePath"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImagePath"]]];
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                
                if ([[memberDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[memberDictionary valueForKey:@"ImageThumbnail"]]];
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
//                if (![self.managedObjectContextTemp save:&error])
//                {
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }

            }
        }
    }

}
-(void)addProfession:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *professionArray=[self.responceDict objectForKey:@"Profession"];
  
    if ([professionArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[professionArray count]; i++){
            
            NSDictionary *professionDictionary=[professionArray objectAtIndex:i];
            
            NSArray *arrayOfProfessionList= [[CoreDataOprations initObject]
                                            fetchRequestAccordingtoCategory:@"Profession" :@"professionId" :@"professionId" :[professionDictionary valueForKey:@"ProfessionID"] :self.managedObjectContextTemp];

            
            
            if ([arrayOfProfessionList count]==0) {
                
            
            
            Profession *professionObj= [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Profession"
                                        inManagedObjectContext:self.managedObjectContextTemp];
            
            
            professionObj.professionId=[professionDictionary valueForKey:@"ProfessionID"];
            
            professionObj.professionName=[professionDictionary valueForKey:@"Name"];
            
            professionObj.professionRS=[professionDictionary valueForKey:@"RS"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            }
            else {
                
                Profession *professionObj= [arrayOfProfessionList objectAtIndex:0];
                
                
                professionObj.professionId=[professionDictionary valueForKey:@"ProfessionID"];
                
                professionObj.professionName=[professionDictionary valueForKey:@"Name"];
                
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }
            
        }
    }

}
-(void)addContinent:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *contitentArray=[self.responceDict objectForKey:@"Continents"];
    if ([contitentArray isEqual:[NSNull null]])
    {
        
    }
    else {
        
        for (int i=0; i<[contitentArray count]; i++)
        {
            
            NSDictionary *contitentDictionary=[contitentArray objectAtIndex:i];

            
            NSArray *arrayOfContinentList= [[CoreDataOprations initObject]
                                             fetchRequestAccordingtoCategory:@"Contitent" :@"contitentId" :@"contitentId" :[contitentDictionary valueForKey:@"ContinentID"] :self.managedObjectContextTemp];
            
            
            
            if ([arrayOfContinentList count]==0) {

            
           Contitent* contitentObj= [NSEntityDescription
                           insertNewObjectForEntityForName:@"Contitent"
                           inManagedObjectContext:self.managedObjectContextTemp];
            
            
            NSString *contitentId=[contitentDictionary objectForKey:@"ContinentID"];
            NSString *contitentName=[contitentDictionary objectForKey:@"Name"];
            
            
            [contitentObj setValue:contitentId forKey:@"contitentId"];
            [contitentObj setValue:contitentName forKey:@"contitentName"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        else {
           
            Contitent* contitentObj= [arrayOfContinentList objectAtIndex:0];
            
            
            NSString *contitentId=[contitentDictionary objectForKey:@"ContinentID"];
            NSString *contitentName=[contitentDictionary objectForKey:@"Name"];
            
            
            [contitentObj setValue:contitentId forKey:@"contitentId"];
            [contitentObj setValue:contitentName forKey:@"contitentName"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }

        }
    }
    }
}
-(void)addState:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *stateArray1=[self.responceDict objectForKey:@"State"];
    
    if ([stateArray1 isEqual:[NSNull null]]) {
    }
    else {
        for (int k=0;k<[stateArray1 count]; k++)
        {
            NSDictionary *stateDictionary=[stateArray1 objectAtIndex:k];
            
            
            NSArray *arrayOfStateList= [[CoreDataOprations initObject]
                                            fetchRequestAccordingtoCategory:@"State" :@"stateId" :@"stateId" :[stateDictionary valueForKey:@"StateID"] :self.managedObjectContextTemp];
            
            
            if ([arrayOfStateList count]==0) {

            
           State* stateObj= [NSEntityDescription
                       insertNewObjectForEntityForName:@"State"
                       inManagedObjectContext:self.managedObjectContextTemp];
            
            [stateObj setValue:[stateDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
            [stateObj setValue:[stateDictionary objectForKey:@"StateID"] forKey:@"stateId"];
            [stateObj setValue:[stateDictionary objectForKey:@"Name"] forKey:@"stateName"];
            
            if (![self.managedObjectContextTemp save:&error])
            {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            }
            else {
                
                State* stateObj= [arrayOfStateList objectAtIndex:0];
                
                [stateObj setValue:[stateDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
                [stateObj setValue:[stateDictionary objectForKey:@"StateID"] forKey:@"stateId"];
                [stateObj setValue:[stateDictionary objectForKey:@"Name"] forKey:@"stateName"];
                
                if (![self.managedObjectContextTemp save:&error])
                {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }
        }
        
    }

}
-(void)addCountry:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *countryArray1=[self.responceDict objectForKey:@"Country"];
    
    if ([countryArray1 isEqual:[NSNull null]]) {
    }
    else {
        
        for (int j=0; j<[countryArray1 count]; j++)
        {
            
            NSDictionary *countryDictionary=[countryArray1 objectAtIndex:j];
            
            
            NSArray *arrayOfCountryList= [[CoreDataOprations initObject]
                                        fetchRequestAccordingtoCategory:@"Country" :@"countryId" :@"countryId" :[countryDictionary valueForKey:@"CountryID"] :self.managedObjectContextTemp];
            
            
            if ([arrayOfCountryList count]==0) {

            
           Country* countryObj= [NSEntityDescription
                         insertNewObjectForEntityForName:@"Country"
                         inManagedObjectContext:self.managedObjectContextTemp];
            
            
            //  NSLog(@"state:%@",countryDictionary);
            
            [countryObj setValue:[countryDictionary objectForKey:@"ContinentID"] forKey:@"contitentId"];
            [countryObj setValue:[countryDictionary objectForKey:@"Name"] forKey:@"countryName"];
            [countryObj setValue:[countryDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
         
            }
            }
            else {
                
                Country* countryObj= [arrayOfCountryList objectAtIndex:0];
                
                [countryObj setValue:[countryDictionary objectForKey:@"ContinentID"] forKey:@"contitentId"];
                [countryObj setValue:[countryDictionary objectForKey:@"Name"] forKey:@"countryName"];
                [countryObj setValue:[countryDictionary objectForKey:@"CountryID"] forKey:@"countryId"];
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                    
                }

            }
        }
    }

}

-(void)addEvents:(NSString*)opration
{
    
    NSArray *eventArray=[self.responceDict objectForKey:@"Events"];
    
    if ([eventArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[eventArray count]; i++){
            
            NSDictionary *eventDictionary=[eventArray objectAtIndex:i];
            
            NSArray *arrayOfEventList= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"Events" :@"eId" :@"eId" :[eventDictionary valueForKey:@"EventID"] :self.managedObjectContextTemp];
            
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[eventDictionary valueForKey:@"Image"] isEqual:[NSNull null]]|| [[eventDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[eventDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
                arrayofstring1=[[eventDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
            }
            
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring lastObject]]];
            
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[eventDictionary valueForKey:@"EventID"],[arrayofstring1 lastObject]]];
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"Events" forKey:kTableName];
            [recordDetailDictionary setObject:@"eId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[eventDictionary valueForKey:@"EventID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:eventDictionary forKey:kDetailDictionary];
            
            
            if ([arrayOfEventList count]==0) {

            
//           Events* eventsObj= [NSEntityDescription
//                        insertNewObjectForEntityForName:@"Events"
//                        inManagedObjectContext:self.managedObjectContextTemp];
//                
//               
//
//                
//            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//            
//            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//            
//            [eventsObj setValue:[eventDictionary valueForKey:@"EventID"] forKey:@"eId"];
//            
//            [eventsObj setValue:[eventDictionary valueForKey:@"EventName"] forKey:@"eName"];
//            
//            [eventsObj setValue:imagePath forKey:@"eImage"];
//            [eventsObj setValue:thumbImagePath forKey:@"eThumbImage"];
//            [eventsObj setValue:[eventDictionary valueForKey:@"Place"] forKey:@"ePlace"];
//            [eventsObj setValue:[eventDictionary valueForKey:@"Place2"] forKey:@"ePlace2"];
//            [eventsObj setValue:[eventDictionary valueForKey:@"Place3"] forKey:@"ePlace3"];
//            [eventsObj setValue:[eventDictionary valueForKey:@"ZipCode"] forKey:@"eZipCode"];
//            
//            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventFrom"]] forKey:@"eFromDate"];
//            
//            [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventTO"]] forKey:@"eToDate"];
//            
//            [eventsObj setValue:[eventDictionary valueForKey:@"comment"] forKey:@"eComment"];
//            
//            [eventsObj setValue:[eventDictionary valueForKey:@"Lat"] forKey:@"eLat"];
//            [eventsObj setValue:[eventDictionary valueForKey:@"Long"] forKey:@"eLong"];
            
                if ([[eventDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
            isDownloadingImage = TRUE;
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"Image"]]];
            
            [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
            
                }
                if ([[eventDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"ImageThumbnail"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
    
                
                
//            if (![self.managedObjectContextTemp save:&error]) {
//                
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            }
            else {
                
//                Events* eventsObj= [arrayOfEventList objectAtIndex:0];
//                
////                NSString  *imagePath = eventsObj.eImage;
////                NSString *thumbImagePath=eventsObj.eThumbImage;
//                
//                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//                
//                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//                
//                [eventsObj setValue:[eventDictionary valueForKey:@"EventID"] forKey:@"eId"];
//                
//                [eventsObj setValue:[eventDictionary valueForKey:@"EventName"] forKey:@"eName"];
//                                
//                [eventsObj setValue:[eventDictionary valueForKey:@"Place"] forKey:@"ePlace"];
//                [eventsObj setValue:[eventDictionary valueForKey:@"Place2"] forKey:@"ePlace2"];
//                [eventsObj setValue:[eventDictionary valueForKey:@"Place3"] forKey:@"ePlace3"];
//                [eventsObj setValue:[eventDictionary valueForKey:@"ZipCode"] forKey:@"eZipCode"];
//                
//                [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventFrom"]] forKey:@"eFromDate"];
//                
//                [eventsObj setValue: [dateFormatter dateFromString:[eventDictionary valueForKey:@"EventTO"]] forKey:@"eToDate"];
//                
//                [eventsObj setValue:[eventDictionary valueForKey:@"comment"] forKey:@"eComment"];
//                
//                [eventsObj setValue:[eventDictionary valueForKey:@"Lat"] forKey:@"eLat"];
//                [eventsObj setValue:[eventDictionary valueForKey:@"Long"] forKey:@"eLong"];
//                
//                [eventsObj setValue:imagePath forKey:@"eImage"];
//                [eventsObj setValue:thumbImagePath forKey:@"eThumbImage"];
                
                if ([[eventDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"Image"]]];
                
                [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
                }
                
                if ([[eventDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventDictionary valueForKey:@"ImageThumbnail"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
                
//                if (![self.managedObjectContextTemp save:&error]) {
//                    
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }
            }
        }
    }

}

-(void)addeventsGallery:(NSString*)opration
{
    
    NSArray *eventGalleryArray=[self.responceDict objectForKey:@"EventImage"];
    if ([eventGalleryArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[eventGalleryArray count]; i++){
            
            NSDictionary *eventGalleryDictionary=[eventGalleryArray objectAtIndex:i];
            
            
            NSArray *arrayOfEventGallery= [[CoreDataOprations initObject]
                                        fetchRequestAccordingtoCategory:@"EventsGallery" :@"egImageId" :@"egImageId" :[eventGalleryDictionary valueForKey:@"ImageID"] :self.managedObjectContextTemp];
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[eventGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[eventGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[eventGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
                arrayofstring1=[[eventGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
                
            }
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@_%@.%@",[eventGalleryDictionary valueForKey:@"EventID"],[eventGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];
            
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"EventsGallery" forKey:kTableName];
            [recordDetailDictionary setObject:@"egImageId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[eventGalleryDictionary valueForKey:@"ImageID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:eventGalleryDictionary forKey:kDetailDictionary];
            
            
            
            if ([arrayOfEventGallery count]==0) {

//            EventsGallery *eventsGalleryObj= [NSEntityDescription
//                                              insertNewObjectForEntityForName:@"EventsGallery"
//                                              inManagedObjectContext:self.managedObjectContextTemp];
            
               
             
                if ([[eventGalleryDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
                    
                }
                else {

                isDownloadingImage = TRUE;
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"Image"]]];
            [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
               
                }
                
                if ([[eventGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"ImageThumb"]]];
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                    
                }
   
                
//            eventsGalleryObj.egEventID=[eventGalleryDictionary valueForKey:@"EventID"];
//            
//            eventsGalleryObj.egImageName=imagePath;
//            
//            eventsGalleryObj.egImageId=[eventGalleryDictionary valueForKey:@"ImageID"];
//            
//            eventsGalleryObj.egRS=[eventGalleryDictionary valueForKey:@"Caption"];
//            
//            eventsGalleryObj.egImageThumb=thumbImagePath;
            
            // [eventsObj setValue:@"" forKey:@"eGallery"];
            
//            if (![self.managedObjectContextTemp save:&error]) {
//                
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            }
            else {
                
//                EventsGallery *eventsGalleryObj= [arrayOfEventGallery objectAtIndex:0];
                
//                NSString  *imagePath = eventsGalleryObj.egImageName;
//                
//                NSString *thumbImagePath=eventsGalleryObj.egImageThumb;
                
                if ([[eventGalleryDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"Image"]]];
                [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
                    
                }
                
                if ([[eventGalleryDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[eventGalleryDictionary valueForKey:@"ImageThumb"]]];
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                    
                }

                
//                eventsGalleryObj.egEventID=[eventGalleryDictionary valueForKey:@"EventID"];
//                
//                eventsGalleryObj.egImageName=imagePath;
//                
//                eventsGalleryObj.egImageId=[eventGalleryDictionary valueForKey:@"ImageID"];
//                
//                eventsGalleryObj.egRS=[eventGalleryDictionary valueForKey:@"Caption"];
//                
//                eventsGalleryObj.egImageThumb=thumbImagePath;
                
                // [eventsObj setValue:@"" forKey:@"eGallery"];
                
//                if (![self.managedObjectContextTemp save:&error]) {
//                    
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }

            }
        }
    }

}
-(void)addeventsAgenda:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *eventAgendaArray=[self.responceDict objectForKey:@"EventAgenda"];
 
    if ([eventAgendaArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[eventAgendaArray count]; i++){
            
            NSDictionary *eventAgendaDictionary=[eventAgendaArray objectAtIndex:i];
            
            NSArray *arrayOfEventAgenda= [[CoreDataOprations initObject]
                                           fetchRequestAccordingtoCategory:@"EventAgenda" :@"eaId" :@"eaId" :[eventAgendaDictionary valueForKey:@"AgendaID"] :self.managedObjectContextTemp];
            
            if ([arrayOfEventAgenda count]==0) {
                
            EventAgenda *eventAgendaObj= [NSEntityDescription
                                          insertNewObjectForEntityForName:@"EventAgenda"
                                          inManagedObjectContext:self.managedObjectContextTemp];
            
            eventAgendaObj.eaEventID=[eventAgendaDictionary valueForKey:@"EventID"];
            
            eventAgendaObj.eaAgendaName=[eventAgendaDictionary valueForKey:@"AgendaName"];
            eventAgendaObj.eaId=[eventAgendaDictionary valueForKey:@"AgendaID"];
            eventAgendaObj.eaDescription1=[eventAgendaDictionary valueForKey:@"Description1"];
            eventAgendaObj.eaDescription2=[eventAgendaDictionary valueForKey:@"Description2"];
            eventAgendaObj.eaDate=[eventAgendaDictionary valueForKey:@"Date"];
            eventAgendaObj.eaLocation=[eventAgendaDictionary valueForKey:@"Location"];
                        
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            }
            else {
             
                EventAgenda *eventAgendaObj= [arrayOfEventAgenda objectAtIndex:0];
                
                eventAgendaObj.eaEventID=[eventAgendaDictionary valueForKey:@"EventID"];
                
                eventAgendaObj.eaAgendaName=[eventAgendaDictionary valueForKey:@"AgendaName"];
                eventAgendaObj.eaId=[eventAgendaDictionary valueForKey:@"AgendaID"];
                eventAgendaObj.eaDescription1=[eventAgendaDictionary valueForKey:@"Description1"];
                eventAgendaObj.eaDescription2=[eventAgendaDictionary valueForKey:@"Description2"];
                eventAgendaObj.eaDate=[eventAgendaDictionary valueForKey:@"Date"];
                eventAgendaObj.eaLocation=[eventAgendaDictionary valueForKey:@"Location"];
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }
        }
    }

}
-(void)addAboutInfo:(NSString*)opration
{
    NSError *error=nil;
    NSArray *aboutUsArray=[self.responceDict objectForKey:@"AboutInfo"];
    
    if ([aboutUsArray isEqual:[NSNull null]]) {
    }
    else {
        for (int i=0; i<[aboutUsArray count]; i++)
        {
            NSDictionary *aboutUsDictionary=[aboutUsArray objectAtIndex:i];
            
            NSArray *arrayOfEventAgenda= [[CoreDataOprations initObject] fetchRequest:@"AboutLdcInfo" :@"address" :self.managedObjectContextTemp];
                                          
                AboutLdcInfo* aboutLdcInfoObj=[arrayOfEventAgenda objectAtIndex:0];
                
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Address"] forKey:@"address"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Description"] forKey:@"aboutDescription"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Email"] forKey:@"email"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Facebook"] forKey:@"facebook"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Houzz"] forKey:@"houzz"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Location"] forKey:@"location"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"PhotoCredit"] forKey:@"photoCredits"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Telephone"] forKey:@"telephone"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Twitter"] forKey:@"twitter"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Website"] forKey:@"website"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"Pinterest"] forKey:@"pinterest"];
                [aboutLdcInfoObj setValue:[aboutUsDictionary valueForKey:@"StatusMessage"] forKey:@"statusMessage"];
            
            //Added By Umesh to save time zone and country for weather
            NSUserDefaults *userDefaultObj = [NSUserDefaults standardUserDefaults];
            [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"Country"] forKey:KeyWeatherAPICountry];
            [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"TimeZone"] forKey:KeyWeatherAPITimeZone];
            [userDefaultObj setValue:[aboutUsDictionary valueForKey:@"Location"] forKey:KeyWeatherAPICity];
            [userDefaultObj synchronize];
                
                if (![self.managedObjectContextTemp save:&error])
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

        }
    }

}
-(void)addAboutImage:(NSString*)opration
{
    NSArray *aboutImageArray=[self.responceDict objectForKey:@"AboutImage"];
    
    if ([aboutImageArray isEqual:[NSNull null]]) {
    }
    else {
        
        
        for (int i=0; i<[aboutImageArray count]; i++) {
            NSDictionary *aboutImageDictionary=[aboutImageArray objectAtIndex:i];
          
            
            NSArray *arrayOfaboutImageGallery= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"AbotLdcImageGallery" :@"imageId" :@"imageId" :[aboutImageDictionary valueForKey:@"ImgID"] :self.managedObjectContextTemp];
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[aboutImageDictionary valueForKey:@"ImageName"]isEqual:[NSNull null] ]||[[aboutImageDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[aboutImageDictionary valueForKey:@"ImageName"] componentsSeparatedByString:@"."];
                arrayofstring1=[[aboutImageDictionary valueForKey:@"ImageName"] componentsSeparatedByString:@"."];
            }
            
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[aboutImageDictionary valueForKey:@"ImgID"],[arrayofstring lastObject]]];
            
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"AbotLdcImageGallery" forKey:kTableName];
            [recordDetailDictionary setObject:@"imageId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[aboutImageDictionary valueForKey:@"ImgID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:aboutImageDictionary forKey:kDetailDictionary];
            
            if ([arrayOfaboutImageGallery count]==0) {

                
               
   
//           AbotLdcImageGallery* aboutImageObj=[NSEntityDescription insertNewObjectForEntityForName:@"AbotLdcImageGallery" inManagedObjectContext:self.managedObjectContextTemp];
//            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"Caption"] forKey:@"caption"];
//            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"ImgID"] forKey:@"imageId"];
//            [aboutImageObj setValue:imagePath forKey:@"imageName"];
//            [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
            
                if ([[aboutImageDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
                    
                }
                else {
   
                isDownloadingImage = TRUE;
            ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutImageDictionary valueForKey:@"ImageName"]]];
            [requesthttp setDownloadDestinationPath:imagePath];
            [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
            [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"ImageName"]];
            [requesthttp setShouldContinueWhenAppEntersBackground:YES];
            [requesthttp setAllowResumeForFileDownloads:YES];
            [requesthttp setTimeOutSeconds:1500];
            [requesthttp setShowAccurateProgress:YES];
            [networkQueue addOperation:requesthttp];
            
                    
                }
//            if (![self.managedObjectContextTemp save:&error])
//            {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            }
            else {
                
//                AbotLdcImageGallery* aboutImageObj=[arrayOfaboutImageGallery objectAtIndex:0];
//               
////                NSString  *imagePath = aboutImageObj.imageName;
//
//                [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"Caption"] forKey:@"caption"];
//                [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"ImgID"] forKey:@"imageId"];
//                [aboutImageObj setValue:imagePath forKey:@"imageName"];
//                [aboutImageObj setValue:[aboutImageDictionary valueForKey:@"RS"] forKey:@"aboutRS"];
                
                if ([[aboutImageDictionary valueForKey:@"ImageName"] isEqual:[NSNull null]]) {
                    
                }
                else {

                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutImageDictionary valueForKey:@"ImageName"]]];
                [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"ImageName"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
                }
                
//                if (![self.managedObjectContextTemp save:&error])
//                {
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }

            }
        }
    }

}
-(void)addAboutNewsLetter:(NSString*)opration
{
    NSArray *aboutNewsLetterArray=[self.responceDict objectForKey:@"AboutNewsLetter"];
    
    if ([aboutNewsLetterArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[aboutNewsLetterArray count]; i++) {
            
            NSDictionary *aboutNewsLetterDictionary=[aboutNewsLetterArray objectAtIndex:i];
        
            NSArray *arrayOfaboutNewsLetter= [[CoreDataOprations initObject]
                                                fetchRequestAccordingtoCategory:@"AboutLdcNewsLetter" :@"newsletterId" :@"newsletterId" :[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] :self.managedObjectContextTemp];
            
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] componentsSeparatedByString:@"."];
                arrayofstring1=[[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] componentsSeparatedByString:@"."];
                
            }
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[aboutNewsLetterDictionary valueForKey:@"NewsletterID"],[arrayofstring lastObject]]];
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"AboutLdcNewsLetter" forKey:kTableName];
            [recordDetailDictionary setObject:@"newsletterId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:aboutNewsLetterDictionary forKey:kDetailDictionary];
            
            
            if ([arrayOfaboutNewsLetter count]==0) {

                

                
//           AboutLdcNewsLetter* aboutNewsObj=[NSEntityDescription insertNewObjectForEntityForName:@"AboutLdcNewsLetter" inManagedObjectContext:self.managedObjectContextTemp];
//            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:@"newsletterId"];
//            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Month"] forKey:@"month"];
//            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Year"] forKey:@"year"];
//            [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"RS"] forKey:@"aboutLdcRS"];
//            [aboutNewsObj setValue:imagePath forKey:@"newsletterName"];

            if ([[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] isEqual:[NSNull null]]) {
                
            }
            else {
                isDownloadingImage = TRUE;
                ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"]]];
                [requesthttp setDownloadDestinationPath:imagePath];
                [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                [requesthttp setAllowResumeForFileDownloads:YES];
                [requesthttp setTimeOutSeconds:1500];
                [requesthttp setShowAccurateProgress:YES];
                [networkQueue addOperation:requesthttp];
                
            }

//            if (![self.managedObjectContextTemp save:&error])
//            {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            }
            else {
                
//                AboutLdcNewsLetter* aboutNewsObj=[arrayOfaboutNewsLetter objectAtIndex:0];
//                
////                NSString  *imagePath = aboutNewsObj.newsletterName;
//                
//                [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"NewsletterID"] forKey:@"newsletterId"];
//                [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Month"] forKey:@"month"];
//                [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"Year"] forKey:@"year"];
//                [aboutNewsObj setValue:[aboutNewsLetterDictionary valueForKey:@"RS"] forKey:@"aboutLdcRS"];
//                [aboutNewsObj setValue:imagePath forKey:@"newsletterName"];
                
                if ([[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[aboutNewsLetterDictionary valueForKey:@"NewsLetterName"]]];
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                }
                
//                if (![self.managedObjectContextTemp save:&error])
//                {
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }

            }
        }
    }

}
-(void)addFavoriety:(NSString*)opration
{
    
    NSArray *favoiratesArray=[self.responceDict objectForKey:@"Favority"];
    if ([favoiratesArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[favoiratesArray count]; i++){
            
            NSDictionary *favoirateDictionary=[favoiratesArray objectAtIndex:i];
            
            NSArray *arrayOfFavoriety= [[CoreDataOprations initObject]
                                          fetchRequestAccordingtoCategory:@"Favorites" :@"favoriteId" :@"favoriteId" :[favoirateDictionary valueForKey:@"FavorityID"] :self.managedObjectContextTemp];
            
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[favoirateDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[favoirateDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[favoirateDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
                arrayofstring1=[[favoirateDictionary valueForKey:@"ImageThumbnail"] componentsSeparatedByString:@"."];
            }
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring lastObject]]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[favoirateDictionary valueForKey:@"FavorityID"],[arrayofstring1 lastObject]]];
            
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"Favorites" forKey:kTableName];
            [recordDetailDictionary setObject:@"favoriteId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[favoirateDictionary valueForKey:@"FavorityID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:favoirateDictionary forKey:kDetailDictionary];

            
            if ([arrayOfFavoriety count]==0) {

//            Favorites *favoritesObj= [NSEntityDescription
//                                      insertNewObjectForEntityForName:@"Favorites"
//                                      inManagedObjectContext:self.managedObjectContextTemp];
//            
//                
//               
//                
//                
//            favoritesObj.favoriteId=[favoirateDictionary valueForKey:@"FavorityID"];
//            favoritesObj.url=[favoirateDictionary valueForKey:@"Url"];
//            favoritesObj.categoryId=[favoirateDictionary valueForKey:@"CategoryID"];
//            favoritesObj.favdescription=[favoirateDictionary valueForKey:@"Description"];
//            favoritesObj.latitude=[favoirateDictionary valueForKey:@"Lat"];
//            favoritesObj.longitude=[favoirateDictionary valueForKey:@"Long"];
//            favoritesObj.favSubTitle=[favoirateDictionary valueForKey:@"SubTittle"];
//            favoritesObj.favRS=[favoirateDictionary valueForKey:@"RS"];
//            favoritesObj.favImage=imagePath;
//            favoritesObj.favThumbImage=thumbImagePath;
            
                if ([[favoirateDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"Image"]]];
                    
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                if ([[favoirateDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"ImageThumbnail"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
                
//            if (![self.managedObjectContextTemp save:&error]) {
//                
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            }
            else {
               
//                Favorites *favoritesObj= [arrayOfFavoriety objectAtIndex:0];
//                
////                NSString *imagePath=favoritesObj.favImage;
////                NSString *thumbImagePath=favoritesObj.favThumbImage;
//                
//                
//                favoritesObj.favoriteId=[favoirateDictionary valueForKey:@"FavorityID"];
//                favoritesObj.url=[favoirateDictionary valueForKey:@"Url"];
//                favoritesObj.categoryId=[favoirateDictionary valueForKey:@"CategoryID"];
//                favoritesObj.favdescription=[favoirateDictionary valueForKey:@"Description"];
//                favoritesObj.latitude=[favoirateDictionary valueForKey:@"Lat"];
//                favoritesObj.longitude=[favoirateDictionary valueForKey:@"Long"];
//                favoritesObj.favSubTitle=[favoirateDictionary valueForKey:@"SubTittle"];
//                favoritesObj.favRS=[favoirateDictionary valueForKey:@"RS"];
//                favoritesObj.favImage=imagePath;
//                favoritesObj.favThumbImage=thumbImagePath;
                
                
                
                if ([[favoirateDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"Image"]]];
                    
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                if ([[favoirateDictionary valueForKey:@"ImageThumbnail"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[favoirateDictionary valueForKey:@"ImageThumbnail"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
//                if (![self.managedObjectContextTemp save:&error]) {
//                    
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }

            }
        }
    }
}
-(void)addFavCategory:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *categoryArray=[self.responceDict objectForKey:@"Category"];
    if ([categoryArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[categoryArray count]; i++){
            
            NSDictionary *eventDictionary=[categoryArray objectAtIndex:i];
            
            NSArray *arrayOfFavorietyCategory= [[CoreDataOprations initObject]
                                        fetchRequestAccordingtoCategory:@"FavCategory" :@"categoryId" :@"categoryId" :[eventDictionary valueForKey:@"CategoryID"] :self.managedObjectContextTemp];
            
            if ([arrayOfFavorietyCategory count]==0) {

            
            FavCategory *categoryObj= [NSEntityDescription
                                       insertNewObjectForEntityForName:@"FavCategory"
                                       inManagedObjectContext:self.managedObjectContextTemp];
            
            categoryObj.categoryId=[eventDictionary valueForKey:@"CategoryID"];
            categoryObj.categoryName=[eventDictionary valueForKey:@"CategoryName"];
            categoryObj.categoryRS=[eventDictionary valueForKey:@"RS"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            }
            else {
                
                FavCategory *categoryObj= [arrayOfFavorietyCategory objectAtIndex:0];
                
                categoryObj.categoryId=[eventDictionary valueForKey:@"CategoryID"];
                categoryObj.categoryName=[eventDictionary valueForKey:@"CategoryName"];
                categoryObj.categoryRS=[eventDictionary valueForKey:@"RS"];
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }
        }
    }

}
-(void)addAppPassword:(NSString*)opration
{
    NSError *error=nil;
    
    NSArray *appsPasswordArray=[self.responceDict objectForKey:@"AppsPassword"];
    if ([appsPasswordArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[appsPasswordArray count]; i++){
            
            NSDictionary *appsPasswordDictionary=[appsPasswordArray objectAtIndex:i];
            
            
            NSArray *arrayOfAppPasword= [[CoreDataOprations initObject]
                                                fetchRequestAccordingtoCategory:@"AppsPassword" :@"appsId" :@"appsId" :[appsPasswordDictionary valueForKey:@"AppsID"] :self.managedObjectContextTemp];
            
            if ([arrayOfAppPasword count]==0) {

            AppsPassword*appsPasswordObj= [NSEntityDescription
                                           insertNewObjectForEntityForName:@"AppsPassword"
                                           inManagedObjectContext:self.managedObjectContextTemp];
            
            appsPasswordObj.appsId=[appsPasswordDictionary valueForKey:@"AppsID"];
            appsPasswordObj.title=[appsPasswordDictionary valueForKey:@"Tittle"];
            appsPasswordObj.password=[appsPasswordDictionary valueForKey:@"Password"];
            appsPasswordObj.dateAdded=[appsPasswordDictionary valueForKey:@"DateAdded"];
        
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
                
            }
            else {
                
                AppsPassword*appsPasswordObj= [arrayOfAppPasword objectAtIndex:0];
                
                appsPasswordObj.appsId=[appsPasswordDictionary valueForKey:@"AppsID"];
                appsPasswordObj.title=[appsPasswordDictionary valueForKey:@"Tittle"];
                appsPasswordObj.password=[appsPasswordDictionary valueForKey:@"Password"];
                appsPasswordObj.dateAdded=[appsPasswordDictionary valueForKey:@"DateAdded"];
            
              if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

            }
        }
    }

}

-(void)addEmailLinks
{
    NSError *error=nil;
    
    NSArray *emailLinksArray=[self.responceDict objectForKey:@"EmailLink"];
    if ([emailLinksArray isEqual:[NSNull null]]) {
    }
    else {
        
        
        for (int i=0; i<[emailLinksArray count]; i++){
            
            NSDictionary *emailLinksDictionary=[emailLinksArray objectAtIndex:i];
            
            NSArray *arrayOfEmailLinks= [[CoreDataOprations initObject]
                                         fetchRequestAccordingtoCategory:@"EmailLinks" :@"accessId" :@"accessId" :[emailLinksDictionary valueForKey:@"AccessID"] :self.managedObjectContextTemp];

            if ([arrayOfEmailLinks count]==0) {

            EmailLinks*emailLinksObj= [NSEntityDescription
                                       insertNewObjectForEntityForName:@"EmailLinks"
                                       inManagedObjectContext:self.managedObjectContextTemp];
            
            emailLinksObj.accessId =[emailLinksDictionary valueForKey:@"AccessID"];
            emailLinksObj.email=[emailLinksDictionary valueForKey:@"Email"];
            emailLinksObj.type=[emailLinksDictionary valueForKey:@"Type"];
            
            if (![self.managedObjectContextTemp save:&error]) {
                
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            }
            else {
             
                EmailLinks*emailLinksObj= [arrayOfEmailLinks objectAtIndex:0];
                
                emailLinksObj.accessId =[emailLinksDictionary valueForKey:@"AccessID"];
                emailLinksObj.email=[emailLinksDictionary valueForKey:@"Email"];
                emailLinksObj.type=[emailLinksDictionary valueForKey:@"Type"];
                
                if (![self.managedObjectContextTemp save:&error]) {
                    
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

                
            }
        }
    }
    
}
-(void)addHomeGallery
{
    
    NSArray *homeGalleryArray=[self.responceDict objectForKey:@"HomeGallery"];
    if ([homeGalleryArray isEqual:[NSNull null]]) {
    }
    else {
        
        
        for (int i=0; i<[homeGalleryArray count]; i++){
            
            NSDictionary *homeGalleryDictionary=[homeGalleryArray objectAtIndex:i];
            
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[homeGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[homeGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
             arrayofstring=[[homeGalleryDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
             arrayofstring1=[[homeGalleryDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
            }
            
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring lastObject]]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[homeGalleryDictionary valueForKey:@"ImageID"],[arrayofstring1 lastObject]]];

            
            NSArray *arrayOfhomeGallery= [[CoreDataOprations initObject]
                                    fetchRequestAccordingtoCategory:@"HomeGallery" :@"imageId" :@"imageId" :[homeGalleryDictionary valueForKey:@"ImageID"] :self.managedObjectContextTemp];
            
            if ([arrayOfhomeGallery count]==0) {
                
//                HomeGallery*homeGalleryObj= [NSEntityDescription
//                                           insertNewObjectForEntityForName:@"HomeGallery"
//                                           inManagedObjectContext:self.managedObjectContextTemp];
//                
//                homeGalleryObj.imageId =[homeGalleryDictionary valueForKey:@"ImageID"];
//                homeGalleryObj.image=imagePath;
//                homeGalleryObj.imageThumb=thumbImagePath;
                NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
                [recordDetailDictionary setObject:@"HomeGallery" forKey:kTableName];
                [recordDetailDictionary setObject:@"imageId" forKey:kAttributeName];
                [recordDetailDictionary setObject:[homeGalleryDictionary valueForKey:@"ImageID"] forKey:kAttributeValue];
                [recordDetailDictionary setObject:homeGalleryDictionary forKey:kDetailDictionary];
                
                if ([[homeGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"Image"]]];
                    
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                if ([[homeGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"ImageThumb"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
                
//                if (![self.managedObjectContextTemp save:&error]) {
//                    
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }
            }
            else {
                
//                HomeGallery*homeGalleryObj= [arrayOfhomeGallery objectAtIndex:0];
//                
////                NSString *imagePath=homeGalleryObj.image;
////                NSString *thumbImagePath=homeGalleryObj.imageThumb;
//                
//                homeGalleryObj.imageId =[homeGalleryDictionary valueForKey:@"ImageID"];
//                homeGalleryObj.image=imagePath;
//                homeGalleryObj.imageThumb=thumbImagePath;
                
                NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
                [recordDetailDictionary setObject:@"HomeGallery" forKey:kTableName];
                [recordDetailDictionary setObject:@"imageId" forKey:kAttributeName];
                [recordDetailDictionary setObject:[homeGalleryDictionary valueForKey:@"ImageID"] forKey:kAttributeValue];
                [recordDetailDictionary setObject:homeGalleryDictionary forKey:kDetailDictionary];
                
                if ([[homeGalleryDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"Image"]]];
                    
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }
                if ([[homeGalleryDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[homeGalleryDictionary valueForKey:@"ImageThumb"]]];
                    
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:thumbImagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                }

                
//                if (![self.managedObjectContextTemp save:&error]) {
//                    
//                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
//                }
                
                
            }
        }
    }
    
}
-(void)addSponsor:(NSString*)opration
{
    
    NSArray *sponsorArray=[self.responceDict objectForKey:@"Sponser"];
    if ([sponsorArray isEqual:[NSNull null]]) {
    }
    else {
        
        for (int i=0; i<[sponsorArray count]; i++){
            
            NSDictionary *sponsorDictionary=[sponsorArray objectAtIndex:i];
            
            
            NSArray *arrayOfSponsor= [[CoreDataOprations initObject]
                                           fetchRequestAccordingtoCategory:@"Sponsor" :@"sponsorId" :@"sponsorId" :[sponsorDictionary valueForKey:@"SponserID"] :self.managedObjectContextTemp];
            
            NSArray *arrayofstring;
            NSArray *arrayofstring1;
            
            if ([[sponsorDictionary valueForKey:@"Image"] isEqual:[NSNull null]]||[[sponsorDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                
                arrayofstring=[[NSArray alloc]initWithObjects:@"png",nil];
                arrayofstring1=[[NSArray alloc]initWithObjects:@"png",nil];
            }
            else {
                arrayofstring=[[sponsorDictionary valueForKey:@"Image"] componentsSeparatedByString:@"."];
                arrayofstring1=[[sponsorDictionary valueForKey:@"ImageThumb"] componentsSeparatedByString:@"."];
                
            }
            NSString *imagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring lastObject]]];
            NSString *thumbImagePath = [[self documentCatchePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumb%@.%@",[sponsorDictionary valueForKey:@"SponserID"],[arrayofstring1 lastObject]]];
            
            
            NSMutableDictionary *recordDetailDictionary = [[NSMutableDictionary alloc] init];
            [recordDetailDictionary setObject:@"Sponsor" forKey:kTableName];
            [recordDetailDictionary setObject:@"sponsorId" forKey:kAttributeName];
            [recordDetailDictionary setObject:[sponsorDictionary valueForKey:@"SponserID"] forKey:kAttributeValue];
            [recordDetailDictionary setObject:sponsorDictionary forKey:kDetailDictionary];
            
            
            
            if ([arrayOfSponsor count]==0) {
                
                if ([[sponsorDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"Image"]]];
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                }
                
                if ([[sponsorDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"ImageThumb"]]];
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                    
                }
            
            }
            else {
                                
                if ([[sponsorDictionary valueForKey:@"Image"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"Image"]]];
                    [requesthttp setDownloadDestinationPath:imagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                    
                }
                
                if ([[sponsorDictionary valueForKey:@"ImageThumb"] isEqual:[NSNull null]]) {
                    
                }
                else {
                    
                    isDownloadingImage = TRUE;
                    ASIHTTPRequest*requesthttp = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[sponsorDictionary valueForKey:@"ImageThumb"]]];
                    [requesthttp setDownloadDestinationPath:thumbImagePath];
                    [requesthttp setDownloadedDataDetailDictionary:recordDetailDictionary];
                    [requesthttp setUserInfo:[NSDictionary dictionaryWithObject:imagePath forKey:@"name"]];
                    [requesthttp setShouldContinueWhenAppEntersBackground:YES];
                    [requesthttp setAllowResumeForFileDownloads:YES];
                    [requesthttp setTimeOutSeconds:1500];
                    [requesthttp setShowAccurateProgress:YES];
                    [networkQueue addOperation:requesthttp];
                    
                    
                }
                
            }
        }
    }
    
}
- (void)imageFetchComplete1:(ASIHTTPRequest *)request
{
    [self preventFileFromBeingBackUpOniCloud:[NSURL fileURLWithPath:[request downloadDestinationPath]]];
    [self addUpdateRecord:request.downloadedDataDetailDictionary];

    NSLog(@"downloadcomnpleted");
    
}
- (void)imageFetchFailed1:(ASIHTTPRequest *)request
{
    NSLog(@"downloadfail");
    
    //[networkQueue addOperation:request];
    
//    NSLog(@"URL :%@",[request url]);
    
}
- (void)imageFetchQeue1:(ASIHTTPRequest *)request
{
    settingObj.downloadLable.text=@"Download Complete";
    [settingObj.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
    [settingObj progress:1.0];
    
    
    if (!isCancelled) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.responceDict valueForKey:@"SyncDateTime"] forKey:@"Synchdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self replaceTheOldDatabaseFileWithNewOne];
        AppDelegate * appDelegateObl=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDelegateObl deleteExistingCoredataManagedObject];
//        NSLog(@"not canceled so save it");
    }
    else{
        [self removeTempDatabase];
    }
    
    
    
    settingObj.userInteractionEnabled=TRUE;
//    NSLog(@"download");
}
-(void)replaceTheOldDatabaseFileWithNewOne{
    
    
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel_Temp.sqlite"];
//	success = [fileManager fileExistsAtPath:writableDBPath];
//	if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
    success = [fileManager removeItemAtPath:defaultDBPath error:&error];
    if (success) {
//        NSLog(@"done removing old database file");
        success = [fileManager copyItemAtPath:writableDBPath toPath:defaultDBPath error:&error];
        if (success) {
//            NSLog(@"done adding temp with new name(Old file name)");
           success = [fileManager removeItemAtPath:writableDBPath error:&error];
            if (success) {
//                NSLog(@"done removing temp file");
            }
            else{
//                NSLog(@"error temp: %@",error);
            }
        }
        else{
//            NSLog(@"error adding temp as old : %@",error);
        }
    }
    else{
//         NSLog(@"error old file: %@",error);
    }
//	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    
    
}

-(void)removeTempDatabase{
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel_Temp.sqlite"];
     success = [fileManager removeItemAtPath:writableDBPath error:&error];
//    if (success) {
//        NSLog(@"done removing temp database file");
//    }
//    else{
//        NSLog(@"Unable to delete temp database file");
//    }
    
}
-(void)preventFileFromBeingBackUpOniCloud:(NSURL *)fileUrl{
    // Added By Umesh to add do not back up attribute to a file
    
    float currentVersion = 5.1;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion){
        [self addSkipBackupAttributeToItemAtURL:fileUrl];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 5.1){
        [self addSkipBackupAttributeToItemAtURLBelowiOS5_1:fileUrl];
    }
    
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    else
        NSLog(@"excluding from backup done ");
    return success;
}

- (BOOL)addSkipBackupAttributeToItemAtURLBelowiOS5_1:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


//Added By Umesh to create temp data base and update it and then rename that file if upload is successful else remove the temp file

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContextTemp;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContextTemp
{
    if (_managedObjectContextTemp != nil) {
        return _managedObjectContextTemp;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContextTemp = [[NSManagedObjectContext alloc] init];
        [_managedObjectContextTemp setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContextTemp;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModelTemp
{
    if (_managedObjectModelTemp != nil) {
        return _managedObjectModelTemp;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LdcCoreDataModel" withExtension:@"momd"];
    _managedObjectModelTemp = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModelTemp;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinatorTemp != nil) {
        return _persistentStoreCoordinatorTemp;
    }
    [self createTemporaryEditableCopyOfDatabaseIfNeeded];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LdcCoreDataModel_Temp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinatorTemp = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModelTemp]];
    if (![_persistentStoreCoordinatorTemp addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinatorTemp;
}

//- (void)createEditableCopyOfDatabaseIfNeeded {
//    
//	BOOL success;
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSError *error;
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
//	success = [fileManager fileExistsAtPath:writableDBPath];
//    
//    NSUserDefaults *userDefaultObj = [NSUserDefaults standardUserDefaults];
//    [userDefaultObj setValue:@"Germany" forKey:KeyWeatherAPICountry];
//    [userDefaultObj setValue:@"W. Europe Standard Time" forKey:KeyWeatherAPITimeZone];
//    [userDefaultObj setValue:@"Berlin" forKey:KeyWeatherAPICity];
//    [userDefaultObj synchronize];
//    
//	if (success) return;
//	
//	// The writable database does not exist, so copy the default to the appropriate location.
//	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
//	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//    
//	if (!success) {
//        
//		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//        
//	}
//}
- (void)createTemporaryEditableCopyOfDatabaseIfNeeded{
    
    
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel_Temp.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	
	// The writable database does not exist, so copy the default to the appropriate location.
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:@"LdcCoreDataModel.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
        
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
	}
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}







@end
