//
//  FunctionViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/30.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "FunctionViewController.h"
#import "ViewController.h"
#import "VideoRecordViewController.h"

@import TXLiteAVSDK_UGC;
@interface FunctionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *circle;
    VideoConfigure *_videoConfig;
}

@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) UIImagePickerController *videoPicker;
@end

@implementation FunctionViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeFunctionUI];
    
    // Do any additional setup after loading the view.
}

-(void)makeFunctionUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.image=  IMAGE_NAME(@"function");
    [self.view addSubview:imageView];
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [imageView addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView).offset(34);
        make.left.equalTo(imageView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    circle = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"fCircle")];
    [imageView addSubview:circle];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                   //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                   animation.fromValue = [NSNumber numberWithFloat:0.f];
                                   animation.toValue = [NSNumber numberWithFloat: M_PI *2];
                                   animation.duration = 3;
                                   animation.autoreverses = NO;
                                   animation.fillMode = kCAFillModeForwards;
                                   animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                   [circle.layer addAnimation:animation forKey:nil];
    
    
    
    
    
    
    
    
    NSArray *nameArray = @[@"AR扫描",@"录像",@"拍照"];
    CGFloat  width = 60;
    CGFloat space = (SCREEN_WIDTH-50-width*3)/2.0f;
    for (int i = 0; i<nameArray.count; i++) {
        NSString *name = nameArray[i];
        UIImageView *fun_imgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(name)];
        fun_imgView.userInteractionEnabled = YES;
        fun_imgView.tag = 10+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [fun_imgView addGestureRecognizer:tap];
        
        [imageView addSubview:fun_imgView];
        [fun_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView).offset(25+(width+space)*i);
            make.bottom.equalTo(imageView).offset(-75);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
        UILabel *label = [UILabel new];
        label.text = nameArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [imageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(fun_imgView);
            make.top.equalTo(fun_imgView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(75, 30));
        }];
    }
}


-(void)tapClick:(UITapGestureRecognizer *)gesture{
    NSInteger tag   = gesture.view.tag;
    switch (tag) {
        case 10:
            [self scanQR];
            break;
        case 13:
            [self scanQR];
            break;
        case 11:
            [self videoRecorder];
            break;
        case 12:
            [self takePhoto];
            break;
            
        default:
            break;
    }
    
}

-(void)scanQR{
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)videoRecorder{
    _videoConfig = [[VideoConfigure alloc] init];
    _videoConfig.videoRatio = VIDEO_ASPECT_RATIO_9_16;
    _videoConfig.bps = 6500;
    _videoConfig.fps = 30;
    _videoConfig.gop = 3;
    VideoRecordViewController *vc = [[VideoRecordViewController alloc] initWithConfigure:_videoConfig];
    [self.navigationController pushViewController:vc animated:YES];
    /*
 //  WTOAST(@"录视频");
    _videoPicker = [[UIImagePickerController alloc] init];
    // 设置代理
    _videoPicker.delegate = self;
    _videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置进入相机时使用前置或后置摄像头
    // imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
   self.videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];
   self.videoPicker.videoQuality  = UIImagePickerControllerQualityTypeMedium;
    //weakSelf.imagePickerController.videoMaximumDuration = 15.0f;
    [self presentViewController:self.videoPicker animated:YES completion:^{}];
    */
}
-(void)takePhoto{
   // WTOAST(@"拍照");
    _photoPicker = [[UIImagePickerController alloc] init];
    // 设置代理
    _photoPicker.delegate = self;
   _photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置进入相机时使用前置或后置摄像头
    [self presentViewController:_photoPicker animated:YES completion:^{}];
}


#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    //  [picker dismissViewControllerAnimated:YES completion:nil];
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    if (picker==_photoPicker) {
        UIImage *imageOrigin = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(imageOrigin, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
    }
    if (picker==_videoPicker) {
        NSURL *url =[info objectForKey:UIImagePickerControllerMediaURL];
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, nil, NULL);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
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
