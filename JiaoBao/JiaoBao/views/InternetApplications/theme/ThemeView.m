//
//  ThemeView.m
//  JiaoBao
//
//  Created by Zqw on 14-12-16.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "ThemeView.h"
#import "Reachability.h"
#import "MobClick.h"

@implementation ThemeView
//@synthesize mScrollV_share,mTableV_detail,mTableV_difine,mInt_index,mArr_tabel,mBtn_add,mLab_name,mArr_difine;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        //做bug服务器显示当前的哪个界面
        NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
        [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
        //将我的主题通知界面
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnjoyInterestList" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnjoyInterestList:) name:@"EnjoyInterestList" object:nil];
//        //获取到单位头像后，刷新界面
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShowViewNew" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowViewNew) name:@"refreshShowViewNew" object:nil];
//        
//        self.mArr_tabel = [NSMutableArray array];
//        self.mArr_difine = [NSMutableArray array];
//        self.mArr_difine = [NSMutableArray arrayWithObjects:@"最新更新主题",@"我关注及我参与的主题", nil];
//        self.mInt_index = 1;
//        [self.mArr_tabel addObjectsFromArray:self.mArr_difine];
//        
//        //scrollview
////        self.mScrollV_share = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
////        [self addSubview:self.mScrollV_share];
//        
//        //表格,更改里面的自定义cell
////        self.mTableV_difine = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 50)];
////        self.mTableV_difine.delegate = self;
////        self.mTableV_difine.dataSource = self;
////        self.mTableV_difine.tag = 1;
////        self.mTableV_difine.scrollEnabled = NO;
////        [self.mScrollV_share addSubview:self.mTableV_difine];
//        
//        //表格的标签
////        self.mLab_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [dm getInstance].width, 20)];
////        self.mLab_name.backgroundColor = [UIColor grayColor];
////        self.mLab_name.text = @"  我关注及我参与的主题";
////        self.mLab_name.font = [UIFont systemFontOfSize:12];
////        [self.mScrollV_share addSubview:self.mLab_name];
//        
//        //表格,更改里面的自定义cell
////        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height, [dm getInstance].width, 0)];
//        self.mTableV_detail = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height)];
//        self.mTableV_detail.delegate = self;
//        self.mTableV_detail.dataSource = self;
////        self.mTableV_detail.scrollEnabled = NO;
//        self.mTableV_detail.tag = 2;
////        [self.mScrollV_share addSubview:self.mTableV_detail];
//        [self addSubview:self.mTableV_detail];
//        [self.mTableV_detail addHeaderWithTarget:self action:@selector(headerRereshing)];
//        self.mTableV_detail.headerPullToRefreshText = @"下拉刷新";
//        self.mTableV_detail.headerReleaseToRefreshText = @"松开后刷新";
//        self.mTableV_detail.headerRefreshingText = @"正在刷新...";
        
    }
    return self;
}

-(void)ProgressViewLoad{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self];
}
//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self];
        return YES;
    }else{
        return NO;
    }
}

//切换账号时，更新数据
-(void)RegisterView:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self];
    [dm getInstance].mImt_showUnRead = 0;
    [dm getInstance].mImt_shareUnRead = 0;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
//        return self.mArr_tabel.count;
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TopArthListCell";
    TopArthListCell *cell = (TopArthListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[TopArthListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopArthListCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (TopArthListCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"TopArthListCell" bundle:[NSBundle mainBundle]];
//        [self.mTableV_detail registerNib:n forCellReuseIdentifier:indentifier];
    }
//    if (tableView.tag == 1){
    
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 1) {
        return 20;
    }else{
        return 50;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
