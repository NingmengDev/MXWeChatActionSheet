//
//  MXWeChatActionSheet.h
//  MXWeChatActionSheet
//
//  Created by 韦纯航 on 16/7/29.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXWeChatActionSheet : UIView

typedef void (^MXWeChatActionSheetTapBlock)(MXWeChatActionSheet *actionSheet, NSString *buttonTitle, NSInteger buttonIndex);

@property (readonly) NSInteger cancelButtonIndex;
@property (readonly) NSInteger destructiveButtonIndex;
@property (readonly) NSInteger firstOtherButtonIndex;

/**
 *  显示一组普通按钮，会自动添加标题为“取消”的关闭按钮，无标题
 *
 *  @param otherButtonTitles 普通按钮标题
 *  @param tapBlock          点击回调
 *
 *  @return 实例
 */
+ (instancetype)showWithOtherButtonTitles:(NSArray <NSString *> *)otherButtonTitles
                                 tapBlock:(MXWeChatActionSheetTapBlock)tapBlock;

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
                                 tapBlock:(MXWeChatActionSheetTapBlock)tapBlock;

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
                     tapBlock:(MXWeChatActionSheetTapBlock)tapBlock;

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
                     tapBlock:(MXWeChatActionSheetTapBlock)tapBlock;

@end
