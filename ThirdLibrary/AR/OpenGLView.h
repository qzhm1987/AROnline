//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <GLKit/GLKView.h>
#define scanContent_X self.frame.size.width * 0.15

@interface OpenGLView : GLKView

@property(nonatomic, strong)UIWebView * web;
@property (strong, nonatomic)NSTimer *timer;
@property (nonatomic, strong) UIImageView *scanningline;
@property (nonatomic ,copy) NSString *urlString;


- (void)start;
- (void)stop;
- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation;
- (void)setOrientation:(UIInterfaceOrientation)orientation;

@end
