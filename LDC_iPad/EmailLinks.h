//
//  EmailLinks.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EmailLinks : NSManagedObject

@property (nonatomic, retain) NSString * accessId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * type;

@end
