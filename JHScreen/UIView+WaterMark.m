//
//  UIView+WaterMark.m
//  WaterMarkDemo
//
//  Created by jinher on 2018/6/25.
//  Copyright © 2018年 wsk. All rights reserved.
//

#import "UIView+WaterMark.h"
#import "UIImage+Util.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@implementation UIView (WaterMark)

- (UIImage *)addWatemarkText:(NSString *)text Photo:(UIImage *)photo
{
    UIColor *bkColor = [UIColor whiteColor];
    UIImage *bkImg = nil;
    /*if (bkImg == nil) {
        bkImg = [UIImage imageWithColor:bkColor];
    }*/
    UIImage *drawImg = [self addWatemarkTextAfteriOS7_WithLogoImage:bkImg watemarkText:text];
    UIImage *markImage = [self rotationImage:drawImg Photo:photo];
    [self setContentMode:UIViewContentModeBottomRight];
    self.layer.contents = (__bridge id _Nullable)(markImage.CGImage);
    return markImage;
}

//文字水印
- (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText {
    int w = SCREEN_WIDTH*3;
    int h = SCREEN_HEIGHT;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [[UIColor whiteColor] set];
    [logoImage drawInRect:CGRectMake(-SCREEN_WIDTH, -SCREEN_HEIGHT, w, h)];
    UIFont * font = [UIFont systemFontOfSize:10.0];
    
    NSInteger line = SCREEN_HEIGHT*3/ 100; //多少行
    NSInteger row = 8;
    for (int i = 0; i < line; i ++) {
        for (int j = 0; j < row; j ++) {
            [watemarkText drawInRect:CGRectMake(j * (SCREEN_WIDTH/3.5), i*100, 90, 25) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        }
    }
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//image旋转
- (UIImage *)rotationImage:(UIImage *)image Photo:(UIImage *)photo {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    rotate = M_2_PI;//M_PI_4;
    rect = CGRectMake(0, 0, image.size.height, image.size.width);
    translateX = 0;
    translateY = -rect.size.width;
    //铺满屏幕的关键↓↓↓
    scaleY = rect.size.width/rect.size.height *1.5;
    scaleX = rect.size.height/rect.size.width *1.5;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    if (photo != nil) {
        CGRect rc = CGRectMake(0, 0, photo.size.width, photo.size.height);
        rc.origin.x += rect.size.width - rc.size.width;
        //rc.origin.y += rect.size.height - rc.size.height;
        //[photo drawInRect:rc];
        CGContextDrawImage(context, rc, photo.CGImage);
    }

    //做CTM变换
    //CGContextTranslateCTM(context, 0.0, rect.size.height);
    //CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

-(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2

{
    UIGraphicsBeginImageContext(image2.size);
    
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(20, 20, image1.size.width, image1.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
