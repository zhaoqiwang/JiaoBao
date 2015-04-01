//
//  ClassView.m
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassView.h"
#import "Reachability.h"

@implementation ClassView
@synthesize mArr_attention,mView_button,mArr_class,mArr_local,mArr_sum,mArr_unit,mBtn_photo,mTableV_list,mInt_index,mArr_attentionTop,mArr_classTop,mArr_localTop,mArr_sumTop,mArr_unitTop,mProgressV,mInt_flag;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        //通知学校界面，获取到的单位和个人数据,本单位或本班
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitArthListIndex:) name:@"UnitArthListIndex" object:nil];
        //取单位空间发表的最新或推荐文章,本地和全部
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowingUnitArthList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowingUnitArthList:) name:@"ShowingUnitArthList" object:nil];
        //通知学校界面，获取到的关注数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyAttUnitArthListIndex" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyAttUnitArthListIndex:) name:@"MyAttUnitArthListIndex" object:nil];
        //获取到头像后刷新
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
        
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
        self.mView_button.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
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
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [dm getInstance].width, self.frame.size.height-44-51)];
        self.mTableV_list.delegate=self;
        self.mTableV_list.dataSource=self;
//        self.mTableV_list.scrollEnabled = NO;
        [self addSubview:self.mTableV_list];
        [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
        self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
        self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
        self.mTableV_list.headerRefreshingText = @"正在刷新...";
        [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
        self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
        self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
        self.mTableV_list.footerRefreshingText = @"正在加载...";
        //新建按钮
        self.mBtn_photo = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
        [self.mBtn_photo setBackgroundImage:img_btn forState:UIControlStateNormal];
        [self.mBtn_photo addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
        self.mBtn_photo.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
        [self.mBtn_photo setTitle:@"拍照发布" forState:UIControlStateNormal];
        [self.mBtn_photo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.mBtn_photo];
        
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;
    }
    return self;
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [self.mTableV_list reloadData];
}

//通知学校界面，获取到的单位和个人数据,本单位或本班
-(void)UnitArthListIndex:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    if ([flag intValue] == 2) {
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_unitTop removeAllObjects];
        }
        self.mArr_unitTop = array;
    }else{
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_unit removeAllObjects];
        }
        [self.mArr_unit addObjectsFromArray:array];
    }
    [self.mTableV_list reloadData];
}

//取单位空间发表的最新或推荐文章,本地和全部
-(void)ShowingUnitArthList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    if ([flag intValue] == 2) {//全部
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_sum removeAllObjects];
        }
        self.mArr_sum = array;
    }else{//本地
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_local removeAllObjects];
        }
        [self.mArr_local addObjectsFromArray:array];
    }
    [self.mTableV_list reloadData];
}

//通知学校界面，获取到的关注数据
-(void)MyAttUnitArthListIndex:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        [self.mArr_attention removeAllObjects];
    }
    NSDictionary *dic = noti.object;
