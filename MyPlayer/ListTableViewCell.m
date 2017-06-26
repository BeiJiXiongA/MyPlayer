
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
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(12, 12, WIDTH - 100, 20);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 5, (WIDTH - 24)/2-6, 20);
        _artistLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_artistLabel];
        
        _albumLabel = [[UILabel alloc] init];
        _albumLabel.frame = CGRectMake(_artistLabel.right+6, _nameLabel.bottom + 5, _artistLabel.width, 20);
        _albumLabel.textAlignment = NSTextAlignmentRight;
        _albumLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_albumLabel];
    }
    return self;
}

@end
