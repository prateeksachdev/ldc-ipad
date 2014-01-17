//
//  Country.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contitent, State;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * contitentId;
@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSString * countrySyncDateTime;
@property (nonatomic, retain) Contitent *countryContinent;
@property (nonatomic, retain) State *countryState;

@end
