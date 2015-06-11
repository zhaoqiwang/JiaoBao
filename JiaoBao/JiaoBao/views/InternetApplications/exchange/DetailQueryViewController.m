//
//  DetailQueryViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/3/6.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "DetailQueryViewController.h"
#import "SignInHttp.h"
#import "DetailQueryCell.h"

@interface DetailQueryViewController ()
@property(nonatomic,strong)NSArray *keyArr;//把需要的字典中的key存到数组中
@property(nonatomic,strong)NSArray *dataSource;//本界面的数据源

@end

@implementation DetailQueryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    //去掉多余的cell分割线
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.keyArr = [NSArray arrayWithObjects:@"sWorkPlace",@"dSdate",@"dEdate",@"sSubject",@"dRecDate", nil];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"日程记录"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getQueryResult" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getQueryResult:) name:@"getQueryResult" object:nil];
    NSString *unitId = [NSString stringWithFormat:@"%d",[dm getInstance].UID];//单位ID
    NSString *userId = [NSString stringWithFormat:@"%@",[dm getInstance].userInfo.UserID];//用户ID
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.selectedDateStr,unitId,userId, nil] forKeys:[NSArray arrayWithObjects:@"WorkPlanDate",@"UnitID",@"UserID", nil]];
    [[SignInHttp getInstance]querySchedule:dic];
   ;
    self.selectedDate.text = self.selectedDateStr;
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view from its nib.
}
-(void)getQueryResult:(id)sender
{
    self.dataSource = [sender object];
    [utils logArr:self.dataSource];
    [self.tableView reloadData];
//    [self logDic:valueDic];
//    
//    for(int i=1;i<self.labelCollection.count;i++)
//    {
//        UILabel *valueLabel = [self.labelCollection objectAtIndex:i];
//        valueLabel.text = [valueDic objectForKey:[self.keyArr objectAtIndex:i-1]];
//        
//    }
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"dataSource_count = %ld",self.dataSource.count);
    return self.dataSource.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//
//}

- (void)configureCell:(DetailQueryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    for(int i=0;i<cell.labelCollection.count;i++)
    {
            UILabel *cellLabel = [cell.labelCollection objectAtIndex:i];
        cellLabel.text = [dic objectForKey:[self.keyArr objectAtIndex:i]];
        if(i==cell.labelCollection.count-1)
        {
            UILabel *cellLabel = [cell.labelCollection objectAtIndex:i];
            cellLabel.text = [dic objectForKey:[self.keyArr objectAtIndex:i]];
            NSString *dateStr = [cellLabel.text stringByReplacingOccurrencesOfString:@"0:00:00" withString:@""];
            cellLabel.text = dateStr;
            
        }
        
    }

    


    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    DetailQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  identifier];
    if(cell == nil)
    {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"DetailQueryCell" owner:self options:nil];
        cell = (DetailQueryCell*)[cellArr objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myNavigationGoback
{
    [utils popViewControllerAnimated:YES];
}
- (void)logDic:(NSDictionary *)dic
{
    NSError *error;
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    NSLog(@"dic[%ld]:%@",dic.count,str);
}
- (void)logArr:(NSArray *)arr
{
    
    NSError *error;
    NSString *tempStr1 = [[arr description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    NSLog(@"arr[%ld]:%@",arr.count,str);
    
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
