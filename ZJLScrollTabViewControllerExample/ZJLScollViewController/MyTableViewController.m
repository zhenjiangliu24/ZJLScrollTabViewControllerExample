//
//  MyTableViewController.m
//  ZJLScrollTabViewControllerExample
//
//  Created by ZhongZhongzhong on 16/6/26.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MyTableViewController.h"

@implementation MyTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
