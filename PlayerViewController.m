
//
//  PlayerViewController.m
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSFileManager *fileManager;
}
@property (nonatomic, strong) UIImageView *defaultImageView;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = _currentMusicModel.musicName;
    
    fileManager = [NSFileManager defaultManager];
    
    MusicPlayControlView *controlView = [[MusicPlayControlView alloc] initWithFrame:CGRectMake(0, HEIGHT - 140, WIDTH, 100)];
    controlView.musicList = _musicList;
    controlView.playedMusicModel = _currentMusicModel;
    [self.view addSubview:controlView];
    
    if ([[MyMusicPlayer sharedMusicPlayer] getDefaultImage]){
        _defaultImageView = [[UIImageView alloc] init];
        _defaultImageView.frame = CGRectMake(40, controlView.top -  WIDTH + 40*2-50, WIDTH - 40*2, WIDTH - 40*2);
        _defaultImageView.layer.cornerRadius = 5;
        _defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
        _defaultImageView.clipsToBounds = YES;
        _defaultImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _defaultImageView.layer.borderWidth = 5;
        [self.view addSubview:_defaultImageView];
        _defaultImageView.image = [[MyMusicPlayer sharedMusicPlayer] getDefaultImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
        _defaultImageView.userInteractionEnabled = YES;
        [_defaultImageView addGestureRecognizer:tap];
        
        if ([fileManager fileExistsAtPath:[CatalogueTools getImageDirectoryPath:[self.currentMusicModel.musicName stringByDeletingPathExtension]]]) {
            UIImage *musicImage = [UIImage imageWithContentsOfFile:[CatalogueTools getImageDirectoryPath:[self.currentMusicModel.musicName stringByDeletingPathExtension]]];
            [_defaultImageView setImage:musicImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:MusicAlbumImageChanged object:nil];
        }
    }
    
    if (![MyMusicPlayer sharedMusicPlayer].currentMusicModel ||
        ![_currentMusicModel.musicName isEqualToString:[MyMusicPlayer sharedMusicPlayer].currentMusicModel.musicName]) {
        [controlView play];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayMusicNotification:) name:PlayMusic object:nil];
}

-(void)selectImage
{
    UIAlertController *alterController = [[UIAlertController alloc] init];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }];
        [alterController addAction:cameraAction];
    }
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"翻翻相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alterController addAction:albumAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alterController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alterController addAction:cancelAction];
    
    [self presentViewController:alterController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    if (picker == picker_camera_)
    //    {
    //        //如果是 来自照相机的image，那么先保存
    //        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //        UIImageWriteToSavedPhotosAlbum(original_image, self,
    //                                       @selector(image:didFinishSavingWithError:contextInfo:),
    //                                       nil);
    //    }
    //
    //    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _defaultImageView.image = image;
        
        NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
        MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:image];
        [dict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        NSLog(@"%@",[CatalogueTools getImageDirectoryPath:[self.currentMusicModel.musicName stringByDeletingPathExtension]]);
        if ([UIImageJPEGRepresentation(image, 1.0) writeToFile:[CatalogueTools getImageDirectoryPath:[self.currentMusicModel.musicName stringByDeletingPathExtension]] atomically:YES]) {
            NSLog(@"image write success!");
        }
//        [UIImagePNGRepresentation(image) writeToFile:[CatalogueTools getDocumentPathWithName:[NSString stringWithFormat:@""]] atomically:YES];
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
