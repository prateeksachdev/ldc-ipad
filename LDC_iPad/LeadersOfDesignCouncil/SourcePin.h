//
//  SourcePin.h
//  AirportCheck
//
//  Created by P Prabhakar on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mapkit/Mapkit.h"

@interface SourcePin : NSObject<MKAnnotation>

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *subTitle;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;

@end
