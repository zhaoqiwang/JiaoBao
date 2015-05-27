//
//  ClassTopViewController.m
//  JiaoBao
//
//  Created by Zqw on 15-3-31.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassTopViewController.h"
#import "Reachability.h"

@interface ClassTopViewController ()

@end

@implementation ClassTopViewController
@synthesize mArr_list,mTableV_list,mNav_navgationBar,mProgressV,mInt_flag,mInt_unit_class,mStr_classID,mStr_navName,mArr_list_class,mTextF_text,mView_popup,mView_text,mBtn_send;

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    //通知学校界面，获取到的单位和个人数据,本单位或本班
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnitArthListIndex3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnitArthListIndex3:) name:@"UnitArthListIndex3" object:nil];
    //获取到头像后刷新
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exchangeGetFaceImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TopArthListIndexImg:) name:@"exchangeGetFaceImg" object:nil];
    //我的班级文章列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AllMyClassArthList3" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllMyClassArthList3:) name:@"AllMyClassArthList3" object:nil];
    //将获取到的评论列表传到界面
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthCommentsList2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthCommentsList2:) name:@"AirthCommentsList2" object:nil];
    //获取文章的附加信息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetArthInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetArthInfo:) name:@"GetArthInfo" object:nil];
    //通知文章详情界面刷新点赞
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthLikeIt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthLikeIt:) name:@"AirthLikeIt" object:nil];
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    //文章评论
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AirthAddComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AirthAddComment:) name:@"AirthAddComment" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mArr_list = [NSMutableArray array];
    self.mArr_list_class = [NSMutableArray array];
    //添加导航条
    if (self.mStr_navName.length>0) {
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    }else{
        self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"所有文章"];
    }
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    [self.mTableV_list addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.mTableV_list.headerPullToRefreshText = @"下拉刷新";
    self.mTableV_list.headerReleaseToRefreshText = @"松开后刷新";
    self.mTableV_list.headerRefreshingText = @"正在刷新...";
    [self.mTableV_list addFooterWithTarget:self action:@selector(footerRereshing)];
    self.mTableV_list.footerPullToRefreshText = @"上拉加载更多";
    self.mTableV_list.footerReleaseToRefreshText = @"松开加载更多数据";
    self.mTableV_list.footerRefreshingText = @"正在加载...";
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    //判断应该加载单位1还是班级2
    if (self.mInt_unit_class == 1) {
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
    } else if(self.mInt_unit_class == 2) {
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"2" RequestFlag:@"3"];//单位
    }else if (self.mInt_unit_class == 3){
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
    }
    
    [self ProgressViewLoad];
    
    self.mView_popup = [[PopupWindow alloc] init];
    self.mView_popup.delegate = self;
    [self.view addSubview:self.mView_popup];
    self.mView_popup.hidden = YES;
    
    //输入View坐标
    self.mView_text = [[UIView alloc] init];
    self.mView_text.frame = CGRectMake(0, 500, [dm getInstance].width, 51);
    self.mView_text.backgroundColor = [UIColor whiteColor];
    //添加边框
    self.mView_text.layer.borderWidth = .5;
    self.mView_text.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [self.view addSubview:self.mView_text];
    //输入框
    self.mTextF_text = [[UITextField alloc] init];
    self.mTextF_text.frame = CGRectMake(15, 10, [dm getInstance].width-15-70, 51-20);
    self.mTextF_text.placeholder = @"请输入评论内容";
    self.mTextF_text.delegate = self;
    self.mTextF_text.font = [UIFont systemFontOfSize:14];
    self.mTextF_text.borderStyle = UITextBorderStyleRoundedRect;
    self.mTextF_text.returnKeyType = UIReturnKeyDone;//return键的类型
    [self.mView_text addSubview:self.mTextF_text];
    //发送按钮
    self.mBtn_send = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mBtn_send.frame = CGRectMake([dm getInstance].width-65, 0, 60, 51);
    [self.mBtn_send addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.mBtn_send setTitle:@"发送" forState:UIControlStateNormal];
    self.mBtn_send.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.mBtn_send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.mView_text addSubview:self.mBtn_send];
    [self.mView_text setHidden:YES];
}

