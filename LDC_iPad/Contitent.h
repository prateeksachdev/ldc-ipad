//
//  Contitent.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, State;

@interface Contitent : NSManagedObject

@property (nonatomic, retain) NSString * continentsSyncDateTime;
@property (nonatomic, retain) NSString * contitentId;
@property (nonatomic, retain) NSString * contitentName;
@property (nonatomic, retain) Country *continentCountry;
@property (nonatomic, retain) State *continentState;

@end
