//
//  Events.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * eComment;
@property (nonatomic, retain) NSDate * eFromDate;
@property (nonatomic, retain) NSData * eGallery;
@property (nonatomic, retain) NSString * eId;
@property (nonatomic, retain) NSString * eImage;
@property (nonatomic, retain) NSString * eLat;
@property (nonatomic, retain) NSString * eLong;
@property (nonatomic, retain) NSString * eName;
@property (nonatomic, retain) NSString * ePlace;
@property (nonatomic, retain) NSString * ePlace2;
@property (nonatomic, retain) NSString * ePlace3;
@property (nonatomic, retain) NSString * eRS;
@property (nonatomic, retain) NSString * eThumbImage;
@property (nonatomic, retain) NSDate * eToDate;
@property (nonatomic, retain) NSString * eZipCode;
@property (nonatomic, retain) NSString * eLongName;

@end
