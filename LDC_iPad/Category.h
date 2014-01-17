//
//  Category.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa_Jan2013 on 20/02/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorites;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * categoryRS;
@property (nonatomic, retain) NSString * categorySynchDate;
@property (nonatomic, retain) Favorites *catagoryFav;

@end
