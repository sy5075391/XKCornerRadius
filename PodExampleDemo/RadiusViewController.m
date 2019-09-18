/*******************************************************************************
 # File        : RadiusViewController.m
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

#import "RadiusViewController.h"
#import "UIView+XKCornerRadius.h"
#import <Masonry.h>
@interface RadiusViewController ()


@property(nonatomic, strong) UILabel *frameView;

@property(nonatomic, strong) UILabel *masonryView;

@end

@implementation RadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 切原角
    self.view.backgroundColor = [UIColor whiteColor];
    _frameView = [[UILabel alloc] init];
    _frameView.backgroundColor = [UIColor redColor];
    _frameView.text = @"frame";
    _frameView.frame = CGRectMake(20, 100, 200, 100);
    
    _frameView.xk_openClip = YES;
    _frameView.xk_radius = 20;
    _frameView.xk_clipType = XKCornerClipTypeTopRight|XKCornerClipTypeBottomLeft;
    
    [self.view addSubview:_frameView];
    
    _masonryView = [[UILabel alloc] init];
    _masonryView.text = @"autoLayout";
    _masonryView.xk_openClip = YES;
    _masonryView.xk_radius = 20;
    _masonryView.backgroundColor = [UIColor orangeColor];
    _masonryView.xk_clipType = XKCornerClipTypeTopRight|XKCornerClipTypeTopLeft;
    
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
    NSArray *arr = @[@(XKCornerClipTypeTopLeft),@(XKCornerClipTypeTopLeft),@(XKCornerClipTypeBottomBoth),@(XKCornerClipTypeNone)];
    _frameView.xk_clipType = [arr[testIndex] integerValue];
    _frameView.xk_radius = arc4random()%40 + 20;
    [_frameView xk_forceClip];
    
    _masonryView.xk_clipType = [arr[testIndex] integerValue];
    _frameView.xk_radius = arc4random()%40 + 20;
    [_masonryView xk_forceClip];
    testIndex ++;
    if (testIndex == arr.count) {
        testIndex = 0;
    }
}

@end

