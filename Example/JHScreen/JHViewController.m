//
//  JHViewController.m
//  JHScreen
//
//  Created by huo3203@hotmail.com on 06/29/2018.
//  Copyright (c) 2018 huo3203@hotmail.com. All rights reserved.
//

#import "JHViewController.h"
#import "UIView+WaterMark.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "JHQuickShotCamera.h"

@interface JHViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation JHViewController
{
    UIImagePickerController *imagePicker;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (IBAction)ibaCameraAction:(id)sender {
    [[JHQuickShotCamera new] showCameraView:^(UIImage *image) {
        [self.view addWatemarkText:@"2018-12-12" Photo:image];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
