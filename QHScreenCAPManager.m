//
//  QHScreenCAPManager.m
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHScreenCAPManager.h"

#import "ASScreenRecorder.h"

#import "QHScreenCAPViewController.h"

@interface QHScreenCAPManager () <QHScreenCAPViewControllerDelegate, ASScreenRecorderDelegate>

@property (nonatomic, strong) UIWindow *screenCAPWindow;

@property (nonatomic, strong) QHScreenCAPViewController *screenCAPVC;

@end

@implementation QHScreenCAPManager

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
    self.screenCAPWindow = nil;
    self.screenCAPVC = nil;
}

+ (QHScreenCAPManager *)createScreenCAPManager {
    QHScreenCAPManager *manager = [[QHScreenCAPManager alloc] init];
    
    manager.screenCAPWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //加载方式不同
    //initWithNibName方法：是延迟加载，这个View上的控件是 nil 的，只有到 需要显示时，才会不是 nil
    //loadNibNamed方法：即时加载，用该方法加载的xib对象中的各个元素都已经存在。
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"JHPatrolResources" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    QHScreenCAPViewController *vc = [[QHScreenCAPViewController alloc] initWithNibName:@"QHScreenCAPViewController" bundle:resourceBundle];
    manager.screenCAPVC = vc;
    manager.screenCAPVC.delegate = manager;
    manager.screenCAPWindow.rootViewController = manager.screenCAPVC;
    
    manager.screenCAPWindow.windowLevel = UIWindowLevelNormal;
    
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    recorder.delegate = manager;
    
    [manager.screenCAPWindow makeKeyAndVisible];
    
    return manager;
}

#pragma mark - util

- (NSURL*)videoTempFileURL {
    [self removeTempFilePath:_videoUrl];
    return [NSURL fileURLWithPath:_videoUrl];
}

- (void)removeTempFilePath:(NSString*)filePath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError* error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording:%@", [error localizedDescription]);
        }
    }
}

#pragma mark - ASScreenRecorderDelegate

- (UIWindow *)screenRecordWindow {
    return [[UIApplication sharedApplication].delegate window];
}

-(void)writeBackgroundFrameInContext:(CGContextRef *)contextRef
{
    //预览图
    NSString* imagePath = [_videoUrl stringByReplacingOccurrencesOfString:_videoUrl.pathExtension withString:@"png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        CGImageRef iOffscreen = CGBitmapContextCreateImage(*contextRef);
        UIImage *image = [UIImage imageWithCGImage: iOffscreen];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        NSData *photoAddedWatermarkData = UIImageJPEGRepresentation(image, 1);
        [photoAddedWatermarkData writeToFile:imagePath atomically:YES];
    }
}
#pragma mark - QHScreenCAPViewControllerDelegate

- (void)restartScreenCAP:(QHScreenCAPViewController *)vc {
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    [recorder closeRecordingWithCompletion:^{
        [recorder startRecording];
    }];
}

- (BOOL)startScreenCAP:(QHScreenCAPViewController *)vc {
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    if (recorder.isRecording) {
        __weak typeof(self) weakSelf = self;
        [recorder stopRecordingWithCompletion:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (recorder.videoURL != nil) {
                [strongSelf.screenCAPVC playResultAction:recorder.videoURL];
            }
        }];
    } else {
        
        //!!!这句注释后就不会出预览的录屏结果，而是将录屏结果保存到相册里面
        
        recorder.videoURL = [self videoTempFileURL];
        [recorder startRecording];
    }
    [self.delegate startRecordCAP:recorder.isRecording];
    return recorder.isRecording;
}

- (void)stopRecordCAP
{
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    if (recorder.isRecording) {
        __weak typeof(self) weakSelf = self;
        [recorder stopRecordingWithCompletion:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (recorder.videoURL != nil) {
                [strongSelf.screenCAPVC playResultAction:recorder.videoURL];
            }
        }];
    }
}

- (void)closeScreenCAP:(QHScreenCAPViewController *)vc {
    __weak typeof(self) weakSelf = self;
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    [recorder closeRecordingWithCompletion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.screenCAPWindow.rootViewController = nil;
        [strongSelf.screenCAPWindow resignKeyWindow];
        strongSelf.screenCAPWindow = nil;
        [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
        
        [strongSelf.delegate closeScreenCAPManager:strongSelf];
    }];
}


- (void)getScreenshotsCAP:(QHScreenCAPViewController *)vc {
    [self.delegate getScreenshotsCAP:self];
}

- (void)toBackCAP:(QHScreenCAPViewController *)vc
{
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    if (recorder.isRecording) {
        
        vc.ibAlertMessageLabel.alpha = 1;
        [UIView animateWithDuration:3.0 animations:^{
            vc.ibAlertMessageLabel.alpha = 0;
        }];
    }
    
    [self.delegate toBackCAP:self];
}

@end
