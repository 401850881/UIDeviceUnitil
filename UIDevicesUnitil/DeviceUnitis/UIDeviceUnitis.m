//
//  UIDeviceUtils.m
//  UIDevicesUnitil
//
//  Created by 任晓雷 on 16/4/3.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "UIDeviceUnitis.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
@interface UIDeviceUnitis ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, copy) Complete imageComplete;
@property (nonatomic, copy) Complete scanComplete;
@property (nonatomic, copy) Complete locationComplete;
@property (nonatomic, copy) Complete moviePlayComplete;
@property (nonatomic, weak) UIViewController * showController;
@property (nonatomic, weak) UIViewController * scanController;
@property (nonatomic, strong)CLLocationManager * locationManager;
@property (nonatomic, strong)AVCaptureDevice * captureDevice;
@property (nonatomic, strong)AVCaptureDeviceInput * captureInput;
@property (nonatomic, strong)AVCaptureMetadataOutput * metadataOutput;
@property (nonatomic, strong)AVCaptureSession * captureSession;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong)UIImageView * scanLine;
@property (nonatomic, copy)Complete presetScanDeviceComplete;
@property (nonatomic, strong)AVAudioPlayer * audioPlayer;
@property (nonatomic, strong)MPMoviePlayerViewController * moviePlayer;
@end

@implementation UIDeviceUnitis

#pragma mark - 拍照/获取照片
+ (UIDeviceUnitis *)shareUtils{
    static UIDeviceUnitis * deviceUtils = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        deviceUtils = [[self alloc] init];
    });
    return deviceUtils;
}

/**
 *  相册权限检测
 *
 *  @return YES、NO
 */
- (BOOL)toCheckCamera{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持相机访问功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            NSString *message = STRCamera;
            if (!message.length)
                message = @"请在\"设置-隐私-相机\"中打开允许访问相机的开关以允许我们访问您的相机";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授予相机访问权限" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}
- (BOOL)toCheckPhotoAlbum{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持照片访问功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied || author == AVAuthorizationStatusRestricted) {
        NSString *message = STRPhotosAlbum;
        if (!message.length) {
            message = @"请在\"设置-隐私-照片\"中打开允许访问照片的开关以允许我们访问您的照片";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授予照片访问权限" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}
- (BOOL)toCheckPhotoLibrary{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持照片访问功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied || author == AVAuthorizationStatusRestricted) {
        NSString *message = STRPhotoLibrary;
        if (!message.length) {
            message = @"请在\"设置-隐私-照片\"中打开允许访问照片的开关以允许我们访问您的照片";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授予照片访问权限" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

/**
 *  调用系统照相、相册、图库
 *
 *  @param viewController
 */
- (BOOL)toTakePhoto:(UIViewController *)viewController complete:(Complete)complete{
    if (![self toCheckCamera]) {
        return NO;
    }
    UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = NO;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerVC.showsCameraControls = YES;
    imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imageComplete = complete;
    _showController = viewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [viewController presentViewController:imagePickerVC animated:YES completion:^(){}];
    return YES;
}
- (BOOL)toPickPhoto:(UIViewController *)viewController complete:(Complete)complete{
    if (![self toCheckPhotoAlbum]) {
        return NO;
    }
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = NO;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imageComplete = complete;
    _showController = viewController;
    [viewController presentViewController:imagePickerVC animated:YES completion:^(){}];
    return YES;
}
- (BOOL)toPickPicture:(UIViewController *)viewController complete:(Complete)complete{
    if (![self toCheckPhotoLibrary]) {
        return NO;
    }
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = NO;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imageComplete = complete;
    _showController = viewController;
    [viewController presentViewController:imagePickerVC animated:YES completion:^(){}];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent
     animated:NO];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageComplete(image, nil);
    [_showController dismissViewControllerAnimated:YES
                             completion:^(){
                             }];
    _imageComplete = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleLightContent
     animated:NO];
    [_showController dismissViewControllerAnimated:YES
                                        completion:^(){
                                        }];
    _imageComplete = nil;
}

#pragma mark - 定位

- (void)toGetLocationComplete:(Complete)complete{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationComplete = complete;
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务可能尚未打开，请设置！");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位服务可能尚未打开，请设置！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位服务已被禁止，请手动设置：->隐私->定位服务" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    _locationManager.delegate = self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
    _locationManager.distanceFilter=distance;
    //启动跟踪定位
    if ([[UIDevice currentDevice] systemVersion].intValue > 7) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [_locationManager requestWhenInUseAuthorization];
        }else{
            [_locationManager startUpdatingLocation];
        }
    }else{
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    _locationComplete(nil, error);
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    __weak __typeof(&*self)weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        weakSelf.locationComplete(placemark.addressDictionary, nil);
    }];
}

