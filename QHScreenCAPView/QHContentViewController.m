//
//  ContentViewController.m
//  YGPatrol
//
//  Created by VH on 2018/1/19.
//  Copyright © 2018年 huoshuguang. All rights reserved.
//

#import "QHContentViewController.h"

@interface QHContentViewController ()


@end

@implementation QHContentViewController
{
    UIView *_contentView;
    
}
-(instancetype)initWithContentView:(UIView *)contentView
{
    
    if (self = [super init]) {
        _contentView = contentView;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_contentView];
    UIView *keyView = self.view;
    keyView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *Hconstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView(==keyView)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(keyView,_contentView)];
    NSArray *Vconstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView(==keyView)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(keyView,_contentView)];
    [keyView addConstraints:Hconstraint];
    [keyView addConstraints:Vconstraint];
    keyView.transform = CGAffineTransformMakeRotation(M_PI_2);
    keyView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [keyView layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
