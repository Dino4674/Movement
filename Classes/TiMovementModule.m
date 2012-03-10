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

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    motionManager = [[CMMotionManager alloc] init];
    
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
    NSLog(@"[INFO] startingg updates...");
    [locationManager startUpdatingLocation];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    NSLog(@"[INFO] started updates.");
}

- (void)stopMovementUpdates:(id)args
{
    [locationManager stopUpdatingLocation];
    [motionManager stopDeviceMotionUpdates];
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