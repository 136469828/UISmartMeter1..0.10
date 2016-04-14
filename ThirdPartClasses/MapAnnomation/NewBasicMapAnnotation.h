//
//  NewBasicMapAnnotation.h
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NewBasicMapAnnotation : NSObject<MKAnnotation>
{
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSString *_title;
}

@property (nonatomic, retain) NSString *title;

@property  CLLocationDegrees _latitude;
@property  CLLocationDegrees _longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
