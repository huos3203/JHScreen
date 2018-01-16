//
//  QHScreenCAPManager.h
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHScreenCAPManager;

@protocol QHScreenCAPManagerDelegate <NSObject>

- (void)closeScreenCAPManager:(QHScreenCAPManager *)manager;
- (void)getScreenshotsCAP:(QHScreenCAPManager *)manager;

- (void)startRecordCAP:(BOOL)isFinished;
- (void)toBackCAP:(QHScreenCAPManager *)vc;
@end

@interface QHScreenCAPManager : NSObject

@property (nonatomic, weak) id<QHScreenCAPManagerDelegate> delegate;
@property (nonatomic, strong) NSString *videoUrl;

+ (QHScreenCAPManager *)createScreenCAPManager;
- (void)closeScreenRecord;
@end
