//
//  AddQuestionViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "KnowledgeHttp.h"
#import "TableViewWithBlock.h"
#import "ProviceModel.h"
#import "AllCategoryModel.h"
#import "CategoryViewController.h"

@interface AddQuestionViewController ()
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSArray *provinceArr;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITextField *selectedTF;
@property(nonatomic,strong)ProviceModel *proviceModel;
@end

@implementation AddQuestionViewController

-(void)knowledgeHttpGetProvice:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        self.dataArr = arr;
        self.provinceArr = arr;
        
    }
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        return self.dataArr.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        ProviceModel *model = [self.dataArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.CnName ;
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
            ProviceModel *model = [self.dataArr objectAtIndex:indexPath.row];
            self.selectedTF.text = model.CnName;
            self.proviceModel = model;
        }];
        if([self.selectedTF isEqual:self.provinceTF])
        {
            self.regionTF.text = @"";
            self.countyTF.text = @"";
        }
        if([self.selectedTF isEqual:self.regionTF])
        {
            self.countyTF.text = @"";

        }
        self.isOpen = NO;
        
        
    }];
    
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:2];
    [self.view addSubview:self.mTableV_name];
    

}
-(void)knowledgeHttpGetCity:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        self.dataArr = arr;
        
    }
    [self.mTableV_name reloadData];


}
-(void)GetAllCategory:(id)sender
{
    NSDictionary *dic = [sender object];
    self.mArr_AllCategory =[dic objectForKey:@"array"] ;
    CategoryViewController *detailVC = [[CategoryViewController alloc]init];
    detailVC.mArr_AllCategory = self.mArr_AllCategory;
    [self.navigationController presentViewController:detailVC animated:NO completion:^{
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedTF = self.provinceTF;
    if([self.provinceTF.text isEqualToString:@""])
    {
        D("provinceTF_text = %@",self.provinceTF.text);

    }
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"评论"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[KnowledgeHttp getInstance]knowledgeHttpGetProvice];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"knowledgeHttpGetProvice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knowledgeHttpGetProvice:) name:@"knowledgeHttpGetProvice" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"knowledgeHttpGetCity" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knowledgeHttpGetCity:) name:@"knowledgeHttpGetCity" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GetAllCategory" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetAllCategory:) name:@"GetAllCategory" object:nil];
    


}



- (IBAction)provinceBtnAction:(id)sender {
    self.selectedTF = self.provinceTF;
    self.dataArr = self.provinceArr;
    [self.mTableV_name reloadData];

    if(self.isOpen == NO)
    {
           [UIView animateWithDuration:0.3 animations:^{
        self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 44*self.dataArr.count);

        
    } completion:^(BOOL finished){
    }];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;


    
}

- (IBAction)regionBtnAction:(id)sender {
    self.selectedTF = self.regionTF;
    self.countyTF.text = @"";
    [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"1"];
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 44*5);
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.regionTF.frame.origin.x, self.regionTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;
}

- (IBAction)countyBtnAction:(id)sender {
    self.selectedTF = self.countyTF;
    [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"2"];
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, 44*5);
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableV_name.frame =  CGRectMake(self.countyTF.frame.origin.x, self.countyTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
        }];
    }
    self.isOpen = !self.isOpen;
}

- (IBAction)categaryBtnAction:(id)sender {
    [[KnowledgeHttp getInstance]GetAllCategory];


}

- (IBAction)addQuestionAction:(id)sender {
    AllCategoryModel *model = [self.mArr_AllCategory objectAtIndex:1];
    NSString *categoryStr = [model.mArr_Category objectAtIndex:1];
    NSString *subItemStr = [model.mArr_subItem objectAtIndex:1];
    [[KnowledgeHttp getInstance]NewQuestionWithCategoryId:@"48" Title:@"李世民和杨贵妃是什么关系" KnContent:@"唐朝历史问题" TagsList:@"" QFlag:@"" AreaCode:@"" atAccIds:@""];
    
}

-(void)myNavigationGoback{
    
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
