//
//  LSTPhotoDisplayView.m
//  哈林教育
//
//  Created by qqqq on 16/4/21.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "LSTPhotoDisplayView.h"
//屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface LSTPhotoDisplayView ()<UIScrollViewDelegate>
/**
 1. 滚动视图
 */
@property (nonatomic) UIScrollView *scrollView;

/**
 2. 获取当前视图
 */
@property (nonatomic) UIView * currentView;

@end

@implementation LSTPhotoDisplayView
static LSTPhotoDisplayView * photoDisplayView = nil;
+ (void) displayPhotoesWithImageArray:(NSArray *)imageArr isImageUrl:(BOOL)isImageUrl currentIndex:(NSInteger)index {
    if (!photoDisplayView) {
        photoDisplayView = [[LSTPhotoDisplayView alloc] init];
    }
    
    [photoDisplayView createMainViewUI];
    if (isImageUrl) {
        [photoDisplayView displayNetworkImageWithUrlArray:imageArr currentIndex:index];
    } else {
        [photoDisplayView displayPhotoesWithImageArray:imageArr currentIndex:index];
    }
    
}

#pragma mark - 创建主界面UI
- (void)createMainViewUI
{
    //1. 获取当前窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //2. 修改视图区域为全屏
    self.frame = window.rootViewController.view.bounds;
    //3. 当前视图添加到窗口
    [window addSubview:self];
    
    /**
     1. 滚动视图
     */
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    [_scrollView setDelegate:self];
    _scrollView.tag = 3000;
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTapAction)];
    [_scrollView addGestureRecognizer:tap];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
        return nil;
    }

    return _currentView;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
        return;
    }
    
    CGFloat scale = scrollView.zoomScale;
    UIImageView * imageView = (UIImageView *)_currentView;
    UIImage * image = imageView.image;
    CGFloat imageScale = image.size.width / image.size.height;
    CGFloat displayScale = scrollView.bounds.size.width / scrollView.bounds.size.height;
    if (displayScale > imageScale) {
        //图片偏高
        CGRect rect = scrollView.frame;
        rect.size.width = WIDTH;
        rect.size.height = HEIGHT;
        scrollView.frame = rect;
        scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT*scale);
        imageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT*scale);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        
    } else {
        //图片偏宽
        CGRect rect = scrollView.frame;
        rect.size.width = WIDTH;
        rect.size.height = HEIGHT;
        scrollView.frame = rect;
        scrollView.contentSize = CGSizeMake(WIDTH*scale, HEIGHT);
        imageView.frame = CGRectMake(0, 0, WIDTH*scale, HEIGHT);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 3000) {
#pragma mark - 放大滑动回来时，需要恢复原样则打开注释代码
//        UIScrollView * displayView = (UIScrollView *)_currentView.superview;
//        displayView.zoomScale = 1.0;
//        _currentView.frame = displayView.bounds;
        CGFloat xxx = scrollView.contentOffset.x;
        _currentView = [scrollView viewWithTag:(xxx/WIDTH)+1000];
        
    }
}

#pragma mark - 展示本地图片
- (void) displayPhotoesWithImageArray:(NSArray *)imageArr currentIndex:(NSInteger)index
{
    for (int i = 0; i < imageArr.count; i++) {
        
        // 1. 图片展示区域
        UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        displayView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:displayView];
        [displayView setDelegate:self];
        [displayView setMinimumZoomScale:1.0f];
        
        // 2. 图片展示区域
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:displayView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [imageView setTag:1000+i];
        // 3. 获取图片及宽高比例
        UIImage *image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        imageView.image = image;
        // 6. 添加到视图
        [displayView addSubview:imageView];
        
        CGFloat imageScale = image.size.width / image.size.height;
        CGFloat displayScale = displayView.bounds.size.width / displayView.bounds.size.height;
        if (displayScale > imageScale) {
            //图片偏高
            [displayView setMaximumZoomScale:WIDTH/(HEIGHT*imageScale)];
            
        } else {
            //图片偏宽
            [displayView setMaximumZoomScale:HEIGHT/WIDTH*imageScale];
        }

        
        if (!i) {
            _currentView = [displayView viewWithTag:1000];
        }
        imageView.userInteractionEnabled = YES;
    }
    
    _scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    //偏移量修改到指定位置
    [_scrollView setContentOffset:CGPointMake(WIDTH *index, 0)];
}


#pragma mark -  展示网络图片
- (void) displayNetworkImageWithUrlArray:(NSArray *)imageUrlArr currentIndex:(NSInteger)index
{
//    if (!imageUrlArr.count) {
//            
//        // 1. 图片展示区域
//        UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
//        displayView.backgroundColor = [UIColor blackColor];
//        [_scrollView addSubview:displayView];
//        [displayView setDelegate:self];
//        [displayView setMaximumZoomScale:5.0f];
//        [displayView setMinimumZoomScale:1.0f];
//        
//        // 2. 图片展示区域
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:displayView.bounds];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
//        [imageView setTag:1000];
//        // 3. 获取图片及宽高比例
//        UIImage *image = [UIImage imageNamed:@"test_1"];
//        imageView.image = image;
//        
//        // 6. 添加到视图
//        [displayView addSubview:imageView];
//        _currentView = [displayView viewWithTag:1000];
//    
//        _scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
//        //偏移量修改到指定位置
//        [_scrollView setContentOffset:CGPointMake(WIDTH *index, 0)];
//    }
//    for (int i = 0; i < imageUrlArr.count; i++) {
//        
//        // 1. 图片展示区域
//        UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
//        displayView.backgroundColor = [UIColor blackColor];
//        [_scrollView addSubview:displayView];
//        [displayView setDelegate:self];
//        [displayView setMaximumZoomScale:5.0f];
//        [displayView setMinimumZoomScale:1.0f];
//        
//        // 2. 图片展示区域
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:displayView.bounds];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
//        [imageView setTag:1000];
//
//        //网络请求图片
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"test_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//           //如果图片请求失败则直接返回
//            if (!image) {
//                image = [UIImage imageNamed:@"test_1"];
//            }
//            
//            imageView.image = image;
//            
//        }];
//        
//        // 6. 添加到视图
//        [displayView addSubview:imageView];
//        _currentView = [displayView viewWithTag:1000];
//        _scrollView.contentSize = CGSizeMake(WIDTH * imageUrlArr.count, HEIGHT);
//        //偏移量修改到指定位置
//        [_scrollView setContentOffset:CGPointMake(WIDTH *index, 0)];
//    }
}

#pragma mark - 点击页面退出
- (void) returnTapAction
{
    [self removeFromSuperview];
}

@end
