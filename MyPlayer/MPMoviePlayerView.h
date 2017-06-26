//
//  MPMoviePlayerView.h
//  MyPlayer
//
//  Created by zw on 16/3/29.
//  Copyright © 2016年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMoviePlayerView : UIView

-(void)stop;

-(void)playMovie:(NSString *)moviePathString;

@end
