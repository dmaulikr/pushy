//
//  Pusher.h
//  Pushy
//
//  Created by Devrex on 10/06/14.
//  Copyright (c) 2014 Devrex Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Pusher : NSObject <CLLocationManagerDelegate>
- (void) start;
- (void) stop;
- (id) initWithUrl: (NSString*) url andSampleRate: (int) sampleRate andPushRate: (int) pushRate;
@end
