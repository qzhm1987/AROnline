//
//  RegisterViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "RegisterViewController.h"
#import "QTextField.h"
#import "NNValidationView.h"
#import "UIImageView+WebCache.h"
#import "NNValidationView.h"
#import "DelegateWeb.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)QTextField *phoneTextField;
@property (strong, nonatomic)QTextField *smsTextField;
@property (strong, nonatomic)QTextField *pwdTextField;
@property (strong, nonatomic)QTextField *codeTextField;
@property (strong, nonatomic)UIImageView  *codeImgView;
@property (strong, nonatomic)UIButton *codeButton;
@property (strong, nonatomic)HttpManager *httpManager;
@property (nonatomic, strong)  NSURLSessionDownloadTask *downloadTask;

@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =self.unionid.length>0?@"注册并绑定":@"用户注册";
   [self addRegTop];
    [self addRegisterUI];
    // Do any additional setup after loading the view.
}


-(void)addRegTop{
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"Top")];
    top.frame = CGRectMake(0, 10, SCREEN_WIDTH, 175*PIX);
    [self.view.layer addSublayer:top.layer];
}
-(void)addRegisterUI{
    WS(weakSelf)
    NSArray *placeArray = @[@"请输入账号",@"请输入验证码",@"请输入密码",@"请输入短信验证码"];
    for (int i = 0; i<placeArray.count; i++) {
        QTextField *textField =[[QTextField alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textField.layer.cornerRadius = 21.0f;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.tag = 20+i;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //textField.textColor = THEME_COLOR;
        textField.placeholder = placeArray[i];
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(30);
            make.centerY.equalTo(weakSelf.view).offset(i*70-80);
            if (i==1||i==3) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-160, 50));
            }else{
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
            }
        }];
    }
    _phoneTextField = (QTextField *)[self.view viewWithTag:20];
    _smsTextField = (QTextField *)[self.view viewWithTag:23];
    _pwdTextField = (QTextField *)[self.view viewWithTag:22];
    _pwdTextField.secureTextEntry = YES;
    _codeTextField = (QTextField *)[self.view viewWithTag:21];
   //短信倒计时
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    button.tag = 10;
    button.layer.cornerRadius = 10.0f;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _codeButton = button;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.smsTextField.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.smsTextField);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    //图片验证码
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.backgroundColor = THEME_COLOR;
    [codeBtn setTitle:@"图片验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    codeBtn.tag = 11;
    codeBtn.layer.cornerRadius = 10.0f;
    [codeBtn addTarget:self action:@selector(tapImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeTextField.mas_right).offset(5);
        make.top.height.equalTo(weakSelf.codeTextField);
        make.right.equalTo(weakSelf.view).offset(-30);
    }];
//    _codeImgView = [[NNValidationView alloc] initWithFrame:CGRectZero andCharCount:4 andLineCount:4];
//    _codeImgView.layer.cornerRadius = 8.0f;
//    [self.view addSubview:_codeImgView];
//    [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.codeTextField.mas_right).offset(5);
//        make.top.height.equalTo(weakSelf.codeTextField);
//        make.right.equalTo(weakSelf.view).offset(-30);
//    }];
//    /// 返回验证码数字
//    _codeImgView.changeValidationCodeBlock = ^(void){
//        NSLog(@"验证码被点击了：%@", weakSelf.codeImgView.charString);
//    };

    
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.backgroundColor = THEME_COLOR;
    NSString *title = self.unionid.length>0?@"注册绑定":@"注册";
    [regBtn setTitle:title forState:UIControlStateNormal];
    regBtn.layer.cornerRadius =20.0f;
    [regBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.phoneTextField);
        make.top.equalTo(weakSelf.smsTextField.mas_bottom).offset(55);
    }];
   
    UILabel *delegateLable =[UILabel new];
    NSString *string =@"同意并已阅读用户协议";
    
    delegateLable.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value: THEME_COLOR range:NSMakeRange(6,4)];
    delegateLable.attributedText = str ;
    delegateLable.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:delegateLable];
    [delegateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button);
        make.top.equalTo(weakSelf.smsTextField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(135, 25));
    }];
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
    delegateLable.userInteractionEnabled = YES;
    [delegateLable addGestureRecognizer:tapRecognizer];

    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _isSelected = NO;
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"36_2"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(delegateLable);
        make.right.equalTo(delegateLable.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}