//将获取到的评论列表传到界面
-(void)AirthCommentsList2:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    CommentsListObjModel *model = [noti.object objectForKey:@"model"];
    NSString *tableID = [noti.object objectForKey:@"tableID"];
    
    if (self.mInt_unit_class == 3){
        for (int i=0; i<self.mArr_list_class.count; i++) {
            ClassModel *classModel = [self.mArr_list_class objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                classModel.mArr_comment = [NSMutableArray arrayWithArray:model.commentsList];
                break;
            }
        }
    }else{
        for (int i=0; i<self.mArr_list.count; i++) {
            ClassModel *classModel = [self.mArr_list objectAtIndex:i];
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
    self.mView_popup.hidden = YES;
    [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
    
    if (btn.tag == 0) {
        //先判断是否已经获取到是否已经点赞的附加信息
        if (self.mView_popup.mModel_class.mModel_info.TabID >0) {//获取到
            if (self.mView_popup.mModel_class.mModel_info.Likeflag >=0){//没有点赞，发送点赞请求
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM] isEqual:@"ArthDetailViewController"]) {
                    
                }else{
                    [[ShareHttp getInstance] shareHttpAirthLikeIt:self.mView_popup.mModel_class.TabIDStr Flag:[NSString stringWithFormat:@"%d",self.mView_popup.mModel_class.mModel_info.Likeflag]];
                    [self ProgressViewLoad:@"点赞中..."];
                }
            }else{//已赞
                //                [self loadNoMore:@"已赞"];
            }
        }else{//发送获取当前文章附加信息的请求
            [[ShareHttp getInstance] shareHttpAirthGetArthInfo:self.mView_popup.mModel_class.TabIDStr sid:self.mView_popup.mModel_class.SectionID];
            [self ProgressViewLoad:@"获取信息中..."];
        }
    }else{
        [self.mTextF_text becomeFirstResponder];
    }
}

//点击发送评论按钮
-(void)clickSendBtn:(UIButton *)btn{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mTextF_text.text.length==0) {
        self.mProgressV.labelText = @"请输入内容";
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
        return;
    }
    self.mView_popup.hidden = YES;
    [[ShareHttp getInstance] shareHttpAirthAddComment:self.mView_popup.mModel_class.TabIDStr content:self.mTextF_text.text refid:@""];
    [self ProgressViewLoad:@"提交中"];
    [self.mTextF_text resignFirstResponder];
}

//文章评论
-(void)AirthAddComment:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    NSString *str = [noti.object objectForKey:@"str"];
    NSString *tableID = [noti.object objectForKey:@"tableID"];
    NSString *comment = [noti.object objectForKey:@"comment"];
    
    commentsListModel *tempModel = [[commentsListModel alloc] init];
    tempModel.UserName = [dm getInstance].name;
    if (self.mTextF_text.text.length==0) {
        tempModel.Commnets = comment;
    }else{
        tempModel.Commnets = self.mTextF_text.text;
    }
    
    if ([str isEqualToString:@"评论成功"]) {
        self.mTextF_text.text = @"";
    }
    if (self.mInt_unit_class == 3){
        for (int i=0; i<self.mArr_list_class.count; i++) {
            ClassModel *classModel = [self.mArr_list_class objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                [classModel.mArr_comment insertObject:tempModel atIndex:0];
                break;
            }
        }
    }else{
        for (int i=0; i<self.mArr_list.count; i++) {
            ClassModel *classModel = [self.mArr_list objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:tableID]) {
                [classModel.mArr_comment insertObject:tempModel atIndex:0];
                break;
            }
        }
    }
    [self.mTableV_list reloadData];
}

//获取文章的附加信息回调
-(void)GetArthInfo:(NSNotification *)noti{
    GetArthInfoModel *model = noti.object;
    //判断是否需要点赞请求
    [self sendLike:model];
    if (self.mInt_unit_class == 3){
        for (int i=0; i<self.mArr_list_class.count; i++) {
            ClassModel *classModel = [self.mArr_list_class objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                classModel.mModel_info = model;
                break;
            }
        }
    }else{
        for (int i=0; i<self.mArr_list.count; i++) {
            ClassModel *classModel = [self.mArr_list objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:model.TabIDStr]) {
                classModel.mModel_info = model;
                break;
            }
        }
    }
}

