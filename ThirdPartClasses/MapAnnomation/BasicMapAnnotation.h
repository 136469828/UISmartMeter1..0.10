#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//@import MapKit;
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
    NSString *subtitle;

    NSString    *_imageUrl;
    NSString *strPriceForHotel;
    int typeNum;
    int step;
    
    int status;
    
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *strPriceForHotel;

@property int typeNum;
@property int step;

@property int status;

@property (nonatomic) int arraySortNum;   // 使用的元素是数组中的第几个

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
