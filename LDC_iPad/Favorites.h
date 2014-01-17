//
//  Favorites.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavCategory;

@interface Favorites : NSManagedObject

@property (nonatomic, retain) NSString * catagoryName;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * favdescription;
@property (nonatomic, retain) NSString * favImage;
@property (nonatomic, retain) NSString * favoriteId;
@property (nonatomic, retain) NSString * favoritesSynchDate;
@property (nonatomic, retain) NSString * favRS;
@property (nonatomic, retain) NSString * favSubTitle;
@property (nonatomic, retain) NSString * favThumbImage;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) FavCategory *favCategory;

@end
