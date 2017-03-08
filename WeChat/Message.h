//
//  Message.h
//  WeChat
//
//  Created by mac on 15/3/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


//Model (存储聊天信息,一个message对象代表一条聊天信息)
@interface Message : NSObject

@property (nonatomic,copy)NSString *content;  //聊天内容
@property (nonatomic,copy)NSString *icon;     //用户头像
@property (nonatomic,assign)BOOL isSelf;      //是否为自己发的信息

@end
