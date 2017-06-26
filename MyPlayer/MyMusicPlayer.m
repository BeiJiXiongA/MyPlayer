
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
        
    }
    return self;
}

#pragma mark - 播放
-(void)playMusic:(NSString *)musicPath
{
    if ([_player isPlaying]) {
        [_player stop];
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
@end
