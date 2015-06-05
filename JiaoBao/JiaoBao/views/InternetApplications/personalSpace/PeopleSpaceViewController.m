//
//  PeopleSpaceViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/6/4.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PeopleSpaceViewController.h"

@interface PeopleSpaceViewController ()

@end

@implementation PeopleSpaceViewController
@synthesize mTableV_personalS,mNav_navgationBar,mProgressV,mArr_personalS;

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setValueModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mArr_personalS = [NSMutableArray array];
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"个人中心"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    //表格
    self.mTableV_personalS.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    
    self.mProgressV = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.mProgressV];
    self.mProgressV.delegate = self;
}

//设置显示值
-(void)setValueModel{
    [self.mArr_personalS removeAllObjects];
    NSString *trueName = [dm getInstance].TrueName;
    NSString *nickName = [dm getInstance].NickName;
    NSMutableArray *tempArr0 = [NSMutableArray arrayWithObjects:nickName,@"账号信息",@"手机",@"邮箱",@"密码",@"所在单位", nil];
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithObjects:trueName,[dm getInstance].jiaoBaoHao,@"",@"",@"修改密码",@"", nil];
    for (int i=0; i<6; i++) {
        PersonalSpaceModel *model = [[PersonalSpaceModel alloc] init];
        model.mStr_nickName = [NSString stringWithFormat:@"%@",[tempArr0 objectAtIndex:i]];
        model.mStr_trueName = [NSString stringWithFormat:@"%@",[tempArr1 objectAtIndex:i]];
        [self.mArr_personalS addObject:model];
    }
    [self.mTableV_personalS reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_personalS.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else{
        return 44;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"PeopleSpaceTableViewCell";
    PeopleSpaceTableViewCell *cell = (PeopleSpaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PeopleSpaceTableViewCell" owner:self options:nil] lastObject];
    }
    PersonalSpaceModel *model = [self.mArr_personalS objectAtIndex:indexPath.row];
    
    if (indexPath.row ==0) {
        cell.mImgV_head.hidden = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSString *imgPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[dm getInstance].jiaoBaoHao]];
        UIImage *img= [UIImage imageWithContentsOfFile:imgPath];
        if (img.size.width>0) {
            [cell.mImgV_head setImage:img];
        }else{
            [cell.mImgV_head setImage:[UIImage imageNamed:@"root_img"]];
            //获取头像
            [[ExchangeHttp getInstance] getUserInfoFace:[dm getInstance].jiaoBaoHao];
        }
        cell.mImgV_head.frame = CGRectMake(10, 10, cell.mImgV_head.frame.size.width, cell.mImgV_head.frame.size.height);
        cell.mLab_nickName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15, [dm getInstance].width-75, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(cell.mImgV_head.frame.size.width+20, 15+cell.mLab_nickName.frame.size.height+5, [dm getInstance].width-75, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 69, [dm getInstance].width, .5);
    }else{
        cell.mImgV_head.hidden = YES;
        cell.mLab_nickName.frame = CGRectMake(15, 10, cell.mLab_nickName.frame.size.width, cell.mLab_nickName.frame.size.height);
        cell.mLab_trueName.frame = CGRectMake(100, 10, 200, cell.mLab_nickName.frame.size.height);
        cell.mLab_line.frame = CGRectMake(0, 43, [dm getInstance].width, .5);
    }
    cell.mLab_nickName.text = model.mStr_nickName;
    cell.mLab_trueName.text = model.mStr_trueName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 1;
        [utils pushViewController:reviseName animated:YES];
    }else if (indexPath.row == 4){
        ReviseNameViewController *reviseName = [[ReviseNameViewController alloc] init];
        reviseName.mInt_flag = 2;
        [utils pushViewController:reviseName animated:YES];
    }
}

//导航条返回按钮回调
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
