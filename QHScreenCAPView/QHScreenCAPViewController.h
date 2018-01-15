//
//  QHScreenCAPViewController.h
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QHScreenCAPViewController;

@protocol QHScreenCAPViewControllerDelegate <NSObject>

- (void)restartScreenCAP:(QHScreenCAPViewController *)vc;

- (BOOL)startScreenCAP:(QHScreenCAPViewController *)vc;

- (void)closeScreenCAP:(QHScreenCAPViewController *)vc;

- (void)getScreenshotsCAP:(QHScreenCAPViewController *)vc;

- (void)toBackCAP:(QHScreenCAPViewController *)vc;
@end

@interface QHScreenCAPViewController : UIViewController

@property (nonatomic, weak) id<QHScreenCAPViewControllerDelegate> delegate;
-(void)playResultAction:(NSURL *)playUrl;
@property (weak, nonatomic) IBOutlet UILabel *ibAlertMessageLabel;

@end
