/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface TiMovementModule : TiModule<CLLocationManagerDelegate>

@property (nonatomic, readonly) NSDictionary *currentMovement;

- (void)startMovementUpdates:(id)args;
- (void)stopMovementUpdates:(id)args;

@end
