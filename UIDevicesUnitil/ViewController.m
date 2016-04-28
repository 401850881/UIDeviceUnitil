//
//  ViewController.m
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/3.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "ViewController.h"
#import "UIDeviceUtils.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
