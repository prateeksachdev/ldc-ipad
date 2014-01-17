//
//  HomeGallery.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HomeGallery : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imageThumb;

@end
