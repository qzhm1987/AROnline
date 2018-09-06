//
//  ArAndSaoBtn.m
//  手机黄页
//
//  Created by youdian on 2018/1/9.
//  Copyright © 2018年 wangguosong. All rights reserved.
//

#import "ArAndSaoBtn.h"

@implementation ArAndSaoBtn

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 40, contentRect.size.width, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(7.5, 0, contentRect.size.width-15, 35);
}
@end
