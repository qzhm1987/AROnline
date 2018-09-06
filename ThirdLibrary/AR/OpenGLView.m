//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================
#define ratio         [[UIScreen mainScreen] bounds].size.width/320.0
#import "OpenGLView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "helloar.h"
#import "ArAndSaoBtn.h"

#import <easyar/engine.oc.h>

/** 扫描内容的Y值 */
#define scanContent_Y self.frame.size.height * 0.24
/** 扫描内容的Y值 */
#define scanContent_X self.frame.size.width * 0.15

@interface OpenGLView ()<UIWebViewDelegate>
{
//    IRCameraMask * view;
    UIView *scanView;
    BOOL _flag;
    UIButton * btn;
    UIButton * _lastbtn;
}

@end

@implementation OpenGLView {
    BOOL initialized;
}

- (id)initWithFrame:(CGRect)frame
{
    _flag = NO;
    frame.size.width = frame.size.height = MAX(frame.size.width, frame.size.height);
    self = [super initWithFrame:frame];
    self->initialized = false;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    [self bindDrawable];
    
    scanView = [UIView new];
    scanView.backgroundColor = [UIColor clearColor];
    scanView.layer.borderWidth = 0.6f;
    scanView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:scanView];
    
    [scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(165);
        make.size.mas_equalTo(CGSizeMake(245, 245));
    }];
    
    UIImageView *left_up = [UIImageView new];
    left_up.image = IMAGE_NAME(@"QRCodeLeftTop");
    [scanView addSubview:left_up];
    [left_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self->scanView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    UIImageView *right_up = [UIImageView new];
    right_up.image = IMAGE_NAME(@"QRCodeRightTop");
    [scanView addSubview:right_up];
    [right_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self->scanView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    UIImageView *left_bottom = [UIImageView new];
    left_bottom.image = IMAGE_NAME(@"QRCodeLeftBottom");
    [scanView addSubview:left_bottom];
    [left_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self->scanView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    UIImageView *right_bottom = [UIImageView new];
   right_bottom.image = IMAGE_NAME(@"QRCodeRightBottom");
    [scanView addSubview:right_bottom];
    [right_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self->scanView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];

    _scanningline = [UIImageView new];
   _scanningline.image = IMAGE_NAME(@"QRCodeScanningLine");
    _scanningline.frame = CGRectMake(0, 0, 245, 12);
    [scanView addSubview: _scanningline];
    
    
    
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(50, 88,[UIScreen mainScreen].bounds.size.width - 100 ,     [UIScreen mainScreen].bounds.size.height-178)];
    _web.delegate = self;
    _web.alpha = 0.8f;
     btn= [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-30)/2, [UIScreen mainScreen].bounds.size.height - 60, 30, 30)];
    
    btn.hidden = YES;
    [btn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [self addSubview:btn];

    NSArray * array = @[@"AR扫描",@"扫一扫"];
    NSArray * picArray = @[@"03",@"扫一扫"];
    for (int i = 0; i < 2; i ++) {
        ArAndSaoBtn * btn = [[ArAndSaoBtn alloc] initWithFrame:CGRectMake(60 + (SCREEN_WIDTH - 50- 60*2)*i, SCREEN_HEIGHT - 90, 50, 60)];
        if (i == 0) {
            btn.selected = YES;
            _lastbtn = btn;
            [[NSUserDefaults standardUserDefaults] setObject:@"AR" forKey:@"AROrSaoyiSao"];
        }
        btn.tag = 100+i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setImage:[UIImage imageNamed:picArray[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(ARORSAO:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [self addSubview:btn];
    }
 
    //扫描到图片的 回调通知监听
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"x" object:nil];
    //扫描到二维码的 回调通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEr:) name:@"er" object:nil];
    //视频播放完成 回调通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay:) name:@"endplay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccess:) name:@"scanSuccess" object:nil];
    
    return self;
}

-(void)scanSuccess:(NSNotification *)notification{
    DLog(@"网络请求扫描成功");
    NSString *urlStr = notification.object;
    
    if (![self.urlString isEqualToString:urlStr]) {
        self.urlString = urlStr;
         [self requestScanCountWithVideoUrl:self.urlString];
    }
}
- (void)ARORSAO:(UIButton *)btn{
    if (btn.tag ==100) {//AR
         [[NSUserDefaults standardUserDefaults] setObject:@"AR" forKey:@"AROrSaoyiSao"];
    }else{//扫一扫
         [[NSUserDefaults standardUserDefaults] setObject:@"saoyisao" forKey:@"AROrSaoyiSao"];
    }
    _lastbtn.selected = NO;
    btn.selected = YES;
    _lastbtn = btn;
}
#pragma mark - 扫描二维码
- (void)changeEr:(NSNotification *)sender{
    NSString * urlString = sender.object;
    NSURL * url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}
#pragma mark - 扫描到图片之后的回调
- (void)change:(NSNotification *)sender{
   // btn.hidden = NO;
    scanView.hidden = YES;
    [_timer invalidate];

    NSString * url = sender.object;
    
    if (url) {
        DLog(@"url = %@ object = %@",url,sender.userInfo);
         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sta"];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];//创建NSURLRequest
        [_web loadRequest:request];
        [self addSubview:_web];
        
    
    }
  
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_flag) {
        SystemSoundID soundId;
        NSString *path = [[NSBundle mainBundle ] pathForResource:@"5012" ofType:@"wav"];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
        // 添加摇动声音
        AudioServicesPlaySystemSound (soundId);
        // 3.设置震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _flag = NO;
    }

}
#pragma mark - 视频播放完成之后的回调
- (void)endPlay:(NSNotification *)sender{
        [self quxiao];
        NSString * string= sender.object;
        NSURL * url = [NSURL URLWithString:string];
    
        [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - 取消视频或网页
- (void)quxiao{
    btn.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"暂停" forKey:@"zanting"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sta"];
    if (_web) {
        [_web removeFromSuperview];
         scanView.hidden = NO;
    }
}


- (void)start {
    if (initialize()) {
        start();
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)stop{
    stop();
    finalize();
    [self quxiao];
   [_timer invalidate];
}

- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation
{
    float scale;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        scale = [[UIScreen mainScreen] nativeScale];
#pragma clang diagnostic pop
    } else {
        scale = [[UIScreen mainScreen] scale];
    }

    resizeGL(frame.size.width * scale, frame.size.height * scale);
}

- (void)drawRect:(CGRect)rect
{
    if (!initialized) {
        initGL();
        initialized = YES;
    }
    render();
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            [easyar_Engine setRotation:270];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [easyar_Engine setRotation:90];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [easyar_Engine setRotation:180];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [easyar_Engine setRotation:0];
            break;
        default:
            break;
    }
}

-(void)timeAction{
    WS(weakSelf)
    DLog(@"frame = %@",NSStringFromCGRect(_scanningline.frame));
    __block  CGFloat y =self.scanningline.frame.origin.y+5;
    if (y>246.0) {
        y=0.0f;
    }
    [UIView animateWithDuration:0.05 animations:^{
       weakSelf.scanningline.frame = CGRectMake(0, y, 245, 12);
    } completion:nil];
    
    
    
}
#pragma mark 扫描成功计数
-(void)requestScanCountWithVideoUrl:(NSString *)videoUrl{
    HttpManager *manager = [HttpManager requestManager];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSString *phoneType = [NSString currentDeviceType];
    DLog(@"phoneType = %@",phoneType);
    [manager scanCountWithSession:sessionId video:videoUrl phone:phoneType city:AppDel.city success:^(Response *response) {
        if (response.msg.status==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newData" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInfo" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

@end
