//
//  AboutViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/26.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于我们";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self addAboutUI];
    // Do any additional setup after loading the view.
}




-(void)addAboutUI{
    WS(weakSelf)
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    [self.view addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(110*PIX);
    }];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [topImgView addSubview:back];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:tap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(30);
        make.left.equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel *label =[UILabel new];
    label.text = @"关于我们";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    UIImageView *adImgView =[[UIImageView alloc]initWithImage:IMAGE_NAME(@"ad")];
    [self.view addSubview:adImgView];
    [adImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(-8);
        make.left.right.equalTo(topImgView);
        make.height.mas_equalTo(194*PIX);
    }];
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"河北邮电广告有限公司";
    nameLabel.textColor  = THEME_COLOR;
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adImgView.mas_bottom).offset(38);
        make.centerX.equalTo(adImgView);
        make.size.mas_equalTo(CGSizeMake(180*PIX, 35));
    }];
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.text = @"版本号：v1.0.0";
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    versionLabel.layer.borderWidth = 2.0f;
    versionLabel.layer.cornerRadius = 19.0f;
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.centerX.equalTo(nameLabel);
        make.size.mas_equalTo(CGSizeMake(250*PIX, 38));
    }];
    UILabel *telLabel = [UILabel new];
    telLabel.text = @"客服热线：15801203493";
    telLabel.textAlignment = NSTextAlignmentCenter;
    telLabel.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    telLabel.layer.borderWidth = 2.0f;
    telLabel.layer.cornerRadius = 19.0f;
    [self.view addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLabel.mas_bottom).offset(12);
        make.centerX.equalTo(versionLabel);
        make.size.mas_equalTo(CGSizeMake(250*PIX, 38));
    }];
    
    UIImageView *bottomImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"bottom")];
    [self.view addSubview:bottomImgView];
    [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(115*PIX);
    }];
}

-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
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