//    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    [self.mArr_attention addObjectsFromArray:array];
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    D("utype-===%d",[dm getInstance].uType);
    self.mInt_index = (int)btn.tag;
    //点击按钮时，判断是否应该进行数据获取
    if (self.mInt_index == 0||self.mArr_unitTop.count==0||self.mArr_unit.count==0) {
        if (self.mArr_unitTop.count==0) {
            if ([dm getInstance].uType==1) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
            }else{
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
            }
            [self ProgressViewLoad];
        }
        if (self.mArr_unit.count==0) {
            if ([dm getInstance].uType==1) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            }else{
                [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            }
            [self ProgressViewLoad];
        }
    }else if (self.mInt_index == 1&&self.mArr_class.count==0){
        
    }else if (self.mInt_index == 2&&self.mArr_local.count == 0){
        [self tableViewDownReloadData];
    }else if (self.mInt_index == 3&&self.mArr_attention.count==0){
        [self tableViewDownReloadData];
    }else if (self.mInt_index == 4&&self.mArr_sum.count==0){
        [self tableViewDownReloadData];
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
//刚进入学校圈，或者下拉刷新时执行
-(void)tableViewDownReloadData{
    if (self.mInt_index == 0) {
        //flag=1个人，=2单位
        if ([dm getInstance].uType==1) {
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
        }else{
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
        }
        [self ProgressViewLoad];
    }else if (self.mInt_index == 1){
        
    }else if (self.mInt_index == 2){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"20" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 3){
        [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:@"1" Num:@"20" accid:[dm getInstance].jiaoBaoHao];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 4){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"20" topFlags:@"1" flag:@"" RequestFlag:@"2"];
        [self ProgressViewLoad];
    }
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 22)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20, 22)];
        if (section ==0) {
            tempLab.text = @"单位动态";
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempBtn.frame = CGRectMake([dm getInstance].width-60, 0, 50, 22);
//            [tempBtn setBackgroundImage:[UIImage imageNamed:@"classView_more"] forState:UIControlStateNormal];
            [tempBtn setImage:[UIImage imageNamed:@"classView_more"] forState:UIControlStateNormal];
            [tempBtn addTarget:self action:@selector(clickMoreUnit) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:tempBtn];
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
            return self.mArr_local.count;
        }else if (self.mInt_index == 3){
            return self.mArr_attention.count;
        }else if (self.mInt_index == 4){
            return self.mArr_sum.count;
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
    NSString *imgPath;
    if (indexPath.section == 0) {
        if (self.mInt_index == 0||self.mInt_index == 1) {
            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",[dm getInstance].UID]];
        }else {
            imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
        }
    }else{
        imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    }
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_head setImage:img];
    }else{
        [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        if (indexPath.section == 0) {
            if (self.mInt_index == 0||self.mInt_index == 1) {
                [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"%d",[dm getInstance].UID] Size:@""];
            }else {
                [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
            }
        }else{
            [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
        }
    }
    cell.mImgV_head.frame = CGRectMake(10, 15, 42, 42);
    //姓名
    NSString *tempName;
    //判断应该显示姓名，还是单位名
    if (indexPath.section == 0) {
        if (self.mInt_index == 0||self.mInt_index == 1) {
            tempName = model.UnitName;
        }else{
            tempName = model.UserName;
        }
    }else{
        tempName = model.UserName;
    }
    CGSize nameSize = [[NSString stringWithFormat:@"%@",tempName] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_name.frame = CGRectMake(62, 18, nameSize.width, cell.mLab_name.frame.size.height);
    cell.mLab_name.text = tempName;
    //发布单位
    NSString *tempUnit = [NSString stringWithFormat:@"(%@)",model.UnitName];
    CGSize unitSize = [tempUnit sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, unitSize.width, cell.mLab_class.frame.size.height);
    cell.mLab_class.text = tempUnit;
    //判断是否隐藏
    if (indexPath.section == 0) {
        if (self.mInt_index == 0||self.mInt_index == 1) {
            cell.mLab_class.hidden = YES;
        }else{
            cell.mLab_class.hidden = NO;
        }
    }else{
        cell.mLab_class.hidden = NO;
    }
    //标题
//    CGSize titleSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_assessContent.frame = CGRectMake(62, cell.mLab_name.frame.origin.y+cell.mLab_name.frame.size.height, [dm getInstance].width-72, cell.mLab_assessContent.frame.size.height);
    cell.mLab_assessContent.text = model.Title;
    //文章logo
    CGSize contentSize;
    if (model.Thumbnail.count>0) {
        cell.mImgV_airPhoto.hidden = NO;
        [cell.mImgV_airPhoto sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:0]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
        cell.mImgV_airPhoto.frame = CGRectMake(62, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+5, 40, 40);
        //详情
        contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-72-45, 99999)];
        if (contentSize.height>26) {
            contentSize = CGSizeMake([dm getInstance].width-82-35, 48);
            cell.mLab_content.numberOfLines = 2;
        }
        cell.mLab_content.frame = CGRectMake(62+45, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+5, contentSize.width, contentSize.height);
    }else{
        cell.mImgV_airPhoto.hidden = YES;
        //详情
        contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-72, 99999)];
        if (contentSize.height>26) {
            contentSize = CGSizeMake([dm getInstance].width-82, 48);
            cell.mLab_content.numberOfLines = 2;
        }
        cell.mLab_content.frame = CGRectMake(62+3, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+5, contentSize.width, contentSize.height);
    }
    
    cell.mLab_content.text = model.Abstracts;
    
    //详情背景色
    cell.mView_background.frame = CGRectMake(62, cell.mLab_content.frame.origin.y-4, [dm getInstance].width-72, contentSize.height+4);
    //时间
    cell.mLab_time.frame = CGRectMake(62, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    //点赞
    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_likeCount.frame = CGRectMake([dm getInstance].width-10-likeSize.width, cell.mLab_time.frame.origin.y, likeSize.width, cell.mLab_likeCount.frame.size.height);
    cell.mLab_likeCount.text = model.LikeCount;
    cell.mLab_like.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-cell.mLab_like.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_like.frame.size.width, cell.mLab_like.frame.size.height);
    //评论
    CGSize feeBackSize = [[NSString stringWithFormat:@"%@",model.FeeBackCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_assessCount.frame = CGRectMake(cell.mLab_like.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, feeBackSize.width, cell.mLab_assessCount.frame.size.height);
    cell.mLab_assessCount.text = model.FeeBackCount;
    cell.mLab_assess.frame = CGRectMake(cell.mLab_assessCount.frame.origin.x-cell.mLab_assess.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_assess.frame.size.width, cell.mLab_assess.frame.size.height);
    //点击量
    CGSize clickSize = [[NSString stringWithFormat:@"%@",model.ClickCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_clickCount.frame = CGRectMake(cell.mLab_assess.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, clickSize.width, cell.mLab_clickCount.frame.size.height);
    cell.mLab_clickCount.text = model.ClickCount;
    cell.mLab_click.frame = CGRectMake(cell.mLab_clickCount.frame.origin.x-cell.mLab_click.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_click.frame.size.width, cell.mLab_click.frame.size.height);
    
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassModel *ClassModel;
    if (indexPath.section == 0) {
        if (self.mInt_index == 0) {
//            ClassTopViewController *topView = [[ClassTopViewController alloc] init];
//            [utils pushViewController:topView animated:YES];
//            return;
            ClassModel = [self.mArr_unitTop objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 1){
            
        }else if (self.mInt_index == 2){
            ClassModel = [self.mArr_local objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 3){
            ClassModel = [self.mArr_attention objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 4){
            ClassModel = [self.mArr_sum objectAtIndex:indexPath.row];
        }
    }else{
        if (self.mInt_index == 0) {
            ClassModel = [self.mArr_unit objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 1){
            ClassModel = [self.mArr_class objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 2){
            
        }else if (self.mInt_index == 3){
            
        }else if (self.mInt_index == 4){
            
        }
    }
    //转model
    TopArthListModel *model = [[TopArthListModel alloc] init];
    model.TabIDStr = ClassModel.TabIDStr;
    model.ClickCount = ClassModel.ClickCount;
    model.Context = ClassModel.Context;
    model.JiaoBaoHao = ClassModel.JiaoBaoHao;
    model.LikeCount = ClassModel.LikeCount;
    model.RecDate = ClassModel.RecDate;
    model.Source = ClassModel.Source;
    model.StarJson = ClassModel.StarJson;
    model.State = ClassModel.State;
    model.Title = ClassModel.Title;
    model.ViewCount = ClassModel.ViewCount;
    model.SectionID = ClassModel.SectionID;
    model.UserName = ClassModel.UserName;

    ArthDetailViewController *arth = [[ArthDetailViewController alloc] init];
    arth.Arthmodel = model;
    [utils pushViewController:arth animated:YES];
}

//发表文章按钮
-(void)clickPosting:(UIButton *)btn{
//    NSString *UnitID;//单位ID
//    NSString *UnitName;//单位名称
//    NSString *IsMyUnit;//单位标识，1我所在单位，2我的上级，如果同在上级和本单位，本单位优先
//    NSString *MessageCount;//未读数量
//    NSString *UnitType;//教育局1，学校2
//    NSString *imgName;//图片
    
    UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
    model.UnitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    model.UnitType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    posting.mModel_unit = model;
    posting.mInt_section = 1;
    [utils pushViewController:posting animated:YES];
}

//点击senction中的更多
-(void)clickMoreUnit{
    ClassTopViewController *topView = [[ClassTopViewController alloc] init];
    [utils pushViewController:topView animated:YES];
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = @"加载中...";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        self.mProgressV.labelText = NETWORKENABLE;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return YES;
    }else{
        return NO;
    }
}

-(void)noMore{
    sleep(1);
}

- (void)Loading {
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    //    self.mProgressV.userInteractionEnabled = NO;
    sleep(2);
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    //标注为刷新
    self.mInt_flag = 1;
    //刚进入学校圈，或者下拉刷新时执行
    [self tableViewDownReloadData];
}
- (void)footerRereshing{
    //不是刷新
    self.mInt_flag = 0;
    if (self.mInt_index == 0) {
        if (self.mArr_unit.count>=20) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_unit.count/20+1;
            if ([dm getInstance].uType==1) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            }else{
                [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            }
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 1){
        
    }else if (self.mInt_index == 2){
        if (self.mArr_local.count>=20) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_local.count/20+1;
            [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"20" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 3){
        if (self.mArr_attention.count>=20) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_attention.count/20+1;
            [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" accid:[dm getInstance].jiaoBaoHao];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 4){
        if (self.mArr_sum.count>=20) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_sum.count/20+1;
            [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"20" topFlags:@"1" flag:@"" RequestFlag:@"2"];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }
}

-(void)loadNoMore{
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"没有更多了";
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
}

@end
