//
//  MainViewController.m
//  MXWeChatActionSheet
//
//  Created by 韦纯航 on 16/7/29.
//  Copyright © 2016年 韦纯航. All rights reserved.
//

#import "MainViewController.h"

#import "MXWeChatActionSheet.h"

@interface MainViewController ()

@property (copy, nonatomic) NSArray <NSString *> *items;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"MXWeChatActionSheet";
    self.tableView.rowHeight = 60.0;
    self.tableView.tableFooterView = [UIView new];
    self.items = @[@"使用方法一", @"使用方法二", @"使用方法三", @"使用方法四"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [MXWeChatActionSheet showWithOtherButtonTitles:@[@"拍照", @"从手机相册选择", @"保存图片"] tapBlock:^(MXWeChatActionSheet *actionSheet, NSString *buttonTitle, NSInteger buttonIndex) {
            NSLog(@"buttonTitle = %@, buttonIndex = %ld", buttonTitle, (long)buttonIndex);
        }];
    }
    else if (indexPath.row == 1) {
        [MXWeChatActionSheet showWithCancelButtonTitle:@"关闭" otherButtonTitles:@[@"拍照", @"从手机相册选择", @"保存图片"] tapBlock:^(MXWeChatActionSheet *actionSheet, NSString *buttonTitle, NSInteger buttonIndex) {
            NSLog(@"buttonTitle = %@, buttonIndex = %ld", buttonTitle, (long)buttonIndex);
        }];
    }
    else if (indexPath.row == 2) {
        [MXWeChatActionSheet showWithTitle:@"更换头像" cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照", @"从手机相册选择", @"保存图片"] tapBlock:^(MXWeChatActionSheet *actionSheet, NSString *buttonTitle, NSInteger buttonIndex) {
            NSLog(@"buttonTitle = %@, buttonIndex = %ld", buttonTitle, (long)buttonIndex);
        }];
    }
    else {
        [MXWeChatActionSheet showWithTitle:@"请选择以下其中一项操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@[@"拍照", @"从手机相册选择", @"保存图片"] tapBlock:^(MXWeChatActionSheet *actionSheet, NSString *buttonTitle, NSInteger buttonIndex) {
            NSLog(@"buttonTitle = %@, buttonIndex = %ld", buttonTitle, (long)buttonIndex);
            
            if (buttonIndex == actionSheet.cancelButtonIndex) {
                NSLog(@"点击了取消按钮");
            }
            else if (buttonIndex == actionSheet.destructiveButtonIndex) {
                NSLog(@"点击了警示按钮");
            }
            else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                NSLog(@"点击了第一个其他按钮");
            }
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
