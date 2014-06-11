//
//  PushyTests.m
//  PushyTests
//
//  Created by Devrex on 10/06/14.
//  Copyright (c) 2014 Devrex Labs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Pusher.h"

@interface PushyTests : XCTestCase

@end

@implementation PushyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    Pusher* pusher = [[Pusher alloc] initWithUrl:@"http://127.0.0.1:1337/pushy?data=" andSampleRate:1000 andPushRate:1000];
    [pusher start];
}

@end
