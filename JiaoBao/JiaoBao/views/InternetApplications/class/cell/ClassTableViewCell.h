//
//  ClassTableViewCell.h
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
#import "CommentsListObjModel.h"


@protocol ClassTableViewCellDelegate;
@protocol ClassTableViewCellClassDelegate,ClassTableViewCellHeadImgDelegate;

@interface ClassTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *mImgV_head;//单位logo
    UILabel *mLab_name;//姓名
    UILabel *mLab_class;//班级
    UILabel *mLab_assessContent;//评价
    UIView *mView_background;//背景色
    UIImageView *mImgV_airPhoto;//文章logo
    UILabel *mLab_content;//内容
    UILabel *mLab_time;//时间
    UILabel *mLab_click;//点击量
    UILabel *mLab_clickCount;//点击量个数
    UILabel *mLab_assess;//评论
    UILabel *mLab_assessCount;//评论条数
    UILabel *mLab_like;//赞
    UILabel *mLab_likeCount;//赞个数
    UIView *mView_img;//显示文章中的图片
    //需要显示的3张预览图片
    UIImageView *mImgV_0;
    UIImageView *mImgV_1;
    UIImageView *mImgV_2;
    UIButton *mBtn_comment;//弹出点赞和评论
    id<ClassTableViewCellDelegate> delegate;
    ClassModel *mModel_class;//
    id<ClassTableViewCellClassDelegate> ClassDelegate;
    id<ClassTableViewCellHeadImgDelegate> headImgDelegate;
}

@property (nonatomic,strong) IBOutlet UIImageView *mImgV_head;//单位logo
@property (nonatomic,strong) IBOutlet UILabel *mLab_name;//姓名
@property (nonatomic,strong) IBOutlet UILabel *mLab_class;//班级
@property (nonatomic,strong) IBOutlet UILabel *mLab_assessContent;//评价
@property (nonatomic,strong) IBOutlet UIView *mView_background;//背景色
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_airPhoto;//文章logo
@property (nonatomic,strong) IBOutlet UILabel *mLab_content;//内容
@property (nonatomic,strong) IBOutlet UILabel *mLab_time;//时间
@property (nonatomic,strong) IBOutlet UILabel *mLab_click;//点击量
@property (nonatomic,strong) IBOutlet UILabel *mLab_clickCount;//点击量个数
@property (nonatomic,strong) IBOutlet UILabel *mLab_assess;//评论
@property (nonatomic,strong) IBOutlet UILabel *mLab_assessCount;//评论条数
@property (nonatomic,strong) IBOutlet UILabel *mLab_like;//赞
@property (nonatomic,strong) IBOutlet UILabel *mLab_likeCount;//赞个数
@property (nonatomic,strong) IBOutlet UIView *mView_img;//显示文章中的图片
//需要显示的3张预览图片
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_0;
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_1;
@property (nonatomic,strong) IBOutlet UIImageView *mImgV_2;
@property (nonatomic,strong) IBOutlet UIButton *mBtn_comment;//弹出点赞和评论

@property (strong,nonatomic) id<ClassTableViewCellDelegate> delegate;
@property (nonatomic,strong) ClassModel *mModel_class;//
@property (strong,nonatomic) id<ClassTableViewCellClassDelegate> ClassDelegate;
@property (strong,nonatomic) id<ClassTableViewCellHeadImgDelegate> headImgDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSArray *nameArr,*commentArr;
@property (weak, nonatomic) IBOutlet UIView *tableBackView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property(nonatomic,strong)NSArray *topArr,*unitArr;

//给图片添加点击事件
-(void)thumbImgClick;

//给班级添加点击事件
-(void)classLabClick;

//给头像添加点击事件
-(void)headImgClick;

@end

//向cell中添加图片点击手势
@protocol ClassTableViewCellDelegate <NSObject>

- (void) ClassTableViewCellTapPress0:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img;

- (void) ClassTableViewCellTapPress1:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img;

- (void) ClassTableViewCellTapPress2:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img;

//点击点赞评论按钮
-(void) ClassTableViewCellCommentBtn:(ClassTableViewCell *) topArthListCell Btn:(UIButton *)btn;

@end

//向cell班级显示中添加点击手势
@protocol ClassTableViewCellClassDelegate <NSObject>

- (void) ClassTableViewCellClassTapPress:(ClassTableViewCell *) topArthListCell;

@end

//向cell头像显示中添加点击手势
@protocol ClassTableViewCellHeadImgDelegate <NSObject>

- (void) ClassTableViewCellHeadImgTapPress:(ClassTableViewCell *) topArthListCell;

@end

