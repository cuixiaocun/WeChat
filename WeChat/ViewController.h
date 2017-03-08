//
//  ViewController.h
//  WeChat
//
//  Created by mac on 15/3/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    
    IBOutlet UIView *_bottomView;
    
    IBOutlet UITextField *_inputView;
    
    IBOutlet UITableView *_tableView;
}

//  data  data1
@property (nonatomic,retain)NSMutableArray *msgData;
@end

