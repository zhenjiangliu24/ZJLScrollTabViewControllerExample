//
//  ZJLScrollTabViewController.m
//  ZJLScrollTabViewControllerExample
//
//  Created by ZhongZhongzhong on 16/6/26.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLScrollTabViewController.h"
#import "UILabel+ZJLScale.h"
#import "MyTableViewController.h"

#define ZJLScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZJLScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat TopBarHeight = 40.0;
static const CGFloat TopLabelWidth = 100.0;
static const CGFloat TopLabelHeight = 40.0;

@interface ZJLScrollTabViewController()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *topTabScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *highlightBar;
@property (nonatomic, assign) NSInteger currentTab;
@end

@implementation ZJLScrollTabViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"ZJLScrollTabView";
    self.view.backgroundColor = [UIColor whiteColor];
    _currentTab = 0;
    [self initSubScrollViews];
    [self initTopBarLabels];
    [self addContentViewControllers];
    [self scrollViewDidEndScrollingAnimation:_contentScrollView];
    [self scrollViewDidScroll:_contentScrollView];
}

- (void)initSubScrollViews
{
    _topTabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ZJLScreenWidth, TopBarHeight)];
    _topTabScrollView.backgroundColor = [UIColor lightGrayColor];
    _topTabScrollView.showsHorizontalScrollIndicator = NO;
    _topTabScrollView.contentSize = CGSizeMake(TopLabelWidth*_numberOfTabs, TopLabelHeight);
    [self.view addSubview:_topTabScrollView];
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopBarHeight, ZJLScreenWidth, ZJLScreenHeight-TopBarHeight)];
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(ZJLScreenWidth*_numberOfTabs, ZJLScreenHeight-TopBarHeight);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
}

- (void)initTopBarLabels
{
    for (NSInteger i = 0; i<_numberOfTabs; i++) {
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.frame = CGRectMake(i*TopLabelWidth, 0, TopLabelWidth, TopBarHeight);
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = [NSString stringWithFormat:@"Tab %ld",(long)i];
        topLabel.font = [UIFont systemFontOfSize:14.0];
        topLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topLabelClicked:)];
        [topLabel addGestureRecognizer:tap];
        [_topTabScrollView addSubview:topLabel];
    }
    _highlightBar = [[UIView alloc] initWithFrame:CGRectMake(0, TopBarHeight-2, TopLabelWidth/2, 2)];
    CGFloat centerX = self.topTabScrollView.subviews[0].center.x;
    _highlightBar.center = CGPointMake(centerX, TopBarHeight-2);
    _highlightBar.backgroundColor = [UIColor redColor];
    [_topTabScrollView addSubview:_highlightBar];
    
}

- (void)addContentViewControllers
{
    for (int i = 0; i<_numberOfTabs; i++) {
        MyTableViewController *testVC = [[MyTableViewController alloc] init];
        testVC.title = [NSString stringWithFormat:@"Tab %d",i];
        [self addChildViewController:testVC];
    }
}

#pragma mark - label clicked
- (void)topLabelClicked:(UITapGestureRecognizer *)tap
{
    NSInteger index = [tap.view.superview.subviews indexOfObject:tap.view];
    _currentTab = index;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index*ZJLScreenWidth;
    [_contentScrollView setContentOffset:offset animated:YES];
    [self scrollViewDidEndScrollingAnimation:_contentScrollView];
}


#pragma mark - content scroll view scroll action delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    _currentTab = index;
    UIViewController *testVC = self.childViewControllers[index];
    
    CGPoint offsetPoint = _topTabScrollView.contentOffset;
    UILabel *selectedLabel = _topTabScrollView.subviews[index];
    offsetPoint.x = selectedLabel.center.x -scrollView.frame.size.width*0.5;;
    if (offsetPoint.x<0) {
        offsetPoint.x = 0;
    }
    CGFloat maxX = _topTabScrollView.contentSize.width-scrollView.frame.size.width;
    if (offsetPoint.x>maxX) {
        offsetPoint.x = maxX;
    }
    [_topTabScrollView setContentOffset:offsetPoint animated:YES];
    if ([testVC isViewLoaded]) {
        return;
    }
    
    testVC.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [_contentScrollView addSubview:testVC.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat num = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"content offset %f width is %f",scrollView.contentOffset.x,scrollView.frame.size.width);
    NSInteger index = num;
    CGFloat centerX = TopLabelWidth/2+index*TopLabelWidth;
    CGPoint center = CGPointMake(centerX, _highlightBar.center.y);
    [UIView animateWithDuration:0.2 animations:^{
        _highlightBar.center = center;
    }];
    
    if (index == _numberOfTabs-1) {
        UILabel *label = _topTabScrollView.subviews[index];
        label.ZJLScale = 1 - (num - index);
        return;
    }
    UILabel *currentLabel = _topTabScrollView.subviews[index];
    UILabel *nextLabel = _topTabScrollView.subviews[index+1];
    currentLabel.ZJLScale = 1 - (num - index);
    nextLabel.ZJLScale = num - index;
    
    
}

@end
