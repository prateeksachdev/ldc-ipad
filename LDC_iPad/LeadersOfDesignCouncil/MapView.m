//
//  MapView.m
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/28/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import "MapView.h"
#import "Constants.h"
#import "SourcePin.h"
@implementation MapView
@synthesize titleLabel,mapObj,sorPin;
@synthesize delegate, selectorBackButtonClicked;        //Added By Umesh on 04 March 2013
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil];
        UIView *viewObj = [viewArray objectAtIndex:0];
        [self addSubview:viewObj];
    }
    [self.mapObj setDelegate:self];
    self.mapObj.showsUserLocation = YES; 
    self.titleLabel.textColor=kLightWhiteColor;
    self.titleLabel.font=[UIFont fontWithName:FontLight size:20];
//    SourcePin *sorPin = [[SourcePin alloc] init];

    return self;
}
-(void)addanotation
{
    [self.mapObj addAnnotation:sorPin];
    MKCoordinateRegion region;
    region.center.latitude = sorPin.latitude;
    region.center.longitude = sorPin.longitude;
    
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta= 0.3;
    [self.mapObj setRegion:region animated:YES];

}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userCurrentLocation = userLocation;
//    NSLog(@"userLocation : %@",userLocation);
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"location"];
    if (![annotation isKindOfClass:[MKUserLocation class]])
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
        aView.canShowCallout = YES;
        
        
//        UIButton *accessoryButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        [accessoryButton setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
//        accessoryButton.frame=CGRectMake(0, 0, 24, 25);
//        aView.rightCalloutAccessoryView =accessoryButton;
//        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    }
   // [(UIImageView *)aView.leftCalloutAccessoryView setImage:[UIImage imageNamed:@"car_icon.png"]];
    aView.annotation = annotation;
    return aView;
}
-(IBAction)backButtonAction:(id)sender{
    //Added By Umesh on 04 March 2013
    if ([delegate respondsToSelector:selectorBackButtonClicked]) {
        [delegate performSelector:selectorBackButtonClicked withObject:@"False" afterDelay:0.0];
    }
    [self removeFromSuperview];
}
-(IBAction)navigatorAction:(id)sender{
    
    [self.mapObj setCenterCoordinate:userCurrentLocation.location.coordinate animated:NO];
//    if ([self.mapObj userTrackingMode] != MKUserTrackingModeFollowWithHeading)
//    {
////        [self.mapObj setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//        
//        
//    }
}
-(IBAction)shareAction:(id)sender{
//    NSLog(@"shareAction");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/?ll=%f,%f",sorPin.latitude,sorPin.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
    else{
        NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",sorPin.latitude,sorPin.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
