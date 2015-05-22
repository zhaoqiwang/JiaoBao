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
@synthesize mArr_attention,mView_button,mArr_class,mArr_local,mArr_sum,mArr_unit,mBtn_photo,mTableV_list,mInt_index,mArr_attentionTop,mArr_classTop,mArr_localTop,mArr_sumTop,mArr_unitTop,mProgressV,mInt_flag,mView_popup;

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
        //我的班级文章列表
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AllMyClassArthList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllMyClassArthList:) name:@"AllMyClassArthList" object:nil];
        //获取到头像后刷新
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
        //通知学校界面，切换成功身份成功，清空数组
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCurUnit" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurUnit) name:@"changeCurUnit" object:nil];
        //切换账号时，更新数据
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RegisterView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterView:) name:@"RegisterView" object:nil];
        //将获取到的评论列表传到界面
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthCommentsList2" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthCommentsList2:) name:@"AirthCommentsList2" object:nil];
        
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
        self.mView_button.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:247/255.0 alpha:1];
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
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [dm getInstance].width, self.frame.size.height-44)];
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
//        self.mBtn_photo = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *img_btn = [UIImage imageNamed:@"root_addBtn"];
//        [self.mBtn_photo setBackgroundImage:img_btn forState:UIControlStateNormal];
//        [self.mBtn_photo addTarget:self action:@selector(clickPosting:) forControlEvents:UIControlEventTouchUpInside];
//        self.mBtn_photo.frame = CGRectMake(([dm getInstance].width-img_btn.size.width)/2, self.frame.size.height-51+(51-img_btn.size.height)/2, img_btn.size.width, img_btn.size.height);
//        [self.mBtn_photo setTitle:@"拍照发布" forState:UIControlStateNormal];
//        [self.mBtn_photo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self addSubview:self.mBtn_photo];
        
        self.mProgressV = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:self.mProgressV];
        self.mProgressV.delegate = self;
        
        self.mView_popup = [[PopupWindow alloc] init];
        self.mView_popup.delegate = self;
        [self addSubview:self.mView_popup];
        self.mView_popup.hidden = YES;
    }
    return self;
}

