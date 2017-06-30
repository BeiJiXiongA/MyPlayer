//
//  PlayingMusicInfo.h
//  MyPlayer
//
//  Created by zw on 17/6/30.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

@interface PlayingMusicInfo : NSObject

@property (nonatomic, assign) NSTimeInterval musicDuration;

@property (nonatomic, assign) NSTimeInterval musicPlayedTime;

@property (nonatomic, strong) MusicModel *musicModel;

@end