#pragma mark - 二维码扫描

- (void)toScanningCodeOnController:(UIViewController *)controller Complete:(Complete)complete{
    NSAssert(controller != nil, @"controller不能为空");
    _scanComplete = complete;
    _scanController = controller;
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_captureSession canAddInput:_captureInput]) {
        [_captureSession addInput:_captureInput];
    }
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
    _metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = controller.view.layer.bounds;
    [controller.view.layer insertSublayer:_preview atIndex:0];
    [_captureSession startRunning];
    [self setScanView:_scanController];
    [self scanLineStartAnimate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avCaptureInputPortFormatDescriptionDidChangeNotification:) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
    


}
- (void)setScanView:(UIViewController *)controller{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [controller.view addSubview:maskView];
    UIBezierPath * maskpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, screenWidth, screenHeight)];
    [maskpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(screenWidth * 0.15, (screenHeight - screenWidth * 0.7) / 2, screenWidth * 0.7, screenWidth * 0.7) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskpath.CGPath;
    maskView.layer.mask = maskLayer;
    _scanController.navigationItem.hidesBackButton = YES;
    _scanController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    _scanController.navigationItem.title = @"二维码/条形码";
    _scanController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册选取" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCodeFromLibrary)];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.15, (screenHeight - screenWidth * 0.7) / 2, 2, 15)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.15, (screenHeight - screenWidth * 0.7) / 2, 15, 2)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.85 - 15, (screenHeight - screenWidth * 0.7) / 2, 15, 2)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.85 -2, (screenHeight - screenWidth * 0.7) / 2, 2, 15)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.15, (screenHeight - screenWidth * 0.7) / 2 + screenWidth * 0.7 - 15, 2, 15)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.15, (screenHeight - screenWidth * 0.7) / 2 + screenWidth * 0.7 - 2, 15, 2)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.85 - 2, (screenHeight - screenWidth * 0.7) / 2 + screenWidth * 0.7 - 15, 2, 15)]];
    [controller.view addSubview:[self addLineWithRect:CGRectMake(screenWidth * 0.85 - 15, (screenHeight - screenWidth * 0.7) / 2 + screenWidth * 0.7 - 2, 15, 2)]];
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * 0.15 + 5, (screenHeight - screenWidth * 0.7) / 2 , screenWidth * 0.7 - 10 , 3)];
    _scanLine.backgroundColor = [UIColor greenColor];
    _scanLine.alpha = 0.6;
    _scanLine.layer.cornerRadius = 3;
    [controller.view addSubview:_scanLine];
}

- (void)scanLineStartAnimate{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = 1.7;
    //animation.fromValue =@((screenHeight - screenWidth * 0.7) / 2);
    animation.toValue = @(screenWidth * 0.7);
    animation.autoreverses = YES;
    animation.repeatCount = 10000000;
    [_scanLine.layer addAnimation:animation forKey:nil];
}

- (void)presetQRCodeScanDeviceComplete:(Complete)complete{
    _presetScanDeviceComplete = complete;
}

