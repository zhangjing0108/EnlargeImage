//
//  ViewController.m
//  123
//
//  Created by mac on 2017/4/20.
//  Copyright © 2017年 LST. All rights reserved.
//

#import "ViewController.h"
#import "LSTPhotoDisplayView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 100);
        button.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
}

- (void)buttonClick:(UIButton *) sender {
    [LSTPhotoDisplayView displayPhotoesWithImageArray:@[@"test_1", @"test_2", @"test_3", @"test_4"] isImageUrl:NO currentIndex:0];
}

@end
