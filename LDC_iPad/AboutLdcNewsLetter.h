//
//  AboutLdcNewsLetter.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AboutLdcNewsLetter : NSManagedObject

@property (nonatomic, retain) NSString * aboutLdcRS;
@property (nonatomic, retain) NSString * aboutNewsLetterSyncDateTime;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * newsletterId;
@property (nonatomic, retain) NSString * newsletterName;
@property (nonatomic, retain) NSString * newsLetterThumb;
@property (nonatomic, retain) NSString * year;

@end
