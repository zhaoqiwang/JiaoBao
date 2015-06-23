//
//  Forward_section.h
//  JiaoBao
//
//  Created by Zqw on 14-11-6.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loger.h"
@protocol Forward_sectionDelegate;

@interface Forward_section : UICollectionReusableView{
    UILabel *mLab_name;//section名称
    UIButton *mBtn_all;//全选按钮
    UIButton *mBtn_invertSelect;//反选
//    id<Forward_sectionDelegate> delegate;
}

@property (nonatomic,strong) UILabel *mLab_name;//section名称
@property (nonatomic,strong) UIButton *mBtn_all;//全选按钮
@property (nonatomic,strong) UIButton *mBtn_invertSelect;//反选
@property (weak,nonatomic) id<Forward_sectionDelegate> delegate;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIButton *triangleBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,assign)BOOL sel_symbol;


- (void)initWithFrame1:(CGRect)frame;

@end

@protocol Forward_sectionDelegate <NSObject>

//点击按钮
-(void)Forward_sectionClickBtnWith:(UIButton *)btn cell:(Forward_section *) section;

@end