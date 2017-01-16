//
//  MXWeChatActionSheet.m
//  MXWeChatActionSheet
//
//  Created by 韦纯航 on 16/7/29.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MXWeChatActionSheet.h"

#define MXWAS_BUTTON_HEIGHT            50.0
#define MXWAS_TITLE_VIEW_HEIGHT        60.0
#define MXWAS_TITLE_FONT_SIZE          13.0
#define MXWAS_CANCEL_BUTTON_PADDING    5.0
#define MXWAS_CONTENT_MAX_SCALE        0.618
#define MXWAS_ANIMATION_DURATION       0.25

#define MXWAS_SEPARATOR_COLOR                [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1.0]
#define MXWAS_TITLE_COLOR                    [UIColor lightGrayColor]
#define MXWAS_BUTTON_TITLE_DEFAULT_COLOR     [UIColor blackColor]
#define MXWAS_BUTTON_TITLE_DESTRUCTIVE_COLOR [UIColor redColor]

#pragma mark - MXWeChatActionSheetImageFromColor

@interface UIImage (MXWeChatActionSheetImageFromColor)

+ (UIImage *)mxwas_imageFromColor:(UIColor *)color;

@end

@implementation UIImage (MXWeChatActionSheetImageFromColor)

/**
 *  将颜色转换成图片
 */
+ (UIImage *)mxwas_imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


#pragma mark - MXWeChatActionSheetLayoutConstraint

@interface UIView (MXWeChatActionSheetLayoutConstraint)

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 cEqualTo:(CGFloat)constant;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view a:(NSLayoutAttribute)a2;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view c:(CGFloat)constant;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view a:(NSLayoutAttribute)a2 c:(CGFloat)constant;

@end

@implementation UIView (MXWeChatActionSheetLayoutConstraint)

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 cEqualTo:(CGFloat)constant
{
    return [self constraint:a1 equalTo:nil c:constant];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view
{
    return [self constraint:a1 equalTo:view c:0.0];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view a:(NSLayoutAttribute)a2
{
    return [self constraint:a1 equalTo:view a:a2 c:0.0];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view c:(CGFloat)constant
{
    NSLayoutAttribute a2 = view ? a1 : NSLayoutAttributeNotAnAttribute;
    return [self constraint:a1 equalTo:view a:a2 c:constant];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)a1 equalTo:(UIView *)view a:(NSLayoutAttribute)a2 c:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:a1 relatedBy:NSLayoutRelationEqual toItem:view attribute:a2 multiplier:1.0 constant:constant];
    [self.superview addConstraint:constraint];
    
    return constraint;
}

@end


#pragma mark - MXWeChatActionSheetButton

@interface MXWeChatActionSheetButton : UIButton

@end

@implementation MXWeChatActionSheetButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage mxwas_imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage mxwas_imageFromColor:[UIColor groupTableViewBackgroundColor]] forState:UIControlStateHighlighted];
    }
    return self;
}

@end


#pragma mark - MXWeChatActionSheetTitleView

@interface MXWeChatActionSheetTitleView : UIView

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *bottomLine;

@end

@implementation MXWeChatActionSheetTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:MXWAS_TITLE_FONT_SIZE];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = MXWAS_TITLE_COLOR;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.bottomLine = [UIImageView new];
        self.bottomLine.backgroundColor = MXWAS_SEPARATOR_COLOR;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.height = 1.0 / [UIScreen mainScreen].scale;
    rect.origin.y = CGRectGetHeight(self.bounds) - rect.size.height;
    [self.bottomLine setFrame:rect];
    
    rect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(10.0, 15.0, 10.0, 15.0));
    [self.titleLabel setFrame:rect];
}

@end


#pragma mark - MXWeChatActionSheetTableView

@interface MXWeChatActionSheetTableView : UITableView

@end

@implementation MXWeChatActionSheetTableView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end


#pragma mark - MXWeChatActionSheetCancelView

@interface MXWeChatActionSheetCancelView : UIView

@property (retain, nonatomic) MXWeChatActionSheetButton *cancelButton;

@end

@implementation MXWeChatActionSheetCancelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.cancelButton = [MXWeChatActionSheetButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitleColor:MXWAS_BUTTON_TITLE_DEFAULT_COLOR forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    [self.cancelButton setFrame:rect];
}

@end


#pragma mark - MXWeChatActionSheetActionsCell

@interface MXWeChatActionSheetActionsCell : UITableViewCell

@property (retain, nonatomic) MXWeChatActionSheetButton *actionSheetButton;
@property (retain, nonatomic) UIImageView *line;

@end

@implementation MXWeChatActionSheetActionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.actionSheetButton = [MXWeChatActionSheetButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.actionSheetButton];
        
        self.line = [UIImageView new];
        self.line.backgroundColor = MXWAS_SEPARATOR_COLOR;
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    [self.actionSheetButton setFrame:rect];
    
    rect.size.height = 1.0 / [UIScreen mainScreen].scale;
    rect.origin.y = CGRectGetHeight(self.contentView.bounds) - rect.size.height;
    [self.line setFrame:rect];
}

@end


#pragma mark - MXWeChatActionSheet

@interface MXWeChatActionSheet () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UIView *contentView;
@property (retain, nonatomic) MXWeChatActionSheetTitleView *titleView;
@property (retain, nonatomic) MXWeChatActionSheetTableView *actionsView;
@property (retain, nonatomic) MXWeChatActionSheetCancelView *cancelView;

@property (copy, nonatomic) MXWeChatActionSheetTapBlock tapBlock;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray <NSString *> *actions;
@property (nonatomic, getter=isAnimating) BOOL animating;

@end

@implementation MXWeChatActionSheet

extern UIWindow *MXWAS_KeyWindow()
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    if (window) return window;
    
    id delegate = app.delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = [delegate window];
    }
    return window;
}

#pragma mark - Setter & Getter

