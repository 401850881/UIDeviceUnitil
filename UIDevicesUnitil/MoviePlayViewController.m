//
//  MoviePlayViewController.m
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/25.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "MoviePlayViewController.h"
#import "UIDeviceUnitis.h"
@interface MoviePlayViewController ()

@end

@implementation MoviePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    NSString * urlStr = [[NSBundle mainBundle] pathForResource:@"IMG_0003.MOV" ofType:nil];
    //CGRect rect = CGRectMake(100, 100, 200, 400);
    [[UIDeviceUnitis shareUtils] playMovieWithFileUrlString:urlStr onView:self isLandscape:YES complete:^(id obj, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
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
