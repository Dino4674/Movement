/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface TiMovementModule : TiModule

@property (nonatomic, readonly) NSDictionary *currentMovement;

@property(nonatomic,readonly) NSNumber *LOCATION_ACCURACY_BEST;
@property(nonatomic,readonly) NSNumber *LOCATION_ACCURACY_BEST_FOR_NAVIGATION;
@property(nonatomic,readonly) NSNumber *LOCATION_ACCURACY_THREE_KILOMETERS;

@property(nonatomic,readonly) NSNumber *ROTATION_REFERENCE_FRAME_TRUE_NORTH;
@property(nonatomic,readonly) NSNumber *ROTATION_REFERENCE_FRAME_MAGNETIC_NORTH;
@property(nonatomic,readonly) NSNumber *ROTATION_REFERENCE_FRAME_CORRECTED;
 
- (void)startMovementUpdates:(id)args;
- (void)stopMovementUpdates:(id)args;

@end
