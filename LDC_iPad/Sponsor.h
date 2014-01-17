//
//  Sponsor.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 4/8/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sponsor : NSManagedObject

@property (nonatomic, retain) NSString * sUrl;
@property (nonatomic, retain) NSString * sImageName;
@property (nonatomic, retain) NSString * sDescription;
@property (nonatomic, retain) NSString * sponsorId;
@property (nonatomic, retain) NSString * sThumbImageName;

@end
