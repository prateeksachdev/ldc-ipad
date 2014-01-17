//
//  AppsPassword.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppsPassword : NSManagedObject

@property (nonatomic, retain) NSString * appsId;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * title;

@end