//收到文章的附加信息后，判断是否需要发送点赞请求
-(void)sendLike:(GetArthInfoModel *)model{
    if (model.Likeflag >=0){//没有点赞，发送点赞请求
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:BUGFROM] isEqual:@"ArthDetailViewController"]) {
            
        }else{
            [[ShareHttp getInstance] shareHttpAirthLikeIt:model.TabIDStr Flag:[NSString stringWithFormat:@"%d",model.Likeflag]];
            [self ProgressViewLoad:@"点赞中..."];
        }
    }else{//已赞
        self.mProgressV.labelText = @"已赞";
        self.mProgressV.mode = MBProgressHUDModeCustomView;
        [self.mProgressV show:YES];
        [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    }
}

//通知文章详情界面刷新点赞
-(void)AirthLikeIt:(NSNotification *)noti{
    NSString *str = [noti.object objectForKey:@"str"];
    self.mProgressV.labelText = str;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
    
    //
    NSString *aid = [noti.object objectForKey:@"aid"];
    if (self.mInt_unit_class == 3){
        for (int i=0; i<self.mArr_list_class.count; i++) {
            ClassModel *classModel = [self.mArr_list_class objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:aid]) {
                classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                classModel.mModel_info.Likeflag = -1;
                break;
            }
        }
    }else{
        for (int i=0; i<self.mArr_list.count; i++) {
            ClassModel *classModel = [self.mArr_list objectAtIndex:i];
            if ([classModel.TabIDStr isEqual:aid]) {
                classModel.LikeCount = [NSString stringWithFormat:@"%d",[classModel.LikeCount intValue]+1];
                classModel.mModel_info.Likeflag = -1;
                break;
            }
        }
    }
    [self.mTableV_list reloadData];
}

//获取到头像后，更新界面
-(void)TopArthListIndexImg:(NSNotification *)noti{
    //刷新，布局
    [self.mProgressV hide:YES];
    [self.mTableV_list reloadData];
}

//通知学校界面，获取到的单位和个人数据,本单位或本班
-(void)UnitArthListIndex3:(NSNotification *)noti{
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
    
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        [self.mArr_list removeAllObjects];
        [self.mArr_list_class removeAllObjects];
    }
    if ([flag intValue] == 3) {
        [self.mArr_list addObjectsFromArray:array];
    }else{
        [self.mArr_list_class addObjectsFromArray:array];
    }
    
    [self.mTableV_list reloadData];
}

//通知学校界面，获取到的单位和个人数据,本单位或本班
-(void)AllMyClassArthList3:(NSNotification *)noti{
    [self.mProgressV hide:YES];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    
    NSDictionary *dic = noti.object;
    //    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    
    for (int i=0; i<array.count; i++) {
        ClassModel *model = [array objectAtIndex:i];
        //获取文章评论
        [[ShareHttp getInstance] shareHttpAirthCommentsList:model.TabIDStr Page:@"1" Num:@"5" Flag:@"2"];
    }
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        [self.mArr_list removeAllObjects];
    }
    [self.mArr_list addObjectsFromArray:array];
    [self.mTableV_list reloadData];
}

#pragma mark - TableViewdelegate&&TableViewdataSource

//表格开始滑动，
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.mView_popup.hidden = YES;
}

