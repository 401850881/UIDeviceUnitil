//
//  UIDeviceUtils.h
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/3.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^Complete)(id obj, NSError * error);
#define STRCamera       @"请授权本App可以访问相机\n设置方式:手机设置->隐私->相机\n允许本App访问相机"
#define STRPhotosAlbum  @""
#define STRPhotoLibrary @"请授权本App可以访问相册\n设置方式:手机设置->隐私->照片\n允许本App访问相册"

@interface UIDeviceUtils : NSObject
+ (UIDeviceUtils *)shareUtils;
/**
 *  相册权限检测
 *
 *  @return YES、NO
 */
- (BOOL)toCheckCamera;
- (BOOL)toCheckPhotoAlbum;
- (BOOL)toCheckPhotoLibrary;


/**
 *  调用系统照相toTakePhoto、相册toPickPhoto、图库toPickPicture
 *
 *  @param viewController
 */

- (BOOL)toTakePhoto:(UIViewController *)viewController complete:(Complete)complete;
- (BOOL)toPickPhoto:(UIViewController *)viewController complete:(Complete)complete;
- (BOOL)toPickPicture:(UIViewController *)viewController complete:(Complete)complete;

#pragma mark - 定位
/**
 *  获取位置信息
 *  本定位支持简单的获取位置信息的应用使用，不支持持续定位，监视一个区域等功能，NSLocationWhenInUseUsageDescription 必须先在plist内设置此参数（请求定位权限时的文本显示）
 *  @param complete 返回两个参数，一个位置信息的字典，一个error（定位失败）需要先判断是否失败
 */
- (void)toGetLocationComplete:(Complete)complete;

#pragma mark - 二维码扫描
/**
 *  在开启扫描功能的等候时间最好在controller上放一个不透明的View和一个“加载中。。。”的提示，
 *  这个方法回调后remove提示
 *  @param complete 无返回值参数
 */
- (void)presetQRCodeScanDeviceComplete:(Complete)complete;
/**
 *  二维码、条形码扫描
 *  因为开启扫描需要一点时间，为了不让UI有卡顿，所以最好用异步加载
 *  @param controller 扫描页面的controller（单独用来扫描的一个VC）
 *  @param complete   返回结果，（string）
 */
- (void)toScanningCodeOnController:(UIViewController *)controller Complete:(Complete)complete;

#pragma mark - 播放视频
/**
 *  播放网络视频
 *
 *  @param urlString   链接
 *  @param view        在哪个View上播放
 *  @param isLandscape 是否横屏播放（最好单独创建一个controller用来播放）,注意：如果横屏，那么需要在controller里调用[self setNeedsStatusBarAppearanceUpdate];并重写prefersStatusBarHidden方法，用来隐藏statusBar
 *  @param complete    播放完成之后的操作（返回前一页等），无参数（obj,error 都是空）
 */
- (void)playMovieWithNetUrlString:(NSString *)urlString onView:(UIViewController *)view isLandscape:(BOOL)isLandscape complete:(Complete)complete;
//播放本地视频
- (void)playMovieWithFileUrlString:(NSString *)urlString onView:(UIViewController *)view isLandscape:(BOOL)isLandscape complete:(Complete)complete;
@end
