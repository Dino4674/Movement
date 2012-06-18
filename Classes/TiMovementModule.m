/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiMovementModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface  TiMovementModule ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CMMotionManager *motionManager;

@end

@implementation TiMovementModule

@synthesize motionManager, locationManager;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
    return @"3d2abdb6-bafb-451c-931d-a979dcc1ea78";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
    return @"ti.movement";
}

-(CLLocationManager *)locationManager {
    
    if(locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return locationManager;
}

-(CMMotionManager *)motionManager {
    if(motionManager == nil) {
        motionManager = [[CMMotionManager alloc] init];
    }
    
    return motionManager;
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
    NSLog(@"[INFO] %@ loaded",self);
}



-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}


#pragma mark Cleanup 

-(void)dealloc
{
    RELEASE_TO_NIL(self.locationManager);
    RELEASE_TO_NIL(self.motionManager);
    
	[super dealloc];
}

#pragma mark Constans

MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST,kCLLocationAccuracyBest);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST_FOR_NAVIGATION, kCLLocationAccuracyBestForNavigation);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_THREE_KILOMETERS, kCLLocationAccuracyThreeKilometers);

MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_TRUE_NORTH, CMAttitudeReferenceFrameXTrueNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_MAGNETIC_NORTH, CMAttitudeReferenceFrameXMagneticNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_CORRECTED, CMAttitudeReferenceFrameXArbitraryCorrectedZVertical);

#pragma Public APIs

- (void)startMovementUpdates:(id)args
{
    ENSURE_UI_THREAD(startMovementUpdates, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    BOOL startLocationUpdates = [TiUtils boolValue:[args objectForKey : @"location"]];
    BOOL startRotationUpdates = [TiUtils boolValue:[args objectForKey : @"rotation"]];
    
    if(startRotationUpdates) {
        
        NSNumber *rotationReferenceFrame = [args objectForKey : @"rotationReferenceFrame"];
        
        if (rotationReferenceFrame != NULL) {
            
            if([rotationReferenceFrame isEqual:self.ROTATION_REFERENCE_FRAME_TRUE_NORTH]) {
                
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
                [self.locationManager startUpdatingLocation];   
            }
            
            [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:[rotationReferenceFrame doubleValue]];
        } else {
            [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        }
    }
    
    if(startLocationUpdates) {
        
        NSNumber *locationAccuracy = [args objectForKey : @"locationAccuracy"];
        
        if(locationAccuracy != NULL) {
            self.locationManager.desiredAccuracy = [locationAccuracy doubleValue];
        } else {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        }
        
        [self.locationManager startUpdatingLocation];   
    }
    
    NSLog(@"[INFO] started movement updates.");
}

- (void)stopMovementUpdates:(id)args
{    
    [self.locationManager stopUpdatingLocation];
    [self.motionManager stopDeviceMotionUpdates];
    
    NSLog(@"[INFO] stopped movement updates.");
}

- (NSDictionary *) currentMovement
{
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude], @"longitude",
                              [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude], @"latitude",
                              [NSNumber numberWithDouble:self.locationManager.location.altitude], @"altitude",
                              nil];
    
    NSDictionary *rotation = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.roll], @"roll",
                              [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.pitch], @"pitch",
                              [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.yaw], @"yaw",
                              nil];
    NSDictionary *movementData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  location, @"location",
                                  rotation, @"rotation",
                                  nil];
    
    return movementData;
}

@end