
//
//  PlayingMusicInfo.m
//  MyPlayer
//
//  Created by zw on 17/6/30.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "PlayingMusicInfo.h"

static PlayingMusicInfo *currentMusicInfo;

@implementation PlayingMusicInfo

+(PlayingMusicInfo *)sharedMusicInfo
{
    if (!currentMusicInfo) {
        currentMusicInfo = [[PlayingMusicInfo alloc] init];
    }
    return currentMusicInfo;;
}

@end
