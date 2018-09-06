//
//  LoginViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "LoginViewController.h"
#import "QTextField.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "NNValidationView.h"
#import <AVFoundation/AVFoundation.h>
#import "BindingLoginVC.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)QTextField *phoneTextField;
@property (strong, nonatomic)QTextField *pwdTextField;
@property (strong, nonatomic)QTextField *codeTextField;
@property (strong, nonatomic)NNValidationView *codeImgView;
//1 播放器
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation LoginViewController

#pragma mark - 懒加载AVPlayer
- (AVPlayer *)player{
    if (!_player) {
        //1 创建一个播放item
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AR.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        // 2 播放的设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
       _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;// 永不暂停
        // 3 将图层嵌入到0层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer insertSublayer:layer atIndex:0];
        // 4 播放到头循环播放
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}
#pragma mark - 视频播放结束 触发
- (void)playToEnd{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    //视频播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideos) name:@"appBecomeActive" object:nil];
}
- (void)playVideos{
    [self.player play];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
   // [self addTopUI];
    [self.player play];
    [self addLoginUI];
    
    // Do any additional setup after loading the view.
}

-(void)addTopUI{
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"loginTop")];
    top.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230*PIX);
    [self.view.layer addSublayer:top.layer];
    
}
-(void)addLoginUI{
    WS(weakSelf)
    NSArray *placeArray = @[@"请输入账号",@"请输入密码",@"请输入验证码"];
    for (int i =0; i<placeArray.count; i++) {
        QTextField *textField =[[QTextField alloc]initWithFrame:CGRectZero];
       
        textField.layer.borderWidth = 2.0f;
        textField.layer.borderColor = [UIColor whiteColor].CGColor;
        textField.backgroundColor = RGBA(250, 250, 250, 0.5f);
        
        //textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textField.layer.cornerRadius = 21.0f;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.tag = 20+i;
       // textField.textColor = THEME_COLOR;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.placeholder = placeArray[i];
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(30);
            make.centerY.equalTo(weakSelf.view).offset(i*70-150);
            if (i==2) {
                 make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-160, 50));
            }else{
                 make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
            }
        }];
    }
    _phoneTextField = (QTextField *)[self.view viewWithTag:20];
    _phoneTextField.text  = [USER_DEFAULT objectForKey:@"phone"]?[USER_DEFAULT objectForKey:@"phone"]:@"";
    _pwdTextField =  (QTextField *)[self.view viewWithTag:21];
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.text  = [USER_DEFAULT objectForKey:@"password"]?[USER_DEFAULT objectForKey:@"password"]:@"";
    _codeTextField =  (QTextField *)[self.view viewWithTag:22];
    _codeTextField.hidden = YES;
//图片验证码
    /*
    _codeImgView = [[UIImageView alloc]init];
    _codeImgView.layer.borderColor = THEME_COLOR.CGColor;
    _codeImgView.layer.borderWidth = 1.5f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    _codeImgView.userInteractionEnabled = YES;
    [_codeImgView addGestureRecognizer:tap];
    [self.view addSubview:_codeImgView];
    [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeTextField.mas_right).offset(5);
        make.top.height.equalTo(weakSelf.codeTextField);
        make.right.equalTo(weakSelf.view).offset(-30);
    }];
    */
    
    _codeImgView = [[NNValidationView alloc] initWithFrame:CGRectZero andCharCount:4 andLineCount:4];
    _codeImgView.layer.cornerRadius = 8.0f;
    [self.view addSubview:_codeImgView];
    [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeTextField.mas_right).offset(5);
        make.top.height.equalTo(weakSelf.codeTextField);
        make.right.equalTo(weakSelf.view).offset(-30);
    }];
    /// 返回验证码数字
    _codeImgView.changeValidationCodeBlock = ^(void){
        NSLog(@"验证码被点击了：%@", weakSelf.codeImgView.charString);
    };

    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = THEME_COLOR;
    
    loginBtn.tag = 10;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius =20.0f;
//     loginBtn.backgroundColor = [UIColor clearColor];
//    loginBtn.layer.borderColor = THEME_COLOR.CGColor;
//    loginBtn.layer.borderWidth = 1.0f;
    [loginBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.phoneTextField);
        make.top.equalTo(weakSelf.pwdTextField.mas_bottom).offset(20);
    }];
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码?"forState:UIControlStateNormal];
    forgetBtn.tag =11;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [forgetBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [forgetBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setTitle:@"立即注册"forState:UIControlStateNormal];
    regBtn.tag = 12;
    regBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [regBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
   
    UILabel *tLabel = [UILabel new];
    tLabel.text = @"第三方登录";
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.textColor = THEME_COLOR;
    [self.view addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(regBtn.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    UIImageView *line = [UIImageView new];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(tLabel.mas_left);
        make.centerY.equalTo(tLabel);
        make.height.mas_equalTo(1.5f);
    }];
    UIImageView *line2 = [UIImageView new];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tLabel.mas_right).offset(0);
        make.right.equalTo(weakSelf.view);
        make.centerY.equalTo(tLabel);
        make.height.mas_equalTo(1.0f);
    }];
    
    UIButton *weiBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiBtn setImage:IMAGE_NAME(@"weixin") forState:UIControlStateNormal];
    weiBtn.tag = 13;
    [weiBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiBtn];
    [weiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tLabel.mas_centerX).offset(-5);
        make.top.equalTo(tLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    UIButton *qqBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setImage:IMAGE_NAME(@"qq") forState:UIControlStateNormal];
    qqBtn.tag = 14;
    [qqBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tLabel.mas_centerX).offset(5);
        make.top.equalTo(tLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    
    
    
}
-(void)tapClick:(UITapGestureRecognizer *)gesture{
    [self requestCodeImage];
}

