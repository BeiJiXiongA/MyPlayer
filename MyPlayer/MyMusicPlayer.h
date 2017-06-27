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

@interface MyMusicPlayer : NSObject<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, strong) MusicModel *currentMusicModel;

+(MyMusicPlayer *)sharedMusicPlayer;

-(void)playMusic:(MusicModel *)musicModel;

-(void)pre;

-(void)next;

-(void)playClick:(void (^)(BOOL isPlaying))action;

@end
