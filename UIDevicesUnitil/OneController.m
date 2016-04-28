//
//  OneController.m
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/3.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "OneController.h"
#import "UIDeviceUtils.h"
@interface OneController ()

@end

@implementation OneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    UIDeviceUtils * utils = [UIDeviceUtils shareUtils];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)paizhao:(id)sender {
    
   [[UIDeviceUtils shareUtils] toTakePhoto:self complete:^(id obj, NSError *error) {
       UIImage * iamge = obj;
   }];
}
- (IBAction)getLocation:(id)sender {
    [[UIDeviceUtils shareUtils] toGetLocationComplete:^(id obj, NSError *error) {
        
    }];
}
- (IBAction)playMovie:(id)sender {

}

- (BOOL)shouldAutorotate{
    return YES;
}
- (void)dealloc
{
    
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
