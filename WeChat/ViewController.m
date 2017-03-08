//
//  ViewController.m
//  WeChat
//
//  Created by mac on 15/3/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"

#import "MessageCell.h"

@interface ViewController ()

@end


@implementation ViewController


- (void)dealloc
{
    
    [_msgData release];
    [_bottomView release];
    [_tableView release];
    [_inputView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.加载数据
    [self loadMessageData];
    //2.创建视图
    [self creatView];
    
    //监听键盘弹出事件(加在window上面的视图)
//    UIWindow
    //如果键盘弹出,会发送通知,通知名为UIKeyboardWillShowNotification(定义在UIWindow类中)
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(showkeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    

}

//当视图出现时,滚动到最后一条消息
- (void)viewDidAppear:(BOOL)animated{

    //滚动到最后一个单元格
    NSInteger count = _msgData.count;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];


}

#pragma -mark KeyBoardNSNotification
- (void)showkeyBoard:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    NSLog(@"%@",dic);
    
    
    //获取键盘高度
    CGRect rect = [[dic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat height = rect.size.height;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    
    _bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
    
    _tableView.transform = CGAffineTransformMakeTranslation(0, -height);
    
    [UIView commitAnimations];
    
    

}

#pragma -mark 加载数据
- (void)loadMessageData{
    
    //1.加载数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    //2.将数据交给model
    NSMutableArray *data = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        
        NSString *content = [dic objectForKey:@"content"];
        NSString *icon = [dic objectForKey:@"icon"];
        BOOL isSelf = [[dic objectForKey:@"self"] boolValue];
        
        Message *msg = [[Message alloc] init];
        msg.content = content;
        msg.icon = icon;
        msg.isSelf = isSelf;
        
        
        //将model对象存入数组中
        [data addObject:msg];
        
        [msg release];
        
        
    }
    
    self.msgData = data;


}

- (void)creatView{
    
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bottom_bar.png"]];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取消分割线
    
    
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
    
//    将return按钮改为发送
//    _inputView.returnKeyType = UIReturnKeySend
    
    _inputView.delegate = self;
    
    
}

#pragma -mark tableViewDelegate
//实现此协议,单元格左滑会出现删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //1.删除数组中对应的数据
    [_msgData removeObjectAtIndex:indexPath.row];
    
    //2.刷新单元格
//    [_tableView reloadData];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _msgData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   static NSString *indenty = @"UITableViewCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty];

    }
    
    Message *message = [_msgData objectAtIndex:indexPath.row];
    
    
    //将数据交给单元格
    cell.msg = message;
//    [cell setMsg:message];
    
    

    return cell;
    
}

//返回单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg =  _msgData[indexPath.row];
    NSString *content = msg.content;
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180, 999999) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 45;
    

    

}

//点击单元格的方法(点击时,将键盘缩回)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //将键盘返回(两种方式)
    //1.失去第一响应
    [_inputView resignFirstResponder];
//    2.
//    [_inputView endEditing:YES];
    
    //调整底部视图与表视图的frame
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    //将视图的transform调整为原始值
    _tableView.transform = CGAffineTransformIdentity;
    _bottomView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];

}

#pragma -mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //创建一个message对象
    Message *msg = [[Message alloc] init];
    msg.content = textField.text;
    msg.icon = @"icon01.jpg";
    msg.isSelf = YES;
    
    [_msgData addObject:msg];
    
    //1.刷新表示图
//    [_tableView reloadData];
    //2.
    //插入一个单元格
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_msgData.count - 1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    //显示最后一条消息(滚动到最后一个单元格)
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    

    return YES;

}

@end
