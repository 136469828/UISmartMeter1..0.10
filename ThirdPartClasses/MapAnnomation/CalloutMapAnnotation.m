#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize _latitude;
@synthesize _longitude;
@synthesize title;
@synthesize typeNum;
@synthesize imageUrl = _imageUrl;
@synthesize step;

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

@end
