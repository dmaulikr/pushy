//
//  ViewController.h
//  Pushy
//
//  Created by Devrex on 10/06/14.
//  Copyright (c) 2014 Devrex Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *trackingActiveButton;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pushRateField;
- (IBAction)trackingValueChanged:(id)sender;
- (IBAction)fdssdf:(id)sender;

@end
