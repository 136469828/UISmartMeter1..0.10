#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString *title;
    NSString    *_imageUrl;
    int typeNum;
    int step;
}

@property  CLLocationDegrees _latitude;
@property  CLLocationDegrees _longitude;

@property (nonatomic,strong)    NSString *title;
@property (nonatomic,strong)    NSString    *imageUrl;
@property  int typeNum;
@property  int step;

@property (nonatomic) int arraySortNum;   // 使用的元素是数组中的第几个

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