- (void)avCaptureInputPortFormatDescriptionDidChangeNotification:(NSNotification *)noti{
//    CGSize size = _scanController.view.bounds.size;
//    CGRect Rect = CGRectMake((size.width - 240)/2.0, 150.0, 240.0, 240.0);
//    CGRect interRect = [_preview metadataOutputRectOfInterestForRect:Rect];
//    _metadataOutput.rectOfInterest = interRect;
    if (_presetScanDeviceComplete) {
        _presetScanDeviceComplete(nil, nil);
    }
    
}

- (void)scanQRCodeFromLibrary{
    [self toPickPicture:_scanController complete:^(id obj, NSError *error) {
        if (obj) {
            UIImage * image = obj;
            CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
            NSArray * features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
            if (features.count >= 1) {
                CIQRCodeFeature * feature = features[0];
                NSString * resultStr = feature.messageString;
                [self playWaningVadio];
                _scanComplete(resultStr, nil);
                [_captureSession stopRunning];
                [self clearScanProperty];
            }
        }

    }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString * valueStr;
    if (metadataObjects.count > 0) {
        [_captureSession stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObj = metadataObjects[0];
        valueStr = metadataObj.stringValue;
        [self playWaningVadio];
        _scanComplete(valueStr, nil);
        [self clearScanProperty];
    }
}

- (UILabel *)addLineWithRect:(CGRect)rect{
    UILabel * line = [[UILabel alloc] initWithFrame:rect];
    line.backgroundColor = [UIColor greenColor];
    return line;
}

- (void)playWaningVadio{
    NSString * urlstr = [[NSBundle mainBundle] pathForResource:@"wanning" ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:urlstr];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}
- (void)backButtonClick{
    [_captureSession stopRunning];
    [self clearScanProperty];
    [_scanController.navigationController popViewControllerAnimated:YES];
}

- (void)clearScanProperty{
    _captureDevice = nil;
    _captureInput = nil;
    _captureSession = nil;
    _preview = nil;
    _metadataOutput = nil;
    [_scanLine removeFromSuperview];
    _scanLine = nil;
    _scanComplete = nil;
    _presetScanDeviceComplete = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
}

#pragma mark - 录制视频
#pragma mark - 播放视频

- (void)playMovieWithNetUrlString:(NSString *)urlString onView:(UIViewController *)view isLandscape:(BOOL)isLandscape complete:(Complete)complete{
    _moviePlayComplete = complete;
    NSURL * url = [self getNetWorkUrl:urlString];
    [self setPlayerWithURL:url onView:view isLandscape:isLandscape];
}

- (void)playMovieWithFileUrlString:(NSString *)urlString onView:(UIViewController *)view isLandscape:(BOOL)isLandscape complete:(Complete)complete{
    _moviePlayComplete = complete;
    NSURL * url = [self getFileUrl:urlString];
    [self setPlayerWithURL:url onView:view isLandscape:isLandscape];
}
- (void)setPlayerWithURL:(NSURL *)url onView:(UIViewController *)view isLandscape:(BOOL)isLandscape{
    _moviePlayer = nil;
    _moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    if (isLandscape) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        _moviePlayer.view.frame = CGRectMake(0, 0, screenHeight, screenWidth);
        _moviePlayer.view.center = CGPointMake(screenWidth / 2, screenHeight / 2);
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    _moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [view.view addSubview:_moviePlayer.view];
    [self addNotification];
    [_moviePlayer.moviePlayer play];
}

- (NSURL *)getNetWorkUrl:(NSString *)urlString{
    NSString * str = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:str];
}

- (NSURL *)getFileUrl:(NSString *)urlString{
    return [NSURL fileURLWithPath:urlString];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

}
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    [_moviePlayer.view removeFromSuperview];
    _moviePlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    _moviePlayComplete(nil,nil);
    _moviePlayComplete = nil;
}

-(void)mediaPlayerWillEnterFullScreen:(NSNotification *)notification{

}

-(void)mediaPlayerWillExitFullScreen:(NSNotification *)notification{

}
@end
