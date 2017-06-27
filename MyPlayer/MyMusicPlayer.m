
//
//  MyMusicPlayer.m
//  MyPlayer
//
//  Created by zw on 17/6/25.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "MyMusicPlayer.h"

static MyMusicPlayer *musicPlayer;

@implementation MyMusicPlayer

+(MyMusicPlayer *)sharedMusicPlayer
{
    if (!musicPlayer) {
        musicPlayer = [[MyMusicPlayer alloc] init];
    }
    return musicPlayer;
}

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}

-(void)handleInterreption:(NSNotification *)sender
{
    [self playClick:nil];
}

#pragma mark - 播放
-(void)playMusic:(MusicModel *)musicModel
{
    _currentMusicModel = musicModel;
    NSString *musicPath = [CatalogueTools getDocumentPathWithName:musicModel.musicName];
    if ([_player isPlaying]) {
        [_player stop];
        _player = nil;
        [_timer invalidate];
        _timer = nil;
    }
    
//    NSString *name = [[musicPath lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:musicPath] error:&error];
    
    _player.delegate = self;
    
    if ([_player prepareToPlay]) {
        [_player play];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
    }else{
        NSLog(@"error %@",error);
    }
    
//    currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
//    currentTime = [timeFormatter stringFromDate:currentDate];
//    leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
//    leftTime = [timeFormatter stringFromDate:leftDate];
}

-(void)progressRefresh
{
    NSLog(@"%f",_player.currentTime);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next];
}

-(void)next
{
    NSInteger index = [_musicList indexOfObject:_currentMusicModel];
    if (index == _musicList.count - 1) {
        _currentMusicModel = [_musicList firstObject];
    }else{
        _currentMusicModel = [_musicList objectAtIndex:++index];
    }
    [self playMusic:_currentMusicModel];
}


-(void)pre
{
    NSInteger index = [_musicList indexOfObject:_currentMusicModel];
    if (index == _musicList.count - 1) {
        _currentMusicModel = [_musicList firstObject];
    }else{
        _currentMusicModel = [_musicList objectAtIndex:--index];
    }
    [self playMusic:_currentMusicModel];
}

-(void)playClick:(void (^)(BOOL isPlaying))action
{
    if ([_player isPlaying]) {
        [_player stop];
    }else{
        [_player play];
    }
    if (action) {
        action(_player.isPlaying);
    }
}

@end
