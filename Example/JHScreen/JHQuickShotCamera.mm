//
//  JHQuickShotViewController.m
//  JHUniversalApp
//
//  Created by admin on 2018/7/2.
//  Copyright © 2018年  William Sterling. All rights reserved.
//

#import "JHQuickShotCamera.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc_c.h>

@interface JHQuickShotCamera ()<CvVideoCameraDelegate>
{
    cv::Mat keepMatImg;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CvVideoCamera *videoCamera;
@property (strong, nonatomic) void(^HandleImage)(UIImage * image);
@end

@implementation JHQuickShotCamera

- (UIImageView *)imageView{
    if (_imageView == nil) {
        CGSize mainSize = [UIScreen mainScreen].bounds.size;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width - 120, 20, 120, 212)];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (void)showCameraView:(void(^)(UIImage * image))handler{
    self.HandleImage = handler;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted == YES) {
                        
                    }else{
                        
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
        {
            UIView * topView = [[UIApplication sharedApplication] keyWindow];
            [topView addSubview:self.imageView];
            [self createVideo];
        }
            break;
        default:
            break;
    }
}
- (void)createVideo {
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    //    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    //    self.videoCamera.defaultFPS = 30;
    //设置摄像头的方向
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    [self.videoCamera start];
    [self performSelector:@selector(autoCloseViewWhenTakePhotoFailure) withObject:nil afterDelay:15.0];
}

- (void)autoCloseViewWhenTakePhotoFailure{
    [self disposeCamare];
}

- (void)disposeCamare {
    [self.videoCamera stop];
    self.videoCamera.delegate = nil;
    self.videoCamera = nil;
}

- (void)finishTakePhoto{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoCloseViewWhenTakePhotoFailure) object:nil];
    [self disposeCamare];
}


- (void)processImage:(cv::Mat &)image {
    cv::Mat outCopyImg;
    image.copyTo(outCopyImg);
    cv::cvtColor(outCopyImg, outCopyImg, CV_BGR2RGB);
    
    if ([self isPhotoContainsFeature:MatToUIImage(outCopyImg)]) {
        if ([self isPhotoIsBrightness:image] == YES) {
            [self disposeCamare];
            keepMatImg = outCopyImg;
            UIImage * resultImage = MatToUIImage(outCopyImg);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.HandleImage(resultImage);
                [self.imageView removeFromSuperview];
            });
        }
    }
}

- (BOOL)isPhotoContainsFeature:(UIImage *)image{
    CIContext * context = [CIContext contextWithOptions:nil];
    
    NSDictionary * param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    CIDetector * faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
    
    CIImage * ciimage = [CIImage imageWithCGImage:image.CGImage];
    
    NSArray * detectResult = [faceDetector featuresInImage:ciimage];
    
    return detectResult.count;
}
- (BOOL)isPhotoIsBrightness:(cv::Mat &)image
{
    
    cv::Mat imageSobel;
    Sobel(image, imageSobel, CV_16U, 1, 1);
    
    //图像的平均灰度
    double meanValue = 0.0;
    meanValue = mean(imageSobel)[0];
    
    if (meanValue > 1.3) {
        return YES;
    }
    return NO;
}

@end
