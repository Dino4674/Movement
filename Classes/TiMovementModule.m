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

#pragma mark MainThreadSelectors

MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST,kCLLocationAccuracyBest);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_BEST_FOR_NAVIGATION, kCLLocationAccuracyBestForNavigation);
MAKE_SYSTEM_PROP_DBL(LOCATION_ACCURACY_THREE_KILOMETERS, kCLLocationAccuracyThreeKilometers);

MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_TRUE_NORTH, CMAttitudeReferenceFrameXTrueNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_MAGNETIC_NORTH, CMAttitudeReferenceFrameXMagneticNorthZVertical);
MAKE_SYSTEM_PROP_DBL(ROTATION_REFERENCE_FRAME_CORRECTED, CMAttitudeReferenceFrameXArbitraryCorrectedZVertical);

-(void)initManagers {
    
    //NSLog(@"[INFO] initializing module...");
    
    locationManager = [[CLLocationManager alloc] init];
    motionManager = [[CMMotionManager alloc] init];
    
    //NSLog(@"[INFO] initialized module.");
}


-(void)startUpdating:(id)args {
    
    NSLog(@"[INFO] selector starting updates...");    

    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSNumber *locationAccuracy = [args objectForKey : @"locationAccuracy"];
    NSNumber *rotationReferenceFrame = [args objectForKey : @"rotationReferenceFrame"];

    
    NSLog(@"[INFO] loc: %@ ", locationAccuracy);
    NSLog(@"[INFO] rot: %@ ", rotationReferenceFrame);
    
    double a = [locationAccuracy doubleValue];
    double r = [rotationReferenceFrame doubleValue];
    
    //locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.desiredAccuracy = [locationAccuracy doubleValue];
    [locationManager startUpdatingLocation];
    //[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:[rotationReferenceFrame doubleValue]];
    
    NSLog(@"[INFO] selector started updates.");
}


-(void)stopUpdating {
    
    NSLog(@"[INFO] selector stopping updates...");
    
    [locationManager stopUpdatingLocation];
    [motionManager stopDeviceMotionUpdates];
    
    NSLog(@"[INFO] selector stopped updates.");
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