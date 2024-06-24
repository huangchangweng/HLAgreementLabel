//
//  HLViewController.m
//  HLAgreementLabel
//
//  Created by huangchangweng on 06/21/2024.
//  Copyright (c) 2024 huangchangweng. All rights reserved.
//

#import "HLViewController.h"
#import <HLAgreementLabel/HLAgreementLabel.h>

@interface HLViewController ()
@property (weak, nonatomic) IBOutlet HLAgreementLabel *agreementLabel;
@end

@implementation HLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    __weak typeof(self) weakSelf = self;
    
    // 点击高亮部分文字点击回调，注意weakSelf
    self.agreementLabel.highlightTextTapBlock = ^(NSString *highlightStr, NSRange range) {
        [weakSelf showAlert:[NSString stringWithFormat:@"点击了：%@", highlightStr]];
    };
    
    // 点击选择图标回调
    // 一般不用监听，直接用self.agreementLabel.selected判断是否选中
    self.agreementLabel.iconTapBlock = ^(BOOL selected, NSRange range) {
        NSLog(@"点击了选择图标为：%@", selected ? @"选中" : @"未选中");
    };
}

#pragma mark - Private Method

- (void)showAlert:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tip"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
