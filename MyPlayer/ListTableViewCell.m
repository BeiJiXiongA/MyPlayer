
//
//  ListTableViewCell.m
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(12, 12, 46, 46);
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 3;
        _iconImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _iconImageView.layer.borderWidth = 3;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        if ([[MyMusicPlayer sharedMusicPlayer] getDefaultImage]) {
            _iconImageView.image = [[MyMusicPlayer sharedMusicPlayer] getDefaultImage];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(_iconImageView.right+10, 12, WIDTH - 100, 20);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 5, (WIDTH - 24)/2-6, 20);
        _artistLabel.textColor = [UIColor whiteColor];
        _artistLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_artistLabel];
        
        _albumLabel = [[UILabel alloc] init];
        _albumLabel.frame = CGRectMake(_artistLabel.right+6, _nameLabel.bottom + 5, _artistLabel.width, 20);
        _albumLabel.textColor = [UIColor whiteColor];
        _albumLabel.textAlignment = NSTextAlignmentRight;
        _albumLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_albumLabel];
    }
    return self;
}

@end
