//
//  MobileUnitViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/6/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MobileUnitViewController.h"
#import "UnitTableViewCell.h"
#import "unitModel.h"
#import "MBProgressHUD.h"
#import "RegisterHttp.h"
#import "Reachability.h"
#import "MobClick.h"


@interface MobileUnitViewController ()<unitCellDelegate,MBProgressHUDDelegate>
{
    id _observer1,_observer2;
}
@property(nonatomic,strong)NSArray *unitArr;
@property(nonatomic,strong)UIButton *addBtn;


@end

@implementation MobileUnitViewController
-(void)dealloc
{
    //viewController销毁时释放通知
    [[NSNotificationCenter defaultCenter]removeObserver:_observer1];
    [[NSNotificationCenter defaultCenter]removeObserver:_observer2];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:UMMESSAGE];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak MobileUnitViewController *weakSelf = self;

    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"加入单位"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //设置tableview的frame
    self.tableView.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, 500);
    
    //去掉tableview没用的的cell的横线
    UIView *view = [[UIView alloc]init];
    self.tableView.tableFooterView = view;
    
    //获取手机自动匹配的单位数据
    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"GetMyMobileUnitList" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([note.object isKindOfClass:[NSString class]])
        {
            [MBProgressHUD showText:@"加载超时" toView:self.view];
            return ;
        }
        NSArray *arr = note.object;
        
        weakSelf.unitArr = arr;
        [weakSelf.tableView reloadData];
        
        
        
    }];
    //向服务器请求手机自动匹配单位数据
    [[RegisterHttp getInstance]registerHttpGetMyMobileUnitList:[dm getInstance].jiaoBaoHao];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    //点击加入单位获取返回信息
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"JoinUnitOP" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *dic = note.object;
        NSArray *keyArr =[dic allKeys];
        NSString *str = [keyArr objectAtIndex:0];
        NSString *ResultDesc = [dic objectForKey:str];
        if([str integerValue ] == 0)
        {
            [MBProgressHUD showText:@"加入成功" toView:self.view];
            [weakSelf.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            weakSelf.addBtn.enabled = NO;
            [[LoginSendHttp getInstance]getIdentityInformation];

            
        }
        else
        {
            [MBProgressHUD showText:ResultDesc toView:self.view];

            
        }
        
        
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma - mark tableview代理方法

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    

        return self.unitArr.count;
}




-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
        return 44;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *cellIdentifier = @"unitTabelViewCell";
        UnitTableViewCell *cell = (UnitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UnitTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        unitModel *unitModel = [self.unitArr objectAtIndex:indexPath.row];
        cell.unitNameLabel.text = unitModel.UnitName;
    NSString *identTypeLabelStr = [NSString stringWithFormat:@"(%@)",unitModel.Identity];

        cell.identTypeLabel.text =identTypeLabelStr;
    
        if([unitModel.AccId integerValue]>0)//accid>0 表示已加入
        {
            [cell.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = NO;
        }
        else//accid = 0 表示未加入
        {
            [cell.addBtn setTitle:@"加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = YES;
            
            
        }
        

        return cell;
        
        
        
    
}

#pragma -mark 点击addBtn的回调方法
-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *)cell
{
    self.addBtn = btn;
    unitModel *model = [self.unitArr objectAtIndex:cell.tag];
    if ([self checkNetWork]) {
        return;
    }
    //向服务器请求加入单位
    [[RegisterHttp getInstance]registerHttpJoinUnitOP:[dm getInstance].jiaoBaoHao option:@"0" tableStr:model.TabIdStr];
    
    
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

-(void)progressViewTishi:(NSString *)title{
    [MBProgressHUD showError:title toView:self.view];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    [MBProgressHUD showMessage:title toView:self.view];
}

-(void)myNavigationGoback{

    
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
