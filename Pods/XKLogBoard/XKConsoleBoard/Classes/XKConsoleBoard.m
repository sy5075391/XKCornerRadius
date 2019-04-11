/*******************************************************************************
 # File        : XKConsoleBoard.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/12/19
 # Corporation : 
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKConsoleBoard.h"
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Border.h"
#import <YYText/YYText.h>

#define IMG_NAME(imgName) [UIImage imageNamed:imgName]
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define XKNormalFont(fontSize)      [UIFont systemFontOfSize:fontSize]
// RGB颜色
#define RGB(r,g,b) RGBA(r,g,b,1)
// RGB颜色 灰色
#define RGBGRAY(A) RGB(A,A,A)
// 16进制颜色
#define HEX_RGB(rgbValue) HEX_RGBA(rgbValue, 1.0)
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 16进制颜色+透明度
#define HEX_RGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0f \
blue:((float)(rgbValue & 0x0000FF))/255.0f \
alpha:alphaValue]

//获取屏幕 宽度、高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define XKConsoleBoardOriginWidth SCREEN_WIDTH / MaxConsoleWidthSCale
#define XKConsoleBoardOriginHeight SCREEN_HEIGHT / MaxConsoleHeightSCale

#define MaxConsoleWidthSCale  1.5
#define MaxConsoleHeightSCale 3.0

#define MinConsoleWidth 220
#define MinConsoleHeight 140

@interface XKConsoleBoard()
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *toolView;
@property(nonatomic, strong) UIView *searchToolView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UITextField *searchTextField;
@property(nonatomic, strong) UIButton *closeBtn;

@property(nonatomic, copy) NSArray<NSTextCheckingResult *> * searchsResult;
@property(nonatomic, assign) NSInteger currentSearchIndex;

@end

@implementation XKConsoleBoard

+ (instancetype)borad {
    static XKConsoleBoard* _board;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _board = [[XKConsoleBoard alloc] init];
    });
    return _board;
}

- (instancetype)init {
    if (self = [super init]) {
#if DEBUG
        [self createBoard];
        [self addNoti];
#endif
    }
    return self;
}


- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLog:) name:@"xk_log_noti" object:nil];
}

- (void)addLog:(NSNotification *)noti {

    NSString *text  = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.contentView.superview == nil) {
            return;
        }
        NSMutableAttributedString *totalText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [totalText appendAttributedString:[[NSAttributedString alloc] initWithString:text]];

        totalText.yy_font = self.textView.font;
        totalText.yy_color = self.textView.textColor;
        self.textView.attributedText = totalText;
        [self.textView scrollRangeToVisible:NSMakeRange(totalText.length - 2, 1)];
    });
}

- (void)createBoard {
    _contentView =  [[UIView alloc] init];
    _contentView.frame = CGRectMake( 0, SCREEN_HEIGHT/2,XKConsoleBoardOriginWidth,XKConsoleBoardOriginHeight);
    _contentView.clipsToBounds = NO;
    _toolView =  [[UIView alloc] init];
    _toolView.backgroundColor = RGBA(230, 230, 230, 0.9);
    
    [KEY_WINDOW addSubview:_toolView];
    [_contentView addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@25);
    }];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:IMG_NAME(@"xkconsoleRes.bundle/xk_icon_welfaregoods_detail_close") forState:UIControlStateNormal];
    [_contentView addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.right.equalTo(self.toolView.mas_right).offset(-8);
        make.height.equalTo(self.toolView);
        make.width.equalTo(self.toolView.mas_height);
    }];
    
    UIButton *clean = [[UIButton alloc] init];
    clean.tintColor = RGBGRAY(51);
    [clean setImage:[IMG_NAME(@"xkconsoleRes.bundle/xk_btn_coinDeail_timeDelete") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_contentView addSubview:clean];
    [clean addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    [clean mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.right.equalTo(self.closeBtn.mas_left).offset(-10);
        make.height.equalTo(self.toolView);
        make.width.equalTo(self.toolView.mas_height);
    }];
    
    
    UIButton *down = [[UIButton alloc] init];
    [down setTitle:@"a" forState:UIControlStateNormal];
    [down setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    [_contentView addSubview:down];
    [down addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.right.equalTo(clean.mas_left).offset(-15);
        make.height.equalTo(self.toolView);
        make.width.equalTo(self.toolView.mas_height);
    }];
    UIButton *up = [[UIButton alloc] init];
    [up setTitle:@"A" forState:UIControlStateNormal];
    [up setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    [_contentView addSubview:up];
    [up addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    [up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.right.equalTo(down.mas_left).offset(-10);
        make.height.equalTo(self.toolView);
        make.width.equalTo(self.toolView.mas_height);
    }];
    
    UIButton *search = [[UIButton alloc] init];
   // [search setTitle:@"search" forState:UIControlStateNormal];
    search.tintColor = RGBGRAY(51);
    [search setImage:[IMG_NAME(@"xkconsoleRes.bundle/搜索icon") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [search setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    [_contentView addSubview:search];
    [search addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.left.equalTo(self.toolView.mas_left).offset(10);
        make.height.equalTo(self.toolView);
        make.width.equalTo(@30);
    }];
    
    _searchToolView = [[UIView alloc] init];
    [self.contentView addSubview:_searchToolView];
    _searchToolView.clipsToBounds = YES;
    _searchToolView.backgroundColor = _toolView.backgroundColor;
    [_searchToolView showBorderSite:rzBorderSitePlaceTop];
    [_searchToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.toolView.mas_bottom);
        make.height.equalTo(@0);
    }];
    
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.textColor = RGBGRAY(51);
    _searchTextField.font = XKNormalFont(14);
    _searchTextField.placeholder = @"search";
    _searchTextField.clipsToBounds = YES;
    _searchTextField.layer.cornerRadius = 3;
    _searchTextField.layer.borderWidth = 1;
    _searchTextField.layer.borderColor = RGBGRAY(51).CGColor;
    [self.searchToolView addSubview:_searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.left.equalTo(self.searchToolView.mas_left).offset(5);
        make.width.equalTo(self.searchToolView.mas_width).multipliedBy(0.5);
        make.centerY.equalTo(self.searchToolView);
    }];
    
    UIButton *pre = [[UIButton alloc] init];
    [pre setTitle:@"<" forState:UIControlStateNormal];
    [pre setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    pre.clipsToBounds = YES;
    pre.layer.cornerRadius = 3;
    pre.layer.borderWidth = 1;
    pre.layer.borderColor = RGBGRAY(51).CGColor;
    [_searchToolView addSubview:pre];
    [pre addTarget:self action:@selector(pre) forControlEvents:UIControlEventTouchUpInside];
    [pre mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTextField.mas_right).offset(10);
        make.width.equalTo(self.searchToolView.mas_width).multipliedBy(1/9.0);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.searchToolView);
    }];
    UIButton *next = [[UIButton alloc] init];
    [next setTitle:@">" forState:UIControlStateNormal];
    next.clipsToBounds = YES;
    next.layer.cornerRadius = 3;
    next.layer.borderWidth = 1;
    next.layer.borderColor = RGBGRAY(51).CGColor;
    [next setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    [_searchToolView addSubview:next];
    [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pre.mas_right).offset(5);
        make.width.equalTo(pre.mas_width);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.searchToolView);
    }];
    
    UIButton *done = [[UIButton alloc] init];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    done.titleLabel.font = XKNormalFont(12);
    done.clipsToBounds = YES;
    done.layer.cornerRadius = 3;
    done.layer.borderWidth = 1;
    done.layer.borderColor = RGBGRAY(51).CGColor;
    [_searchToolView addSubview:done];
    [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(next.mas_right).offset(8);
        make.width.equalTo(self.searchToolView.mas_width).multipliedBy(1/7.0);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.searchToolView);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = RGBA(0, 0, 0, 0.8);
    _textView.font = XKNormalFont(10);
    _textView.textColor = [UIColor whiteColor];
    _textView.editable = NO;
    [_contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.searchToolView.mas_bottom);
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
    [self.contentView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *ping = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.contentView addGestureRecognizer:ping];
    

    UIView *arrowView = [[UIView alloc] init];
    [self.contentView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    UIPanGestureRecognizer *arrowPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragArrow:)];
    [arrowView addGestureRecognizer:arrowPan];
    [pan requireGestureRecognizerToFail:arrowPan];
    
    UILabel *arrowLabel = [[UILabel alloc] init];
    arrowLabel.text = @"↔";
    arrowLabel.font = [UIFont boldSystemFontOfSize:25];
    arrowLabel.userInteractionEnabled = YES;
    arrowLabel.textColor = RGBGRAY(220);
    arrowLabel.transform = CGAffineTransformMakeRotation(45/180.0 * M_PI);
    [arrowView addSubview:arrowLabel];
    [arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(arrowView);
    }];
    
}

#pragma mark - 显示
- (void)show {
#if DEBUG
    [KEY_WINDOW addSubview:_contentView];
#endif
}

#pragma mark - 关闭
- (void)close {
    [_contentView removeFromSuperview];
    _textView.text = nil;
}

#pragma mark - 清空
- (void)clean {
    self.searchsResult = nil;
    self.currentSearchIndex = 0;
    _textView.text = nil;
}

#pragma mark - 字体变小
- (void)down {
    NSInteger pointSize = self.textView.font.pointSize;
    if (pointSize > 6) {
        pointSize --;
    } else {
        return;
    }
    self.textView.font = XKNormalFont(pointSize);
}

#pragma mark - 字体变大
- (void)up {
    NSInteger pointSize = self.textView.font.pointSize;
    if (pointSize < 17) {
        pointSize ++;
    } else {
        return;
    }
    self.textView.font = XKNormalFont(pointSize);
}

#pragma mark - 显示搜索界面
- (void)searchClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [_searchToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(btn.selected ? @30 : @0);
    }];
    if (!btn.selected) {
        [self cleanSearchResult];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView layoutIfNeeded];
    }];
}

#pragma mark - 搜索
- (void)done {
    [self searchWord:self.searchTextField.text];
    [self jumpSepicalSearchPlace];
}

#pragma mark - 定位上一个搜索结果
- (void)pre {
    [self preSearchResult];
}

#pragma mark - 定位下一个搜索结果
- (void)next {
    [self nextSearchResult];
}

// 搜索事件
- (void)searchWord:(NSString *)searchText {
    [KEY_WINDOW endEditing:YES];
    NSString *oringinText = self.textView.text;
    NSString *match = searchText;
   
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:oringinText];

    if (searchText.length == 0) {
        self.searchsResult = nil;
        self.currentSearchIndex = 0;
        attStr.yy_font = self.textView.font;
        attStr.yy_color = self.textView.textColor;
        self.textView.attributedText = attStr;
    } else {
        NSArray *specialArr = @[@"$",@"(",@")",@"*",@"[",@"]",@"?",@"^",@"{",@"}",@"|",@"\\"];
        //处理表情
        for (NSString *sepical in specialArr) {
            match = [match stringByReplacingOccurrencesOfString:sepical withString:[NSString stringWithFormat:@"\\%@",sepical]];
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:match options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matches = [regex matchesInString:oringinText options:NSMatchingWithTransparentBounds range:NSMakeRange(0,oringinText.length)];
        self.searchsResult = matches;
        self.currentSearchIndex = 0;
        [self jumpSepicalSearchPlace];
    }
}

// 下一个
- (void)nextSearchResult {
    NSInteger count = self.searchsResult.count;
    if (self.currentSearchIndex + 1 < count) {
        self.currentSearchIndex += 1;
    }
    [self jumpSepicalSearchPlace];
}

// 上一个
- (void)preSearchResult {
    [KEY_WINDOW endEditing:YES];
    if (self.currentSearchIndex - 1 >= 0) {
        self.currentSearchIndex -= 1;
    }
    [self jumpSepicalSearchPlace];
}

#pragma mark - 定位到指定搜索结果位置
- (void)jumpSepicalSearchPlace {
    if ( self.searchsResult.count!= 0 && self.currentSearchIndex < self.searchsResult.count && self.currentSearchIndex >= 0) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
        attStr.yy_font = self.textView.font;
        attStr.yy_color = self.textView.textColor;
        NSInteger index = 0;
        for (NSTextCheckingResult *result in self.searchsResult) {
            if (index == self.currentSearchIndex) {
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
                [attStr addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor]  range:result.range];
            } else {
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
                [attStr addAttribute:NSBackgroundColorAttributeName value:RGBGRAY(151)  range:result.range];
            }
            index ++;
        }
        self.textView.attributedText = attStr;
        [self.textView scrollRangeToVisible:self.searchsResult[self.currentSearchIndex].range];
    }
}

#pragma mark - 清空搜索结果
- (void)cleanSearchResult {
    self.searchTextField.text = nil;
    [self searchWord:nil];
}


#pragma mark - 拖动位置
-(void)dragMe:(UIPanGestureRecognizer *)rec {
  
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if (rec.state == UIGestureRecognizerStateChanged){
        CGPoint point = [rec translationInView:self.contentView];
        //该方法返回在横坐标上、纵坐标上拖动了多少像素
        rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
        //rec.view 指的是把rec添加到那个控件上的
        // 因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        [rec setTranslation:CGPointMake(0, 0) inView:self.contentView];
        
    }else if (rec.state == UIGestureRecognizerStateEnded || rec.state ==UIGestureRecognizerStateCancelled || rec.state == UIGestureRecognizerStateFailed){
    }
}

#pragma mark - 拖动箭头 自由改变宽高
-(void)dragArrow:(UIPanGestureRecognizer *)rec {
    UIView *view = rec.view;
    if (rec.state == UIGestureRecognizerStateBegan) {
    }else if (rec.state == UIGestureRecognizerStateChanged){
        CGPoint point = [rec translationInView:view];
        //该方法返回在横坐标上、纵坐标上拖动了多少像素
   
        CGFloat width =  MIN(MAX(self.contentView.frame.size.width + point.x, MinConsoleWidth), XKConsoleBoardOriginWidth * MaxConsoleWidthSCale);
        CGFloat height = MIN(MAX(self.contentView.frame.size.height + point.y, MinConsoleHeight), XKConsoleBoardOriginHeight * MaxConsoleHeightSCale);
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, width, height);
        //rec.view 指的是把rec添加到那个控件上的
        // 因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        [rec setTranslation:CGPointMake(0, 0) inView:view];
        
    }else if (rec.state == UIGestureRecognizerStateEnded || rec.state ==UIGestureRecognizerStateCancelled || rec.state == UIGestureRecognizerStateFailed){
    }
}

#pragma mark - 处理缩放手势
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    
    CGFloat scale = pinchGestureRecognizer.scale;

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint center = view.center;
        view.frame = CGRectMake(0, 0, MIN(MAX(view.frame.size.width * scale, MinConsoleWidth), XKConsoleBoardOriginWidth * MaxConsoleWidthSCale)  , MIN(MAX(view.frame.size.height * scale, MinConsoleHeight), XKConsoleBoardOriginHeight * MaxConsoleHeightSCale));
        view.center = center;
        pinchGestureRecognizer.scale = 1;
    }
}



@end
