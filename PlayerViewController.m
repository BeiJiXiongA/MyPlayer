
//
//  PlayerViewController.m
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = _currentMusicModel.musicName;
    
    MusicPlayControlView *controlView = [[MusicPlayControlView alloc] initWithFrame:CGRectMake(0, HEIGHT - 140, WIDTH, 100)];
    controlView.musicList = _musicList;
    controlView.playedMusicModel = _currentMusicModel;
    [self.view addSubview:controlView];
    
    if ([[MyMusicPlayer sharedMusicPlayer] getDefaultImage]){
        UIImageView *defaultImageView = [[UIImageView alloc] init];
        defaultImageView.frame = CGRectMake(40, controlView.top -  WIDTH + 40*2-50, WIDTH - 40*2, WIDTH - 40*2);
        defaultImageView.layer.cornerRadius = 5;
        defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
        defaultImageView.clipsToBounds = YES;
        defaultImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        defaultImageView.layer.borderWidth = 5;
        [self.view addSubview:defaultImageView];
        defaultImageView.image = [[MyMusicPlayer sharedMusicPlayer] getDefaultImage];
    }
    
    if (![MyMusicPlayer sharedMusicPlayer].currentMusicModel ||
        ![_currentMusicModel.musicName isEqualToString:[MyMusicPlayer sharedMusicPlayer].currentMusicModel.musicName]) {
        [controlView play];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayMusicNotification:) name:PlayMusic object:nil];
}

-(void)receivePlayMusicNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[PlayingMusicInfo class]]) {
        PlayingMusicInfo *musicInfo = (PlayingMusicInfo *)notification.object;
        self.title = musicInfo.musicModel.musicName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
