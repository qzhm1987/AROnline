//
//  NickViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/19.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "NickViewController.h"




@interface NickViewController ()<UITextFieldDelegate>


@end

@implementation NickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTop];
    [self addMainNickUI];
    
    // Do any additional setup after loading the view.
}

-(void)addTop{
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
    label.text = @"修改昵称";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}

-(void)addMainNickUI{
    WS(weakSelf)
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
   // textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = @"昵称修改";
    textField.borderStyle = UITextBorderStyleNone;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(150);
        make.left.equalTo(weakSelf.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    _nameTextField = textField;
    UIImageView *line = [UIImageView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(1);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    button.tag = 10;
    button.layer.cornerRadius = 5.0f;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line).offset(-5);
        make.right.equalTo(line).offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 38));
    }];
    
    
    
}

-(void)btnClick:(UIButton *)button{
    WTOAST(@"保存");
    if (_nameBlock) {
        _nameBlock(_nameTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma Mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
   
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
