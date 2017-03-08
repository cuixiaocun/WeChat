//
//  MessageCell.m
//  WeChat
//
//  Created by mac on 15/3/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MessageCell.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       //创建子视图
        
        //子视图的frame无法确定(需要根据外部传入的数据来确定frame)
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _textLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_bgImage];
        [self.contentView addSubview:_textLable];
        [self.contentView addSubview:_userImage];
        
        
//        _textLable.text = _msg.content; 错误,此时数据还没有传入(注意方法调用的顺序)
        _textLable.font = [UIFont systemFontOfSize:14];
        _textLable.numberOfLines = 0;  //自动换行
        
        
    }



    return self;

}

//外部传递数据调用的方法(set方法)此方法调用时说明数据已经传入
- (void)setMsg:(Message *)msg{

    if (_msg != msg) {
        
        [_msg release];
        _msg = [msg retain];
        
    }
    
    
//    [self layoutSubviews]; 错误
    [self setNeedsLayout]; //通知系统,有空去调用layoutSubviews
    
    
    
}


//当屏幕刷新完以后,系统会调用此方法
//1. 调整子视图的frame
//2. 将数据交给对应的视图显示(填充数据)

- (void)layoutSubviews{
    
    //父类的方法一定要去调用
    [super layoutSubviews];
    
    //1.填充数据
    
    //用户头像
    _userImage.image = [UIImage imageNamed:_msg.icon];
    
    //背景视图
    UIImage *img1 = [UIImage imageNamed:@"chatfrom_bg_normal.png"];//其他人
    UIImage *img2 = [UIImage imageNamed:@"chatto_bg_normal.png"];   //自己
    
    UIImage *img = _msg.isSelf ? img2 : img1;
    
    //拉伸聊天背景图片
    img = [img stretchableImageWithLeftCapWidth:img.size.width * .5 topCapHeight:img.size.height * .7];
    
    _bgImage.image = img;
    
    
    NSString *conttent = _msg.content;
    
    _textLable.text = conttent;
    
    
    //计算聊天信息占用的空间大小
    //此方法会显示警告,因为此方法在ios7已经不推荐使用(但仍可以使用)
    CGSize size = [conttent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(180, 99999) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    //布局子视图(需要判断消息是否为自己发送)
    
    if (_msg.isSelf) {
        
        
        _userImage.frame = CGRectMake(kScreenWidth - 50, 10, 50,50);
        
        _bgImage.frame = CGRectMake(100, 10, 220, size.height + 30);
        
        _textLable.frame = CGRectMake(120, 20, 180, size.height);
        
    }else {
    
    
        _userImage.frame = CGRectMake(0, 10, 50, 50);
        
        _bgImage.frame = CGRectMake(60, 10, 220, size.height + 30);
        
        _textLable.frame = CGRectMake(80, 20, 180, size.height);
    
    
    }
    
    
    
    
    
    
    
    
 
    
    //2.布局
    
    
    
    
    

    


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
