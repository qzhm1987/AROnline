//
//  UserInfoViewController.m
//  ARVideo
//
//  Created by youdian on 2018/7/17.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "UserInfoViewController.h"
#import "NickViewController.h"
#import "IntroViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel *nickLabel;
    UILabel *sexLabel;
    UILabel *birthLabel;
    UILabel *disLabel;
    UILabel *introLabel;

}

@property (strong, nonatomic)UIView *back;
@end

@implementation UserInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    WS(weakSelf)
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = THEME_COLOR;
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.layer.cornerRadius =20.0f;
    [button addTarget: self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_centerY).offset(265);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 52));
    }];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)saveInfo:(UIButton *)button{
    WS(weakSelf)
    HttpManager *manager = [HttpManager requestManager];
    NSString *sex;
    if ([sexLabel.text isEqualToString:@"男"]) {
        sex = @"0";
    }else if ([sexLabel.text isEqualToString:@"女"]){
        sex = @"1";
    }else{
        sex = @"2";
    }

    [manager updateInfoWithSessionIdAndName:nickLabel.text info:introLabel.text birth:birthLabel.text sex:sex success:^(Response *response) {
        CWTOAST(response.msg.desc);
        if (response.msg.status==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfo" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if (response.msg.status==2){
            [USER_DEFAULT removeObjectForKey:@"sessionId"];
            [AppDel goMainViewController];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    
    
    
    
    
}
#pragma mark USER_INFO

-(void)changeHeadImage{
    [self alertSelectPhoto];
}
-(void)changePassword{
    [self goViewController:@"ModifyViewController"];
}
-(void)changeNickName{
    NickViewController *nick = [NickViewController new];
    nick.nameBlock = ^(NSString *nickName) {
        self->nickLabel.text =nickName;
    };
    [self.navigationController pushViewController:nick animated:YES];
}

-(void)selectBirthday{
    self.PWpickerView = [[PW_DatePickerView alloc] initDatePickerWithDefaultDate:nil andDatePickerMode:UIDatePickerModeDate];
    self.PWpickerView.delegate = self;
    [self.PWpickerView show];
}
-(void)selectRegion{
    WTOAST(@"区域");
}
-(void)introduction{
    IntroViewController *intro = [IntroViewController new];
    intro.introBlock = ^(NSString *introduce) {
         self->introLabel.text =introduce;
    };
    [self.navigationController pushViewController:intro animated:YES];
}

-(void)alertSelectPhoto{
   WS(weakSelf)
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.back];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 8.0f;
    [self.back addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.back);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 120));
    }];
    for (int i=0; i<2; i++) {
        UILabel *label = [UILabel new];
        label.text = @[@"拍摄照片",@"选择手机中的照片"][i];
        label.textColor = [UIColor darkGrayColor];
        label.tag = 30+i;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView).offset(i*60);
            make.left.right.equalTo(alertView);
            make.height.mas_equalTo(60);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [label addGestureRecognizer:tap];
    }
    UIImageView *line = [UIImageView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(alertView);
        make.height.mas_equalTo(1);
    }];
/*
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选取图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机拍照" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    */
    
}
-(void)alertSelectSex{
    WS(weakSelf)
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.back];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 8.0f;
    [self.back addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.back);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 150));
    }];
    for (int i=0; i<3; i++) {
        UILabel *label = [UILabel new];
        label.text = @[@"男",@"女",@"保密"][i];
        label.textColor = [UIColor darkGrayColor];
        label.tag = 40+i;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView).offset(i*50);
            make.left.right.equalTo(alertView);
            make.height.mas_equalTo(50);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSexClick:)];
        [label addGestureRecognizer:tap];
        
    }
   
    
}

-(void)tapSexClick:(UITapGestureRecognizer *)gesture{
    [self.back removeFromSuperview];
    NSInteger tag = gesture.view.tag-40;
    sexLabel.text = @[@"男",@"女",@"保密"][tag];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
      [self.back removeFromSuperview];
    NSInteger tag = tap.view.tag;
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    //   imagePickerController.allowsEditing = YES;
    if (tag==30) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        // imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (tag==31){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else{
       
       
    }
    
    
    
}
- (void)pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString{
    
   birthLabel.text = dateString;
    
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
    UIImage *imageOrigin = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self uploadHeadImageWithImage:imageOrigin];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITableViewDelegate&&DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = self.funArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if (indexPath.row==0) {
            UIImageView *head = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"Mine_gray")];
            [cell.contentView addSubview:head];
            [head mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(0);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addViewWithCell:cell index:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self changeHeadImage];
            break;
        case 1:
            [self changeNickName];
            break;
        case 2:
            [self alertSelectSex];
            break;
        case 3:
            [self selectBirthday];
            break;
        case 5:
            [self selectRegion];
            break;
        case 4:
            [self introduction];
            break;
        default:
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.0f;
}

-(void)addViewWithCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath{
    ARUser *user = [ARUser shareARUser];
    if (indexPath.row==1) {
        UILabel *label = [UILabel new];
        label.text = user.username.length>0?user.username:@"User";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
        nickLabel = label;
    }
    if (indexPath.row==2) {
        UILabel *label = [UILabel new];
        label.text = @"未知";
        if (user.sex==0) {
            label.text = @"男";
        }else if (user.sex == 1){
            label.text = @"女";
        }else{
            label.text = @"未知";
        }
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
       sexLabel = label;
    }
    if (indexPath.row==3) {
        UILabel *label = [UILabel new];
        NSString *birthday = [NSString getDateWithTimeStamp:user.birthday dateFormatter:@"YYYY-MM-dd"];
        label.text = birthday.length>1?birthday:@"去填写";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
        birthLabel = label;
    }
    if (indexPath.row==5) {
        UILabel *label = [UILabel new];
        label.text = @"去填写";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
       disLabel = label;
    }
    if (indexPath.row==4) {
        UILabel *label = [UILabel new];
        label.text = user.infomation.length>1?user.infomation:@"介绍一下自己";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
        introLabel = label;

    }
    
    
}



-(void)uploadHeadImageWithImage:(UIImage *)image{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    NSString *path = @"admin/uploadImage";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSString *sessionId = [USER_DEFAULT objectForKey:@"sessionId"];
    NSDictionary *parameters = NSDictionaryOfVariableBindings(sessionId);
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
        [formData appendPartWithFileData:imageData name:@"imageUrl" fileName:@"iOS_image" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"Res =%@",responseObject);
        WTOAST(responseObject[@"msg"][@"desc"]);
        ARUser *user = [ARUser shareARUser];
        user.image = responseObject[@"data"][@"imageUrl"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHead" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"******");
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView =[self headView];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(UIView *)headView{
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 111);
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
    label.text = @"个人资料";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView).offset(20);
        make.centerX.equalTo(topImgView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    return topImgView;
}
-(NSArray *)funArray{
    if (!_funArray) {
        _funArray = @[@"修改头像",@"昵称",@"性别",@"生日",@"简介"];
    }
    return _funArray;
}
-(void)backTap:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goViewController:(NSString *)viewController{
    UIViewController * vc = [NSClassFromString(viewController) new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView *)back{
    if (!_back) {
        _back = [UIView new];
        _back.backgroundColor = RGBA(0.0f, 0.0f, 0.0f, 0.5f);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                        action:@selector(removeTap:)];
        [_back addGestureRecognizer:tap];
    }
    return _back;
}

-(void)removeTap:(UITapGestureRecognizer *)gesture{
      [self.back removeFromSuperview];
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
