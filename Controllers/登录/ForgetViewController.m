//
//  ForgetViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ForgetViewController.h"
#import "QTextField.h"
#import "NNValidationView.h"

#import "NNValidationView.h"
@interface ForgetViewController  ()<UITextFieldDelegate>

@property (strong, nonatomic)QTextField *phoneTextField;
@property (strong, nonatomic)QTextField *smsTextField;
@property (strong, nonatomic)QTextField *pwdTextField;
@property (strong, nonatomic)QTextField *rPwdTextField;
@property (strong, nonatomic)QTextField *codeTextField;
@property (strong, nonatomic)NNValidationView  *codeImgView;
@property (strong, nonatomic)UIButton *codeButton;
@property (nonatomic, strong)  NSURLSessionDownloadTask *downloadTask;
@end

@implementation ForgetViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    [self addRegTop];
    [self addRegisterUI];
    // Do any additional setup after loading the view.
}


-(void)addRegTop{
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"Top")];
    top.frame = CGRectMake(0, 10, SCREEN_WIDTH, 175*PIX);
    [self.view addSubview:top];
    /*
    UILabel *lable = [UILabel new];
    lable.text = @"忘记密码";
    lable.textColor =  THEME_COLOR;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont boldSystemFontOfSize:22.0f];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top.mas_bottom).offset(-10);
        make.centerX.equalTo(top);
        make.size.mas_equalTo(CGSizeMake(150, 45));
    }];
    */
}
-(void)addRegisterUI{
    WS(weakSelf)
    NSArray *placeArray = @[@"请输入账号",@"请输入图片验证码",@"请输入密码",@"请输入短信验证码"];
    for (int i = 0; i<placeArray.count; i++) {
        QTextField *textField =[[QTextField alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textField.layer.cornerRadius = 21.0f;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.tag = 20+i;
        //textField.textColor = THEME_COLOR;
        textField.placeholder = placeArray[i];
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(30);
            make.centerY.equalTo(weakSelf.view).offset(i*70-50);
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
    _rPwdTextField.secureTextEntry = YES;
   //_rPwdTextField = (QTextField *)[self.view viewWithTag:23];
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
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.backgroundColor = THEME_COLOR;
    regBtn.tag = 12;
    [regBtn setTitle:@"确定" forState:UIControlStateNormal];
    regBtn.layer.cornerRadius =20.0f;
    [regBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.phoneTextField);
        make.top.equalTo(weakSelf.smsTextField.mas_bottom).offset(25);
    }];
}

-(void)btnClick:(UIButton *)button{
    if (_phoneTextField.text.length<11) {
        WTOAST(@"请输入正确手机号");
        return;
    }
    if (_codeTextField.text.length<1) {
        WTOAST(@"请输入验证码");
        return;
    }
    if (button.tag==10) {
        [self gcdTimer];
        [self requestSMSCode];
    }else{
        [self requestForget];
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
                weakSelf.codeButton.userInteractionEnabled = YES;
                [weakSelf.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            DLog(@"timeout = %ld",(long)timeout);
            timeout--;
            dispatch_async(dispatch_get_main_queue(), ^{
                 weakSelf.codeButton.userInteractionEnabled = NO;
                [weakSelf.codeButton setTitle:[NSString stringWithFormat:@"%lds",timeout] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

-(void)requestSMSCode{
    HttpManager *manager = [HttpManager requestManager];
    [manager getSMSCodeWithPhone:_phoneTextField.text code:_codeTextField.text type:@"findPwd" success:^(Response *response) {
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)requestForget{
    WS(weakSelf)
    if (![NSString isMobile:_phoneTextField.text]) {
        WTOAST(@"请输入正确的手机号码");
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
    HttpManager *manager = [HttpManager requestManager];
    [manager forgetPasswordWithPhone:_phoneTextField.text password:_pwdTextField.text code:_smsTextField.text success:^(Response *response) {
        WTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.pwdTextField.text forKey:@"password"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    
    
    
}

//
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?telphone=%@&type=findPwd",string,_phoneTextField.text];
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
