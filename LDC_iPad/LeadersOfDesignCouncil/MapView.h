//
//  MapView.h
//  LeadersOfDesignCouncil
//
//  Created by Mobikasa on 1/28/13.
//  Copyright (c) 2013 Mobikasa_Jan2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class SourcePin;
@interface MapView : UIView<MKMapViewDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet MKMapView *mapObj;
    MKUserLocation *userCurrentLocation;
    id delegate;
    SEL selectorBackButtonClicked;
}
@property(nonatomic,retain)IBOutlet MKMapView *mapObj;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)SourcePin *sorPin;
@property(nonatomic,retain)id delegate;
@property(nonatomic, assign)SEL selectorBackButtonClicked;
-(IBAction)backButtonAction:(id)sender;
-(IBAction)navigatorAction:(id)sender;
-(IBAction)shareAction:(id)sender;
-(void)addanotation;
@end
