//
//  SearchViewController.m
//  ARVideo
//
//  Created by youdian on 2018/8/1.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "SearchViewController.h"
#import "QTextField.h"
#import "SearchResultVC.h"


@interface SearchViewController ()

@property (strong, nonatomic)UIImageView *line;
@property (strong, nonatomic)UILabel *lastLabel;
@property (strong, nonatomic)NSMutableArray *hotArray;
@property (strong, nonatomic)NSMutableArray *historyArray;
@property (strong, nonatomic)QTextField *searchTextField;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSearchTop];
    [self addSelectitems];
    _hotArray = [NSMutableArray arrayWithCapacity:0];
    _historyArray =[NSMutableArray arrayWithCapacity:0];
    [self getWebSearchWithType:@"0"];
    // Do any additional setup after loading the view.
}

-(void)addSearchTop{
    WS(weakSelf)
    UIImageView *nav = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    nav.userInteractionEnabled = YES;
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(110*PIX);
    }];
    
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
    searchTF.placeholder = @"请输入您要搜索的内容";
    searchTF.backgroundColor = [UIColor lightTextColor];
    [nav addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav).offset(40);
        make.top.equalTo(nav).offset(34);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 38));
    }];
    _searchTextField = searchTF;
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [self.view addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchTF);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
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
}

-(void)addSelectitems{
    WS(weakSelf)
    NSArray *array = @[@"全部作品",@"名称"];
    for (int i= 0; i<2; i++) {
        UILabel *label = [UILabel new];
        label.tag = 30+i;
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text =array[i];
        [self.view sendSubviewToBack:label];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(SCREEN_WIDTH/2.0f*i);
            make.top.equalTo(weakSelf.view).offset(100);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0f, 50));
        }];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelect:)];
        [label addGestureRecognizer:tap];
        
    }
    _lastLabel = (UILabel *)[self.view viewWithTag:30];
    _lastLabel.textColor = THEME_COLOR;
    _line = [[UIImageView alloc]init];
    _line.backgroundColor =  THEME_COLOR;
    [self.view addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_lastLabel);
        make.top.equalTo(self->_lastLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0f-80, 3));
    }];
    
}

-(void)addViewWithSearchArrayAndType:(NSString *)type{
    WS(weakSelf)
    DLog(@"type = %@",type);
    NSInteger tag = [type isEqualToString:@"0"]?11:10;
    UIView *last = [self.view viewWithTag:tag];
    [last removeFromSuperview];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = [type isEqualToString:@"0"]?11:10;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_lastLabel.mas_bottom).offset(4);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(0);
    }];
    //view.backgroundColor = [type isEqualToString:@"1"]?[UIColor redColor]:[UIColor purpleColor];
    UILabel *hot = [UILabel new];
    hot.text = @"探索发现";
    hot.font = [UIFont systemFontOfSize:16.0f];
    hot.textColor = [UIColor darkGrayColor];
    [view addSubview:hot];
    [hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10);
        make.left.equalTo(view).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    CGFloat offset_x = 20;
    CGFloat offset_y = 20;
    CGFloat space = 15.0f;
    for (int i = 0; i<self.hotArray.count; i++){
        UILabel *label = [UILabel new];
        label.tag= 60+i;
        label.userInteractionEnabled  = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.layer.cornerRadius = 15.0f;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        HotSearch *search = self.hotArray[i];
        label.text = search.name;
        CGFloat width = [NSString calculateRowWidth:label.text fontSize:15.0f height:30];
        if (offset_x+width+space>SCREEN_WIDTH) {
            offset_y+=space+30;
            offset_x = 20;
        }
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hot.mas_bottom).offset(offset_y);
            make.left.equalTo(view).offset(offset_x);
            make.size.mas_equalTo(CGSizeMake(width, 30));
        }];
        offset_x+=width+space;
        offset_y+=  offset_x < SCREEN_WIDTH-20?0:space+30;
        UITapGestureRecognizer *hotTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotTap:)];
        [label addGestureRecognizer:hotTap];
    
    }
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    if (sessionId.length<1) {
        return;
    }
    offset_y+=80;
    UILabel *history = [UILabel new];
    history.text = @"历史搜索";
    history.font = [UIFont systemFontOfSize:16.0f];
    history.textColor = [UIColor darkGrayColor];
    [view addSubview:history];
    [history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hot.mas_bottom).offset(offset_y);
        make.left.equalTo(view).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    offset_y =20;
    offset_x = 20;
    for (int i = 0; i<self.historyArray.count; i++) {
        UILabel *label = [UILabel new];
        label.tag = 60+i;
        label.userInteractionEnabled  = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.layer.cornerRadius = 15.0f;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.clipsToBounds = YES;
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        HotSearch *search = self.historyArray[i];
        label.text = search.name;
        CGFloat width = [NSString calculateRowWidth:label.text fontSize:15.0f height:30];
        if (offset_x+width+space>SCREEN_WIDTH) {
            offset_y+=space+30;
            offset_x = 20;
        }
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(history.mas_bottom).offset(offset_y);
            make.left.equalTo(view).offset(offset_x);
            make.size.mas_equalTo(CGSizeMake(width, 30));
        }];
        offset_x+=width+space;
        offset_y+=  offset_x < SCREEN_WIDTH-30?0:space+30;
        offset_x = offset_x<SCREEN_WIDTH-30?offset_x:20.0f;
        UITapGestureRecognizer *historyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(historyTap:)];
        [label addGestureRecognizer:historyTap];
    }
    
    
    
}

