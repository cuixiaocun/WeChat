//
//  MessageCell.h
//  WeChat
//
//  Created by mac on 15/3/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"
//自定义视图类

@interface MessageCell : UITableViewCell{

    
    UIImageView *_bgImage;  //聊天背景
    
    UILabel *_textLable;  //显示聊天信息
    
    UIImageView *_userImage; //用户头像

}

@property (nonatomic,retain)Message *msg;  //视图需要显示的model数据

@end
