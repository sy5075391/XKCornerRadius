/*******************************************************************************
 # File        : BorderViewController.m
 # Project     : PodExampleDemo
 # Author      : Jamesholy
 # Created     : 2019/9/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BorderViewController.h"
#import "UIView+XKCornerBorder.h"
#import <Masonry.h>

@interface BorderViewController ()


@property(nonatomic, strong) UIView *frameView;

@property(nonatomic, strong) UIView *masonryView;

@end

@implementation BorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 切原角
    self.view.backgroundColor = [UIColor whiteColor];
    _frameView = [[UIView alloc] init];
    _frameView.frame = CGRectMake(20, 100, 200, 100);
    
    _frameView.xk_openBorder = YES; // 开启功能
    _frameView.xk_borderFillColor = [UIColor redColor]; // 视图背景颜色这样设置
    _frameView.xk_borderType = XKBorderTypeTopLeft; // 指定下方圆角
    _frameView.xk_borderRadius = 20; // 圆角大小
    _frameView.xk_borderColor = [UIColor orangeColor]; // 边框颜色
    _frameView.xk_borderWidth = 5; // 边框宽度
    // 阴影还是系统的方法
    _frameView.layer.shadowColor = [UIColor blackColor].CGColor;
    _frameView.layer.shadowOffset = CGSizeMake(2, 2);
    _frameView.layer.shadowRadius = 10;
    _frameView.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:_frameView];
    
    _masonryView = [[UIView alloc] init];
    _masonryView.xk_openBorder = YES; // 开启功能
    _masonryView.xk_borderFillColor = [UIColor redColor]; // 视图背景颜色这样设置
    _masonryView.xk_borderType = XKBorderTypeTopLeft; // 指定下方圆角
    _masonryView.xk_borderRadius = 20; // 圆角大小
    _masonryView.xk_borderColor = [UIColor orangeColor]; // 边框颜色
    _masonryView.xk_borderWidth = 5; // 边框宽度
    // 阴影还是系统的方法
    _masonryView.layer.shadowColor = [UIColor blackColor].CGColor;
    _masonryView.layer.shadowOffset = CGSizeMake(2, 2);
    _masonryView.layer.shadowRadius = 10;
    _masonryView.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:_masonryView];
    
    [_masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frameView.mas_bottom).offset(40);
        make.left.equalTo(self.frameView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    
    UIButton *changeBtn  = [UIButton new];
    changeBtn.backgroundColor = [UIColor lightGrayColor];
    [changeBtn setTitle:@"改变" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masonryView.mas_bottom).offset(40);
        make.left.equalTo(self.masonryView);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
}


- (void)changeBtn {
    static int testIndex = 0;
    NSArray *arr = @[@(XKBorderTypeTopLeft),@(XKBorderTypeBottomLeft),@(XKBorderTypeBottomRight),@(XKBorderTypeNone)];
    _frameView.xk_borderType = [arr[testIndex] integerValue];
    _frameView.xk_borderRadius = arc4random()%40 + 20;
    [_frameView xk_forceReLayout];
    
    _masonryView.xk_borderType = [arr[testIndex] integerValue];
    _frameView.xk_borderRadius = arc4random()%40 + 20;
    [_masonryView xk_forceReLayout];
    testIndex ++;
    if (testIndex == arr.count) {
        testIndex = 0;
    }
}

@end
