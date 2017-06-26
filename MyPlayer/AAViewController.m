//
//  AAViewController.m
//  MyPlayer
//
//  Created by zw on 16/3/26.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "AAViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Extention.h"
#import "MPMoviePlayerView.h"

typedef enum {
    PanTypeControlProgress = 0,
    PanTypeControlPlayer
}PanTypeControl;

@interface AAViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MPMoviePlayerController *player;
    NSString *currentMovieUrlString;
    UIView *playerControlView;
    
    BOOL fullScreen;
    PanTypeControl panType;
    
    CGFloat colorAlpha;
    
    UITableView *listTableView;
    NSMutableArray *listArray;
}
@end

@implementation AAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    listArray = [[NSMutableArray alloc] initWithCapacity:0];
    fullScreen = NO;
    colorAlpha = 0.5;
    panType = PanTypeControlProgress;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [listArray addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:docDir error:&error]];
    for (int i = 0; i < listArray.count; i++) {
        NSLog(@"%@",listArray[i]);
    }
    currentMovieUrlString = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",[listArray firstObject]]];
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:currentMovieUrlString]];
    player.controlStyle = MPMovieControlStyleFullscreen;
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
    player.view.backgroundColor = [UIColor blackColor];
    player.scalingMode = MPMovieScalingModeNone;
    [self.view addSubview:player.view];
    
    //播放，暂停
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play)];
    player.view.userInteractionEnabled = YES;
    playTap.numberOfTapsRequired = 2;
    [player.view addGestureRecognizer:playTap];
    
//    UITapGestureRecognizer *controlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControl)];
//    controlTap.numberOfTouchesRequired = 2;
//    [player.view addGestureRecognizer:controlTap];
    
//    playerControlView = [[UIView alloc] init];
//    playerControlView.frame = player.view.bounds;
//    playerControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [player.view addSubview:playerControlView];
    
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [player.view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [player.view addGestureRecognizer:pinchGestureRecognizer];
    
//    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [player.view addGestureRecognizer:panGestureRecognizer];
    
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, player.view.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - player.view.height) style:UITableViewStylePlain];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    listTableView.backgroundColor = [UIColor blackColor];
    listTableView.hidden = YES;
    [self.view insertSubview:listTableView belowSubview:player.view];
    
    NSArray *titleArray = @[@"🐶",@"🐱",@"🐭"];
    for(NSString *title in titleArray){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:title forState:UIControlStateNormal];
        backButton.frame = CGRectMake(SCREEN_WIDTH/titleArray.count*[titleArray indexOfObject:title], SCREEN_HEIGHT - 40, SCREEN_WIDTH/titleArray.count, 40);
        backButton.backgroundColor = [UIColor blackColor];
        [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showList)];
    tap.numberOfTapsRequired = 3;
    tap.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:tap];
}

-(void)showList
{
    listTableView.hidden = NO;
}

-(void)hideList
{
    listTableView.hidden = YES;
}

-(void)showControl
{
//    if (player.controlStyle == MPMovieControlStyleNone) {
//        player.controlStyle = MPMovieControlStyleFullscreen;
//    }else if(player.controlStyle == MPMovieControlStyleFullscreen){
//        player.controlStyle = MPMovieControlStyleNone;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"🐶"]) {
        [player stop];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([button.currentTitle isEqualToString:@"🐱"] ||
              [button.currentTitle isEqualToString:@"🐯"]){
        if (panType == PanTypeControlPlayer) {
            [button setTitle:@"🐱" forState:UIControlStateNormal];
            panType = PanTypeControlProgress;
        }else{
            [button setTitle:@"🐯" forState:UIControlStateNormal];
            panType = PanTypeControlPlayer;
        }
    }else if ([button.currentTitle isEqualToString:@"🐭"]){
        [self fullScreen];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"listcell"];
    }
    cell.textLabel.text = listArray[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentMovieUrlString = [self getFileFullPath:listArray[indexPath.row]];
    [self playMovie:currentMovieUrlString];
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

-(void)playMovie:(NSString *)moviePathString
{
    [self hideList];
    player.contentURL = [[NSURL alloc] initFileURLWithPath:moviePathString];
    [player prepareToPlay];
    [player play];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fileUrl = [self getFileFullPath:listArray[indexPath.row]];
        NSError *error = nil;
        if([[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:fileUrl] error:&error]){
            [listArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            NSLog(@"remove file error %@",error);
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"👅";
}

-(NSString *)getFileFullPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        NSLog(@"%f",rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    CGPoint startPoint = [panGestureRecognizer locationInView:player.view];
    if (panType == PanTypeControlProgress) {
        //快进/后退
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
            panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
        }else{
            CGPoint endPoint = [panGestureRecognizer locationInView:player.view];
            NSLog(@"%f -- %f",endPoint.x - startPoint.x,endPoint.y - startPoint.y);
            if (startPoint.x < SCREEN_HEIGHT/2) {
                //调节亮度
                NSLog(@"left");
            }else{
                //调节音量
                NSLog(@"right");
            }
        }
    }else if(panType == PanTypeControlPlayer){
        UIView *view = panGestureRecognizer.view;
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:view.superview];
            [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        }
    }
}

-(void)fullScreen
{
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform form;
        if (!fullScreen) {
            NSLog(@"full");
            form = CGAffineTransformMakeRotation(M_PI_2);
            player.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            player.view.center = self.view.center;
            [UIApplication sharedApplication].statusBarOrientation =  UIDeviceOrientationLandscapeLeft;
            fullScreen = YES;
        }else{
            NSLog(@"not full");
            form = CGAffineTransformRotate(player.view.transform, -M_PI_2);
            player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH/16*9, SCREEN_WIDTH);
            player.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH/16*9/2);
            fullScreen = NO;
        }
        player.view.transform = form;
        playerControlView.transform = form;
        playerControlView.frame = player.view.bounds;
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideList];
}

@end
