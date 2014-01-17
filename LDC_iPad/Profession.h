//
//  Profession.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profession : NSManagedObject

@property (nonatomic, retain) NSString * professionId;
@property (nonatomic, retain) NSString * professionName;
@property (nonatomic, retain) NSString * professionRS;
@property (nonatomic, retain) NSString * professionSyncDateTime;

@end