//将获取到的评论列表传到界面
-(void)AirthCommentsList2:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    CommentsListObjModel *model = [noti.object objectForKey:@"model"];
    for (int i=0; i<model.commentsList.count; i++) {
        commentsListModel *tempModel = [model.commentsList objectAtIndex:i];
        D("jdjfjdlsjfjfjjfjffjfjfjfjfj-=====%@,%@",tempModel.UserName,tempModel.Commnets);
    }
    NSString *tableID = [noti.object objectForKey:@"tableID"];
        if (self.mInt_index == 0) {
            for (int i=0; i<self.mArr_unitTop.count; i++) {
                ClassModel *classModel = [self.mArr_unitTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
            for (int i=0; i<self.mArr_unit.count; i++) {
                ClassModel *classModel = [self.mArr_unit objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
        }else if (self.mInt_index == 1){
            for (int i=0; i<self.mArr_classTop.count; i++) {
                ClassModel *classModel = [self.mArr_classTop objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
            for (int i=0; i<self.mArr_class.count; i++) {
                ClassModel *classModel = [self.mArr_class objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
        }else if (self.mInt_index == 2){
            for (int i=0; i<self.mArr_local.count; i++) {
                ClassModel *classModel = [self.mArr_local objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
        }else if (self.mInt_index == 3){
            for (int i=0; i<self.mArr_attention.count; i++) {
                ClassModel *classModel = [self.mArr_attention objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
        }else if (self.mInt_index == 4){
            for (int i=0; i<self.mArr_sum.count; i++) {
                ClassModel *classModel = [self.mArr_sum objectAtIndex:i];
                if ([classModel.TabIDStr isEqual:tableID]) {
                    classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                    break;
                }
            }
        }
    
    [self.mTableV_list reloadData];
}

//点击弹出框中的赞或者评论按钮
-(void)PopupWindowClickBtn:(PopupWindow *)PopupWindow Button:(UIButton *)btn{
    D("btn.tag-=======%ld",(long)btn.tag);
    self.mView_popup.hidden = YES;
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [self clearArray];
    self.mInt_index = 0;
}

//通知学校界面，切换成功身份成功，清空数组
-(void)changeCurUnit{
    [self clearArray];
    [self.mTableV_list reloadData];
    //重新获取数据
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = self.mInt_index;
    [self btnChange:btn];
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    [self.mTableV_list reloadData];
}

//我的班级文章列表
-(void)AllMyClassArthList:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    NSDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    if ([flag intValue] == 2) {//单位动态
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_classTop removeAllObjects];
        }
        self.mArr_classTop = array;
    }else{//个人
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_class removeAllObjects];
        }
        [self.mArr_class addObjectsFromArray:array];
    }
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
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
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
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    if ([flag intValue] == 2) {//全部
        //如果是刷新，将数据清除
        if (self.mInt_flag == 1) {
            [self.mArr_sum removeAllObjects];
        }
        [self.mArr_sum addObjectsFromArray:array];
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
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    [self.mArr_attention addObjectsFromArray:array];
    [self.mTableV_list reloadData];
//    self.mScrollV_sum.contentSize = CGSizeMake([dm getInstance].width, self.mTableV_list.contentSize.height+42);
//    self.mTableV_list.frame = CGRectMake(0, 42, [dm getInstance].width, self.mTableV_list.contentSize.height);
}

//按钮点击事件
-(void)btnChange:(UIButton *)btn{
    D("utype-===%d",[dm getInstance].uType);
    self.mView_popup.hidden = YES;
    self.mInt_index = (int)btn.tag;
    //点击按钮时，判断是否应该进行数据获取
    if (self.mInt_index == 0&&(self.mArr_unitTop.count==0||self.mArr_unit.count==0)) {
        if (self.mArr_unitTop.count==0) {
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
            [self ProgressViewLoad];
        }
        if (self.mArr_unit.count==0) {
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            [self ProgressViewLoad];
        }
    }else if (self.mInt_index == 1&&(self.mArr_class.count==0||self.mArr_classTop.count==0)){
        if (self.mArr_classTop.count==0) {
            [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"1" sectionFlag:@"2" RequestFlag:@"2"];//单位
            [self ProgressViewLoad];
        }
        if (self.mArr_class.count==0) {
            [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
            [self ProgressViewLoad];
        }
    }else if (self.mInt_index == 2&&self.mArr_local.count == 0){
        [self tableViewDownReloadData];
    }else if (self.mInt_index == 3&&self.mArr_attention.count==0){
        [self tableViewDownReloadData];
    }else if (self.mInt_index == 4&&self.mArr_sum.count==0){
        [self tableViewDownReloadData];
    }
    D("sldjflksgjlk-====%lu",(unsigned long)self.mArr_attention.count);
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
    self.mView_popup.hidden = YES;
    if (self.mInt_index == 0) {
        //flag=1个人，=2单位
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"1" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"2"];
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 1){
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"1" sectionFlag:@"2" RequestFlag:@"2"];//单位
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
        [self ProgressViewLoad];
    }else if (self.mInt_index == 2){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"5" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 3){
        [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:@"1" Num:@"5" accid:[dm getInstance].jiaoBaoHao];
        [self ProgressViewLoad];
    }else if (self.mInt_index == 4){
        [[ClassHttp getInstance] classHttpShowingUnitArthList:@"1" Num:@"5" topFlags:@"1" flag:@"" RequestFlag:@"2"];
        [self ProgressViewLoad];
    }
}

//表格开始滑动，
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.mView_popup.hidden = YES;
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
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:247/255.0 alpha:1];
        UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [dm getInstance].width-20, 22)];
        if (section ==0) {
            if (self.mInt_index == 0) {
                tempLab.text = @"单位动态";
            }else{
                tempLab.text = @"班级动态";
            }
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
    if ([model.flag intValue] ==1) {//展示
        imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.unitId]];
    }else{
        imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    }
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_head setImage:img];
    }else{
        [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        if ([model.flag intValue] ==1) {//展示
             [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"%@",model.unitId] Size:@""];
        }else{
            [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
        }
    }
    cell.mImgV_head.frame = CGRectMake(10, 15, 42, 42);
    //姓名
    NSString *tempName;
    //判断应该显示姓名，还是单位名
    if ([model.flag intValue] ==1) {//展示
        tempName = model.UnitName;
    }else{
        tempName = model.UserName;
    }
    CGSize nameSize = [[NSString stringWithFormat:@"%@",tempName] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_name.frame = CGRectMake(62, 18, nameSize.width, cell.mLab_name.frame.size.height);
    cell.mLab_name.text = tempName;
    //发布单位
    NSString *tempUnit;
    if ([model.flag intValue] ==1) {//展示
        if (self.mInt_index == 0||self.mInt_index == 1) {
            cell.mLab_class.hidden = YES;
        }else{
            tempUnit = [NSString stringWithFormat:@" 动态 "];
            cell.mLab_class.backgroundColor = [UIColor colorWithRed:230/255.0 green:130/255.0 blue:130/255.0 alpha:1];
            cell.mLab_class.textColor = [UIColor whiteColor];
            //将图层的边框设置为圆脚
            cell.mLab_class.layer.cornerRadius = 3;
            cell.mLab_class.layer.masksToBounds = YES;
        }
        CGSize unitSize = [tempUnit sizeWithFont:[UIFont systemFontOfSize:14]];
        cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, unitSize.width, cell.mLab_class.frame.size.height);
    }else{
        if (model.className.length>0) {
            tempUnit = [NSString stringWithFormat:@"(%@)",model.className];
        }else{
            tempUnit = [NSString stringWithFormat:@"(%@)",model.UnitName];
        }
        cell.mLab_class.hidden = NO;
        //cell.tableview.frame = CGRectMake(0, cell.mLab_class.frame.origin, <#CGFloat width#>, <#CGFloat height#>)
        cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, [dm getInstance].width-cell.mLab_name.frame.origin.x-nameSize.width-10, cell.mLab_class.frame.size.height);
    }
    
    
    cell.mLab_class.text = tempUnit;
    
    //判断是否隐藏
    //标题
