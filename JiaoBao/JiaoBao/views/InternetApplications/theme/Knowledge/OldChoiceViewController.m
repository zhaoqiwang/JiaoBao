//
//  OldChoiceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/9/9.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "OldChoiceViewController.h"
#import "GetPickedViewController.h"

@interface OldChoiceViewController ()

@end

@implementation OldChoiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取往期精选
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PickedIndex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PickedIndex:) name:@"PickedIndex" object:nil];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"往期精选"];
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
    //发送获取往期精选
    [[KnowledgeHttp getInstance] PickedIndexWithNumPerPage:@"20" pageNum:@"1" RowCount:@"0"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}

//获取往期精选
-(void)PickedIndex:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mTableV_list headerEndRefreshing];
    [self.mTableV_list footerEndRefreshing];
    NSMutableDictionary *dic = noti.object;
    NSString *code = [dic objectForKey:@"ResultCode"];
    if ([code integerValue] ==0) {
        NSMutableArray *array  = [dic objectForKey:@"array"];
        if (self.mInt_reloadData ==0) {
            self.mArr_list = [NSMutableArray arrayWithArray:array];
        }else{
            [self.mArr_list addObjectsFromArray:array];
        }
        [self.mTableV_list reloadData];
    }else{
        NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
    }
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"OldChoiceTableViewCell";
    OldChoiceTableViewCell *cell = (OldChoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[OldChoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OldChoiceTableViewCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (OldChoiceTableViewCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"OldChoiceTableViewCell" bundle:[NSBundle mainBundle]];
        [self.mTableV_list registerNib:n forCellReuseIdentifier:indentifier];
    }
    PickedIndexModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    //分割线
    cell.mLab_background.frame = CGRectMake(10, 0, [dm getInstance].width-10, .5);
    cell.mLab_background.textColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    //标题
    CGSize titleSize = [model.PTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-27-70, MAXFLOAT)];
    cell.mLab_title.frame = CGRectMake(9, 10, [dm getInstance].width-27-70, titleSize.height);
    cell.mLab_title.text = model.PTitle;
    cell.mLab_title.textColor = [UIColor colorWithRed:37/255.0 green:137/255.0 blue:209/255.0 alpha:1];
    //日期
    cell.mLab_time.frame = CGRectMake(9, cell.mLab_title.frame.origin.y+titleSize.height+10, cell.mLab_time.frame.size.width, cell.mLab_time.frame.size.height);
    cell.mLab_time.text = model.RecDate;
    cell.mLab_time.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    //图片
    NSString *tempUrl;
    if (model.ImgContent.count>0) {
        tempUrl = [NSString stringWithFormat:@"%@%@%@",[dm getInstance].url,model.baseImgUrl,[model.ImgContent objectAtIndex:0]];
    }
    D("ldghjalksgjaskl-===%@",tempUrl);
    [cell.mImgV_img sd_setImageWithURL:(NSURL *)tempUrl placeholderImage:[UIImage  imageNamed:@"root_img"]];
    cell.mImgV_img.frame = CGRectMake([dm getInstance].width-70-9, 10, 70, 50);
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    float height = 0.0;
    PickedIndexModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    //标题
    CGSize titleSize = [model.PTitle sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake([dm getInstance].width-27-70, MAXFLOAT)];
    height = height+10+titleSize.height+10+21+10;
    if (height>70) {
        return height;
    }
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PickedIndexModel *model = [self.mArr_list objectAtIndex:indexPath.row];
    GetPickedViewController *view = [[GetPickedViewController alloc] init];
    view.mModel_first = model;
    [utils pushViewController:view animated:YES];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.mInt_reloadData = 0;
    [self sendRequest];
}

- (void)footerRereshing{
    self.mInt_reloadData = 1;
    [self sendRequest];
}

-(void)sendRequest{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    NSString *page = @"";
    if (self.mInt_reloadData == 0) {
        page = @"1";
        [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    }else{
        NSMutableArray *array = self.mArr_list;
        if (array.count>=20&&array.count%20==0) {
            //检查当前网络是否可用
            if ([self checkNetWork]) {
                return;
            }
            page = [NSString stringWithFormat:@"%d",(int)array.count/20+1];
            [MBProgressHUD showMessage:@"加载中..." toView:self.view];
        } else {
            [self.mTableV_list headerEndRefreshing];
            [self.mTableV_list footerEndRefreshing];
            [MBProgressHUD showSuccess:@"没有更多了" toView:self.view];
            return;
        }
    }
    NSString *rowCount = @"0";
    if (self.mArr_list.count>0) {
        PickedIndexModel *model = [self.mArr_list objectAtIndex:self.mArr_list.count-1];
        rowCount = model.RowCount;
    }
    [[KnowledgeHttp getInstance] PickedIndexWithNumPerPage:@"20" pageNum:page RowCount:rowCount];
}

//检查当前网络是否可用
-(BOOL)checkNetWork{
    if([Reachability isEnableNetwork]==NO){
        [MBProgressHUD showError:NETWORKENABLE toView:self.view];
        return YES;
    }else{
        return NO;
    }
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [utils popViewControllerAnimated:YES];
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
