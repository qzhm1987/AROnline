//
//  IntroViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/18.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "IntroViewController.h"
#import "QTextView.h"


@interface IntroViewController ()

@property (strong, nonatomic)QTextView *qTextView;
@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addTop];
    [self addMianIntroUI];
    
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
    label.text = @"简介";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}

-(void)addMianIntroUI{
    WS(weakSelf)
    QTextView * textView = [[QTextView alloc]initWithFrame:CGRectZero];
    textView.font=[UIFont systemFontOfSize:16.0f];
    textView.placeholder = @"介绍一下自己吧";
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 220));
    }];
    _qTextView = textView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.layer.cornerRadius =20.0f;
    [button addTarget: self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(textView);
        make.top.equalTo(textView.mas_bottom).offset(75);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 50));
    }];
}
-(void)save{
    WTOAST(@"保存提交");
    if (_introBlock) {
        self.introBlock(_qTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
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