-(void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 10:
            [self requestLogin];
            break;
        case 11:
            [self goForgetPasswordViewController];
            break;
        case 12:
            [self goRegisterViewController];
            break;
        case 13:
            [self getAuthWithUserInfoFromWeiXin];
            break;
        case 14:
            [self getAuthWithUserInfoFromQQ];
            break;
        default:
            break;
    }
}


-(void)getAuthWithUserInfoFromWeiXin{
    WS(weakSelf)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            WTOAST(@"error");
        } else {
            UMSocialUserInfoResponse *resp = result;
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
            [weakSelf requestWechatLoginWithUnionid:resp.unionId];
        }
    }];
}
-(void)getAuthWithUserInfoFromQQ{
    WS(weakSelf)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            
            UMSocialUserInfoResponse *resp = result;
           // [weakSelf requestQQLoginWithUnionid:resp.openid];
            [weakSelf requestQQLoginWithOpenId:resp.openid];
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ unionid: %@", resp.unionId);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}
#pragma mark 微信登录
-(void)requestWechatLoginWithUnionid:(NSString *)unionid{
    WS(weakSelf)
    [self.manager weChatLoginWithOpenId:unionid success:^(Response *response) {
        
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT synchronize];
            [AppDel goMainViewController];
        }else if (response.msg.status==1){
            //未绑定手机号新注册
            [weakSelf alertNotBindingWithMessage:response.msg.desc openId:unionid type:@"wechat"];
        }else{
            WTOAST(response.msg.desc);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



#pragma mark QQ登录

-(void)requestQQLoginWithOpenId:(NSString *)openId{
    WS(weakSelf)
    [self.manager qqLoginWithOpenId:openId success:^(Response *response) {
        
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT synchronize];
            [AppDel goMainViewController];
        }else if (response.msg.status==1){
            //未绑定手机号新注册
            [weakSelf alertNotBindingWithMessage:response.msg.desc openId:openId type:@"qq"];
        }else{
            WTOAST(response.msg.desc);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
}
//请求登录接口
-(void)requestLogin{
    WS(weakSelf)
     DLog(@"请求登录接口");
    if (![NSString isMobile:_phoneTextField.text]) {
        WTOAST(@"您输入的号码有误");
        return;
    }
    if (_pwdTextField.text.length<6) {
        WTOAST(@"密码长度不小于6位");
        return;
    }
//    if (_codeTextField.text.length<1) {
//        WTOAST(@"请输入图片验证码");
//        return;
//    }

    [self.manager loginWithPhone:_phoneTextField.text password:_pwdTextField.text success:^(Response *response) {
        WTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.pwdTextField.text forKey:@"password"];
            [AppDel goMainViewController];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
   
}
//请求图片验证码接口
-(void)requestCodeImage{
    DLog(@"请求图片验证码");

}






-(void)alertNotBindingWithMessage:(NSString *)msg openId:(NSString *)openId type:(NSString *)type{
    WS(weakSelf)
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"已有账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BindingLoginVC *binding = [BindingLoginVC new];
        binding.unionid = openId;
        binding.type = type;
        [weakSelf.navigationController pushViewController:binding animated:YES];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        RegisterViewController *reg = [RegisterViewController new];
        reg.unionid = openId;
        reg.type = type;
        [weakSelf.navigationController pushViewController:reg animated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
}
-(void)goForgetPasswordViewController{
    ForgetViewController *forget = [ForgetViewController new];
    forget.returnBlock = ^(NSString *phone, NSString *password) {
        self->_phoneTextField.text = phone;
        self->_pwdTextField.text = password;
    };
    [self.navigationController pushViewController:forget animated:YES];
}
-(void)goRegisterViewController{
    UIViewController *viewController = [NSClassFromString(@"RegisterViewController") new];
   // UIViewController *viewController = [NSClassFromString(@"ModifyViewController") new];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma Mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    if (textField.tag==20){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else{
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    //限制手机号输入长度 大陆手机号 +86省去
    if (textField.tag==20) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(HttpManager*)manager{
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
