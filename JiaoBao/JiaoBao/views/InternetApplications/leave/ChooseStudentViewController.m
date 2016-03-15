//
//  ChooseStudentViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ChooseStudentViewController.h"

@interface ChooseStudentViewController ()

@end

@implementation ChooseStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mArr_student = [NSMutableArray array];
    //根据类型，判断是那种情况
    if (self.mInt_flag == 0) {//家长
        self.mArr_student = [dm getInstance].mArr_leaveStudent;
    }else if (self.mInt_flag == 1){//班主任
        
    }else if (self.mInt_flag == 2){//请假理由
        //用学生信息model代替，只为传值
        for (int i=0; i<4; i++) {
            MyStdInfo *model = [[MyStdInfo alloc] init];
            if (i==0) {
                model.StdName = @"补课";
            }else if (i==1){
                model.StdName = @"病假";
            }else if (i==2){
                model.StdName = @"事假";
            }else if (i==3){
                model.StdName = @"其他";
            }
        }
    }
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height);
    
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_student.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyStdInfo *model = [self.mArr_student objectAtIndex:indexPath.row];
    static NSString *simpleIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    cell.textLabel.text = model.StdName;
    return cell;
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 44;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyStdInfo *model = [self.mArr_student objectAtIndex:indexPath.row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ChooseStudentViewCSelect:)]) {
        [self.delegate ChooseStudentViewCSelect:model];
    }
    [utils popViewControllerAnimated:YES];
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
