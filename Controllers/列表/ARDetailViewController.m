//
//  ARDetailViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/27.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ARDetailViewController.h"
#import "QTextField.h"
#import "UIImageView+WebCache.h"
#import "TableViewCell.h"
#import "SearchViewController.h"

#import "ReportViewController.h"//举报






@interface ARDetailViewController ()<UITextFieldDelegate>
{
    UIView *blackView;
}
@property (strong, nonatomic)UILabel *hot;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic)UITextField *commentTF;
@property (strong, nonatomic)QTextField *searchTextField;
@property (strong, nonatomic)UILabel *label1;
@property (strong, nonatomic)UILabel *label2;
@property (strong, nonatomic)UILabel *label3;
@property (strong, nonatomic)UILabel *label4;
@property (strong, nonatomic)UILabel *reviewLabel;
@property (strong, nonatomic)UIImageView *gzImgView;

@property (strong, nonatomic)UIImageView *topImgView;
@property (nonatomic, strong)  NSURLSessionDownloadTask *downloadTask;
@end

@implementation ARDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getARdetail];
    [self.view addSubview:self.tableView];
    [self requestCommentList];
    
    
    // Do any additional setup after loading the view.
}

#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment *comment = self.dataList[indexPath.row];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:comment.adminImage]];
    cell.nameLabel.text = comment.adminName.length>0?comment.adminName:self.ar.name;
    NSString *date = [NSString stringWithFormat:@"%ld",comment.createdAt];
    NSString *dateString  = [NSString getDateWithTimeStamp:date dateFormatter:@"YYYY-MM-dd"];
    cell.dateLabel.text = dateString;
    cell.contentLabel.text = comment.content;
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    UIImageView *zanImg = cell.zanView;
    UITapGestureRecognizer *tapZan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zanTap:)];
    if (sessionId.length>0) {
        [zanImg addGestureRecognizer:tapZan];
    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",comment.counts];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"关于评论" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ReportViewController *report = [ReportViewController new];
        report.rType = @"2";
         Comment *comment = self.dataList[indexPath.row];
        report.contentId = [NSString stringWithFormat:@"%ld",comment.id];
        report.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:report animated:YES];
    }];
    
    
    
    
    [actionSheet addAction:reportAction];
    [actionSheet addAction:cacelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
    
}


#pragma mark 点赞
-(void)zanTap:(UITapGestureRecognizer *)gesture{
    WS(weakSelf)
    TableViewCell *cell = (TableViewCell *)[gesture.view superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    Comment *comment = self.dataList[indexPath.row];
    NSNumber *commentId = [NSNumber numberWithInteger:comment.id];
    [self.manager arCommentGiveWithSessionIdAndCommentId:commentId success:^(Response *response) {
        WTOAST(response.msg.desc);
        if (response.msg.status ==0) {
            [weakSelf requestCommentList];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
    
    
    
    
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableViewHeader];
        _tableView.tableFooterView = [[UIView alloc]init];
         _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"CommentCell"];
    }
    return _tableView;
}


-(UIView *)tableViewHeader{
    WS(weakSelf)
    UIView *header = [UIView new];
   // header.backgroundColor = [UIColor redColor];
    header.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 445+40);
    UIImageView *nav = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    nav.userInteractionEnabled = YES;
    [header addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(header);
        make.height.mas_equalTo(110*PIX);
    }];
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
    searchTF.placeholder = @"请输入您要搜索的内容";
    searchTF.backgroundColor = [UIColor lightTextColor];
    searchTF.delegate = self;
    [nav addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav).offset(40);
        make.top.equalTo(nav).offset(34);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 38));
    }];
    _searchTextField = searchTF;
    UIImageView *searchImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"search")];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap:)];
    searchImgView.userInteractionEnabled = YES;
    [searchImgView addGestureRecognizer:searchTap];
    [nav addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchTF).offset(-15);
        make.centerY.equalTo(searchTF);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [header addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchTF);
        make.left.equalTo(header).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIImageView *bgImgView = [UIImageView new];
    bgImgView.frame = CGRectMake(0, 100*PIX, SCREEN_WIDTH, 235);
    bgImgView.image = IMAGE_NAME(@"video_back_iv");
    NSString *urlString = self.ar.imageUrl.length>0?self.ar.imageUrl:self.ar.image_url;
