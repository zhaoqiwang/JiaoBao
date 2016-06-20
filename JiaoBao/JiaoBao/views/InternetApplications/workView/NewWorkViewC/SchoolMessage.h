//
//  SchoolMessage.h
//  JiaoBao
//  校园通知
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolMessage : UIView
@property(nonatomic,strong)UIButton* rightBtn;
@property(nonatomic,assign)BOOL allSelected;
@property(nonatomic,strong)UILabel *label;
- (void)removeNotification;



@end
