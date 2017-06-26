//
//  MusicListViewController.m
//  MyPlayer
//
//  Created by zw on 17/6/24.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "MusicListViewController.h"
#import "ListTableViewCell.h"
#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>


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
    [self.view addSubview:_listTableView];
    _listTableView.tableFooterView = [[UIView alloc] init];
    
    [self freshList];
}

-(void)freshList
{
    [_listArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSError *error = nil;
    NSArray *documentFiles = [_fileManager contentsOfDirectoryAtPath:docDir error:&error];
    [documentFiles enumerateObjectsUsingBlock:^(NSString *musicName, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *musicPath = [CatalogueTools getDocumentPathWithName:musicName];
        MusicModel *model = [[MusicModel alloc] init];
        model.musicName = musicName;
        model.musicInfo = [self getInfoWithMusicPath:musicPath];
        [_listArray addObject:model];
    }];
    [_listTableView reloadData];
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
    listCell.nameLabel.text = [model.musicName stringByDeletingPathExtension];
    NSDictionary *infoDict = model.musicInfo;
    listCell.artistLabel.text = [infoDict objectForKey:@"artist"];
    listCell.albumLabel.text = [infoDict objectForKey:@"albumName"];
    return listCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicModel *model = [_listArray objectAtIndex:indexPath.row];
    PlayerViewController *player = [[PlayerViewController alloc] init];
    player.currentMusicModel = model;
    player.musicList = _listArray;
    [self.navigationController pushViewController:player animated:YES];
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
