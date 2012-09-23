//
//  RecordViewController.h
//  klaxpont
//
//  Created by François Benaiteau on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RecordViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    // Location manager used for video recording localisation
    CLLocationManager *_locationManager;
    
    // Store the last location update time to ensure right video relation
    NSDate *_lastLocationEventDate;
    
    // Bool value to inform that location storage is needed
    BOOL _storeLocation;
}

// Last location recorded. Nil if no location available
@property (nonatomic, readonly) CLLocation *location;

-(void) showRecorder;
@end
