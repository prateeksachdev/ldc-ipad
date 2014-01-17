//
//  State.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contitent, Country;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * contitentId;
@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * stateId;
@property (nonatomic, retain) NSString * stateName;
@property (nonatomic, retain) NSString * stateSyncDateTime;
@property (nonatomic, retain) Contitent *stateContinent;
@property (nonatomic, retain) Country *stateCountry;

@end
