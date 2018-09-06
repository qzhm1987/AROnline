//
//  DelegateWeb.m
//  ARVideo
//
//  Created by youdian on 2018/9/3.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "DelegateWeb.h"

@interface DelegateWeb ()

@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation DelegateWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   NSURL*_url = [[NSBundle mainBundle] URLForResource:@"ARVideo.html" withExtension:nil];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:_url];
    // 3.加载网页
    [_wkWebView loadRequest:request];
    
    // 最后将webView添加到界面
    [self.view addSubview:_wkWebView];
    
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 NSURL *fileUrl = [[NSURL alloc] initWithString:filePath];
 NSURL *url = [NSURL URLWithString:encodedComponent relativeToURL:fileUrl];
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
