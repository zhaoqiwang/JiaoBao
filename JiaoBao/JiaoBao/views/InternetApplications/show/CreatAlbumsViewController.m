//
//  CreatAlbumsViewController.m
//  JiaoBao
//
//  Created by Zqw on 14-12-24.
//  Copyright (c) 2014年 JSY. All rights reserved.
//

#import "CreatAlbumsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "Reachability.h"
#import "MobClick.h"

@interface CreatAlbumsViewController ()

@end

@implementation CreatAlbumsViewController
@synthesize mNav_navgationBar,mLab_name,mTextF_name,mLab_desInfo,mTextF_desInfo,mLab_type,mStr_flag,mStr_unitID,mStr_type,mBtn_type,mTableV_type,mTextF_type,delegate;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //创建单位相册回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreateUnitPhotoGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CreateUnitPhotoGroup:) name:@"CreateUnitPhotoGroup" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"创建相册"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.mNav_navgationBar setRightBtnTitle:@"确定"];
    [self.view addSubview:self.mNav_navgationBar];
    
    //
    self.mLab_name.frame = CGRectMake(20, self.mNav_navgationBar.frame.size.height+10, self.mLab_name.frame.size.width, self.mLab_name.frame.size.height);
    self.mTextF_name.frame = CGRectMake(self.mLab_name.frame.origin.x+self.mLab_name.frame.size.width+10, self.mLab_name.frame.origin.y, self.mTextF_name.frame.size.width, self.mTextF_name.frame.size.height);
    self.mLab_desInfo.hidden = YES;
    self.mTextF_desInfo.hidden = YES;
    self.mLab_type.frame = CGRectMake(20, self.mLab_name.frame.origin.y+self.mLab_name.frame.size.height+20, self.mLab_type.frame.size.width, self.mLab_type.frame.size.height);
    self.mTextF_type.frame = CGRectMake(self.mLab_name.frame.origin.x+self.mLab_name.frame.size.width+10, self.mLab_type.frame.origin.y, self.mTextF_type.frame.size.width, self.mTextF_type.frame.size.height);
    self.mBtn_type.frame = self.mTextF_type.frame;
    self.mTableV_type.frame = CGRectMake(self.mTextF_type.frame.origin.x, self.mTextF_type.frame.origin.y+self.mTextF_type.frame.size.height, self.mTextF_type.frame.size.width, 0);
    
//    个人，0:私有；1：好友可访问；2：关注可访问；3：游客可访问，单位：0无限制，1单位内可见
    NSMutableArray *array ;
    if ([self.mStr_flag intValue] == 1) {
        array = [NSMutableArray arrayWithObjects:@"别人不可访问",@"好友可访问",@"关注可访问",@"游客可访问", nil];
    }else{
        array = [NSMutableArray arrayWithObjects:@"任何人可见",@"单位内可见", nil];
    }
    isOpened=NO;
    [self.mTableV_type initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        return array.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:[NSString stringWithFormat:@"%@",[array objectAtIndex:indexPath.row]]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.mTextF_type.text=cell.lb.text;
        self.mStr_type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self.mBtn_type sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self.mTableV_type.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_type.layer setBorderWidth:2];
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

//创建单位相册回调
-(void)CreateUnitPhotoGroup:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSString *flag = noti.object;
    if ([flag intValue] == 0) {//成功
        [MBProgressHUD showSuccess:@"创建成功" toView:self.view];
        //通知相册列表界面，重新刷新
        [self.delegate CreatePhotoGroupSuccess];
        [utils popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"创建失败" toView:self.view];
    }
}

- (IBAction)changeOpenStatus:(id)sender {
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.mTableV_type.frame;
            frame.size.height=0;
            [self.mTableV_type setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.mTableV_type.frame;
            frame.size.height=90;
            [self.mTableV_type setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [utils popViewControllerAnimated:YES];
}
-(void)navigationRightAction:(UIButton *)sender{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    if (self.mTextF_name.text.length == 0) {
        [MBProgressHUD showError:@"请输入相册名称" toView:self.view];
        return;
    }
    if (self.mStr_type.length==0) {
        [MBProgressHUD showError:@"请选择权限" toView:self.view];
        return;
    }
    if ([self.mStr_flag intValue] == 1) {
        [[ThemeHttp getInstance] themeHttpAddPhotoGroup:[dm getInstance].jiaoBaoHao PhotoName:self.mTextF_name.text viewType:self.mStr_type];
    }else{
        [[ThemeHttp getInstance] themeHttpCreateUnitPhotoGroup:self.mStr_unitID PhotoName:self.mTextF_name.text CreatBy:[dm getInstance].jiaoBaoHao DesInfo:@"来自手机" ViewType:self.mStr_type];
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
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
