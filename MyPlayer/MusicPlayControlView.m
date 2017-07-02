//
//  MusicPlayControlView.m
//  MyPlayer
//
//  Created by zw on 17/6/25.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "MusicPlayControlView.h"

@interface MusicPlayControlView ()
{
    UIButton *playButton;
    UIButton *backwordButton;
    UIButton *forwardButton;
    
    MyMusicPlayer *myMusicPlayer;
    
    NSDateFormatter *timeFormatter;
}
@property (nonatomic, strong) UILabel *progressLeftLabel;
@property (nonatomic, strong) UILabel *progressRightLabel;
@property (nonatomic, strong) UISlider *progressSlider;
@end

@implementation MusicPlayControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        timeFormatter = [[NSDateFormatter alloc]init];
        [timeFormatter setDateFormat:@"mm:ss"];
        
        _progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(50, 0, WIDTH - 100, 40)];
        _progressSlider.backgroundColor = [UIColor clearColor];
        _progressSlider.tag = 201;
        _progressSlider.maximumValue = 1;
        _progressSlider.minimumValue =0;
        [_progressSlider setMinimumTrackImage:[UIImage imageNamed:@"player_slider_playback_left.png"] forState:UIControlStateNormal];
        [_progressSlider setMaximumTrackImage:[UIImage imageNamed:@"player_slider_playback_right.png"] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb.png"] forState:UIControlStateNormal];
        [_progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_progressSlider];
        
        _progressLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _progressSlider.top, 40, 40)];
        _progressLeftLabel.textColor = [UIColor whiteColor];
        _progressLeftLabel.font = [UIFont systemFontOfSize:10];
        _progressLeftLabel.textAlignment = NSTextAlignmentCenter;
        _progressLeftLabel.text = @"00:00";
        _progressLeftLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_progressLeftLabel];
        
        _progressRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(_progressSlider.right, _progressLeftLabel.top, 40, 40)];
        _progressRightLabel.font = [UIFont systemFontOfSize:10];
        _progressRightLabel.textColor = [UIColor whiteColor];
        _progressRightLabel.text = @"00:00";
        _progressRightLabel.textAlignment = NSTextAlignmentCenter;
        _progressRightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_progressRightLabel];
        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.backgroundColor = [UIColor clearColor];
        if ([MyMusicPlayer sharedMusicPlayer].player.isPlaying) {
            [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }else{
            [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
        
        playButton.frame = CGRectMake(self.width/2 - 18.5, _progressSlider.top+50,  37, 37);
        [playButton addTarget:self action:@selector(controlMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        
        backwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backwordButton setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
        backwordButton.frame = CGRectMake(playButton.left - 57, playButton.top, 37, 37);
        [backwordButton addTarget:self action:@selector(preMusic:) forControlEvents:UIControlEventTouchUpInside];
        backwordButton.backgroundColor = [UIColor clearColor];
        [self addSubview:backwordButton];
        
        forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forwardButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [forwardButton addTarget:self action:@selector(nextMusic:) forControlEvents:UIControlEventTouchUpInside];
        forwardButton.backgroundColor = [UIColor clearColor];
        forwardButton.frame = CGRectMake(playButton.right + 20, playButton.top,  37, 37);
        [self addSubview:forwardButton];
        
        __weak MusicPlayControlView *weakSelf = self;
        myMusicPlayer = [MyMusicPlayer sharedMusicPlayer];
        myMusicPlayer.processChanged = ^(){
            [weakSelf progressChanged];
        };
        
        PlayingMusicInfo *musicInfo = [PlayingMusicInfo sharedMusicInfo];
        if (musicInfo.musicModel) {
            _progressLeftLabel.text = [self getTimeStringWithSeconds:0];
            _progressRightLabel.text = [self getTimeStringWithSeconds:musicInfo.musicDuration];
            _progressSlider.value = musicInfo.musicPlayedTime/musicInfo.musicDuration;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayMusicNotification:) name:PlayMusic object:nil];
 
    }
    return self;
}


-(void)receivePlayMusicNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[PlayingMusicInfo class]]) {
        PlayingMusicInfo *musicInfo = (PlayingMusicInfo *)notification.object;
        _progressLeftLabel.text = [self getTimeStringWithSeconds:0];
        _progressRightLabel.text = [self getTimeStringWithSeconds:musicInfo.musicDuration];
        _progressSlider.value = musicInfo.musicPlayedTime/musicInfo.musicDuration;
    }
}


-(void)play
{
    [myMusicPlayer playMusic:_playedMusicModel];
}

-(void)valueChanged:(UISlider *)slider
{
    PlayingMusicInfo *musidInfo = [PlayingMusicInfo sharedMusicInfo];
    NSTimeInterval sliderValue = _progressSlider.value * musidInfo.musicDuration;
    musidInfo.musicPlayedTime = sliderValue;
    [self progressChanged];
    [myMusicPlayer playAtTime:sliderValue];
    
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    [dict setObject:@(sliderValue) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

-(void)progressChanged
{
    PlayingMusicInfo *processInfo = [PlayingMusicInfo sharedMusicInfo];
    self.progressLeftLabel.text = [self getTimeStringWithSeconds:processInfo.musicPlayedTime];
    self.progressRightLabel.text = [self getTimeStringWithSeconds:processInfo.musicDuration-processInfo.musicPlayedTime];
    self.progressSlider.value = processInfo.musicPlayedTime/processInfo.musicDuration;
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    [dict setObject:@(processInfo.musicPlayedTime) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

-(void)nextMusic:(UIButton *)button
{
    [myMusicPlayer next];
}

-(void)preMusic:(UIButton *)button
{
    [myMusicPlayer pre];
}

-(void)controlMusic:(UIButton *)button
{
    [myMusicPlayer playClick:^(BOOL isPlaying){
        if (isPlaying) {
            [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }else{
            [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
    }];
}

-(NSString *)getTimeStringWithSeconds:(NSTimeInterval)seconds
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    NSString *currentTime = [timeFormatter stringFromDate:currentDate];
    return currentTime;
}

@end