-(void)hotTap:(UITapGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag-60;
    HotSearch *search = self.hotArray[index];
    SearchResultVC *res = [SearchResultVC new];
    res.type = search.type;
    res.keywords =search.name;
    [self.navigationController pushViewController:res animated:YES];
    
    
}
-(void)historyTap:(UITapGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag-60;
    HotSearch *search = self.historyArray[index];
    SearchResultVC *res = [SearchResultVC new];
    res.search = search;
    [self.navigationController pushViewController:res animated:YES];
}
-(void)tapSelect:(UITapGestureRecognizer *)gesture{
     _hotArray = [NSMutableArray arrayWithCapacity:0];
    _historyArray =[NSMutableArray arrayWithCapacity:0];
    _lastLabel.textColor = [UIColor darkGrayColor];
    
    _lastLabel = (UILabel *)gesture.view;
    NSString *type =_lastLabel.tag==30?@"0":@"1";
    [self getWebSearchWithType:type];
    [UIView animateWithDuration:2 animations:^{
        [self->_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_lastLabel);
            make.top.equalTo(self->_lastLabel.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2.0f-80, 3));
        }];
    }];
    [_line setNeedsLayout];
  
    _lastLabel.textColor = THEME_COLOR;
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    SearchResultVC *res = [SearchResultVC new];
    res.keywords = _searchTextField.text.length>0?_searchTextField.text:@"";
    res.type = [NSString stringWithFormat:@"%ld",_lastLabel.tag-30];
    [self.navigationController pushViewController:res animated:YES];
}

#pragma mark Networking

-(void)getWebSearchWithType:(NSString *)type{
    WS(weakSelf)
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
   
    [self.manager getWebSearchWithType:type success:^(Response *response) {
        if (response.msg.status==0) {
            [weakSelf.hotArray addObjectsFromArray:response.data.search];
            sessionId.length>1? [weakSelf getMySearchWithType:type]:[weakSelf addViewWithSearchArrayAndType:type];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)getMySearchWithType:(NSString *)type{
    WS(weakSelf)
    [self.manager getMySearchWithSessionIdAndType:type success:^(Response *response) {
        if (response.msg.status==0||response.msg.status==1) {
            [weakSelf.historyArray addObjectsFromArray:response.data.search];
            [weakSelf addViewWithSearchArrayAndType:type];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}







-(HttpManager *)manager{
    if (!_manager) {
        _manager = [HttpManager requestManager];
    }
    return _manager;
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
