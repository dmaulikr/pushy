//
// Audio stuff from:
// http://b2cloud.com.au/tutorial/obtaining-decibels-from-the-ios-microphone/
//
// Location stuff from:
// https://developer.apple.com/library/ios/samplecode/LocateMe
//
// Difference between peak and average:
// http://stackoverflow.com/questions/1240846/avaudiorecorder-peak-and-average-power

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Pusher.h"
#import <stdlib.h>

@implementation Pusher

int _pushRate;
NSString* _url;
NSString* _user;

CLLocationManager* locationManager;
AVAudioRecorder* recorder;
NSTimer* _timer;

/*
 * Last read data
 */

float decibelMax;
float decibelAvg;
CLLocation* location;



- (Pusher*) init:(NSString*) url pushRate:(int)pushRate user: (NSString*) user {
    _url  = url;
    _user = user;
    _pushRate = pushRate;
    return self;
}

- (void) start {

    NSLog(@"start called");
    [self startRecorder];
    [self startLocationUpdates];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_pushRate target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];

}

- (void) startRecorder {
    
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    
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
    [recorder deleteRecording];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}


- (void) timerTicked: (NSTimer*) timer{

    [self readDecibel];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    NSString* urlWithData = [NSString stringWithFormat:_url, _user, decibelAvg, decibelMax, location.coordinate.latitude, location.coordinate.longitude];
    [request setURL:[NSURL URLWithString:urlWithData]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSLog(urlWithData);
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if([response statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", _url, (long)[response statusCode]);
    }
}


- (void) readDecibel {
    [recorder updateMeters];
    decibelAvg = [recorder averagePowerForChannel:0];
    [recorder updateMeters];
    decibelMax = [recorder peakPowerForChannel:0];
}


- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 3; // meters
    
    [locationManager startUpdatingLocation];
}


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stop];
        NSLog(@"Error reading location: %d, %@", error.code, error.description);
    }
}

@end
