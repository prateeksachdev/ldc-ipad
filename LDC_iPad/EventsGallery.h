//
//  EventsGallery.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventsGallery : NSManagedObject

@property (nonatomic, retain) NSString * egEventID;
@property (nonatomic, retain) NSString * egEventImageSyncDateTime;
@property (nonatomic, retain) NSString * egImageId;
@property (nonatomic, retain) NSString * egImageName;
@property (nonatomic, retain) NSString * egImageThumb;
@property (nonatomic, retain) NSString * egCaption;
@property (nonatomic, retain) NSNumber * egImagePosition;

@end
