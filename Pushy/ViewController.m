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

@synthesize trackingActiveButton;
@synthesize userField;
@synthesize urlTemplate;

Pusher* pusher;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)trackingValueChanged:(id)sender {
    if (trackingActiveButton.isOn) [self start];
    else [pusher stop];
    
    
}

- (IBAction)fdssdf:(id)sender {
    [userField resignFirstResponder];
}

- (void) start {
    pusher = [[Pusher alloc] init: self.urlTemplate.text pushRate: [self.pushRateField.text intValue] user: self.userField.text];
    [pusher start];
}
@end
