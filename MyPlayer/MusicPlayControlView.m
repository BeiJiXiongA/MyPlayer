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
    UILabel *progressLeftLabel;
    UILabel *progressRightLabel;
    UISlider *progressSlider;
    
    UIButton *playButton;
    UIButton *backwordButton;
    UIButton *forwardButton;
    
    MyMusicPlayer *myMusicPlayer;
}
@end

@implementation MusicPlayControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(50, 0, WIDTH - 100, 40)];
        progressSlider.backgroundColor = [UIColor clearColor];
        progressSlider.tag = 201;
        progressSlider.maximumValue = 100;
        progressSlider.minimumValue =0;
        [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"player_slider_playback_left.png"] forState:UIControlStateNormal];
        [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"player_slider_playback_right.png"] forState:UIControlStateNormal];
        [progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb.png"] forState:UIControlStateNormal];
        [progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:progressSlider];
        
        progressLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, progressSlider.top, 40, 40)];
        progressLeftLabel.textColor = [UIColor whiteColor];
        progressLeftLabel.font = [UIFont systemFontOfSize:10];
        progressLeftLabel.textAlignment = NSTextAlignmentCenter;
        progressLeftLabel.text = @"00:00";
        progressLeftLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:progressLeftLabel];
        
        progressRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressSlider.right, progressLeftLabel.top, 40, 40)];
        progressRightLabel.font = [UIFont systemFontOfSize:10];
        progressRightLabel.textColor = [UIColor whiteColor];
        progressRightLabel.text = @"00:00";
        progressRightLabel.textAlignment = NSTextAlignmentCenter;
        progressRightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:progressRightLabel];
        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.backgroundColor = [UIColor clearColor];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        playButton.frame = CGRectMake(self.width/2 - 18.5, progressSlider.top+50,  37, 37);
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
        
        myMusicPlayer = [MyMusicPlayer sharedMusicPlayer];
 
    }
    return self;
}

-(void)playMusicWithPath:(NSString *)musicPath
{
    [myMusicPlayer playMusic:musicPath];
}

-(void)valueChanged:(UISlider *)slider
{
    
}

-(void)nextMusic:(UIButton *)button
{
    NSInteger index = [_musicList indexOfObject:_playedMusicModel];
    if (index == _musicList.count - 1) {
        _playedMusicModel = [_musicList firstObject];
    }else{
        _playedMusicModel = [_musicList objectAtIndex:++index];
    }
    [myMusicPlayer playMusic:[CatalogueTools getDocumentPathWithName:_playedMusicModel.musicName]];
}

-(void)preMusic:(UIButton *)button
{
    NSInteger index = [_musicList indexOfObject:_playedMusicModel];
    if (index == 0) {
        _playedMusicModel = [_musicList lastObject];
    }else{
        _playedMusicModel = [_musicList objectAtIndex:--index];
    }
    [myMusicPlayer playMusic:[CatalogueTools getDocumentPathWithName:_playedMusicModel.musicName]];
}

-(void)controlMusic:(UIButton *)button
{
    if ([myMusicPlayer.player isPlaying]) {
        [myMusicPlayer.player stop];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }else{
        [myMusicPlayer.player play];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

@end
