//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "helloar.h"



#import <easyar/vector.oc.h>
#import <easyar/matrix.oc.h>

#import <easyar/types.oc.h>
#import <easyar/camera.oc.h>
#import <easyar/frame.oc.h>
#import <easyar/framestreamer.oc.h>
#import <easyar/imagetracker.oc.h>
#import <easyar/imagetarget.oc.h>

#import <easyar/renderer.oc.h>


#import <easyar/cloud.oc.h>//云识别
#import <easyar/qrcode.oc.h>//二维码
#import "VideoRenderer.h"//视频框架
#import "ARVideo.h"//视频播放

#include <OpenGLES/ES2/gl.h>

extern NSString * cloud_server_address;
extern NSString * cloud_key;
extern NSString * cloud_secret;

easyar_CameraDevice * camera;
easyar_CameraFrameStreamer * streamer;
NSMutableArray<easyar_ImageTracker *> * trackers;
//视频
easyar_Renderer * videobg_renderer;
NSMutableArray<VideoRenderer*> * video_renderers = nil;
VideoRenderer * current_video_renderer = nil;
int tracked_target = 0;
int active_target = 0;
ARVideo * video = nil;


//云识别器
easyar_CloudRecognizer * cloud_recognizer;
//二维码扫描器
easyar_QRCodeScanner * qrcode_scanner;

bool viewport_changed = false;
int view_size[] = {0, 0};
int view_rotation = 0;
int viewport[] = {0, 0, 1280, 720};
int previous_qrcode_index = -1;
NSMutableSet<NSString *> * uids;

void loadFromImage(easyar_ImageTracker * tracker, NSString * path)
{
    
    easyar_ImageTarget * target = [easyar_ImageTarget create];
    NSString * name = [path substringToIndex:[path rangeOfString:@"."].location];
    NSString * jstr = [@[@"{\n"
                         "  \"images\" :\n"
                         "  [\n"
                         "    {\n"
                         "      \"image\" : \"", path, @"\",\n"
                         "      \"name\" : \"", name, @"\"\n"
                         "    }\n"
                         "  ]\n"
                         "}"] componentsJoinedByString:@""];
    [target setup:jstr storageType:(easyar_StorageType_Assets | easyar_StorageType_Json) name:@""];
    [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
        NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
    }];
}

void loadFromJsonFile(easyar_ImageTracker * tracker, NSString * path, NSString * targetname)
{
    easyar_ImageTarget * target = [easyar_ImageTarget create];
    [target setup:path storageType:easyar_StorageType_Assets name:targetname];
    [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
        NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
    }];
}

void loadAllFromJsonFile(easyar_ImageTracker * tracker, NSString * path)
{
    for (easyar_ImageTarget * target in [easyar_ImageTarget setupAll:path storageType:easyar_StorageType_Assets]) {
        [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
            NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
        }];
    }
}

BOOL initialize()
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"sta" ];
    camera = [easyar_CameraDevice create];
    streamer = [easyar_CameraFrameStreamer create];
    [streamer attachCamera:camera];
    //二维码扫描器
    qrcode_scanner = [easyar_QRCodeScanner create]; //加
    [qrcode_scanner attachStreamer:streamer];
    //云识别器
    cloud_recognizer = [easyar_CloudRecognizer create];
    [cloud_recognizer attachStreamer:streamer];

    
    bool status = true;
    status &= [camera open:easyar_CameraDeviceType_Default];
    [camera setSize:[easyar_Vec2I create:@[@1280, @720]]];
   //云识别
    uids = [[NSMutableSet<NSString *> alloc] init];
    [cloud_recognizer open:cloud_server_address appKey:cloud_key appSecret:cloud_secret callback_open:^(easyar_CloudStatus status) {
        if (status == easyar_CloudStatus_Success ) {
            NSLog(@"CloudRecognizerInitCallBack: Success");
        } else if (status == easyar_CloudStatus_Reconnecting) {
            NSLog(@"CloudRecognizerInitCallBack: Reconnecting");
        } else if (status == easyar_CloudStatus_Fail) {
            NSLog(@"CloudRecognizerInitCallBack: Fail");
        } else {
            NSLog(@"CloudRecognizerInitCallBack: %ld", (long)status);
        }
    } callback_recognize:^(easyar_CloudStatus status, NSArray<easyar_Target *> * targets) {
        if (status == easyar_CloudStatus_Success ) {
            NSLog(@"CloudRecognizerCallBack: Success");
        } else if (status == easyar_CloudStatus_Reconnecting) {
            NSLog(@"CloudRecognizerCallBack: Reconnecting");
        } else if (status == easyar_CloudStatus_Fail) {
            NSLog(@"CloudRecognizerCallBack: Fail");
        } else {
            NSLog(@"CloudRecognizerCallBack: %ld", (long)status);
        }
        @synchronized (uids) {
            for (easyar_Target * t in targets) {
                if (![uids containsObject:[t uid]]) {
                    NSLog(@"add cloud target: %@", [t uid]);
                    [uids addObject:[t uid]];
                    [[trackers objectAtIndex:0] loadTarget:t callback:^(easyar_Target *target, bool status) {
                        NSLog(@"load target (%@): %@ (%d)", status ? @"true" : @"false", [target name], [target runtimeID]);
                    }];
                }
            }
        }
    }];

    
    
    if (!status) { return status; }
    easyar_ImageTracker * tracker = [easyar_ImageTracker create];
    [tracker attachStreamer:streamer];
    loadFromJsonFile(tracker, @"targets.json", @"argame");
    loadFromJsonFile(tracker, @"targets.json", @"idback");
    loadAllFromJsonFile(tracker, @"targets2.json");
    loadFromImage(tracker, @"namecard.jpg");
    trackers = [[NSMutableArray<easyar_ImageTracker *> alloc] init];
    [trackers addObject:tracker];

    return status;
}

