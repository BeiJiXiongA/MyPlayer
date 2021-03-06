//
//  ListTableViewCell.h
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (nonatomic, strong) CALayer *progressLayer;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *playStatusButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *albumLabel;
@property (nonatomic, copy) void (^playButtonClick)(void);

@end