//    [bgImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [header addSubview:bgImgView];
    
    
//    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    effectView.frame = bgImgView.frame;
//    [header addSubview:effectView];
    
    UIImageView *imgView = [UIImageView new];
    imgView.layer.masksToBounds = YES;
    imgView.contentMode =  UIViewContentModeScaleAspectFill;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [imgView addGestureRecognizer:videoTap];
    [header addSubview:imgView];
    _topImgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgImgView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 185));
    }];
    UIImageView *headImgView = [UIImageView new];
    headImgView.backgroundColor = [UIColor clearColor];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:self.ar.image]];
    headImgView.layer.cornerRadius = 20.0f;
    headImgView.clipsToBounds = YES;
    headImgView.layer.masksToBounds = YES;
    [header addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(10);
        make.top.equalTo(bgImgView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *label = [UILabel new];
    label.text = self.ar.name;
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgView.mas_right).offset(5);
        make.centerY.equalTo(headImgView);
        make.size.mas_equalTo(CGSizeMake(160, 30));
    }];
    UIImageView *review = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"数据")];
    [header addSubview:review];
    [review mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label).offset(5);
        make.right.equalTo(header).offset(-85);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    _reviewLabel = [UILabel new];
    _reviewLabel.font = [UIFont systemFontOfSize:15.0f];
    [header addSubview:_reviewLabel];
    [_reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(review.mas_right).offset(10);
        make.centerY.equalTo(review);
        make.size.mas_equalTo(CGSizeMake(30, 25));
    }];
    
    
    UIImageView *reportView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"report")];
    [header addSubview:reportView];
    [reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.equalTo(header).offset(-20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    reportView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapReport = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReport:)];
    [reportView addGestureRecognizer:tapReport];
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(header);
        make.height.mas_equalTo(1);
        make.top.equalTo(headImgView.mas_bottom).offset(10);
    }];
    UIImageView *line2 = [UIImageView new];
    line2.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line).offset(45);
        make.height.mas_equalTo(1);
    }];
   _hot = [UILabel new];
    _hot.font = [UIFont boldSystemFontOfSize:18.0f];
    [header addSubview:_hot];
    [_hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(10);
        make.bottom.mas_equalTo(header);
        make.size.mas_equalTo(CGSizeMake(160, 36));
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    button.layer.cornerRadius = 8.0f;
    [button setTitle:@"点击评论" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.hot);
        make.right.equalTo(header).offset(-10);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
    
    
    
    UIImageView *cImgView = [UIImageView new];
    cImgView.image =IMAGE_NAME(@"mesage");
    
    [header addSubview:cImgView];
    [cImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(8);
        make.bottom.equalTo(line2).offset(-8);
        make.left.equalTo(header).offset(15);
        make.width.mas_equalTo(25);
    }];
    
    _countLabel = [UILabel new];
   _countLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [header addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cImgView.mas_right).offset(10);
        make.centerY.equalTo(cImgView);
        make.size.mas_equalTo(CGSizeMake(80, 36));
    }];
    
    CGFloat w = SCREEN_WIDTH/7;
    for (int i = 0; i<4; i++) {
        NSArray *array = @[@"关注-灰",@"图片",@"视频",@"分享"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(array[i])];
        imgView.userInteractionEnabled = YES;
        [header addSubview:imgView];
        imgView.tag = 20+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imgView addGestureRecognizer:tap];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.mas_centerX).offset(w*i-25);
            make.centerY.equalTo(cImgView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.tag = 100+i;
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(5);
            make.centerY.equalTo(imgView);
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
    }
    
    _label1 = (UILabel *)[header viewWithTag:100];
    _label2 = (UILabel *)[header viewWithTag:101];
    _label3 = (UILabel *)[header viewWithTag:102];
    _label4 = (UILabel *)[header viewWithTag:103];
    _gzImgView = (UIImageView *)[header viewWithTag:20];

    return header;
}

