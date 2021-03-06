//
//  CLWXManager.h
//  SimpleWeather
//
//  Created by mm on 8/15/14.
//  Copyright (c) 2014 mm. All rights reserved.
//
@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

#import "WXCondition.h"

@interface WXManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly)CLLocation *currentLocation;
@property (nonatomic, strong, readonly)WXCondition *currentCondition;
@property (nonatomic, strong, readonly)NSArray *hourlyForecast;
@property (nonatomic, strong, readonly)NSArray *dailyForecast;

- (void)findCurrentLocation;

@end
