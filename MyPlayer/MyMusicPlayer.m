
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
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    }
    return self;
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"耳机插入");
            [self resumePlay];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"耳机拔出，停止播放操作");
            [self pause];
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleInterreption:(NSNotification *)sender
{
    [self playClick:nil];
}

#pragma mark - 播放
-(void)playMusic:(MusicModel *)musicModel andAction:(void (^)(PlayingMusicInfo *musicInfo))playedAction
{
    _currentMusicModel = musicModel;
    NSString *musicPath = [CatalogueTools getDocumentPathWithName:musicModel.musicName];
    if ([_player isPlaying]) {
        [_player stop];
        _player = nil;
        [_timer invalidate];
        _timer = nil;
    }
    
    NSError *error = nil;
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:musicPath];
    
    _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    
    _player.delegate = self;
    
    if ([_player prepareToPlay]) {
        [_player play];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
    }else{
        NSLog(@"error %@",error);
        [self next];
    }
    
    PlayingMusicInfo *musicInfo = [PlayingMusicInfo sharedMusicInfo];
    musicInfo.musicDuration = _player.duration;
    musicInfo.musicPlayedTime = 0;
    musicInfo.musicModel = musicModel;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlayMusic object:musicInfo];
    [self setPlayingInfoCenter];
    
    if (playedAction) {
        
    }
}

-(void)setPlayingInfoCenter
{
    PlayingMusicInfo *musicInfo = [PlayingMusicInfo sharedMusicInfo];
    MusicModel *musicModel = [PlayingMusicInfo sharedMusicInfo].musicModel;
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:musicModel.musicName forKey:MPMediaItemPropertyTitle];
    //歌手名
    if ([musicModel.musicInfo objectForKey:@"artist"]) {
        [songDict setObject:[musicModel.musicInfo objectForKey:@"artist"] forKey:MPMediaItemPropertyArtist];
    }
    
    //歌曲的总时间
    [songDict setObject:@(musicInfo.musicDuration) forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    
    if (musicInfo.musicPlayedTime > 0) {
        [songDict setObject:@(musicInfo.musicPlayedTime) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    }
    
    //设置歌曲图片
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultimage"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultimage"];
        MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageWithData:imageData]];
        [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    }
    //设置控制中心歌曲信息
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

-(void)playMusic:(MusicModel *)musicModel
{
    [self playMusic:musicModel andAction:nil];
}

-(void)progressRefresh
{
    PlayingMusicInfo *musicInfo = [PlayingMusicInfo sharedMusicInfo];
    musicInfo.musicDuration = _player.duration;
    musicInfo.musicPlayedTime = _player.currentTime;
    if (self.processChanged) {
        self.processChanged();
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next];
}

-(NSInteger)getCurrentMusicIndex
{
    __block NSInteger index = 0;
    if ([_musicList containsObject:_currentMusicModel]) {
        index = [_musicList indexOfObject:_currentMusicModel];
    }else{
        [_musicList enumerateObjectsUsingBlock:^(MusicModel *musicModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([musicModel.musicName isEqualToString:_currentMusicModel.musicName]) {
                index = idx;
            }
        }];
    }
    return index;
}

-(void)next
{
    NSInteger index = [self getCurrentMusicIndex];
    if (index == _musicList.count - 1) {
        _currentMusicModel = [_musicList firstObject];
    }else{
        _currentMusicModel = [_musicList objectAtIndex:++index];
    }
    [self playMusic:_currentMusicModel];
}


-(void)pre
{
    NSInteger index = [self getCurrentMusicIndex];
    if (index == 0) {
        _currentMusicModel = [_musicList lastObject];
    }else{
        _currentMusicModel = [_musicList objectAtIndex:--index];
    }
    [self playMusic:_currentMusicModel];
}

-(void)pause
{
    [_player stop];
    if (self.playStateChanged) {
        self.playStateChanged(NO);
    }
}

-(void)resumePlay
{
    [_player play];
    if (self.playStateChanged) {
        self.playStateChanged(YES);
    }
}

-(void)playAtTime:(NSTimeInterval)seconds
{
    [_player setCurrentTime:seconds];
    [PlayingMusicInfo sharedMusicInfo].musicPlayedTime = seconds;
    [self setPlayingInfoCenter];
}

-(void)playClick:(void (^)(BOOL isPlaying))action
{
    if ([_player isPlaying]) {
        [self pause];
    }else{
        [self resumePlay];
    }
    if (action) {
        action(_player.isPlaying);
    }
}

-(UIImage *)getDefaultImage
{
    UIImage *image = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultimage"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultimage"];
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

@end