#pragma mark 点赞 保存 下载视频 分享链接
-(void)tapReport:(UITapGestureRecognizer *)gesture{
    ReportViewController *report = [ReportViewController new];
    report.rType = @"1";
    report.contentId = [NSString stringWithFormat:@"%ld",self.ar.id];
    report.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:report animated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag;
    switch (index) {
        case 20:
            [self zanARMake];
            break;
        case 21:
            DLog(@"保存图片");
            [self saveImage];
            break;
        case 22:
            DLog(@"下载视频");
            [self downloadVideo];
            break;
        case 23:
            DLog(@"分享");
            [self share];
            break;
            
        default:
            break;
    }
    
}
//点赞
-(void)zanARMake{
    WS(weakSelf)
    [self.manager addShareOrZanWithSession:nil type:@"give" identifier:self.ar.id success:^(Response *response) {
        
        if (response.msg.status==0) {
            CWTOAST(@"已点赞");
            weakSelf.gzImgView.image = IMAGE_NAME(@"关注-红");
        }else{
             CWTOAST(@"取消点赞");
             weakSelf.gzImgView.image = IMAGE_NAME(@"关注-灰");
        }
        
        
        [weakSelf getARdetail];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)saveImage{
   
    UIImage *image = _topImgView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
     WS(weakSelf)
    if (error) {
    }else{
        [self.manager addShareOrZanWithSession:nil type:@"uploadImage" identifier:self.ar.id success:^(Response *response) {
            CWTOAST(@"图片保存成功");
             [weakSelf getARdetail];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    //NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

-(void)downloadVideo{
    WS(weakSelf)
    //远程地址
     [SVProgressHUD show];
    NSURL *URL = [NSURL URLWithString:self.ar.videoUrl];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    _downloadTask  = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        DLog(@"downloadProgress.completedUnitCount =%f  downloadProgress.totalUnitCount= %f",1.0 *downloadProgress.completedUnitCount ,1.0 *downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        DLog(@"path = %@ filename = %@",path,response.suggestedFilename);
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *dataFilePath = [filePath path];// 将NSURL转成NSString
        DLog(@"data = %@",dataFilePath);
        UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, nil, NULL);
         [SVProgressHUD dismiss];
        [weakSelf netDownloadUp];
        
    }];
    
    [_downloadTask resume];
}
-(void)netDownloadUp {
    WS(weakSelf)
    [self.manager addShareOrZanWithSession:nil type:@"uploadVideo" identifier:self.ar.id success:^(Response *response) {
        if (response.msg.status==0) {
            CWTOAST(@"视频已保存至相册");
             [weakSelf getARdetail];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)share{
    WS(weakSelf)
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString *title = self.ar.name;
    NSString* thumbURL = [self.ar.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:self.ar.info thumImage:thumbURL];
    //设置网页地址
    NSString *webShareUrl = @"https://arzx.zhyell.com/#/buildAfter?easyArId=";
    NSString *url =[NSString stringWithFormat:@"%@%ld",webShareUrl,self.ar.id];
    
    shareObject.webpageUrl = url;
   // [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        DLog(@"data = %@",data);
        if (error) {
            
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [self netShareRequest];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                DLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                DLog(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                DLog(@"response data is %@",data);
            }
        }
    }];
}

-(void)netShareRequest{
    WS(weakSelf)
    [self.manager addShareOrZanWithSession:nil type:@"share" identifier:self.ar.id success:^(Response *response) {
        CWTOAST(response.msg.desc);
         [weakSelf getARdetail];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}




#pragma mark VideoPlay

-(void)tapClick:(UITapGestureRecognizer *)gesture{
    DLog(@"视频播放");
    
    blackView = [UIView new];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.frame=CGRectMake(0, 100, SCREEN_WIDTH, 235);
    [self.view addSubview:blackView];
    UIImageView *close = [UIImageView new];
    close.image = IMAGE_NAME(@"close");
    close.frame = CGRectMake(5, 5, 20, 20);
    close.userInteractionEnabled = YES;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeTap:)];
    [close addGestureRecognizer:closeTap];
    [blackView addSubview:close];
    NSString *urlString = self.ar.videoUrl.length>0?self.ar.videoUrl:self.ar.video_url;
    MPMoviePlayerController *movieplayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
    //设置该播放器的控制条风格。
    movieplayer.controlStyle =MPMovieControlStyleEmbedded;
    //设置该播放器的缩放模式
    movieplayer.scalingMode =MPMovieScalingModeAspectFit;
    [movieplayer.view setFrame:CGRectMake(0 ,25 ,SCREEN_WIDTH, 215)];
    self.movieplayer= movieplayer;

    [blackView addSubview:movieplayer.view];
    [self.movieplayer play];
    [self.movieplayer endPlaybackTime];

}

-(void)closeTap:(UITapGestureRecognizer *)gesture{
    [blackView removeFromSuperview];
    [self.movieplayer stop];
}
-(void)requestCommentList{
    WS(weakSelf)
    NSNumber *arId = [NSNumber numberWithInteger:self.ar.id];
    _dataList  = [NSMutableArray arrayWithCapacity:0];
    [self.manager arCommentWithARId:arId success:^(Response *response) {
        if (response.msg.status==0) {
            weakSelf.hot.text = [NSString stringWithFormat:@"热门评论(%ld)",response.data.listCount];
            weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld条评论",response.data.listCount];
            [response.data.commentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Comment *comment = [[Comment alloc]init];
                [comment yy_modelSetWithJSON:obj];
                [weakSelf.dataList addObject:comment];
            }];
            [weakSelf.tableView reloadData];
        }else{
            WTOAST(response.msg.desc);
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

-(void)nextClick:(UIButton *)button{
    WS(weakSelf)
    DLog(@"点击评论");
    UIView *view = [UIView new];
    view.tag = 5;
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(55);
    }];
    UITextField *textfield = [[UITextField alloc]init];
    textfield.placeholder = @"期待您的神评论";
    textfield.delegate = self;
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.backgroundColor = [UIColor whiteColor];
    [view addSubview:textfield];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(5);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 35));
    }];
    self.commentTF = textfield;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = THEME_COLOR;
    button1.layer.cornerRadius = 8.0f;
    [button1 setTitle:@"评论" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
}

-(void)btnClick:(UIButton *)button{
    if (self.commentTF.text.length<1) {
        WTOAST(@"请填写评论内容");
        return;
    }
    NSNumber *arId = [NSNumber numberWithInteger:self.ar.id];
    WS(weakSelf)
    [self.manager arCommentWithSessionIdAndContent:self.commentTF.text arid:arId commentId:nil success:^(Response *response) {
        WTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [weakSelf commentARSuccess];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


-(void)getARdetail{
    WS(weakSelf)
    [self.manager arDetailWithSessionIdAndEasyArId:self.ar.id success:^(Response *response) {
        if (response.msg.status==0) {
            ARModel *easyAr = [[ARModel alloc]init];
            [easyAr yy_modelSetWithJSON:response.data.easyAr];
           NSString *urlString = [easyAr.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [weakSelf.topImgView sd_setImageWithURL:[NSURL URLWithString:urlString]];
            weakSelf.label1.text  = [NSString stringWithFormat:@"%ld",easyAr.give];
            weakSelf.label2.text =[NSString stringWithFormat:@"%ld",easyAr.uploadImage];
            weakSelf.label3.text =[NSString stringWithFormat:@"%ld",easyAr.uploadVideo];
            weakSelf.label4.text =[NSString stringWithFormat:@"%ld",easyAr.share];
            weakSelf.reviewLabel.text = [NSString stringWithFormat:@"%ld",easyAr.interviewCount];
            if ([easyAr.remark isEqualToString:@"1"]) {
                weakSelf.gzImgView.image = IMAGE_NAME(@"关注-红");
            }else{
                weakSelf.gzImgView.image = IMAGE_NAME(@"关注-灰");
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}
-(void)commentARSuccess{
    [self requestCommentList];
    UIView *view = [self.view viewWithTag:5];
    [view removeFromSuperview];
    
    
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
     [self.movieplayer stop];
    [self.navigationController popViewControllerAnimated:YES];
   
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    WTOAST(@"搜索点击");
}

-(HttpManager *)manager{
    if (!_manager) {
        _manager = [HttpManager requestManager];
    }
    return _manager;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_searchTextField) {
        SearchViewController *search = [SearchViewController new];
        self.tabBarController.tabBar.hidden= YES;
        [self.navigationController pushViewController:search animated:YES];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
