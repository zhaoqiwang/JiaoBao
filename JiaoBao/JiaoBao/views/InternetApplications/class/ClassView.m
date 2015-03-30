//
//  ClassView.m
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView
@synthesize mArr_attention,mView_button,mArr_class,mArr_local,mArr_sum,mArr_unit,mBtn_photo,mTableV_list,mInt_index,mArr_attentionTop,mArr_classTop,mArr_localTop,mArr_sumTop,mArr_unitTop;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        //通知学校界面，获取到的单位和个人数据,本单位或本班
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitArthListIndex:) name:@"UnitArthListIndex" object:nil];
        //取单位空间发表的最新或推荐文章,本地和全部
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowingUnitArthList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowingUnitArthList:) name:@"ShowingUnitArthList" object:nil];
        //通知学校界面，获取到的关注数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyAttUnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyAttUnitArthListIndex:) name:@"MyAttUnitArthListIndex" object:nil];
        
        self.mArr_unit = [NSMutableArray array];
        self.mArr_class = [NSMutableArray array];
        self.mArr_local = [NSMutableArray array];
        self.mArr_attention = [NSMutableArray array];
        self.mArr_sum = [NSMutableArray array];
        self.mArr_unitTop = [NSMutableArray array];
        self.mArr_classTop = [NSMutableArray array];
        self.mArr_localTop = [NSMutableArray array];
        self.mArr_attentionTop = [NSMutableArray array];
        self.mArr_sumTop = [NSMutableArray array];
        self.mInt_index = 0;
        //可滑动界面
//        self.mScrollV_sum = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height - 51)];
//        [self addSubview:self.mScrollV_sum];
//        self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, 488);
        
        //放四个按钮
        self.mView_button = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 42)];
        [self addSubview:self.mView_button];
        
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
//        self.mTableV_list.scrollEnabled = NO;
        [self addSubview:self.mTableV_list];
        [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_list.headerRefreshingText = @"正在刷新...";
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
//通知学校界面，获取到的单位和个人数据,本单位或本班
-(void)UnitArthListIndex:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    if ([flag intValue] == 2) {
        self.mArr_unitTop = array;
    }else{
        self.mArr_unit = array;
    }
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//取单位空间发表的最新或推荐文章,本地和全部
-(void)ShowingUnitArthList:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    if ([flag intValue] == 2) {//全部
        self.mArr_sum = array;
    }else{//本地
        self.mArr_local = array;
    }
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//通知学校界面，获取到的关注数据
-(void)MyAttUnitArthListIndex:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
//    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    self.mArr_attention = array;
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    self.mInt_index = (int)btn.tag;
    if (self.mInt_index == 0) {
        //flag=1个人，=2单位
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
    }else if (self.mInt_index == 1){
        
    }else if (self.mInt_index == 2){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"20" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
    }else if (self.mInt_index == 3){
        [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:@"1" Num:@"20" accid:[dm getInstance].jiaoBaoHao];
    }else if (self.mInt_index == 4){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"20" topFlags:@"1" flag:@"" RequestFlag:@"2"];
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
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}
//每个section头返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.mInt_index == 0||self.mInt_index == 1) {
        return 20;
    }else{
        return 0;
    }
    return 0;
}
//每个section底返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//返回section头的uiview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.mInt_index == 0||self.mInt_index == 1) {
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
    }else {
        return nil;
    }
    
    return nil;
}
//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.mInt_index == 0) {
            return self.mArr_unitTop.count;
        }else if (self.mInt_index == 1){
            return self.mArr_classTop.count;
        }else if (self.mInt_index == 2){
            return self.mArr_local.count;
        }else if (self.mInt_index == 3){
            return self.mArr_attention.count;
        }else if (self.mInt_index == 4){
            return self.mArr_sum.count;
        }
    }else{
        if (self.mInt_index == 0) {
            return self.mArr_unit.count;
        }else if (self.mInt_index == 1){
            return self.mArr_class.count;
        }else if (self.mInt_index == 2){
//            return self.mArr_local.count;
        }else if (self.mInt_index == 3){
//            return self.mArr_attention.count;
        }else if (self.mInt_index == 4){
//            return self.mArr_sum.count;
        }
    }
    return 0;
}
//有多少section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.mInt_index == 0||self.mInt_index == 1) {
        return 2;
    }else {
        return 1;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"ClassTableViewCell";
    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 54);
    }
    //找到当前应该显示的数组
    NSMutableArray *array = [NSMutableArray array];
    if (indexPath.section == 0) {
        if (self.mInt_index == 0) {
            array = [NSMutableArray arrayWithArray:self.mArr_unitTop];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_classTop];
        }else if (self.mInt_index == 2){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }else{
        if (self.mInt_index == 0) {
            array = [NSMutableArray arrayWithArray:self.mArr_unit];
        }else if (self.mInt_index == 1){
            array = [NSMutableArray arrayWithArray:self.mArr_class];
        }else if (self.mInt_index == 2){
            array = [NSMutableArray arrayWithArray:self.mArr_local];
        }else if (self.mInt_index == 3){
            array = [NSMutableArray arrayWithArray:self.mArr_attention];
        }else if (self.mInt_index == 4){
            array = [NSMutableArray arrayWithArray:self.mArr_sum];
        }
    }

    //显示具体界面
    ClassModel *model = [array objectAtIndex:indexPath.row];
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
    cell.mLab_time.text = model.RecDate;
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
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    
}
- (void)footerRereshing{
    
}

@end
