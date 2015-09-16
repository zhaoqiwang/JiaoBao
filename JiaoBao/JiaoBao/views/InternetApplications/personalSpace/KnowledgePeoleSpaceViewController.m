//
//  KnowledgePeoleSpaceViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/9/16.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "KnowledgePeoleSpaceViewController.h"
#import "KpeopleSpaceCell.h"
#import "MyNavigationBar.h"
#import "HeadCell.h";

@interface KnowledgePeoleSpaceViewController ()<MyNavigationDelegate>
@property(nonatomic,strong)NSArray *questionArr;
@property(nonatomic,strong)NSArray *categoryArr;
@property(nonatomic,strong)NSArray *datasource;
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;


@end

@implementation KnowledgePeoleSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
//    self.questionArr = [NSArray arrayWithObjects:@"我答过得问题",@"我提出的问题",@"邀请我回答的问题",@"我关注的问题", nil];
//    self.categoryArr = [NSArray arrayWithObjects:@"", nil];
    self.datasource = [NSArray arrayWithObjects:@"我答过得问题",@"我提出的问题",@"邀请我回答的问题",@"我关注的问题", nil];
    HeadCell *cell = [[HeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeadCell" owner:self options:nil];
    if ([nib count]>0) {
        cell = (HeadCell *)[nib objectAtIndex:0];
        //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
    }
    //HeadCell *cellView = [[[NSBundle mainBundle] loadNibNamed:@"HeadCell" owner:self options:nil] lastObject];
    UIView *headView = [[UIView alloc]initWithFrame:cell.frame];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:cell];
    self.tableView.tableHeaderView = headView;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark tableview代理方法

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.datasource objectAtIndex:section];
    return self.datasource.count;

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"KpeopleSpaceCell";
    KpeopleSpaceCell *cell = (KpeopleSpaceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KpeopleSpaceCell" owner:self options:nil] lastObject];
    }

    cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
    
    return cell;
    
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
