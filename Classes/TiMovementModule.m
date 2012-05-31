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


MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST,kCLLocationAccuracyBest);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST_FOR_NAVIGATION, kCLLocationAccuracyBestForNavigation);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_THREE_KILOMETERS, kCLLocationAccuracyThreeKilometers);

MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_TRUE_NORTH, CMAttitudeReferenceFrameXTrueNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_MAGNETIC_NORTH, CMAttitudeReferenceFrameXMagneticNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_CORRECTED, CMAttitudeReferenceFrameXArbitraryCorrectedZVertical);

#pragma mark MainThreadSelectors

-(void)initManagers {
    locationManager = [[CLLocationManager alloc] init];
    motionManager = [[CMMotionManager alloc] init];
}


-(void)startUpdating:(id)args {
    
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSNumber *startLocationUpdates = [args objectForKey : @"location"];
    NSNumber *startRotationUpdates = [args objectForKey : @"rotation"];
    
    
    if([startRotationUpdates isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        NSNumber *rotationReferenceFrame = [args objectForKey : @"rotationReferenceFrame"];
        
        if (rotationReferenceFrame != NULL) {
            
            if([rotationReferenceFrame isEqualToNumber:self.ROTATION_REFERENCE_FRAME_TRUE_NORTH]) {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
                [locationManager startUpdatingLocation];   
            }
            
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:[rotationReferenceFrame doubleValue]];
        } else {
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        }
    }
    
    
    if([startLocationUpdates isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        NSNumber *locationAccuracy = [args objectForKey : @"locationAccuracy"];
        
        if(locationAccuracy != NULL) {
            locationManager.desiredAccuracy = [locationAccuracy doubleValue];
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        }
        
        [locationManager startUpdatingLocation];   
    }
    
    
    NSLog(@"[INFO] started movement updates.");
}


-(void)stopUpdating {

    [locationManager stopUpdatingLocation];
    [motionManager stopDeviceMotionUpdates];
    
    NSLog(@"[INFO] stopped movement updates.");
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
    TiThreadPerformOnMainThread(^{[self initManagers];}, NO);
    
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
	self.motionManager = nil;
    self.locationManager = nil;
    
	[super dealloc];
}

#pragma Public APIs



- (void)startMovementUpdates:(id)args
{
    
    TiThreadPerformOnMainThread(^{[self startUpdating:args];}, NO);
}

- (void)stopMovementUpdates:(id)args
{
    TiThreadPerformOnMainThread(^{[self stopUpdating];}, NO);
}

- (NSDictionary *) currentMovement
{
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:locationManager.location.coordinate.longitude], @"longitude",
                              [NSNumber numberWithDouble:locationManager.location.coordinate.latitude], @"latitude",
                              [NSNumber numberWithDouble:locationManager.location.altitude], @"altitude",
                              nil];
    
    NSDictionary *rotation = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:motionManager.deviceMotion.attitude.roll], @"roll",
                              [NSNumber numberWithDouble:motionManager.deviceMotion.attitude.pitch], @"pitch",
                              [NSNumber numberWithDouble:motionManager.deviceMotion.attitude.yaw], @"yaw",
                              nil];
    NSDictionary *movementData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  location, @"location",
                                  rotation, @"rotation",
                                  nil];
    
    return movementData;
}

@end