//
//  ViewController.m
//  Pushy
//
//  Created by Devrex on 10/06/14.
//  Copyright (c) 2014 Devrex Labs. All rights reserved.
//

#import "ViewController.h"
#include "Pusher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    Pusher* pusher = [[Pusher alloc] initWithUrl:@"http://127.0.0.1:1337/figaro?data=" andSampleRate:1000 andPushRate:1000];
    [pusher start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