void finalize()
{
    //视频
    video = nil;
    tracked_target = 0;
    active_target = 0;
    
    
    [trackers removeAllObjects];
    //云
    cloud_recognizer = nil;
    
    videobg_renderer = nil;
    //二维码
    qrcode_scanner = nil;//加
    streamer = nil;
    camera = nil;
}

BOOL start()
{
    bool status = true;
    status &= (camera != nil) && [camera start];
    status &= (streamer != nil) && [streamer start];
    status &= (qrcode_scanner!=nil) &&[qrcode_scanner start];//加
    status &= (cloud_recognizer != nil) && [cloud_recognizer start];
    [camera setFocusMode:easyar_CameraDeviceFocusMode_Continousauto];
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker start];
    }
    return status;
}

BOOL stop()
{
    bool status = true;
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker stop];
    }
    status &= (qrcode_scanner != nil)&&[qrcode_scanner stop];
    status &= (cloud_recognizer != nil) && [cloud_recognizer stop];
    status &= (streamer != nil) && [streamer stop];
    status &= (camera != nil) && [camera stop];
    return status;
}

void initGL()
{
    //视频
    if (active_target != 0) {
        [video onLost];
        video = nil;
        tracked_target = 0;
        active_target = 0;
    }
    videobg_renderer = nil;
    videobg_renderer = [easyar_Renderer create];
    video_renderers = [[NSMutableArray<VideoRenderer *>alloc] init];
    for (int i = 0; i < 3; i ++) {
        VideoRenderer * video_renderer = [[VideoRenderer alloc] init];
        [video_renderer init_];
        [video_renderers addObject:video_renderer];
        
    }
    current_video_renderer = nil;
    
}

void resizeGL(int width, int height)
{
    view_size[0] = width;
    view_size[1] = height;
    viewport_changed = true;
}

void updateViewport()
{
    easyar_CameraCalibration * calib = camera != nil ? [camera cameraCalibration] : nil;
    int rotation = calib != nil ? [calib rotation] : 0;
    if (rotation != view_rotation) {
        view_rotation = rotation;
        viewport_changed = true;
    }
    if (viewport_changed) {
        int size[] = {1, 1};
        if (camera && [camera isOpened]) {
            size[0] = [[[camera size].data objectAtIndex:0] intValue];
            size[1] = [[[camera size].data objectAtIndex:1] intValue];
        }
        if (rotation == 90 || rotation == 270) {
            int t = size[0];
            size[0] = size[1];
            size[1] = t;
        }
        float scaleRatio = MAX((float)view_size[0] / (float)size[0], (float)view_size[1] / (float)size[1]);
        int viewport_size[] = {(int)roundf(size[0] * scaleRatio), (int)roundf(size[1] * scaleRatio)};
        int viewport_new[] = {(view_size[0] - viewport_size[0]) / 2, (view_size[1] - viewport_size[1]) / 2, viewport_size[0], viewport_size[1]};
        memcpy(&viewport[0], &viewport_new[0], 4 * sizeof(int));
        
        if (camera && [camera isOpened])
            viewport_changed = false;
    }
}

