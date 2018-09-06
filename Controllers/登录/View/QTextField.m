//
//  QTextField.m
//  ARVideo
//
//  Created by youdian on 2018/6/13.
//  Copyright © 2018年 YouDian. All rights reserved.
//

#import "QTextField.h"

@implementation QTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
    return inset;
}

@end
