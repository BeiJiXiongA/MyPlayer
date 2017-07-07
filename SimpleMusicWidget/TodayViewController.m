//
//  TodayViewController.m
//  SimpleMusicWidget
//
//  Created by ZhangWei-SpaceHome on 2017/7/2.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = CGSizeMake(0, 200);
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if(activeDisplayMode == NCWidgetDisplayModeCompact) {
        // 尺寸只设置高度即可，因为宽度是固定的，设置了也不会有效果
        self.preferredContentSize = CGSizeMake(0, 110);
    } else {
        self.preferredContentSize = CGSizeMake(0, 310);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
