//
//  PlayerViewController.h
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayControlView.h"
#import "CatalogueTools.h"

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) MusicModel *currentMusicModel;
@property (nonatomic, strong) NSArray *musicList;

@end
