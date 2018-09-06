//
//  ARDetailViewController.h
//  ARVideo
//
//  Created by youdian on 2018/7/27.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ARDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataList;
@property (strong, nonatomic)ARModel *ar;
@property (strong, nonatomic)HttpManager *manager;
@property (strong, nonatomic) MPMoviePlayerController * movieplayer;
@property (nonatomic ,copy) NSString *urlString;
@end
