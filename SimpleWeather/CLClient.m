//
//  CLWXClient.m
//  SimpleWeather
//
//  Created by mm on 8/15/14.
//  Copyright (c) 2014 mm. All rights reserved.
//

#import "CLClient.h"
#import "CLDailyForecast.h"

@interface CLClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation CLClient

- (id)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url
{
    NSLog(@"Fetching: %@", url.absoluteString);

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }

            [subscriber sendCompleted];
        }];

        [dataTask resume];

        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (RACSignal *)fetchCurrentConditionForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];

    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[CLCondition class] fromJSONDictionary:json error:nil];
    }];
}

@end
