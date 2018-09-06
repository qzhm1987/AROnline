//
//  MLBasePageViewController.m
//  MLPageVC
//
//  Created by 玛丽 on 2017/12/11.
//  Copyright © 2017年 玛丽. All rights reserved.
//

#import "MLBasePageViewController.h"
#import "HMSegmentedControl.h"
#import "QTextField.h"
#import "SearchViewController.h"
#import <PYSearch.h>






#define kScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

@interface MLBasePageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,UITextFieldDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmented;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation MLBasePageViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex  = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.segmented.sectionTitles = self.sectionTitles;
    [self.pageVC setViewControllers:@[self.VCArray.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:self.segmented];
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
}





#pragma mark - UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.VCArray indexOfObject:viewController];
    if(index == 0 || index == NSNotFound) {
        return nil;
    }
    return (UIViewController *)[self.VCArray objectAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.VCArray indexOfObject:viewController];
    if(index == NSNotFound || index == self.VCArray.count - 1) {
        return nil;
    }
    return (UIViewController *)[self.VCArray objectAtIndex:index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *viewController = self.pageVC.viewControllers[0];
    NSUInteger index = [self.VCArray indexOfObject:viewController];
    self.currentSelectIndex = index;
    [self.segmented setSelectedSegmentIndex:index animated:YES];
}

- (void)segmentedControlChangedValue:(UISegmentedControl *)segment {
    long index = segment.selectedSegmentIndex;
    [self navigationDidSelectedControllerIndex:index];
}

- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    _selectIndex = index;
    DLog(@"index = %ld",_selectIndex);
    if (index == 0) {
        [self.pageVC setViewControllers:@[[self.VCArray objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    else {
        [self.pageVC setViewControllers:@[[self.VCArray objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (UIPageViewController *)pageVC {
    
    
    [self addTop];
    
    if (!_pageVC) {
         //CGFloat nav_H =[AppDel isIphoneX]?84:64;
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                options:options];
        _pageVC.view.frame = CGRectMake(0, 165, kScreenWidth, kScreenHeight-165);
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
    }
    return _pageVC;
}

-(void)addTop{
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"backSmall")];
    topImgView.userInteractionEnabled = YES;
    topImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 111);
    [self.view addSubview:topImgView];
    
    QTextField *searchTF = [[QTextField alloc]init];
    searchTF.layer.cornerRadius = 19.0f;
    searchTF.delegate = self;
    searchTF.placeholder = @"请输入您要搜索的内容";
    searchTF.backgroundColor = [UIColor lightTextColor];
    [topImgView addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImgView);
        make.top.equalTo(topImgView).offset(44);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 38));
    }];
    UIImageView *searchImgView = [[UIImageView alloc]initWithImage:IMAGE_NAME(@"search")];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap:)];
    searchImgView.userInteractionEnabled = YES;
    [searchImgView addGestureRecognizer:searchTap];
    [topImgView addSubview:searchImgView];
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchTF).offset(-15);
        make.centerY.equalTo(searchTF);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}
-(void)searchTap:(UITapGestureRecognizer *)gesture{
    DLog(@"searchTap");
}
- (HMSegmentedControl *)segmented {
    if (!_segmented) {
        _segmented = [[HMSegmentedControl alloc] init];
        _segmented.frame = CGRectMake(0, 111, kScreenWidth, 44);
        _segmented.selectionIndicatorHeight = 4.0f;
        _segmented.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmented.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmented.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:THEME_COLOR};
        _currentSelectIndex = 0;
        _segmented.selectedSegmentIndex = _currentSelectIndex;
        [_segmented addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmented;
}

#pragma mark Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    SearchViewController *search = [SearchViewController new];
    [self.navigationController pushViewController:search animated:YES];
//     NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
//    PYSearchViewController *pySearch = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"作品搜索"];
//    
//    [self.navigationController pushViewController:pySearch animated:YES];
//    
    
    return NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
