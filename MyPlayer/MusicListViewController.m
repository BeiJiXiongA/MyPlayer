//
//  MusicListViewController.m
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MusicListViewController.h"
#import "ListTableViewCell.h"
#import "PlayerViewController.h"
#import "SettingViewController.h"


@interface MusicListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"音乐列表";
    
    _listArray = [[NSMutableArray alloc] init];
    _fileManager = [NSFileManager defaultManager];
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_listTableView];
    _listTableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(toSettingView)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"正在播放" style:UIBarButtonItemStylePlain target:self action:@selector(toPlayingView)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self freshList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PlayingMusicInfo *currentMusicInfo = [PlayingMusicInfo sharedMusicInfo];
    if (currentMusicInfo.musicModel) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)toPlayingView
{
    [self toPlayingView:[PlayingMusicInfo sharedMusicInfo].musicModel];
}

-(void)toSettingView
{
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

-(void)toPlayingView:(MusicModel *)model
{
    PlayerViewController *player = [[PlayerViewController alloc] init];
    player.currentMusicModel = model;
    [self.navigationController pushViewController:player animated:YES];
}

-(void)freshList
{
    [_listArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSLog(@"doc path %@",docDir);
    NSError *error = nil;
    NSArray *documentFiles = [_fileManager contentsOfDirectoryAtPath:docDir error:&error];
    [documentFiles enumerateObjectsUsingBlock:^(NSString *musicName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *musicPath = [CatalogueTools getDocumentPathWithName:musicName];
            MusicModel *model = [[MusicModel alloc] init];
            model.musicName = musicName;
            model.musicInfo = [self getInfoWithMusicPath:musicPath];
            [_listArray addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MyMusicPlayer sharedMusicPlayer].musicList = _listArray;
                [_listTableView reloadData];
            });
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIder = @"listcell";
    ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellIder];
    if (!listCell) {
        listCell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];
    }
    MusicModel *model = [_listArray objectAtIndex:indexPath.row];
    listCell.nameLabel.text = [NSString stringWithFormat:@"%ld.%@",indexPath.row,[model.musicName stringByDeletingPathExtension]];
    NSDictionary *infoDict = model.musicInfo;
    listCell.artistLabel.text = [infoDict objectForKey:@"artist"];
    listCell.albumLabel.text = [infoDict objectForKey:@"albumName"];
    return listCell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MusicModel *model = [_listArray objectAtIndex:indexPath.row];
        [_listArray removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        if (![fileManager removeItemAtPath:[CatalogueTools getDocumentPathWithName:model.musicName] error:&error]) {
            NSLog(@"file remove error %@",error);
        }else{
            NSLog(@"file remove success!");
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicModel *model = [_listArray objectAtIndex:indexPath.row];
    [self toPlayingView:model];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSDictionary *)getInfoWithMusicPath:(NSString *)musicPath
{
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:musicPath] options:nil];
    NSLog(@"%@",[mp3Asset availableMetadataFormats]);
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
    for (NSString *format  in [mp3Asset availableMetadataFormats]) {
        
        NSLog(@"format type = %@",format);
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            NSLog(@"commonKey = %@",metadataItem.commonKey);
            
            if([metadataItem.commonKey isEqualToString:@"title"])
            {
                NSString *title = (NSString *)metadataItem.value;
                NSLog(@"title: %@",title);
                
                [infoDict setObject:title forKey:@"title"];
            }
            else if([metadataItem.commonKey isEqualToString:@"artist"])
            {
                NSString *artist = (NSString *)metadataItem.value;
                NSLog(@"artist: %@",artist);
                
                [infoDict setObject:artist forKey:@"artist"];
            }
            else if([metadataItem.commonKey isEqualToString:@"albumName"])
            {
                NSString *albumName = (NSString *)metadataItem.value;
                NSLog(@"albumName: %@",albumName);
                
                [infoDict setObject:albumName forKey:@"albumName"];
            }
        }
    }
    return infoDict;
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
