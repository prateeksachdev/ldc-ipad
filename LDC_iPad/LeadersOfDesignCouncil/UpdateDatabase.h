//
//  UpdateDatabase.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 05/03/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate,ASINetworkQueue,SettingsView,ASIHTTPRequest;
@class ASIFormDataRequest;
@interface UpdateDatabase : NSObject{
    BOOL isCancelled;
    BOOL isDownloadingImage;
}
@property (nonatomic,retain)NSDictionary *responceDict;
@property (nonatomic,retain)AppDelegate *appDelegate;
@property (nonatomic,retain)ASINetworkQueue *networkQueue;
@property (nonatomic,retain)id delegate;
@property (nonatomic,retain)SettingsView *settingObj;


@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContextTemp;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModelTemp;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinatorTemp;


+(UpdateDatabase*)initObject;
-(void)addFiles:(id)sender;
- (void)imageFetchComplete1:(ASIHTTPRequest *)request;
- (void)imageFetchFailed1:(ASIHTTPRequest *)request;
- (void)imageFetchQeue1:(ASIHTTPRequest *)request;
-(void)cancelUpdate;

-(void)addUpdateRecord:(NSMutableDictionary *)downloadedImageDetail;
-(void)replaceTheOldDatabaseFileWithNewOne;
-(void)removeTempDatabase;
-(NSString*)documentCatchePath;
@end
