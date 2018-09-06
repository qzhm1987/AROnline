//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "ViewController.h"

#import "OpenGLView.h"

@implementation ViewController {
    OpenGLView *glView;
}

- (void)loadView {
    self->glView = [[OpenGLView alloc] initWithFrame:CGRectZero];
    self.view = self->glView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self->glView setOrientation:self.interfaceOrientation];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 22, 22)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
#pragma mark - 后退
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView start];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden  = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView stop];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self->glView resize:self.view.bounds orientation:self.interfaceOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self->glView setOrientation:toInterfaceOrientation];
}


@end
