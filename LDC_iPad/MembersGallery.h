//
//  MembersGallery.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MembersGallery : NSManagedObject

@property (nonatomic, retain) NSString * mgCaption;
@property (nonatomic, retain) NSString * mgImageId;
@property (nonatomic, retain) NSString * mgImagePath;
@property (nonatomic, retain) NSString * mgImageThumb;
@property (nonatomic, retain) NSString * mgMemberImageGalleryStateSyncDateTime;
@property (nonatomic, retain) NSString * mgMembersId;
@property (nonatomic, retain) NSString * mgRS;
@property (nonatomic, retain) NSNumber * mgImagePosition;

@end
