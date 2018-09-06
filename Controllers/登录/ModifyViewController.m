//
//  ModifyViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/3.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "ModifyViewController.h"
#import "QTextField.h"

@interface ModifyViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)QTextField *oPwdTextField;
@property (strong, nonatomic)QTextField *nPwdTextField;
@property (strong, nonatomic)QTextField *rPwdTextField;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改密码";
    [self addModifyPwdTop];
    [self addModifyPwdUI];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
     self.navigationController.navigationBar.hidden = YES;
}
-(void)addModifyPwdTop{
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"Top")];
    top.frame = CGRectMake(0, 20, SCREEN_WIDTH, 175*PIX);
    [self.view addSubview:top];
//    UILabel *lable = [UILabel new];
//    lable.text = @"修改密码";
//    lable.textColor =  THEME_COLOR;
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.font = [UIFont boldSystemFontOfSize:22.0f];
//    [self.view addSubview:lable];
//    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(top.mas_bottom).offset(-10);
//        make.centerX.equalTo(top);
//        make.size.mas_equalTo(CGSizeMake(150, 45));
//    }];
}


-(void)addModifyPwdUI{
    WS(weakSelf)
    NSArray *placeArray = @[@"请输入原密码",@"请输入新密码",@"请再次输入密码"];
        for (int i = 0; i<placeArray.count; i++) {
            QTextField *textField =[[QTextField alloc]initWithFrame:CGRectZero];
            textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
            textField.layer.cornerRadius = 21.0f;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            textField.tag = 20+i;
            textField.secureTextEntry = YES;
          //  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            textField.placeholder = placeArray[i];
            [self.view addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.view).offset(30);
                make.centerY.equalTo(weakSelf.view).offset(i*70-80);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
            }];
        }
    _oPwdTextField = (QTextField*)[self.view viewWithTag:20];
    _nPwdTextField = (QTextField*)[self.view viewWithTag:21];
    _rPwdTextField = (QTextField*)[self.view viewWithTag:22];
    UIButton * modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = THEME_COLOR;
    
   modifyBtn.tag = 10;
    [modifyBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    modifyBtn.layer.cornerRadius =20.0f;
    [modifyBtn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.oPwdTextField);
        make.top.equalTo(weakSelf.rPwdTextField.mas_bottom).offset(20);
    }];
}

-(void)btnClick:(UIButton *)button{
    if (_oPwdTextField.text.length<1) {
        WTOAST(@"请输入原密码");
        return;
    }
    if (_nPwdTextField.text.length<6) {
        WTOAST(@"新密码密码长度不小于6位");
        return;
    }
    if (![_nPwdTextField.text isEqualToString:_rPwdTextField.text]) {
        WTOAST(@"密码前后输入不一致");
        return;
    }
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    [manager modifyPasswordWithOldPwd:_oPwdTextField.text newPwd:_nPwdTextField.text success:^(Response *response) {
        if (response.msg.status==0) {
            [USER_DEFAULT setObject:weakSelf.nPwdTextField.text forKey:@"password"];
            [AppDel goLoginViewController];
        }
        WTOAST(response.msg.desc);
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
