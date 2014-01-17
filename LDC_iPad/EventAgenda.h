//
//  EventAgenda.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventAgenda : NSManagedObject

@property (nonatomic, retain) NSString * eaAgendaName;
@property (nonatomic, retain) NSString * eaDate;
@property (nonatomic, retain) NSString * eaDescription1;
@property (nonatomic, retain) NSString * eaDescription2;
@property (nonatomic, retain) NSString * eaEventAgendaSyncDateTime;
@property (nonatomic, retain) NSString * eaEventID;
@property (nonatomic, retain) NSString * eaId;
@property (nonatomic, retain) NSString * eaLocation;

@end
