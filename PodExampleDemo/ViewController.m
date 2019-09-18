//
//  ViewController.m
//  PodExampleDemo
//
//  Created by Jamesholy on 2018/12/29.
//  Copyright © 2018 Jamesholy. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

#import "RadiusViewController.h"
#import "BorderViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn1  = [UIButton new];
    btn1.backgroundColor = [UIColor lightGrayColor];
    [btn1 setTitle:@"切圆角" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UIButton *btn2  = [UIButton new];
    [self.view addSubview:btn2];

    btn2.backgroundColor = [UIColor lightGrayColor];
    [btn2 setTitle:@"切圆角+阴影+边框" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(40);
        make.left.equalTo(btn1);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
        
}


- (void)btn1 {
    [self.navigationController pushViewController:[RadiusViewController new] animated:YES];
}


- (void)btn2 {
    [self.navigationController pushViewController:[BorderViewController new] animated:YES];
}


@end
