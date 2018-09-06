//
//  MakeARViewController.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "MakeARViewController.h"
#import "QTextField.h"
#import "QTextView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


// 照片原图路径
#define KOriginalPhotoImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface MakeARViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,copy) NSString *nameAR;
@property (nonatomic ,copy) NSString *videoUrl;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)QTextField *arNameTF;
@property (strong, nonatomic)QTextView *textView;
@property (strong, nonatomic)UIImageView *imageAR;
@property (strong, nonatomic)UIImageView *video;
@property (assign, nonatomic)BOOL selectVideo;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) UIImagePickerController *videoPicker;
@end

@implementation MakeARViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addMakeARUI];
    
   
    
    
    // Do any additional setup after loading the view.
}


-(void)addMakeARUI{
    WS(weakSelf)
    UIImageView *top = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"blue_back")];
    top.userInteractionEnabled = YES;
    [self.view addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(200*PIX);
    }];
   
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
    searchTF.placeholder = @"请输入您要搜索的内容";
    searchTF.backgroundColor = [UIColor lightTextColor];
    [top addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(top).offset(40);
        make.right.equalTo(top).offset(-20);
        make.top.equalTo(top).offset(44);
        make.height.mas_equalTo(38);
    }];
    
    
    UIImageView *back = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"ARback")];
    back.userInteractionEnabled  = YES;
    [top addSubview:back];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
    [back addGestureRecognizer:backTap];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchTF);
        make.left.equalTo(top).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UIImageView *searchImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"search")];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap:)];
    searchImgView.userInteractionEnabled = YES;
    [searchImgView addGestureRecognizer:searchTap];
    [top addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchTF).offset(-15);
        make.centerY.equalTo(searchTF);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UIImageView *whiteLine = [[UIImageView alloc]init];
    whiteLine.tag=7;
    whiteLine.backgroundColor = [UIColor whiteColor];
    [top addSubview:whiteLine];
    [whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(searchTF);
        make.top.equalTo(searchTF.mas_bottom).offset(40);
        make.height.mas_equalTo(5);
    }];
    UIImageView *orangeLine = [[UIImageView alloc]init];
    orangeLine.backgroundColor = [UIColor orangeColor];
    [top addSubview:orangeLine];
    [orangeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(whiteLine);
        make.right.equalTo(whiteLine.mas_centerX).offset(0);
    }];
    for (int i = 0; i<4; i++) {
        UILabel *circle  = [[UILabel alloc]init];
        circle.textAlignment = NSTextAlignmentCenter;
        circle.backgroundColor =i<2?[UIColor orangeColor]:[UIColor whiteColor];
        circle.textColor = i<2?[UIColor whiteColor]:[UIColor blackColor];
        circle.font = [UIFont systemFontOfSize:15.0f];
        circle.layer.cornerRadius  = 8;
        circle.clipsToBounds = YES;
        circle.text = [NSString stringWithFormat:@"%d",i+1];
        circle.tag = 50+i;
        [top addSubview:circle];
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteLine);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(whiteLine).offset(30+i*85);
        }];
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @[@"取名称",@"上传图片",@"上传视频",@"提交"][i];
        [top addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(circle);
            make.centerY.equalTo(circle.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    
    UIView *bView = [UIView new];
    bView.tag = 5;
    bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    for (int j = 0; j<2; j++) {
        UILabel *upLabel = [UILabel new];
        upLabel.text = @[@"AR名称",@"上传AR图片"][j];
        upLabel.tag = 30+j;
        upLabel.textColor = [UIColor darkGrayColor];
        [bView addSubview:upLabel];
        [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bView).offset(20);
            make.top.equalTo(top.mas_bottom).offset(20+j*100);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
    }
   _nameLabel = (UILabel *)[self.view viewWithTag:30];
    UILabel *photoLabel = (UILabel *)[self.view viewWithTag:31];
    _arNameTF = [[QTextField alloc]init];
    _arNameTF.borderStyle = UITextBorderStyleRoundedRect;
    _arNameTF.placeholder = @"请输入AR名称";
    _arNameTF.backgroundColor = [UIColor lightTextColor];
    [bView addSubview:_arNameTF];
    [_arNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.nameLabel);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 50));
    }];
    
    UIImageView *photoImgView = [UIImageView new];
    photoImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    photoImgView.image = IMAGE_NAME(@"add");
