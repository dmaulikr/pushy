//
//  Pusher.m
//  Pushy
//
//  Created by Devrex on 10/06/14.
//  Copyright (c) 2014 Devrex Labs. All rights reserved.
// Audio stuff based on http://b2cloud.com.au/tutorial/obtaining-decibels-from-the-ios-microphone/
// Location stuff from: https://developer.apple.com/library/ios/samplecode/LocateMe
//

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Pusher.h"
#import <stdlib.h>

@implementation Pusher

NSTimer* _timer;
int _sampleRate;
int _pushRate;
NSString* _url;
CLLocationManager* locationManager;
AVAudioRecorder* recorder;


- (Pusher*) initWithUrl: (NSString*) url andSampleRate:(int)sampleRate andPushRate:(int)pushRate {
    _url  = url;
    _sampleRate = sampleRate;
    _pushRate = pushRate;
    return self;
}

- (void) start {

    NSLog(@"start called");
    //[self startRecorder];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];

}

- (void) startRecorder {
    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    

    NSError* error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]]  settings:recorderSettings error:&error];
    recorder.meteringEnabled = YES;
    [recorder record];
}

- (void) stop
{
    [_timer invalidate];
    [recorder stop];
}


- (void) timerTicked: (NSTimer*) timer{

    [self readData];

    NSLog(@"tick %d", reading);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    NSString* urlWithData = [NSString stringWithFormat:@"%@%d", _url, reading];
    [request setURL:[NSURL URLWithString:urlWithData]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if([response statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", _url, [response statusCode]);
    }
}

/*
 * Read location and sound data and save to local variables
 */
- (void) readData {
    
}

- (int) readDecibelMock {
    return arc4random() % 200;
}


- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 10; // meters
    
    [locationManager startUpdatingLocation];
}


- (int) readDecibel {
    [recorder updateMeters];
    return [recorder averagePowerForChannel:0];
}

@end
