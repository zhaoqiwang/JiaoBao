//
//  ClassView.m
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView
@synthesize mArr_attention,mView_button,mArr_class,mArr_local,mArr_sum,mArr_unit,mBtn_photo,mTableV_list,mInt_index,mScrollV_sum;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        //
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitArthListIndex:) name:@"UnitArthListIndex" object:nil];
        
        self.mArr_unit = [NSMutableArray array];
        self.mArr_class = [NSMutableArray array];
        self.mArr_local = [NSMutableArray array];
        self.mArr_attention = [NSMutableArray array];
        self.mArr_sum = [NSMutableArray array];
        self.mInt_index = 0;
        //可滑动界面
        self.mScrollV_sum = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height - 51)];
        [self addSubview:self.mScrollV_sum];
        self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, 488);
        
        //放四个按钮
        self.mView_button = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 42)];
        [self.mScrollV_sum addSubview:self.mView_button];
        
        //加载按钮
        for (int i=0; i<5; i++) {
            UIButton *tempbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempbtn.tag = i;
            if (i == 0) {
                tempbtn.selected = YES;
            }
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_%d",i]] forState:UIControlStateSelected];
            [tempbtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_click_%d",i]] forState:UIControlStateNormal];
            tempbtn.frame = CGRectMake((([dm getInstance].width-56*5)/6)*(i+1)+56*i, 0, 56, 42);
            [tempbtn addTarget:self action:@selector(btnChange:) forControlEvents:UIControlEventTouchUpInside];
            [self.mView_button addSubview:tempbtn];
        }
        //列表
//        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height) style:UITableViewStyleGrouped];
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, [dm getInstance].width, self.frame.size.height-42-51)];
        self.mTableV_list.delegate=self;
        self.mTableV_list.dataSource=self;
        self.mTableV_list.scrollEnabled = NO;
        [self.mScrollV_sum addSubview:self.mTableV_list];
        //新建按钮
        self.mBtn_photo = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_photo setBackgroundImage:img_btn forState:UIControlStateNormal];
        self.mBtn_photo.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        [self.mBtn_photo setTitle:@"拍照发布" forState:UIControlStateNormal];
        [self.mBtn_photo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.mBtn_photo addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mBtn_photo];
    }
    return self;
}

-(void)UnitArthListIndex:(NSNotification *)noti{
    self.mArr_unit = noti.object;
    [self.mTableV_list reloadData];
    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    self.mInt_index = (int)btn.tag;
    if (self.mInt_index == 0) {
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@""];
    }else if (self.mInt_index == 1){
        
    }else if (self.mInt_index == 2){
        
    }else if (self.mInt_index == 3){
        
    }else if (self.mInt_index == 4){
        
    }
    //切换图片
    for (UIButton *tempBtn in self.mView_button.subviews) {
        if ([tempBtn isKindOfClass:[UIButton class]]) {
            if (tempBtn.tag == btn.tag) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }
    }
    [self.mTableV_list reloadData];
}

#pragma mark - TableViewdelegate&&TableViewdataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
//每个cell返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mInt_index == 0) {
        UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            return cell.frame.size.height;
        }
    }else{
        return 50;
    }
    return 50;
}
//每个section头返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//每个section底返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//返回section头的uiview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 20)];
    view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20, 20)];
    if (section ==0) {
        tempLab.text = @"成果展示";
    }else{
        tempLab.text = @"活动分享";
    }
    tempLab.font = [UIFont systemFontOfSize:12];
    tempLab.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
    [view addSubview:tempLab];
    return view;
}
//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
//        return mArr_unit.count;
        if (self.mInt_index == 0) {
            return self.mArr_unit.count;
        }else if (self.mInt_index == 1){
            return 0;
        }else if (self.mInt_index == 2){
            return 0;
        }else if (self.mInt_index == 3){
            return 0;
        }else if (self.mInt_index == 4){
            return 0;
        }
    }
    return 0;
}
//有多少section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"ClassTableViewCell";
    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 54);
    }

    if (self.mInt_index == 0) {
        ClassModel *model = [self.mArr_unit objectAtIndex:indexPath.row];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell.mImgV_head setImage:img];
        }else{
            [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
            //获取头像
            [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
        }
        cell.mImgV_head.frame = CGRectMake(10, 6, 34, 34);
        //姓名
        CGSize nameSize = [[NSString stringWithFormat:@"%@",model.UserName] sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_name.frame = CGRectMake(54, 9, nameSize.width, cell.mLab_name.frame.size.height);
        cell.mLab_name.text = model.UserName;
        //发布单位
        NSString *tempUnit = [NSString stringWithFormat:@"(%@)",model.UnitName];
        CGSize unitSize = [tempUnit sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 9, unitSize.width, cell.mLab_class.frame.size.height);
        cell.mLab_class.text = tempUnit;
        //标题
        CGSize titleSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_assessContent.frame = CGRectMake(54, cell.mLab_name.frame.origin.y+cell.mLab_name.frame.size.height+5, titleSize.width, cell.mLab_assessContent.frame.size.height);
        cell.mLab_assessContent.text = model.Title;
        //详情
//        CGSize contentSize = [[NSString stringWithFormat:@"%@",model.Context] sizeWithFont:[UIFont systemFontOfSize:12]];
        CGSize contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-74, 99999)];
        if (contentSize.height>26) {
            contentSize = CGSizeMake([dm getInstance].width-74, 30);
            cell.mLab_content.numberOfLines = 2;
        }
        cell.mLab_content.frame = CGRectMake(54, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+5, contentSize.width, contentSize.height);
        cell.mLab_content.text = model.Abstracts;
        //文章logo
        cell.mImgV_airPhoto.hidden = YES;
        //详情背景色
        cell.mView_background.frame = CGRectMake(cell.mLab_content.frame.origin.x-1, cell.mLab_content.frame.origin.y-1, [dm getInstance].width-62, contentSize.height+2);
        //时间
        cell.mLab_time.frame = CGRectMake(54, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
//        cell.mLab_time.text = model.RecDate;
        cell.mLab_time.text = @"2015-03-09";
        //点赞
        CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_likeCount.frame = CGRectMake([dm getInstance].width-10-likeSize.width, cell.mLab_time.frame.origin.y, likeSize.width, cell.mLab_likeCount.frame.size.height);
        cell.mLab_likeCount.text = model.LikeCount;
        cell.mLab_like.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-cell.mLab_like.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_like.frame.size.width, cell.mLab_like.frame.size.height);
        //评论
        CGSize feeBackSize = [[NSString stringWithFormat:@"%@",model.FeeBackCount] sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_assessCount.frame = CGRectMake(cell.mLab_like.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, feeBackSize.width, cell.mLab_assessCount.frame.size.height);
        cell.mLab_assessCount.text = model.FeeBackCount;
        cell.mLab_assess.frame = CGRectMake(cell.mLab_assessCount.frame.origin.x-cell.mLab_assess.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_assess.frame.size.width, cell.mLab_assess.frame.size.height);
        //点击量
        CGSize clickSize = [[NSString stringWithFormat:@"%@",model.ClickCount] sizeWithFont:[UIFont systemFontOfSize:12]];
        cell.mLab_clickCount.frame = CGRectMake(cell.mLab_assess.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, clickSize.width, cell.mLab_clickCount.frame.size.height);
        cell.mLab_clickCount.text = model.ClickCount;
        cell.mLab_click.frame = CGRectMake(cell.mLab_clickCount.frame.origin.x-cell.mLab_click.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_click.frame.size.width, cell.mLab_click.frame.size.height);
        
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height);
    }else {
//        return 5;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