//    photoImgView.layer.borderWidth = 1.0f;
//    photoImgView.layer.cornerRadius = 8.0f;
//    photoImgView.clipsToBounds = YES;
    photoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)];
    [photoImgView addGestureRecognizer:tap];
    
    [bView addSubview:photoImgView];
    
    [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bView);
        make.top.equalTo(photoLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    _imageAR = photoImgView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGBA(255, 191, 0, 1);
    button.layer.cornerRadius = 8.0f;
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bView);
        make.top.equalTo(photoImgView.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(160, 50));
    }];
}
-(void)addNextUI{
    WS(weakSelf)
    UIImageView *orangeLine = [self.view viewWithTag:7];
    UILabel *label3 = [self.view viewWithTag:52];
     UILabel *label4 = [self.view viewWithTag:53];
    label3.backgroundColor = [UIColor orangeColor];
    label3.textColor = [UIColor whiteColor];
    label4.backgroundColor = [UIColor orangeColor];
    label4.textColor = [UIColor whiteColor];
    orangeLine.backgroundColor = [UIColor orangeColor];
    UIView *bView = [UIView new];
    bView.tag = 6;
    bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(200);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
//    for (int i = 0; i<2; i++) {
//        UILabel *upLabel = [UILabel new];
//        upLabel.text = @[@"上传AR视频",@"AR视频介绍"][i];
//        upLabel.tag = 40+i;
//        upLabel.textColor = [UIColor darkGrayColor];
//        [bView addSubview:upLabel];
//        [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(bView).offset(20);
//            make.top.equalTo(bView).offset(10+i*160);
//            make.size.mas_equalTo(CGSizeMake(120, 30));
//        }];
//    }
    UILabel *videoLabel = [UILabel new];
    videoLabel.text = @"上传视频";
    videoLabel.textColor = [UIColor darkGrayColor];
    [bView addSubview:videoLabel];
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bView).offset(20);
        make.top.equalTo(bView).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];

   
    _video = [UIImageView new];
    _video.userInteractionEnabled = YES;
    _video.image = IMAGE_NAME(@"add");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoTap:)];
    [_video addGestureRecognizer:tap];
    [bView addSubview:_video];
    [_video mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bView);
        make.top.equalTo(videoLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    UILabel *infoLabel = [UILabel new];
    infoLabel.text = @"AR视频介绍";
    infoLabel.textColor = [UIColor darkGrayColor];
    [bView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bView).offset(20);
        make.top.equalTo(weakSelf.video.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    QTextView *text = [[QTextView alloc]init];
    text.placeholder = @"视频介绍";
    text.layer.borderWidth = 0.8f;
    text.layer.cornerRadius = 8.0f;
    text.font = [UIFont systemFontOfSize:15.0f];
    text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLabel);
        make.top.equalTo(infoLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 140));
    }];
    _textView = text;
    
    //选择框
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGBA(255, 191, 0, 1);
    button.layer.cornerRadius = 8.0f;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bView);
        make.bottom.equalTo(weakSelf.view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(160, 50));
    }];
    
    
    
}

-(void)commitClick:(UIButton *)button{
    if (!_selectVideo) {
        WTOAST(@"请上传视频");
        return;
    }
    if (_textView.text.length<1) {
        WTOAST(@"请填写AR视频说明介绍");
        return;
    }
    [self makeAROnlineAndUpLoad];
}
-(void)nextClick:(UIButton *)button{
    DLog(@"下一步");
    if (_arNameTF.text.length<1) {
        WTOAST(@"请输入AR名称");
        return;
    }
    if (!_imageAR.image) {
        WTOAST(@"请上传AR图片");
        return;
    }
    UIView *view =(UIView *) [self.view viewWithTag:5];
    [view removeFromSuperview];
    [self addNextUI];
    
}


