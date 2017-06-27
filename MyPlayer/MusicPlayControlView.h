//
//  MusicPlayControlView.h
//  MyPlayer
//
//  Created by zw on 17/6/25.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayControlView : UIView

@property (nonatomic, strong) MusicModel *playedMusicModel;
@property (nonatomic, strong) NSArray *musicList;

-(void)play;

@end
