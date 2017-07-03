//
//  AppDelegate.m
//  MyPlayer
//
//  Created by zw on 16/3/26.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicListViewController.h"
//http://www.jianshu.com/p/ab300ea6e90c 后台播放

@interface AppDelegate ()
@property (nonatomic, assign) NSUInteger bgTaskId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:PlayedMusicInfoMusicName]) {
        [self playTerminateMusic];
        [[MyMusicPlayer sharedMusicPlayer] pause];
    }
    
    MusicListViewController *list = [[MusicListViewController alloc] init];
    UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:list];
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //或者用这个都行
    
    //    [bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    self.window.rootViewController = listNav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)playTerminateMusic
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:PlayedMusicInfoMusicName]) {
        PlayingMusicInfo *musicInfo = [PlayingMusicInfo sharedMusicInfo];
        musicInfo.musicPlayedTime = [[ud objectForKey:PlayedMusicInfoPlayedTime] doubleValue];
        musicInfo.musicDuration = [[ud objectForKey:PlayedMusicInfoDuration] doubleValue];
        MusicModel *musicModel = [[MusicModel alloc] init];
        musicModel.musicName = [ud objectForKey:PlayedMusicInfoMusicName];
        musicModel.musicInfo = [ud objectForKey:PlayedMusicInfoMusicInfo];
        musicInfo.musicModel = musicModel;
        [[MyMusicPlayer sharedMusicPlayer] playMusic:musicModel];
        [[MyMusicPlayer sharedMusicPlayer] playAtTime:[[ud objectForKey:PlayedMusicInfoPlayedTime] doubleValue]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    _bgTaskId=[self backgroundPlayerID:_bgTaskId];
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
}
//实现一下backgroundPlayerID:这个方法:
- (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if(event.type==UIEventTypeRemoteControl)
    {
        NSInteger order=-1;
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                order=UIEventSubtypeRemoteControlPause;
                [[MyMusicPlayer sharedMusicPlayer] pause];//101
                break;
            case UIEventSubtypeRemoteControlPlay:
                order=UIEventSubtypeRemoteControlPlay;  //100
                if ([PlayingMusicInfo sharedMusicInfo].musicModel) {
                    [[MyMusicPlayer sharedMusicPlayer] resumePlay];
                }else{
                    [self playTerminateMusic];
                }
                
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                order=UIEventSubtypeRemoteControlNextTrack;
                [[MyMusicPlayer sharedMusicPlayer] next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                order=UIEventSubtypeRemoteControlPreviousTrack;
                [[MyMusicPlayer sharedMusicPlayer] pre];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                order=UIEventSubtypeRemoteControlTogglePlayPause;
                [[MyMusicPlayer sharedMusicPlayer] pause];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:{
                NSLog(@"单击，再按下不放：108");
            }break;
                
            case UIEventSubtypeRemoteControlEndSeekingForward:{
                NSLog(@"单击，再按下不放，松开时：109");                 }break;
            default:
                break;
        }
        NSDictionary *orderDict=@{@"order":@(order)};
        NSLog(@"order dict %@",orderDict);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if ([PlayingMusicInfo sharedMusicInfo].musicModel) {
        [[NSUserDefaults standardUserDefaults] setObject:@([PlayingMusicInfo sharedMusicInfo].musicDuration) forKey:PlayedMusicInfoDuration];
        [[NSUserDefaults standardUserDefaults] setObject:@([PlayingMusicInfo sharedMusicInfo].musicPlayedTime) forKey:PlayedMusicInfoPlayedTime];
        [[NSUserDefaults standardUserDefaults] setObject:[PlayingMusicInfo sharedMusicInfo].musicModel.musicName forKey:PlayedMusicInfoMusicName];
        [[NSUserDefaults standardUserDefaults] setObject:[PlayingMusicInfo sharedMusicInfo].musicModel.musicInfo forKey:PlayedMusicInfoMusicInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