//每个cell返回的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell.frame.size.height;
    }
    return 0;
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mInt_unit_class == 3){
        return self.mArr_list_class.count;
    }else{
        return self.mArr_list.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"ClassTableViewCell";
    ClassTableViewCell *cell = (ClassTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    NSMutableArray *array = [NSMutableArray array];
    if (self.mInt_unit_class == 3){
        array = [NSMutableArray arrayWithArray:self.mArr_list_class];
    }else{
        array = [NSMutableArray arrayWithArray:self.mArr_list];
    }
    //显示具体界面
    ClassModel *model = [array objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.unitId]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_head setImage:img];
    }else{
        [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
//        [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
        [[ShowHttp getInstance] showHttpGetUnitLogo:[NSString stringWithFormat:@"%@",model.unitId] Size:@""];
    }
    cell.mImgV_head.frame = CGRectMake(10, 15, 42, 42);
    //姓名
    CGSize nameSize = [[NSString stringWithFormat:@"%@",model.UserName] sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_name.frame = CGRectMake(62, 18, nameSize.width, cell.mLab_name.frame.size.height);
    cell.mLab_name.text = model.UserName;
    //发布单位
    NSString *tempUnit;
    if (model.className.length>0) {
        tempUnit = [NSString stringWithFormat:@"(%@)",model.className];
    }else{
        tempUnit = [NSString stringWithFormat:@"(%@)",model.UnitName];
    }
    CGSize unitSize = [tempUnit sizeWithFont:[UIFont systemFontOfSize:14]];
    cell.mLab_class.frame = CGRectMake(cell.mLab_name.frame.origin.x+cell.mLab_name.frame.size.width, 18, unitSize.width, cell.mLab_class.frame.size.height);
    cell.mLab_class.text = tempUnit;
    //判断是否添加班级的点击事件
    if (self.mInt_unit_class == 2&&model.className.length>0) {
        cell.ClassDelegate = self;
        [cell classLabClick];
    }
    //添加图片点击事件
    [cell thumbImgClick];
    cell.mModel_class = model;
    NSLog(@"classModel.mArr_comment.count = %lu",model.mArr_comment.count);

    cell.delegate = self;
    cell.tag = indexPath.row;
    //添加头像点击事件
    [cell headImgClick];
    cell.headImgDelegate = self;
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
    }
    if (model.Abstracts.length==0) {
        contentSize = CGSizeMake([dm getInstance].width-82, 0);
        cell.mView_background.hidden = YES;
    }
    cell.mLab_content.frame = CGRectMake(62+3, cell.mLab_assessContent.frame.origin.y+cell.mLab_assessContent.frame.size.height+5, contentSize.width, contentSize.height);
    
    cell.mLab_content.text = model.Abstracts;
    
    //详情背景色
    cell.mView_background.frame = CGRectMake(62, cell.mLab_content.frame.origin.y-4, [dm getInstance].width-72, contentSize.height+4);
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
                [cell.mImgV_1 setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
                [cell.mImgV_1 sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
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
    cell.mLab_time.frame = CGRectMake(62, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    //点赞评论按钮
    cell.mBtn_comment.frame = CGRectMake([dm getInstance].width-10-26, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height, 40, 35);
    [cell.mBtn_comment setImage:[UIImage imageNamed:@"popupWindow_like_comment"] forState:UIControlStateNormal];
    
    //点赞
    CGSize likeSize = [[NSString stringWithFormat:@"%@",model.LikeCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_likeCount.frame = CGRectMake(cell.mBtn_comment.frame.origin.x-10-likeSize.width, cell.mLab_time.frame.origin.y, likeSize.width, cell.mLab_likeCount.frame.size.height);
    cell.mLab_likeCount.text = model.LikeCount;
    cell.mLab_like.frame = CGRectMake(cell.mLab_likeCount.frame.origin.x-cell.mLab_like.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_like.frame.size.width, cell.mLab_like.frame.size.height);
    //评论
    //    CGSize feeBackSize = [[NSString stringWithFormat:@"%@",model.FeeBackCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    //    cell.mLab_assessCount.frame = CGRectMake(cell.mLab_like.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, feeBackSize.width, cell.mLab_assessCount.frame.size.height);
    //    cell.mLab_assessCount.text = model.FeeBackCount;
    //    cell.mLab_assess.frame = CGRectMake(cell.mLab_assessCount.frame.origin.x-cell.mLab_assess.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_assess.frame.size.width, cell.mLab_assess.frame.size.height);
    cell.mLab_assess.hidden = YES;
    cell.mLab_assessCount.hidden = YES;
    //点击量
    CGSize clickSize = [[NSString stringWithFormat:@"%@",model.ClickCount] sizeWithFont:[UIFont systemFontOfSize:10]];
    cell.mLab_clickCount.frame = CGRectMake(cell.mLab_like.frame.origin.x-likeSize.width-10, cell.mLab_time.frame.origin.y, clickSize.width, cell.mLab_assessCount.frame.size.height);
    cell.mLab_clickCount.text = model.ClickCount;
    cell.mLab_click.frame = CGRectMake(cell.mLab_clickCount.frame.origin.x-cell.mLab_click.frame.size.width, cell.mLab_time.frame.origin.y, cell.mLab_click.frame.size.width, cell.mLab_click.frame.size.height);
    NSUInteger h = 0;
    for(int i=0;i<model.mArr_comment.count;i++)
    {
        commentsListModel *tempModel = [model.mArr_comment objectAtIndex:i];
        
        NSString *string1 = tempModel.UserName;
        NSString *string2 = tempModel.Commnets;
        //        NSString *string1 = [self.nameArr objectAtIndex:i ];
        //        NSString *string2 = [self.commentArr objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];
        //        NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:string];
        //        NSRange range = NSMakeRange(0, atrString.length);
        //        NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
        CGRect rect=[string boundingRectWithSize:CGSizeMake(cell.frame.size.width-65, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]  context:nil];
        
        h = h+rect.size.height;
        
    }
    
    if(model.mArr_comment.count == 0)
    {
        cell.tableview.frame = CGRectZero;
        cell.backImgV.frame = CGRectZero;
        cell.moreBtn.frame = CGRectZero;
        
    }
    else
    {
        if(model.mArr_comment.count<5)
        {
            cell.moreBtn.frame = CGRectZero;
            cell.tableview.frame = CGRectMake(62, cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height+5, [dm getInstance].width-65, h+7);
            cell.backImgV.frame = CGRectMake(62,  cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height-4, [dm getInstance].width-65, h+13);
            UIImage *backImage = [UIImage imageNamed:@"bj.png"];
            // The background should be pinned to the left and not stretch.
            backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.height - 1, 0, 0, 0)];
            cell.backImgV.image = backImage;
            //            cell.moreBtn.frame = CGRectMake(62, cell.backImgV.frame.origin.y+cell.backImgV.frame.size.height+5, [dm getInstance].width-65, 30);
            
            
        }
        else{
            cell.tableview.frame = CGRectMake(62, cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height+5, [dm getInstance].width-65, h+7);
            cell.backImgV.frame = CGRectMake(62,  cell.mLab_click.frame.origin.y+cell.mLab_click.frame.size.height-4, [dm getInstance].width-65, h+13);
            UIImage *backImage = [UIImage imageNamed:@"bj.png"];
            // The background should be pinned to the left and not stretch.
            backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.height - 1, 0, 0, 0)];
            cell.backImgV.image = backImage;
            cell.moreBtn.frame = CGRectMake(62, cell.backImgV.frame.origin.y+cell.backImgV.frame.size.height+5, [dm getInstance].width-65, 30);
            
        }
        
        
        
    }
    
    cell.tableview.backgroundColor = [UIColor clearColor];
    
    
    cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height+h+15+cell.moreBtn.frame.size.height+5);
    
//    cell.frame = CGRectMake(0, 0, [dm getInstance].width, cell.mLab_time.frame.origin.y+cell.mLab_time.frame.size.height);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = [NSMutableArray array];
    if (self.mInt_unit_class == 3){
        array = [NSMutableArray arrayWithArray:self.mArr_list_class];
    }else{
        array = [NSMutableArray arrayWithArray:self.mArr_list];
    }
    ClassModel *ClassModel = [array objectAtIndex:indexPath.row];
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

-(void)ProgressViewLoad:(NSString *)title{
    self.mView_popup.hidden = YES;
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = title;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

//点击点赞评论按钮
-(void)ClassTableViewCellCommentBtn:(ClassTableViewCell *)topArthListCell Btn:(UIButton *)btn{
    self.mView_popup.mModel_class = topArthListCell.mModel_class;
    //得到当前点击的button相对于整个view的坐标
    CGRect parentRect = [btn convertRect:btn.bounds toView:self.view];
    self.mView_popup.hidden = NO;
    self.mView_popup.frame = CGRectMake(parentRect.origin.x-120, parentRect.origin.y, self.mView_popup.frame.size.width, self.mView_popup.frame.size.height);
    if (topArthListCell.mModel_class.mModel_info.TabID >0) {//获取到
        if (topArthListCell.mModel_class.mModel_info.Likeflag >=0){//没有点赞，发送点赞请求
            [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
        }else{//已赞
            [self.mView_popup.mBtn_like setTitle:@"已赞" forState:UIControlStateNormal];
        }
    }else{
        [self.mView_popup.mBtn_like setTitle:@"点赞" forState:UIControlStateNormal];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    [self ProgressViewLoad];
    //标注为刷新
    self.mInt_flag = 1;
    //判断应该加载单位1还是班级2
    if (self.mInt_unit_class == 1) {
        //刚进入学校圈，或者下拉刷新时执行
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
    } else if (self.mInt_unit_class == 2){
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"5" sectionFlag:@"2" RequestFlag:@"3"];//单位
    }else if (self.mInt_unit_class == 3){
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"5" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
    }
}
- (void)footerRereshing{
    //不是刷新
    self.mInt_flag = 0;
    if (self.mArr_list.count>=5) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        //判断应该加载单位1还是班级2
        if (self.mInt_unit_class == 1) {
            int a = (int)self.mArr_list.count/5+1;
            [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
        } else if (self.mInt_unit_class == 2){
            int a = (int)self.mArr_list.count/5+1;
            [[ClassHttp getInstance] classHttpAllMyClassArthList:[NSString stringWithFormat:@"%d",a] Num:@"5" sectionFlag:@"2" RequestFlag:@"3"];//单位
        }else if (self.mInt_unit_class == 3){
            
        }
        
        [self ProgressViewLoad];
    }else if (self.mArr_list_class.count>=5){
        int a = (int)self.mArr_list_class.count/5+1;
        [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"5" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
        [self ProgressViewLoad];
    } else {
        [self loadNoMore];
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

//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}

//cell中，点击班级时的回调
-(void)ClassTableViewCellClassTapPress:(ClassTableViewCell *)topArthListCell{
    ClassModel *model = [self.mArr_list objectAtIndex:topArthListCell.tag];
    D("sjdlhsglfkhgilw;fghejkrhn;-===%ld,%@",(long)topArthListCell.tag,model.className);
    //重新跳转到当前界面,显示当前班级中的所有数据
    ClassTopViewController *topView = [[ClassTopViewController alloc] init];
    topView.mInt_unit_class = 3;
    topView.mStr_navName = model.className;
    topView.mStr_classID = model.classID;
    [utils pushViewController:topView animated:YES];
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
//        UIImageView * imageView = (UIImageView *)[self.view viewWithTag: i+10000];
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
    self.navigationController.title = @"";
    [self.navigationController pushViewController:browser animated:YES];
}

- (void) ClassTableViewCellTapPress1:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self.view viewWithTag: i+10000];
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
    self.navigationController.title = @"";
    [self.navigationController pushViewController:browser animated:YES];
}


- (void) ClassTableViewCellTapPress2:(ClassTableViewCell *) topArthListCell ImgV:(UIImageView *)img{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
//    for (int i = 0; i < [topArthListCell.mModel_class.Thumbnail count]; i++) {
//        // 替换为中等尺寸图片
//        NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [topArthListCell.mModel_class.Thumbnail objectAtIndex:i]];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString: getImageStrUrl]; // 图片路径
//        UIImageView * imageView = (UIImageView *)[self.view viewWithTag: i+10000];
//        photo.srcImageView = imageView;
//        [photos addObject:photo];
//    }
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
    self.navigationController.title = @"";
    [self.navigationController pushViewController:browser animated:YES];
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
        //        D("tempModel.unitType-====%@",tempModel.unitType);
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mView_text.hidden = NO;
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height-keyboardSize.height-51, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}
- (void) keyboardWasHidden:(NSNotification *) notif{
    self.mView_text.hidden = YES;
    NSDictionary *userInfo = [notif userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.mView_text.frame = CGRectMake(0, [dm getInstance].height, [dm getInstance].width, 51);
                     }
                     completion:^(BOOL finished){
                         ;
                     }];
}

//键盘点击DO
#pragma mark - UITextView Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        //若其有输入内容，则发送
        if (self.mTextF_text.text.length>0) {
            //            [self clickSendBtn];
        }
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
