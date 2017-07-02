//
//  MyMusicPlayer.h
//  MyPlayer
//
//  Created by zw on 17/6/25.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import "PlayingMusicInfo.h"

@interface MyMusicPlayer : NSObject<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, strong) MusicModel *currentMusicModel;

@property (nonatomic, copy) void (^processChanged)(void);

+(MyMusicPlayer *)sharedMusicPlayer;

-(void)playMusic:(MusicModel *)musicModel andAction:(void (^)(PlayingMusicInfo *musicInfo))playedAction;

-(void)playMusic:(MusicModel *)musicModel;

-(void)pre;

-(void)next;

-(void)pause;

-(void)resumePlay;

-(void)playAtTime:(NSTimeInterval)seconds;

-(void)playClick:(void (^)(BOOL isPlaying))action;

-(UIImage *)getDefaultImage;

@end
