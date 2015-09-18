//
//  AttentionCategoryVCViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/9/17.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AttentionCategoryVCViewController.h"
#import "categoryCell.h"
#import "MyNavigationBar.h"
#import "KnowledgeHttp.h"
#import "CategoryModel.h"
#import "UIImageView+WebCache.h"



@interface AttentionCategoryVCViewController ()<MyNavigationDelegate>
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;


@end

@implementation AttentionCategoryVCViewController
-(void)GetCategoryById:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSNotification *note = sender;
    
    NSString *code = [note.object objectForKey:@"ResultCode"];
    if([code integerValue]==0)
    {
        CategoryModel *model = [note.object objectForKey:@"model"];
        [self.datasource addObject:model];
        if(self.datasource.count == self.categoryArr.count )
        {
            NSArray *arr = [self.datasource sortedArrayUsingComparator:^NSComparisonResult(CategoryModel *p1, CategoryModel *p2){
                int p1_int = [p1.TabID intValue];
                NSNumber *p1_num = [NSNumber numberWithInt:p1_int ];
                

                int p2_int = [p2.TabID intValue];
                NSNumber *p2_num = [NSNumber numberWithInt:p2_int ];
                
                return [p1_num compare:p2_num];
            }];
            self.datasource =[NSMutableArray arrayWithArray:arr];
            [self.tableView reloadData];

        }

    }
    else
    {
        NSString *ResultDesc = [note.object objectForKey:@"ResultDesc"];
        [MBProgressHUD showError:ResultDesc toView:self.view];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetCategoryById" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetCategoryById:) name:@"GetCategoryById" object:nil];
    for(int i=0;i<self.categoryArr.count;i++)
    {
        [[KnowledgeHttp getInstance]GetCategoryById:[self.categoryArr objectAtIndex:i]];

    }
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"我关注的话题"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma - mark tableview代理方法

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 74 ;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"categoryCell";
    categoryCell *cell = (categoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:self options:nil] lastObject];
    }
    
    CategoryModel *model = [self.datasource objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.Subject;
    cell.contentLabel.text = model.Description;

//    cell.titleLabel.text = [self.datasource objectAtIndex:indexPath.row];
//    cell.contentLabel.text = self
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
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
