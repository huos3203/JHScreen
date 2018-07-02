//
//  JHQuickShotViewController.h
//  JHUniversalApp
//
//  Created by admin on 2018/7/2.
//  Copyright © 2018年  William Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface JHQuickShotCamera : NSObject

- (void)showCameraView:(void(^)(UIImage * image))handler;

@end
