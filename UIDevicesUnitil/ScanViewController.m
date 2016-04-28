//
//  ScanViewController.m
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/18.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "ScanViewController.h"
#import "UIDeviceUtils.h"
@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIDeviceUtils shareUtils] toScanningCodeOnController:self Complete:^(id obj, NSError *error) {
            
        }];
    });
    UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [self.view addSubview:backView];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    lable.center = self.view.center;
    lable.text = @"加载中...";
    lable.textColor = [UIColor whiteColor];
    [backView addSubview:lable];
    [[UIDeviceUtils shareUtils] presetQRCodeScanDeviceComplete:^(id obj, NSError *error) {
        [backView removeFromSuperview];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
