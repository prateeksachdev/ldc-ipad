//
//  AppDelegate.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 21/01/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memebers.h"
#import "Contitent.h"
#import "Country.h"
#import "State.h"
#import "Events.h"
#import "FavCategory.h"
//#import "Category.h"
#import "Favorites.h"
#import "AboutLdcInfo.h"
#import "AbotLdcImageGallery.h"
#import "AboutLdcNewsLetter.h"
#import "MembersGallery.h"
#import "SettingsView.h"
#import "EventsGallery.h"

 @class ViewController,HomeViewController;
@class ASIHTTPRequest,ASIFormDataRequest,ASINetworkQueue;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) HomeViewController *homeViewController;

@property (strong, nonatomic)NSMutableDictionary * responseDictionary;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,retain)Memebers *membersObj;
@property(nonatomic,retain)Contitent *contitentObj;
@property(nonatomic,retain)Country *countryObj;
@property(nonatomic,retain)State *stateObj;
@property(nonatomic,retain)Events *eventsObj;
@property(nonatomic,retain)MembersGallery*membersGalleryObj;
@property(nonatomic,retain)AboutLdcInfo *aboutLdcInfoObj;
@property(nonatomic,retain)AbotLdcImageGallery *aboutImageObj;
@property(nonatomic,retain)AboutLdcNewsLetter *aboutNewsObj;
@property(nonatomic,retain)SettingsView *settingView;
@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic,strong)ASINetworkQueue *networkQueue;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//Added By Umesh to add database.
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)createTemporaryEditableCopyOfDatabaseIfNeeded;
-(void)deleteExistingCoredataManagedObject;

@end