//    CGSize titleSize = [[NSString stringWithFormat:@"%@",model.Title] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_assessContent.frame = CGRectMake(62, cell.mLab_name.frame.origin.y+cell.mLab_name.frame.size.height, [dm getInstance].width-72, cell.mLab_assessContent.frame.size.height);
    cell.mLab_assessContent.text = model.Title;
    //文章logo
    CGSize contentSize;
    cell.mImgV_airPhoto.hidden = YES;
    //详情
    contentSize = [model.Abstracts sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-72, 99999)];
    if (contentSize.height>26) {
        contentSize = CGSizeMake([dm getInstance].width-82, 30);
        cell.mLab_content.numberOfLines = 2;
        cell.mView_background.hidden = NO;
    }
    if (model.Abstracts.length==0) {
        contentSize = CGSizeMake([dm getInstance].width-82, 0);
        cell.mView_background.hidden = YES;
    }
    cell.mLab_content.frame = CGRectMake(62+5, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+4, contentSize.width, contentSize.height);
    cell.mLab_content.text = model.Abstracts;
    
    //添加图片点击事件
    [cell thumbImgClick];
    cell.mModel_class = model;
    cell.delegate = self;
    cell.tag = indexPath.row;
    //添加头像点击事件
    [cell headImgClick];
    cell.headImgDelegate = self;
    //详情背景色
    cell.mView_background.frame = CGRectMake(62, cell.mLab_content.frame.origin.y-4, [dm getInstance].width-72, contentSize.height+8);
    //是否有文章图片需要显示
    if (model.Thumbnail.count>0) {
        cell.mView_img.hidden = NO;
        //最多显示6个图片
        int a;
        if (model.Thumbnail.count>=3) {
            a=3;
        }else{
            a = (int)model.Thumbnail.count;
        }
        //显示图片的宽度
        int m = ([dm getInstance].width-82)/3;
        //开始塞图片
        BOOL notFirst = NO;
        float y = 5;    float x = 0;
        
        for (int i=0; i<a; i++,x++) {
            if ((i%3)==0 && notFirst) {
                
                y = y+(m+5);
                x = 0;
            }
            notFirst = YES;
            if (i==0) {
                cell.mImgV_0.hidden = NO;
                [cell.mImgV_0 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_0 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }else if (i==1){
                cell.mImgV_1.hidden = NO;
                [cell.mImgV_1 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];                [cell.mImgV_1 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }else if (i==2){
                cell.mImgV_2.hidden = NO;
                [cell.mImgV_2 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_2 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            }
        }
        cell.mView_img.frame = CGRectMake(62, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, [dm getInstance].width-72, m+10);
    }else{
        cell.mView_img.hidden = YES;
        cell.mView_img.frame = cell.mView_background.frame;
    }
    
    //时间
    cell.mLab_time.frame = CGRectMake(62, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height+5, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    
    //点赞评论按钮
    cell.mBtn_comment.frame = CGRectMake([dm getInstance].width-10-26, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height, 26, 30);
    [cell.mBtn_comment setImage:[UIImage imageNamed:@"popupWindow_like_comment"] forState:UIControlStateNormal];
    
    //点赞
    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_likeCount.frame = CGRectMake(cell.mBtn_comment.frame.origin.x-10-likeSize.width, cell.mLab_time.frame.origin.y, likeSize.width, cell.mLab_likeCount.frame.size.height);
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
    cell.tableview.frame = CGRectMake(0, cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height, [dm getInstance].width, cell.tableview.contentSize.height);
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height+cell.tableview.frame.size.height);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.mView_popup.hidden = YES;
    ClassModel *ClassModel;
    if (indexPath.section == 0) {
        if (self.mInt_index == 0) {
            ClassModel = [self.mArr_unitTop objectAtIndex:indexPath.row];
        }else if (self.mInt_index == 1){
            ClassModel = [self.mArr_classTop objectAtIndex:indexPath.row];
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
    UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
    model.UnitID = [NSString stringWithFormat:@"%d",[dm getInstance].UID];
    model.UnitType = [NSString stringWithFormat:@"%d",[dm getInstance].uType];
    SharePostingViewController *posting = [[SharePostingViewController alloc] init];
    posting.mModel_unit = model;
    posting.mInt_section = 0;
    [utils pushViewController:posting animated:YES];
}

//点击senction中的更多
-(void)clickMoreUnit{
    ClassTopViewController *topView = [[ClassTopViewController alloc] init];
    if (self.mInt_index ==0) {
        topView.mInt_unit_class = 1;
        topView.mStr_navName = @"单位动态";
    }else{
        topView.mInt_unit_class = 2;
        topView.mStr_navName = @"班级动态";
    }
    [utils pushViewController:topView animated:YES];
}

-(void)ProgressViewLoad{
    self.mView_popup.hidden = YES;
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
        if (self.mArr_unit.count>=5&&self.mArr_unit.count%5==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_unit.count/5+1;
            [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"1"];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 1){
        if (self.mArr_class.count>=5&&self.mArr_class.count%5==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_class.count/5+1;
            [[ClassHttp getInstance] classHttpAllMyClassArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" sectionFlag:@"1" RequestFlag:@"1"];//个人
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 2){
        if (self.mArr_local.count>=5&&self.mArr_local.count%5==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_local.count/5+1;
            [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" topFlags:@"1" flag:@"local" RequestFlag:@"1"];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 3){
        if (self.mArr_attention.count>=5&&self.mArr_attention.count%5==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_attention.count/5+1;
            [[ClassHttp getInstance] classHttpMyAttUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" accid:[dm getInstance].jiaoBaoHao];
            [self ProgressViewLoad];
        } else {
            [self loadNoMore];
        }
    }else if (self.mInt_index == 4){
        if (self.mArr_sum.count>=5&&self.mArr_sum.count%5==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            int a = (int)self.mArr_sum.count/5+1;
            [[ClassHttp getInstance] classHttpShowingUnitArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" topFlags:@"1" flag:@"" RequestFlag:@"2"];
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

//点击点赞评论按钮
-(void)ClassTableViewCellCommentBtn:(ClassTableViewCell *)topArthListCell Btn:(UIButton *)btn{
    //得到当前点击的button相对于整个view的坐标
    CGRect parentRect = [btn convertRect:btn.bounds toView:self];
    self.mView_popup.hidden = NO;
    self.mView_popup.frame = CGRectMake(parentRect.origin.x-120, parentRect.origin.y, self.mView_popup.frame.size.width, self.mView_popup.frame.size.height);
}

//向cell中添加图片点击手势
- (void) ClassTableViewCellTapPress0:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:0];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
}

- (void) ClassTableViewCellTapPress1:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 1; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:1];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
//    self.navigationController.title = @"";
//    [self.navigationController pushViewController:browser animated:YES];
}


- (void) ClassTableViewCellTapPress2:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
//    
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = 2; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
        
    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
        // 替换为中等尺寸图片
        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
        D("getImageStrUrl-====%@",getImageStrUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:getImageStrUrl]]];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = NO;//是否第一张,默认否
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:2];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    [utils pushViewController:browser animated:YES];
}
-(void)ClassTableViewCellHeadImgTapPress:(ClassTableViewCell *)topArthListCell{
    ClassModel *ClassModel = topArthListCell.mModel_class;
    if ([ClassModel.flag intValue] ==1) {//展示
        UnitSectionMessageModel *model = [[UnitSectionMessageModel alloc] init];
        model.UnitID = ClassModel.unitId;
        if (ClassModel.className.length>0) {
            model.UnitName = ClassModel.className;
        }else{
            model.UnitName = ClassModel.UnitName;
        }
        
        model.UnitType = ClassModel.UnitType;
        UnitSpaceViewController *space = [[UnitSpaceViewController alloc] init];
        space.mModel_unit = model;
        [utils pushViewController:space animated:YES];
    }else{//分享
        //生成个人信息
        UserInfoByUnitIDModel *userModel = [[UserInfoByUnitIDModel alloc] init];
        userModel.UserID = ClassModel.JiaoBaoHao;
        userModel.UserName = ClassModel.UserName;
        userModel.AccID = ClassModel.JiaoBaoHao;
        
        PersonalSpaceViewController *personal = [[PersonalSpaceViewController alloc] init];
        personal.mModel_personal = userModel;
        [utils pushViewController:personal animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [utils popViewControllerAnimated:YES];
}

//当切换账号时，将此界面的所有数组清空
-(void)clearArray{
    [self.mArr_attention removeAllObjects];
    [self.mArr_attentionTop removeAllObjects];
    [self.mArr_class removeAllObjects];
    [self.mArr_classTop removeAllObjects];
    [self.mArr_local removeAllObjects];
    [self.mArr_localTop removeAllObjects];
    [self.mArr_sum removeAllObjects];
    [self.mArr_sumTop removeAllObjects];
    [self.mArr_unit removeAllObjects];
    [self.mArr_unitTop removeAllObjects];
}

@end
