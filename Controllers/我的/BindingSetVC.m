//
//  BindingSetVC.m
//  ARVideo
//
//  Created by youdian on 2018/8/16.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "BindingSetVC.h"

@interface BindingSetVC ()

@property (strong, nonatomic)UIButton *wButton;
@property (strong, nonatomic)UIButton *qButton;
@end

@implementation BindingSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBindingSetTop];
    [self addBindingSetUI];
    // Do any additional setup after loading the view.
}

-(void)addBindingSetTop{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    [self.view addSubview:topImgView];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [topImgView addSubview:back];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:tap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(30);
        make.left.equalTo(topImgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label =[UILabel new];
    label.text = @"账号和绑定设置";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(160, 30));
    }];
}


-(void)addBindingSetUI{
    WS(weakSelf)
    ARUser *user= [ARUser shareARUser];
    UILabel *label =[UILabel new];
    label.text = @"绑定与解绑设置";
    label.font=[UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(145);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(160, 30));
    }];
    
    
    
    
    NSArray *imgArray = @[@"weixin",@"qq"];
    NSArray *nameArray = @[@"微信",@"QQ"];
    for (int i = 0; i<2; i++) {
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.view).offset(200+80*i);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 75));
        }];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = IMAGE_NAME(imgArray[i]);
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        UILabel *nameLabel = [UILabel new];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.text = nameArray[i];
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = THEME_COLOR;
        button.layer.cornerRadius = 8.0f;
        button.tag = 10+i;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }
    _wButton = (UIButton *)[self.view viewWithTag:10];
    _qButton = (UIButton *)[self.view viewWithTag:11];
    if (user.qqOpenId.length>1) {
        [_qButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    }else{
         [_qButton setTitle:@"绑定" forState:UIControlStateNormal];
    }
    if (user.wechatOpenId.length>1) {
         [_wButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    }else{
         [_wButton setTitle:@"绑定" forState:UIControlStateNormal];
    }
    
    
}

-(void)btnClick:(UIButton *)button{
    if (button==_wButton) {
        if ([ARUser shareARUser].wechatOpenId.length<1) {
            [self wechatBinding];
        }else{
            [self wechatCancelBinding];
        }
        
    }else{
        if ([ARUser shareARUser].qqOpenId.length<1) {
            [self qqBinding];
        }else{
            [self qqCancelBinding];
        }
    }
    
    
    
}

#pragma mark 绑定与解绑

-(void)wechatBinding{
    WS(weakSelf)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            WTOAST(@"error");
        } else {
            UMSocialUserInfoResponse *resp = result;
            [weakSelf wechatLoginBindingWithUnionid:resp.unionId];//绑定
            // 授权信息
            NSLog(@"WeiXin uid: %@", resp.uid);
            NSLog(@"WeiXin openid: %@", resp.openid);
            NSLog(@"WeiXin unionid: %@", resp.unionId);
            NSLog(@"WeiXin accessToken: %@", resp.accessToken);
            NSLog(@"WeiXin expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"WeiXin name: %@", resp.name);
            NSLog(@"WeiXin iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"WeiXin originalResponse: %@", resp.originalResponse);
         
        }
    }];
    
}
-(void)wechatCancelBinding{
    WS(weakSelf)
       [self.manager qqOrWeChatCancelWithSessionPath:@"register/wechatCancel" success:^(Response *response) {
           CWTOAST(response.msg.desc);
           if (response.msg.status==0) {
               [ARUser shareARUser].wechatOpenId = nil;
               [weakSelf.wButton setTitle:@"绑定" forState:UIControlStateNormal];
           }
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           
       }];
}
-(void)qqBinding{
    WS(weakSelf)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            WTOAST(@"error");
        } else {
            UMSocialUserInfoResponse *resp = result;
            [weakSelf qqLoginBindingWithOpenid:resp.openid];
            // 授权信息
            NSLog(@"WeiXin uid: %@", resp.uid);
            NSLog(@"WeiXin openid: %@", resp.openid);
            NSLog(@"WeiXin unionid: %@", resp.unionId);
            NSLog(@"WeiXin accessToken: %@", resp.accessToken);
            NSLog(@"WeiXin expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"WeiXin name: %@", resp.name);
            NSLog(@"WeiXin iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"WeiXin originalResponse: %@", resp.originalResponse);
            
        }
    }];
}
-(void)qqCancelBinding{
    WS(weakSelf)
    [self.manager qqOrWeChatCancelWithSessionPath:@"register/qqCancel" success:^(Response *response) {
        CWTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [ARUser shareARUser].qqOpenId = nil;
            [weakSelf.qButton setTitle:@"绑定" forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)wechatLoginBindingWithUnionid:(NSString *)unionid{
    WS(weakSelf)
    NSString *password = [USER_DEFAULT objectForKey:@"password"];
    NSString *phone = [USER_DEFAULT objectForKey:@"phone"];
    [self.manager weChatLoginBindingWithSessionAndOpenId:unionid phone:phone pwd:password success:^(Response *response) {
          WTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT synchronize];
             [ARUser shareARUser].wechatOpenId = unionid;
            [weakSelf.wButton setTitle:@"解除绑定" forState:UIControlStateNormal];
           
        }else{
          
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)qqLoginBindingWithOpenid:(NSString *)openid{
    WS(weakSelf)

    NSString *password = [USER_DEFAULT objectForKey:@"password"];
    NSString *phone = [USER_DEFAULT objectForKey:@"phone"];
    [self.manager qqLoginBindingWithSessionAndOpenId:openid phone:phone pwd:password success:^(Response *response) {
        WTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT synchronize];
             [ARUser shareARUser].qqOpenId = openid;
            [weakSelf.qButton setTitle:@"解除绑定" forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

-(HttpManager *)manager{
    if (!_manager) {
        _manager = [HttpManager requestManager];
    }
    return _manager;
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
