
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
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.title = _currentMusicModel.musicName;
    
    MusicPlayControlView *controlView = [[MusicPlayControlView alloc] initWithFrame:CGRectMake(0, HEIGHT - 140, WIDTH, 100)];
    controlView.musicList = _musicList;
    controlView.playedMusicModel = _currentMusicModel;
    [self.view addSubview:controlView];
    
    [controlView playMusicWithPath:[CatalogueTools getDocumentPathWithName:_currentMusicModel.musicName]];
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