void render()
{
    
   NSString * string  = [[NSUserDefaults standardUserDefaults] objectForKey:@"zanting"];
    if (string) {
        initGL();
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zanting"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saomiao" object:@"n"];

    }
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (videobg_renderer != nil) {
        int default_viewport[] = {0, 0, view_size[0], view_size[1]};
        easyar_Vec4I * oc_default_viewport = [easyar_Vec4I create:@[[NSNumber numberWithInt:default_viewport[0]], [NSNumber numberWithInt:default_viewport[1]], [NSNumber numberWithInt:default_viewport[2]], [NSNumber numberWithInt:default_viewport[3]]]];
        glViewport(default_viewport[0], default_viewport[1], default_viewport[2], default_viewport[3]);
        if ([videobg_renderer renderErrorMessage:oc_default_viewport]) {
            return;
        }
    }

    if (streamer == nil) { return; }
    easyar_Frame * frame = [streamer peek];
    updateViewport();
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);

    if (videobg_renderer != nil) {
        [videobg_renderer render:frame viewport:[easyar_Vec4I create:@[[NSNumber numberWithInt:viewport[0]], [NSNumber numberWithInt:viewport[1]], [NSNumber numberWithInt:viewport[2]], [NSNumber numberWithInt:viewport[3]]]]];
    }
    //识别图片
    NSArray<easyar_TargetInstance*> * targetInstances = [frame targetInstances];

    easyar_TargetInstance * targetInstance;
    easyar_ImageTarget * imagetarget;
    
    NSString * s = [[NSUserDefaults standardUserDefaults] objectForKey:@"AROrSaoyiSao"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AROrSaoyiSao"] isEqualToString:@"AR"]) {//只进行AR识别
        if ([targetInstances count] > 0) {//识别到图片
            NSString * string1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"sta"];
            if ([string1 isEqualToString:@"1"]) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saomiao" object:@"y"];
            targetInstance = [targetInstances objectAtIndex:0];
            easyar_Target * target = [targetInstance target];
            
            int status = [targetInstance status];
            //判断是视频 还是网站 yes 为视频
            BOOL flag = NO;
            NSString * urlString1;
            NSString * urlString2;
            NSString * me1 = target.meta;
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:me1 options:0];
            NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            NSLog(@"decodedString = %@",decodedString);
            //如果什么都没返回
            if (decodedString.length == 0) {
                return;
            }
            
           
            NSRange range = [decodedString rangeOfString:@","];
            if (range.length>0) {
                urlString1 = [decodedString substringToIndex:range.location];
                urlString2 = [decodedString substringFromIndex:range.location+1];
                flag = YES; //确定是视频
                
            }else{
                urlString1 = decodedString;
                NSArray * array1 = [urlString1 componentsSeparatedByString:@"."];
                NSString * s = [array1 lastObject];
                if ([ s isEqualToString:@"mp4"]) {
                    flag = YES; //确定是视频
                }
            }
            
            
            if (flag) {//是视频
                [[NSNotificationCenter defaultCenter] postNotificationName:@"x" object:nil];
                if (status == easyar_TargetStatus_Tracked) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"sta"];
                    int runtimeID = [target runtimeID];
                    if (active_target!=0 && active_target!=runtimeID) {
                        
                        //暂停
                        [video onLost];
                        video = nil;
                        tracked_target = 0;
                        active_target = 0;
                    }
                    if (tracked_target == 0) {
                        if (video == nil &&[video_renderers count]>0) {
                            video = [[ARVideo alloc] init];
                            [video openStreamingVideo:urlString1 texid:[[video_renderers objectAtIndex:2] texid]];
                            current_video_renderer = [video_renderers objectAtIndex:2];
                            if (urlString2) {
                                video.urlstring = urlString2;
                            }
                            
                        }
                        if (video != nil) {
                            [video onFound];
                            tracked_target = runtimeID;
                            active_target = runtimeID;
                        }
                    }
                    
                    imagetarget = [target isKindOfClass:[easyar_ImageTarget class]]?(easyar_ImageTarget *)target:nil;
                    
                    if (imagetarget!=nil) {
                        if (current_video_renderer!=nil) {
                            [video update];
                            if ([video isRenderTextureAvailable]) {//播放视频并设置视频位置
                                [current_video_renderer render:[camera projectionGL:0.2f farPlane:500.f] cameraview:[targetInstance poseGL] size:[imagetarget size]flag:YES];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"scanSuccess" object:decodedString];
                                //                        [current_video_renderer init_];
                            }
                        }
                    }
                }
            }else{//网页的
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"x" object:urlString1];
                return;
            }
            
            
            
            
        }else{//未识别到图片
            if (video) {//已播放视频但 摄像头离开图片
                [video update];
                [current_video_renderer render:[camera projectionGL:0.2f farPlane:500.f] cameraview:[targetInstance poseGL] size:[imagetarget size] flag:NO];
                
            }else{
                if (tracked_target != 0) {//视频暂停
                    [video onLost];
                    tracked_target = 0;
                }
                
            }
            
        }
        
    }else{//只识别二维码
        //识别二维码
        if ([frame index] != previous_qrcode_index) {
            previous_qrcode_index = [frame index];
            NSString * text = [frame text];
            if (text != nil && ![text isEqualToString:@""]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saomiao" object:@"y"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"er" object:text];
            }
        }
    }
}
    
   


   




