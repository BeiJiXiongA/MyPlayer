//
//  MPMoviePlayerView.m
//  MyPlayer
//
//  Created by zw on 16/3/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "MPMoviePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPMoviePlayerView ()
{
    MPMoviePlayerController *player;
    UIView *playerControlView;
}
@end

@implementation MPMoviePlayerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        
        player = [[MPMoviePlayerController alloc] init];
        player.controlStyle = MPMovieControlStyleNone;
        player.view.frame = frame;
        player.view.backgroundColor = [UIColor blackColor];
        player.scalingMode = MPMovieScalingModeNone;
        [self addSubview:player.view];
        
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play)];
        player.view.userInteractionEnabled = YES;
        playTap.numberOfTapsRequired = 2;
        [player.view addGestureRecognizer:playTap];
        
        playerControlView = [[UIView alloc] init];
        playerControlView.frame = player.view.bounds;
        playerControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [player.view addSubview:playerControlView];
    }
    return self;
}

-(void)play
{
    NSLog(@"movie duration = %f",player.duration);
    if (player.playbackState == MPMoviePlaybackStatePlaying) {
        [player pause];
    }else if(player.playbackState == MPMoviePlaybackStatePaused){
        [player play];
    }
}

-(void)stop
{
    [player stop];
}

-(void)playMovie:(NSString *)moviePathString
{
    player.contentURL = [[NSURL alloc] initFileURLWithPath:moviePathString];
    [player prepareToPlay];
    [player play];
}

@end
