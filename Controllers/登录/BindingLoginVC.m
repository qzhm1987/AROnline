//
//  BindingLoginVC.m
//  ARVideo
//
//  Created by youdian on 2018/8/15.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "BindingLoginVC.h"

@interface BindingLoginVC ()<UITextFieldDelegate>

@end

@implementation BindingLoginVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账号绑定";
    [self addModifyPwdTop];
    [self addModifyPwdUI];
    // Do any additional setup after loading the view.
}
-(void)addModifyPwdTop{
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"Top")];
    top.frame = CGRectMake(0, 20, SCREEN_WIDTH, 175*PIX);
    [self.view addSubview:top];
}


-(void)addModifyPwdUI{
    WS(weakSelf)
    NSArray *placeArray = @[@"请输入原有账号手机",@"请输入密码"];
    for (int i = 0; i<placeArray.count; i++) {
        QTextField *textField =[[QTextField alloc]initWithFrame:CGRectZero];
        textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textField.layer.cornerRadius = 21.0f;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        textField.tag = 20+i;
        
        //  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.placeholder = placeArray[i];
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view).offset(30);
            make.centerY.equalTo(weakSelf.view).offset(i*70-80);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
        }];
    }
    _phoneTextField = (QTextField*)[self.view viewWithTag:20];
    _nPwdTextField = (QTextField*)[self.view viewWithTag:21];
    _nPwdTextField.secureTextEntry  = YES;
    UIButton * modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = THEME_COLOR;
    
    modifyBtn.tag = 10;
    [modifyBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    modifyBtn.layer.cornerRadius =20.0f;
    [modifyBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.phoneTextField);
        make.top.equalTo(weakSelf.nPwdTextField.mas_bottom).offset(50);
    }];
}

-(void)btnClick:(UIButton *)button{
    if (![NSString isMobile:_phoneTextField.text]) {
        WTOAST(@"请输入手机账号");
        return;
    }
    if (_nPwdTextField.text.length<6) {
        WTOAST(@"新密码密码长度不小于6位");
        return;
    }
    
    DLog(@"type = %@ unionid = %@",self.type,self.unionid);
    if ([self.type isEqualToString:@"wechat"]) {
        [self wechatLoginBinding];
    }else{
        [self qqLoginBinding];
    }
    
    
}


-(void)wechatLoginBinding{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    [manager weChatLoginBindingWithSessionAndOpenId:self.unionid phone:_phoneTextField.text pwd:_nPwdTextField.text success:^(Response *response) {
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.nPwdTextField.text forKey:@"password"];
            [AppDel goMainViewController];
        }else{
            WTOAST(response.msg.desc);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)qqLoginBinding{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    [manager qqLoginBindingWithSessionAndOpenId:self.unionid phone:_phoneTextField.text pwd:_nPwdTextField.text success:^(Response *response) {
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:response.data.sessionId forKey:@"sessionId"];
            [USER_DEFAULT setObject:weakSelf.phoneTextField.text forKey:@"phone"];
            [USER_DEFAULT setObject:weakSelf.nPwdTextField.text forKey:@"password"];
            [AppDel goMainViewController];
        }else{
            WTOAST(response.msg.desc);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
