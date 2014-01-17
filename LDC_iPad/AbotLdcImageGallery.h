//
//  AbotLdcImageGallery.h
//  LeadersOfDesignCouncil
//
//  Created by Prateek Sachdev on 3/16/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AbotLdcImageGallery : NSManagedObject

@property (nonatomic, retain) NSString * aboutImageSyncDateTime;
@property (nonatomic, retain) NSString * aboutRS;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imageThumb;
@property (nonatomic, retain) NSNumber * imagePosition;

@end
