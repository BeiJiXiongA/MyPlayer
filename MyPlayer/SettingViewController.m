//
//  SettingViewController.m
//  MyPlayer
//
//  Created by ZhangWei-SpaceHome on 2017/7/2.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *defaultImageView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"设置";
    
    _defaultImageView = [[UIImageView alloc] init];
    _defaultImageView.frame = CGRectMake((WIDTH - 200)/2, 100, 200, 200);
    _defaultImageView.layer.cornerRadius = 5;
    _defaultImageView.clipsToBounds = YES;
    _defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
    _defaultImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _defaultImageView.layer.borderWidth = 5;
    [self.view addSubview:_defaultImageView];
    
    if ([[MyMusicPlayer sharedMusicPlayer] getDefaultImage]){
        _defaultImageView.image = [[MyMusicPlayer sharedMusicPlayer] getDefaultImage];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
    _defaultImageView.userInteractionEnabled = YES;
    [_defaultImageView addGestureRecognizer:tap];
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
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"defaultimage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
