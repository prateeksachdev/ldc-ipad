//
//  SourcePin.m
//  AirportCheck
//
//  Created by P Prabhakar on 14/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SourcePin.h"

@implementation SourcePin
@synthesize title,subTitle,latitude,longitude;
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = latitude;
    theCoordinate.longitude = longitude;
    return theCoordinate;
}

- (NSString *)title 
{
    return title;
}

// optional
- (NSString *)subtitle
{
    return subTitle;
}

@end
