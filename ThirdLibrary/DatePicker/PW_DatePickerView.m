//
//  PW_DatePickerView.m
//  ThreeDimensional
//
//  Created by 东方视界 on 16/12/26.
//  Copyright © 2016年 DFSJ. All rights reserved.
//
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#import "PW_DatePickerView.h"

static float ToolbarH = 44;

@interface PW_DatePickerView ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolBar;

// 保存PickView的Y值
@property (nonatomic, assign) CGFloat toolViewY;
@end

@implementation PW_DatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}


- (void)tapAction{
    [self remove];

}
- (instancetype)initDatePickerWithDefaultDate:(NSDate *)date
                            andDatePickerMode:(UIDatePickerMode )mode
{
    self = [super init];
    
    if (self)
    {
        [self addSubview:self.toolBar];
        [self addSubview:self.datePicker];
        self.datePicker.datePickerMode = mode;
        if (date) [self.datePicker setDate:date];
        
        [self setUpFrame];
    }
    return self;
}

- (void)setUpFrame
{
    // self 高度
    CGFloat ViewH = self.datePicker.frame.size.height + ToolbarH;
    // 默认self Y值
    self.toolViewY = kScreenHeight - ViewH;
    // 默认设置self的Y值在屏幕下方
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ViewH);
}

/**
 确定
 */
- (void)doneClick
{
    NSDate *select = self.datePicker.date;
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc]init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    NSString *resultString = [dateFormmater stringFromDate:select];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectDateString:)])
    {
        [self.delegate pickerView:self didSelectDateString:resultString];
    }
    
    [self remove];
}

/**
 显示PickerView
 */
- (void)show
{
    self.screenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.screenView.tag     = 1001;
    self.screenView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                 green:0/255.0
                                                  blue:0/255.0
                                                 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.screenView  addGestureRecognizer:tap];
    [self.screenView addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.screenView];
    
    [UIView animateWithDuration:0.35 animations:^
     {
         self.screenView.alpha = 1.0;
         self.frame = CGRectMake(0, self.toolViewY, kScreenWidth, self.datePicker.frame.size.height + ToolbarH);
         
     } completion:^(BOOL finished)
     {
         
     }];
}


/**
 移除PickerView
 */
- (void)remove
{
    [UIView animateWithDuration:0.35 animations:^
     {
         self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.datePicker.frame.size.height + ToolbarH);
         
     } completion:^(BOOL finished)
     {
         for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews])
         {
             if (view.tag == 1001)
             {
                 [view removeFromSuperview];
             }
         }
     }];
    
}
#pragma mark -- 懒加载

/**
 DatePicker
 */
- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker   = [[UIDatePicker alloc] init];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.backgroundColor = [UIColor whiteColor];
        // UIDatePicker默认高度216
        _datePicker.frame = CGRectMake(0, ToolbarH , kScreenWidth, _datePicker.frame.size.height);
        
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _datePicker.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _datePicker.maximumDate = minDate;
    }
    return _datePicker;
}

/**
 工具栏
 */
- (UIToolbar *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ToolbarH)];
        _toolBar.barStyle = UIBarStyleBlackTranslucent;
                // 设置UIToolbar背景色
          _toolBar.barTintColor = [UIColor colorWithRed:255.0/255.0
                                                        green:255.0/255.0
                                                         blue:255.0/255.0
                                                        alpha:1.0];
        // 取消按钮
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"   取消"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(remove)];
        
        [leftItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                forState:UIControlStateNormal];
        [leftItem setTintColor:[UIColor grayColor]];
        
        UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        // 确定按钮
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定   "
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(doneClick)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                 forState:UIControlStateNormal];
         [rightItem setTintColor:[UIColor grayColor]];
       
        _toolBar.items = @[leftItem,centerSpace,rightItem];
    }
    return _toolBar;
}



@end
