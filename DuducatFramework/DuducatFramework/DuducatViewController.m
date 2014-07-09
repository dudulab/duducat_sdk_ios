//
//  DuducatViewController.m
//  DuducatFramework
//
//  Created by dyun on 6/4/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatViewController.h"
#import "UILabel+Duducat.h"
#import "UIImageView+DuducatSDWebImageView.h"

@interface DuducatViewController ()

@end

@implementation DuducatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.label setTextWithKey:@"t1" placeholderText:@"hello"];
    [self.imageVIew setImageWithKey:@"t1"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