-(void)click{
    _isSelected = !_isSelected;
    if (_isSelected) {
          [_selectBtn setBackgroundImage:[UIImage imageNamed:@"36_1"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"36_2"] forState:UIControlStateNormal];
    }
    
}
-(void)openURL{
    DelegateWeb *web = [DelegateWeb new];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)btnClick:(UIButton *)button{
    if (_phoneTextField.text.length<11) {
        WTOAST(@"请输入正确手机号");
        return;
    }
    if (button.tag==10) {
        if (_codeTextField.text.length<1) {
            WTOAST(@"请输入图片验证码");
            return;
        }
        
        [self gcdTimer];
        [self requestSMSCode];
    }else{
        [self requestRegister];
    }

}
-(void)gcdTimer{
    WS(weakSelf)
    __block NSInteger timeout = 60;
    //拿到一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个timer 放到队列里面
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置timer首次执行的时间 执行时间间隔、精确度
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                weakSelf.codeButton.userInteractionEnabled = YES;
            });
        }else{
            timeout--;
            dispatch_async(dispatch_get_main_queue(), ^{
                 weakSelf.codeButton.userInteractionEnabled = NO;
                [weakSelf.codeButton setTitle:[NSString stringWithFormat:@"%ld秒",timeout] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

-(void)requestRegister{
    
    DLog(@"网络注册请求");
    if (_phoneTextField.text.length<11) {
        WTOAST(@"您输入的号码有误");
        return;
    }
    if (_smsTextField.text.length<6) {
        WTOAST(@"请输入6位短信验证码");
        return;
    }
    if (_pwdTextField.text.length<6) {
        WTOAST(@"密码长度不得小于6位");
        return;
    }
    if (_codeTextField.text.length<1) {
        WTOAST(@"请输入验证码");
        return;
    }
    if (!_isSelected) {
        WTOAST(@"确认同意并阅读用户协议");
        return;
    }
    if (self.unionid.length>0) {
        if ([self.type isEqualToString:@"wechat"]) {
            [self registerBindingWechat];
        }else{
             [self registerBindingQQ];
        }
        
    }else{
        [self registerWithoutBinding];
    }
}

#pragma mark 注册 绑定登录
-(void)registerBindingWechat{
    WS(weakSelf)
  
    
    [self.httpManager wechatRegisterWithPhone:_phoneTextField.text pwd:_pwdTextField.text sms:_smsTextField.text openId:self.unionid success:^(Response *response) {
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.pwdTextField.text forKey:@"password"];
            [AppDel goMainViewController];
        }else{
            WTOAST(response.msg.desc);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)registerBindingQQ{
    WS(weakSelf)
    [self.httpManager qqRegisterWithPhone:_phoneTextField.text pwd:_pwdTextField.text sms:_smsTextField.text openId:self.unionid success:^(Response *response) {
        
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.pwdTextField.text forKey:@"password"];
            [AppDel goMainViewController];
        }else{
            WTOAST(response.msg.desc);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
    }];
}
-(void)registerWithoutBinding{
   
    [self.httpManager registerUserWithPhone:_phoneTextField.text password:_pwdTextField.text code:_smsTextField.text success:^(Response *response) {
        WTOAST(response.msg.desc);
        
        if (response.msg.status ==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [AppDel goMainViewController];
        }else{
          
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)tapImg:(UIButton *)button{
    if (![NSString isMobile:_phoneTextField.text]) {
        WTOAST(@"您输入的号码有误");
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"reg.png"];
    BOOL res = [fileManager removeItemAtPath:path error:nil];
    if (res) {
        DLog(@"文件删除成功");
    }
    else{
        DLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:path]?@"YES":@"NO");
    }
    NSString *string = @"https://ar.zhyell.com/api/verifyCode/getCode";
    NSString *urlStr = [NSString stringWithFormat:@"%@?telphone=%@&type=register",string,_phoneTextField.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _downloadTask  = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:@"reg.png"];
        DLog(@"path = %@ filename = %@",path,response.suggestedFilename);
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        UIImage *numberCode = [UIImage imageWithContentsOfFile:[filePath path]];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setBackgroundImage:numberCode forState:UIControlStateNormal];
        
    }];
    
    [_downloadTask resume];
}

-(void)requestSMSCode{
    [self.httpManager getSMSCodeWithPhone:_phoneTextField.text code:_codeTextField.text type:@"register" success:^(Response *response) {
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(HttpManager *)httpManager{
    if (!_httpManager) {
        _httpManager = [HttpManager requestManager];
    }
    return _httpManager;
}

- (void)textFieldDidChange:(UITextField *)textField {
    //限制手机号输入长度 大陆手机号 +86省去
    if (textField.tag==20) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    if (textField.tag==20||textField.tag==21){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else{
        textField.keyboardType = UIKeyboardTypeASCIICapable;
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
