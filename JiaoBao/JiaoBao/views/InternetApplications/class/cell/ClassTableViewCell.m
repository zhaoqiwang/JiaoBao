//
//  ClassTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "CommentCell.h"

@implementation ClassTableViewCell

@synthesize mImgV_head,mLab_name,mLab_class,mLab_assessContent,mView_background,mImgV_airPhoto,mLab_content,mLab_time,mLab_click,mLab_clickCount,mLab_assess,mLab_assessCount,mLab_like,mLab_likeCount,mView_img,mImgV_0,mImgV_1,mImgV_2,delegate,mModel_class,ClassDelegate,headImgDelegate,mBtn_comment;

- (void)awakeFromNib {
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    self.arr = [NSArray arrayWithObjects:@"aaaaaaaaaaaaaa",@"aaaaaaaaaaaaaa",@"aaaaaaaaaaaaaa",@"aaaaaaaaaaaaaa",@"aaaaaaaaaaaaaa", nil];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TableViewdelegate&&TableViewdataSource
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
//每个cell返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
        
    }
    return 30;
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//给头像添加点击事件
-(void)thumbImgClick{
    self.mModel_class = [mModel_class init];
    self.mImgV_0.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick0:)];
    [self.mImgV_0 addGestureRecognizer:tap];
    
    self.mImgV_1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick1:)];
    [self.mImgV_1 addGestureRecognizer:tap2];
    
    self.mImgV_2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick2:)];
    [self.mImgV_2 addGestureRecognizer:tap3];
    
    //
    [self.mBtn_comment addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)commentClick:(UIButton *)btn{
    [self.delegate ClassTableViewCellCommentBtn:self Btn:btn];
}

-(void)tapImgClick0:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress0:self ImgV:self.mImgV_0];
}

-(void)tapImgClick1:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress1:self ImgV:self.mImgV_1];
}

-(void)tapImgClick2:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress2:self ImgV:self.mImgV_2];
}

//给班级添加点击事件
-(void)classLabClick{
    self.mLab_class.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classLabClick:)];
    [self.mLab_class addGestureRecognizer:tap];
}

-(void)classLabClick:(UIGestureRecognizer *)gest{
    [ClassDelegate ClassTableViewCellClassTapPress:self];
}

//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgClick:)];
    [self.mImgV_head addGestureRecognizer:tap];
}

-(void)headImgClick:(UIGestureRecognizer *)gest{
    [headImgDelegate ClassTableViewCellHeadImgTapPress:self];
}

@end
