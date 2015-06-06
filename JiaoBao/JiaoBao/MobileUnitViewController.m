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

@interface MobileUnitViewController ()<unitCellDelegate,MBProgressHUDDelegate>
{
    id _observer1,_observer2;
}
@property(nonatomic,strong)NSArray *unitArr;
@property (nonatomic,strong) MBProgressHUD *mProgressV;//
@property(nonatomic,strong)UIButton *addBtn;


@end

@implementation MobileUnitViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_observer1];
    [[NSNotificationCenter defaultCenter]removeObserver:_observer2];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.tableView.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height+self.mNav_navgationBar.frame.origin.y, [dm getInstance].width, 500);
    UIView *view = [[UIView alloc]init];
    self.tableView.tableFooterView = view;
    _observer2 = [[NSNotificationCenter defaultCenter]addObserverForName:@"GetMyMobileUnitList" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSArray *arr = note.object;
        NSLog(@"arr_count = %ld",arr.count);

        self.unitArr = arr;
        [self.tableView reloadData];
        
        
        
    }];
    [[RegisterHttp getInstance]registerHttpGetMyMobileUnitList:[dm getInstance].jiaoBaoHao];


    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
    _observer1 = [[NSNotificationCenter defaultCenter]addObserverForName:@"JoinUnitOP" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *str =note.object;
        if([str integerValue ] == 0)
        {
            [self progressViewTishi:@"加入成功"];
            [self.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            self.addBtn.enabled = NO;
            
            
            
        }
        else
        {
            [self progressViewTishi:@"加入失败"];
            
        }
        
        
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.unitArr = %ld",self.unitArr.count);
    

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
        cell.identTypeLabel.text =unitModel.Identity;
    
        if([unitModel.AccId integerValue]>0)
        {
            [cell.addBtn setTitle:@"已加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = NO;
        }
        else
        {
            [cell.addBtn setTitle:@"加入" forState:UIControlStateNormal];
            cell.addBtn.enabled = YES;
            
            
        }
        

        return cell;
        
        
        
    
}
-(void)ClickBtnWith:(UIButton *)btn cell:(UnitTableViewCell *)cell
{
    self.addBtn = btn;
    unitModel *model = [self.unitArr objectAtIndex:cell.tag];
    if ([self checkNetWork]) {
        return;
    }
    [[RegisterHttp getInstance]registerHttpJoinUnitOP:[dm getInstance].jiaoBaoHao option:@"1" tableStr:model.TabIdStr];
    
    
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

-(void)progressViewTishi:(NSString *)title{
    self.mProgressV.labelText = title;
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(noMore) onTarget:self withObject:nil animated:YES];
}

-(void)ProgressViewLoad:(NSString *)title{
    //检查当前网络是否可用
    if ([self checkNetWork]) {
        return;
    }
    self.mProgressV.mode = MBProgressHUDModeIndeterminate;
    self.mProgressV.labelText = title;
    [self.mProgressV show:YES];
    [self.mProgressV showWhileExecuting:@selector(Loading) onTarget:self withObject:nil animated:YES];
}

- (void)Loading {
    sleep(TIMEOUT);
    self.mProgressV.mode = MBProgressHUDModeCustomView;
    self.mProgressV.labelText = @"加载超时";
    sleep(2);
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
