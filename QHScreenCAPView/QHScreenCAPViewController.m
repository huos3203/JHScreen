//
//  QHScreenCAPViewController.m
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHScreenCAPViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "NSTimer+EOCBlocksSupport.h"

@interface QHScreenCAPViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startScreenCAPButton;
@property (weak, nonatomic) IBOutlet UIButton *ibScreenShotsBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibBackBtn;


@property (weak, nonatomic) IBOutlet UIView *screenCAPResultV;
@property (weak, nonatomic) IBOutlet UIView *playerV;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;


@property (nonatomic, strong) NSTimer *showTimer;
@property (weak, nonatomic) IBOutlet UILabel *ibShowTimeLabel;
@property (nonatomic) NSUInteger timeCount;
@end

@implementation QHScreenCAPViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    self.player = nil;
    self.playerLayer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.startScreenCAPButton.layer setBorderWidth:0];
    [self.startScreenCAPButton.layer setMasksToBounds:YES];
    [self.startScreenCAPButton.layer setCornerRadius:self.startScreenCAPButton.bounds.size.width/2];
    
    [self.ibAlertMessageLabel.layer setBorderWidth:0];
    [self.ibAlertMessageLabel.layer setMasksToBounds:YES];
    [self.ibAlertMessageLabel.layer setCornerRadius:15];
}

#pragma mark - Action

//重新录屏
- (IBAction)restartScreenCAPAction:(id)sender {
    [self.delegate restartScreenCAP:self];
    self.startScreenCAPButton.selected = YES;
    [self.startScreenCAPButton setBackgroundColor:[UIColor greenColor]];
}

- (IBAction)ibBackAction:(id)sender {
    [self.delegate toBackCAP:self];
}

-(void)createTimer
{
    self.timeCount = 11;

    __weak typeof(self) weakSelf = self;
    self.showTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
        weakSelf.timeCount--;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.ibShowTimeLabel.text = [NSString stringWithFormat:@"%lus", (unsigned long)weakSelf.timeCount];
            if (weakSelf.timeCount == 0) {
                [weakSelf startScreenCAPAction:nil];
            }
        });
    } repeats:YES];
    [self.showTimer fire];
    
}

//开始录屏
- (IBAction)startScreenCAPAction:(id)sender {
    BOOL bRecording = [self.delegate startScreenCAP:self];
    self.startScreenCAPButton.selected = bRecording;
    if (bRecording == YES) {
        //开始录屏
        [self.startScreenCAPButton setBackgroundColor:[UIColor redColor]];
        [self createTimer];
        [_ibShowTimeLabel setHidden:YES];
    }
    else {
        //完成录屏
        [self.startScreenCAPButton setBackgroundColor:[UIColor clearColor]];
        [_ibShowTimeLabel setHidden:YES];
        _ibShowTimeLabel.text = @"0";
        [self.showTimer invalidate];
        self.showTimer = nil;
    }
}
//关闭录屏
- (IBAction)closeScreenCAPAction:(id)sender {
    [self.startScreenCAPButton setBackgroundColor:[UIColor redColor]];
    [self.delegate closeScreenCAP:self];
}

//截屏
- (IBAction)getScreenshotsCAPAction:(id)sender {
    [self.delegate getScreenshotsCAP:self];
}

//关闭录屏视频预览播放器
- (IBAction)closeScreenCAPResultAction:(id)sender {
    [self.player pause];
    self.screenCAPResultV.hidden = YES;
}

//完成录屏，并预览播放视频
- (void)playResultAction:(NSURL *)playUrl {
    if (self.showTimer) {
        [self.showTimer invalidate];
        self.showTimer = nil;
    }
    [self closeScreenCAPAction:nil];
    return;
    
    
    //录制完播放预览
    self.screenCAPResultV.hidden = NO;
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerV.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.playerV.bounds;
    [self.player play];
}

//不支持旋转
-(BOOL)shouldAutorotate
{
    return NO;//!self.startScreenCAPButton.selected;
}
@end