-(void)backTap:(UIGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    DLog(@"searchTap");
}
-(void)photoTap:(UITapGestureRecognizer *)gesture{
  _photoPicker = [[UIImagePickerController alloc] init];
    // 设置代理
  _photoPicker.delegate = self;
    WS(weakSelf)
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选取图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        // weakSelf.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
       // self->_photoPicker.allowsEditing = YES;
        [self presentViewController:weakSelf.photoPicker animated:YES completion:^{}];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
       // weakSelf.imagePickerController.mediaTypes = @[(NSString*)kUTTypeMovie];
        [self presentViewController:weakSelf.photoPicker animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void)videoTap:(UITapGestureRecognizer *)gesture{
   _videoPicker = [[UIImagePickerController alloc] init];
    // 设置代理
   _videoPicker.delegate = self;
    
    WS(weakSelf)
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选取视频" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        
        // imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        weakSelf.videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        weakSelf.videoPicker.videoQuality  = UIImagePickerControllerQualityTypeMedium;
        //weakSelf.imagePickerController.videoMaximumDuration = 15.0f;
        [self presentViewController:weakSelf.videoPicker animated:YES completion:^{}];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        weakSelf.videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        [self presentViewController:weakSelf.videoPicker animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
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
        
        //相似度检测
        [self uploadImageCheckSameWithImage:imageOrigin];
    }
    if (picker==_videoPicker) {
        NSURL *url =[info objectForKey:UIImagePickerControllerMediaURL];
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
             UISaveVideoAtPathToSavedPhotosAlbum([url path], self, nil, NULL);
        }
         [self movTomp4:url];
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

-(void)makeAROnlineAndUpLoad{
    WS(weakSelf)
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    NSString *path = @"arInsert/add";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *name = _arNameTF.text;
    NSString *lng = [USER_DEFAULT objectForKey:@"lng"]?[USER_DEFAULT objectForKey:@"lng"]:  @"114.51517144";
    NSString *lat = [USER_DEFAULT objectForKey:@"lat"]?[USER_DEFAULT objectForKey:@"lat"]:  @"38.05085449";
    NSString *info =_textView.text;
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(name,lat,lng,sessionId,info);
    UIImage *image = self.imageAR.image;
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
        NSString *documentPath=[[NSString alloc]init];
       documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * filePath =  [documentPath stringByAppendingPathComponent:@"ARMake.mp4"];
        NSData *videoData = [NSData dataWithContentsOfFile:filePath];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",[self currentTimeStr]];
         NSString *videoName = [NSString stringWithFormat:@"%@.mp4",[self currentTimeStr]];
        [formData appendPartWithFileData:imageData name:@"imageUrl" fileName:imgName mimeType:@"image/jpeg"];
         [formData appendPartWithFileData:videoData name:@"videoUrl" fileName:videoName mimeType:@"video/mp4"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        DLog(@"Res =%@",responseObject);
        Response *response = [[Response alloc]init];
        [response yy_modelSetWithJSON:responseObject];
        if (response.msg.status==0) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        }
        WTOAST(response.msg.desc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WTOAST(@"上传失败");
        [SVProgressHUD dismiss];
    }];
}

-(void)uploadImageCheckSameWithImage:(UIImage *)image{
    WS(weakSelf)
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    NSString *path = @"arInsert/checkSame";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation( weakSelf.imageAR.image);
        [formData appendPartWithFileData:imageData
                                    name:@"imageUrl"
                                fileName:@"ARImage"
                                mimeType:@"application/json"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Response *response = [[Response alloc]init];
        [response yy_modelSetWithJSON:responseObject];
        if (response.msg.status==0) {
            weakSelf.imageAR.image = image;
            CGFloat scale =  image.size.width/image.size.height;
            CGFloat width = scale<1?120:200;
            DLog(@"width = %f",width);
            [weakSelf.imageAR mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.size.mas_equalTo(CGSizeMake(width, width/scale));
            }];
           
        }else{
            weakSelf.imageAR.image = IMAGE_NAME(@"add");
            [weakSelf.imageAR mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(120, 120));
            }];
           WTOAST(response.msg.desc);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WTOAST(@"上传失败");
    }];
  
}




- (void)movTomp4:(NSURL *)movUrl{
    WS(weakSelf)
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMediumQuality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        //转换完成保存的文件路径
        NSString *path=[[NSString alloc]init];
        path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * resultPath =  [path stringByAppendingPathComponent:@"ARMake.mp4"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:resultPath]) {
            [fileManager removeItemAtPath:resultPath error:nil];
        }
         exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        //要转换的格式，这里使用 MP4
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //异步处理开始转换
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
             //转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                 case AVAssetExportSessionStatusCompleted:{
                     //转换完成
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     dispatch_async(dispatch_get_main_queue(), ^{
                       weakSelf.selectVideo =  YES;
                         UIImage *image = [self getVideoPreViewImage:exportSession.outputURL];
                         CGFloat scale = image.size.width/image.size.height;
                         CGFloat width = scale<1?120:200;
                         weakSelf.video.image = image;
                         [weakSelf.video mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.size.mas_equalTo(CGSizeMake(width, width/scale));
                         }];
                     });
                 }
             }
             
         }];
        
    }
    
}

//获取视频第一帧图片
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

// 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}





// 将原始图片的URL转化为NSData数据,写入沙盒
- (void)imageWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 进这个方法的时候也应该加判断,如果已经转化了的就不要调用这个方法了
    // 如何判断已经转化了,通过是否存在文件路径
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    // 创建存放原始图的文件夹--->OriginalPhotoImages
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KOriginalPhotoImagePath]) {
        [fileManager createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            // 主要方法
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                NSString * imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:fileName];
                [data writeToFile:imagePath atomically:YES];
            } failureBlock:nil];
        }
    });
}

// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [KCachesPath stringByAppendingPathComponent:fileName];
                char const *cvideoPath = [videoPath UTF8String];
              FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 1024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
            } failureBlock:nil];
        }
    });
}
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    //NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    DLog(@"time==%@",timeString);
    return timeString;
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
