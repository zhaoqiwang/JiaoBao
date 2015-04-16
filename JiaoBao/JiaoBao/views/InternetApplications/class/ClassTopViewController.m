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
@synthesize mArr_list,mTableV_list,mNav_navgationBar,mProgressV,mInt_flag,mInt_unit_class,mStr_classID,mStr_navName,mArr_list_class;

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
        if ([dm getInstance].uType==1) {
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
        }else{
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
        }
    } else if(self.mInt_unit_class == 2) {
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"20" sectionFlag:@"2" RequestFlag:@"3"];//单位
    }else if (self.mInt_unit_class == 3){
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
    }
    
    [self ProgressViewLoad];
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
    //如果是刷新，将数据清除
    if (self.mInt_flag == 1) {
        [self.mArr_list removeAllObjects];
    }
    [self.mArr_list addObjectsFromArray:array];
    [self.mTableV_list reloadData];
}

#pragma mark - TableViewdelegate&&TableViewdataSource
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
    NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.JiaoBaoHao]];
    UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
    if (img.size.width>0) {
        [cell.mImgV_head setImage:img];
    }else{
        [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
        //获取头像
        [[ExchangeHttp getInstance] getUserInfoFace:model.JiaoBaoHao];
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
        if (model.Thumbnail.count>=6) {
            a=6;
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
            
            UIImageView *gridItem = [[UIImageView alloc] init];
            [gridItem setFrame:CGRectMake(0+(5+m)*x, y, m, m)];
            [gridItem sd_setImageWithURL:[NSURL  URLWithString:[model.Thumbnail objectAtIndex:i]] placeholderImage:[UIImage  imageNamed:@"photo_default"]];
            [cell.mView_img addSubview:gridItem];
        }
        if (model.Thumbnail.count>3) {
            cell.mView_img.frame = CGRectMake(62, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, [dm getInstance].width-72, m*2+10);
        }else{
            cell.mView_img.frame = CGRectMake(62, cell.mView_background.frame.origin.y+cell.mView_background.frame.size.height, [dm getInstance].width-72, m+10);
        }
    }else{
        cell.mView_img.hidden = YES;
        cell.mView_img.frame = cell.mView_background.frame;
    }
    
    //时间
    cell.mLab_time.frame = CGRectMake(62, cell.mView_img.frame.origin.y+cell.mView_img.frame.size.height, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
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

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    [self ProgressViewLoad];
    //标注为刷新
    self.mInt_flag = 1;
    //判断应该加载单位1还是班级2
    if (self.mInt_unit_class == 1) {
        //刚进入学校圈，或者下拉刷新时执行
        if ([dm getInstance].uType==1) {
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
        }else{
            [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
        }
    } else if (self.mInt_unit_class == 2){
        [[ClassHttp getInstance] classHttpAllMyClassArthList:@"1" Num:@"20" sectionFlag:@"2" RequestFlag:@"3"];//单位
    }else if (self.mInt_unit_class == 3){
        [[ClassHttp getInstance] classHttpUnitArthListIndex:@"1" Num:@"20" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
    }
}
- (void)footerRereshing{
    //不是刷新
    self.mInt_flag = 0;
    if (self.mArr_list.count>=20) {
        //检查当前网络是否可用
        if ([self checkNetWork]) {
            return;
        }
        //判断应该加载单位1还是班级2
        if (self.mInt_unit_class == 1) {
            int a = (int)self.mArr_list.count/20+1;
            if ([dm getInstance].uType==1) {
                [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" Flag:@"1" UnitID:[NSString stringWithFormat:@"%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
            }else{
                [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" Flag:@"2" UnitID:[NSString stringWithFormat:@"-%d",[dm getInstance].UID] order:@"" title:@"" RequestFlag:@"3"];
            }
        } else if (self.mInt_unit_class == 2){
            int a = (int)self.mArr_list.count/20+1;
            [[ClassHttp getInstance] classHttpAllMyClassArthList:[NSString stringWithFormat:@"%d",a] Num:@"20" sectionFlag:@"2" RequestFlag:@"3"];//单位
        }else if (self.mInt_unit_class == 3){
            
        }
        
        [self ProgressViewLoad];
    }else if (self.mArr_list_class.count>=20){
        int a = (int)self.mArr_list_class.count/20+1;
        [[ClassHttp getInstance] classHttpUnitArthListIndex:[NSString stringWithFormat:@"%d",a] Num:@"20" Flag:@"2" UnitID:self.mStr_classID order:@"" title:@"" RequestFlag:@"4"];
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
