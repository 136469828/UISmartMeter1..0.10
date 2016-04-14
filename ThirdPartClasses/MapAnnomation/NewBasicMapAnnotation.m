//
//  NewBasicMapAnnotation.m
//  UISmartMeter
//
//  Created by RealTmac on 15-4-7.
//  Copyright (c) 2015年 RealTmac . All rights reserved.
//


#import "NewBasicMapAnnotation.h"

@implementation NewBasicMapAnnotation

@synthesize _latitude;
@synthesize _longitude;
@synthesize title = _title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude {
    if (self = [super init]) {
        self._latitude = latitude;
        self._longitude = longitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self._latitude;
    coordinate.longitude = self._longitude;
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self._latitude = newCoordinate.latitude;
    self._longitude = newCoordinate.longitude;
}


@end
