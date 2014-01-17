//
//  AboutLdcInfo.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AboutLdcInfo : NSManagedObject

@property (nonatomic, retain) NSString * aboutDescription;
@property (nonatomic, retain) NSString * aboutInfoSyncDateTime;
@property (nonatomic, retain) NSString * aboutRS;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * houzz;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) id photoCredits;
@property (nonatomic, retain) NSString * pinterest;
@property (nonatomic, retain) NSString * statusMessage;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * website;

@end