- (UIView *)contentView
{
    if (_contentView == nil) {
        CGRect rect = [self rectForContentView];
        rect.origin.y = CGRectGetHeight(self.bounds);
        _contentView = [[UIView alloc] initWithFrame:rect];
        _contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    return _contentView;
}

- (MXWeChatActionSheetTitleView *)titleView
{
    if (_titleView == nil) {
        _titleView = [MXWeChatActionSheetTitleView new];
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
        _titleView.titleLabel.text = _title;
    }
    return _titleView;
}

- (MXWeChatActionSheetTableView *)actionsView
{
    if (_actionsView == nil) {
        _actionsView = [[MXWeChatActionSheetTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _actionsView.translatesAutoresizingMaskIntoConstraints = NO;
        _actionsView.backgroundColor = [UIColor clearColor];
        _actionsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _actionsView.rowHeight = MXWAS_BUTTON_HEIGHT;
        _actionsView.bounces = NO;
        _actionsView.dataSource = self;
        _actionsView.delegate = self;
        _actionsView.delaysContentTouches = NO;
        
        for (id view in _actionsView.subviews) {
            if ([view respondsToSelector:@selector(delaysContentTouches)]) {
                [view setValue:@(NO) forKey:@"delaysContentTouches"];
                break;
            }
        }
    }
    return _actionsView;
}


- (MXWeChatActionSheetCancelView *)cancelView
{
    if (_cancelView == nil) {
        _cancelView = [MXWeChatActionSheetCancelView new];
        _cancelView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *title = _actions[_cancelButtonIndex];
        [_cancelView.cancelButton setTitle:title forState:UIControlStateNormal];
        [_cancelView.cancelButton setTag:_cancelButtonIndex];
        [_cancelView.cancelButton addTarget:self action:@selector(actionSheetButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelView;
}

- (NSInteger)contentViewAccurateHeight
{
    CGFloat height = self.actions.count * MXWAS_BUTTON_HEIGHT;
    if (self.title) height += MXWAS_TITLE_VIEW_HEIGHT; // title view
    height += MXWAS_CANCEL_BUTTON_PADDING; // padding for cancel button
    return height;
}

- (CGRect)rectForContentView
{
    CGFloat contentMaxHeight = CGRectGetHeight(self.bounds) * MXWAS_CONTENT_MAX_SCALE;
    CGFloat contentAccurateHeight = [self contentViewAccurateHeight];
    self.actionsView.scrollEnabled = (contentAccurateHeight > contentMaxHeight);
    
    CGRect rect = self.bounds;
    rect.size.height = MIN(contentMaxHeight, contentAccurateHeight);
    rect.origin.y = CGRectGetHeight(self.bounds) - rect.size.height;
    return rect;
}

#pragma mark - Public Method

/**
 *  显示一组普通按钮，会自动添加标题为“取消”的关闭按钮，无标题
 *
 *  @param otherButtonTitles 普通按钮标题
 *  @param tapBlock          点击回调
 *
 *  @return 实例
 */
+ (instancetype)showWithOtherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                 tapBlock:(MXWeChatActionSheetTapBlock)tapBlock
{
    return [self showWithCancelButtonTitle:nil otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

/**
 *  显示一组普通按钮和关闭按钮，关闭按钮标题自定义，无标题
 *
 *  @param cancelButtonTitle 关闭按钮标题
 *  @param otherButtonTitles 普通按钮标题
 *  @param tapBlock          点击回调
 *
 *  @return 实例
 */
+ (instancetype)showWithCancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                 tapBlock:(MXWeChatActionSheetTapBlock)tapBlock
{
    return [self showWithTitle:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

/**
 *  显示一组普通按钮和关闭按钮，关闭按钮标题自定义，带自定义标题
 *
 *  @param title             标题
 *  @param cancelButtonTitle 关闭按钮标题
 *  @param otherButtonTitles 普通按钮标题
 *  @param tapBlock          点击回调
 *
 *  @return 实例
 */
+ (instancetype)showWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                     tapBlock:(MXWeChatActionSheetTapBlock)tapBlock
{
    return [self showWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

/**
 *  显示一组普通按钮、关闭按钮和警示按钮，关闭按钮和警示按钮标题自定义，带自定义标题
 *
 *  @param title                  标题
 *  @param cancelButtonTitle      关闭按钮标题
 *  @param destructiveButtonTitle 警示按钮标题
 *  @param otherButtonTitles      普通按钮标题
 *  @param tapBlock               点击回调
 *
 *  @return 实例
 */
+ (instancetype)showWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                     tapBlock:(MXWeChatActionSheetTapBlock)tapBlock
{
    BOOL condition = (otherButtonTitles.count > 0 || destructiveButtonTitle != nil);
    NSAssert(condition, @"MXWeChatActionSheet must have a otherButtonTitle or a destructiveButtonTitle to display.");
    
    // 若没有设置关闭按钮标题，则自动设置关闭按钮标题为“取消”
    if (cancelButtonTitle == nil) cancelButtonTitle = @"取消";
    
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

#pragma mark - Private Method

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                     tapBlock:(MXWeChatActionSheetTapBlock)tapBlock
{
    self = [super initWithFrame:MXWAS_KeyWindow().bounds];
    if (self) {
        _cancelButtonIndex = -1;
        _destructiveButtonIndex = -1;
        _firstOtherButtonIndex = -1;
        
        NSMutableArray <NSString *> *actions = [NSMutableArray array];
        if (destructiveButtonTitle) {
            [actions addObject:destructiveButtonTitle];
            _destructiveButtonIndex = [actions indexOfObject:destructiveButtonTitle];
        }
        
        if (otherButtonTitles) {
            [actions addObjectsFromArray:otherButtonTitles];
            _firstOtherButtonIndex = [actions indexOfObject:otherButtonTitles.firstObject];
        }
        
        if (cancelButtonTitle) {
            [actions addObject:cancelButtonTitle];
            _cancelButtonIndex = [actions indexOfObject:cancelButtonTitle];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.tapBlock = tapBlock;
        self.title = title;
        self.actions = [NSArray arrayWithArray:actions];
        
        [self setupSubviews];
        [self showWithAnimation];
    }
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.actionsView];
    [self.contentView addSubview:self.cancelView];
    
    if (self.title) {
        [self.contentView addSubview:self.titleView];
        [self.titleView constraint:NSLayoutAttributeLeft equalTo:self.contentView];
        [self.titleView constraint:NSLayoutAttributeRight equalTo:self.contentView];
        [self.titleView constraint:NSLayoutAttributeTop equalTo:self.contentView];
        [self.titleView constraint:NSLayoutAttributeHeight cEqualTo:MXWAS_TITLE_VIEW_HEIGHT];
        [self.actionsView constraint:NSLayoutAttributeTop equalTo:self.titleView a:NSLayoutAttributeBottom];
    }
    else {
        [self.actionsView constraint:NSLayoutAttributeTop equalTo:self.contentView];
    }

    [self.actionsView constraint:NSLayoutAttributeLeft equalTo:self.contentView];
    [self.actionsView constraint:NSLayoutAttributeRight equalTo:self.contentView];
    [self.actionsView constraint:NSLayoutAttributeBottom equalTo:self.cancelView a:NSLayoutAttributeTop c:-MXWAS_CANCEL_BUTTON_PADDING];
    
    [self.cancelView constraint:NSLayoutAttributeLeft equalTo:self.contentView];
    [self.cancelView constraint:NSLayoutAttributeRight equalTo:self.contentView];
    [self.cancelView constraint:NSLayoutAttributeBottom equalTo:self.contentView];
    [self.cancelView constraint:NSLayoutAttributeHeight cEqualTo:MXWAS_BUTTON_HEIGHT];
}

- (void)showWithAnimation
{
    [MXWAS_KeyWindow() addSubview:self];
    
    self.animating = YES;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [UIView animateWithDuration:MXWAS_ANIMATION_DURATION animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        
        CGRect rect = self.contentView.frame;
        rect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(rect);
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)dismissWithAnimation
{
    self.animating = YES;
    
    [UIView animateWithDuration:MXWAS_ANIMATION_DURATION animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        CGRect rect = self.contentView.frame;
        rect.origin.y = CGRectGetHeight(self.bounds);
        self.contentView.frame = rect;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark - Override Method

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**
     *  在show或dismiss过程中，有一个动画过程，
     *  为了防止在动画过程中contentView的frame被修改掉，
     *  故在动画过程中使用isAnimating属性来屏蔽掉[MXWeChatActionSheet layoutSubviews]方法对contentView的frame的修改。
     */
    if (self.isAnimating) return;
    
    CGRect rect = [self rectForContentView];
    [self.contentView setFrame:rect];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *touchView = [touches.anyObject view];
    if (touchView == self) { // 点击了背景的空白区域，就相当于点击了取消按钮
        MXWeChatActionSheetButton *cancelButton = self.cancelView.cancelButton;
        [self actionSheetButtonEvent:cancelButton];
    }
}

#pragma mark - Button Event

- (void)actionSheetButtonEvent:(MXWeChatActionSheetButton *)button
{
    if (self.tapBlock) {
        NSString *buttonTitle = button.currentTitle;
        NSInteger buttonIndex = button.tag;
        self.tapBlock(self, buttonTitle, buttonIndex);
    }
    
    [self dismissWithAnimation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actions.count - 1; // 去掉取消按钮标题
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const MXWASCellIdentifier = @"MXWeChatActionSheetActionsCell";
    MXWeChatActionSheetActionsCell *cell = [tableView dequeueReusableCellWithIdentifier:MXWASCellIdentifier];
    if (cell == nil) {
        cell = [[MXWeChatActionSheetActionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MXWASCellIdentifier];
        [cell.actionSheetButton addTarget:self action:@selector(actionSheetButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }

    NSString *tilte = self.actions[indexPath.row];
    UIColor *titleColor = (indexPath.row == self.destructiveButtonIndex) ? MXWAS_BUTTON_TITLE_DESTRUCTIVE_COLOR : MXWAS_BUTTON_TITLE_DEFAULT_COLOR;
    [cell.actionSheetButton setTitleColor:titleColor forState:UIControlStateNormal];
    [cell.actionSheetButton setTitle:tilte forState:UIControlStateNormal];
    [cell.actionSheetButton setTag:indexPath.row];
    
    // 隐藏最后一根分割线
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    cell.line.hidden = (indexPath.row == numberOfRows - 1);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
