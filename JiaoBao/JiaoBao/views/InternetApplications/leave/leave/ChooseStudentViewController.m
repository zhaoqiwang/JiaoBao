//
//  ChooseStudentViewController.m
//  JiaoBao
//
//  Created by Zqw on 16/3/15.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "ChooseStudentViewController.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface ChooseStudentViewController ()

@end

@implementation ChooseStudentViewController

-(instancetype)init{
    self = [super init];
    self.mArr_student = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获取指定班级的所有学生数据列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getClassStdInfoWithUID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassStdInfoWithUID:) name:@"getClassStdInfoWithUID" object:nil];
    //根据类型，判断是那种情况,先判断是请假理由还是选择学生
    if (self.mInt_flag == 0) {//选择请假学生0
        if (self.mInt_flagID == 0) {//家长
            self.mArr_student = [dm getInstance].mArr_leaveStudent;
        }else if (self.mInt_flagID == 1){//班主任
            if ([dm getInstance].mArr_leaveClass.count>0) {
                MyAdminClass *model = [[dm getInstance].mArr_leaveClass objectAtIndex:0];
                //获取当前班级中的学生
                [[LeaveHttp getInstance] getClassStdInfoWithUID:model.TabID];
                [MBProgressHUD showMessage:@"" toView:self.view];
            }else{
                [MBProgressHUD showError:@"暂时没查到管理的班级" toView:self.view];
            }
        }
    }else if (self.mInt_flag == 1) {//选择请假理由
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
            [self.mArr_student addObject:model];
        }
    }else if (self.mInt_flag == 2) {//选择年级
        
    }else if (self.mInt_flag == 3) {//选择班级
        
    }
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.mStr_navName];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    
    self.mTableV_list.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_list.tableFooterView = [[UIView alloc]init];
}

//获取指定班级的所有学生数据列表
-(void)getClassStdInfoWithUID:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    //对分组名字进行排序
    NSMutableArray *arrayTemp = [self userNameChineseSort:array Flag:1];
    self.mArr_student = arrayTemp;
    [self.mTableV_list reloadData];
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_student.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
    }
    if (self.mInt_flagID == 0) {//家长
        MyStdInfo *model = [self.mArr_student objectAtIndex:indexPath.row];
        cell.textLabel.text = model.StdName;
    }else if (self.mInt_flagID == 1){//班主任
        StuInfoModel *model = [self.mArr_student objectAtIndex:indexPath.row];
        cell.textLabel.text = model.StdName;
    }else if (self.mInt_flagID == 3){//年级
        UserClassInfo *model = [self.mArr_student objectAtIndex:indexPath.row];
        cell.textLabel.text = model.GradeName;
    }else if (self.mInt_flagID == 4){//班级
        UserClassInfo *model = [self.mArr_student objectAtIndex:indexPath.row];
        cell.textLabel.text = model.ClassName;
    }
    
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
    
    id model = [self.mArr_student objectAtIndex:indexPath.row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ChooseStudentViewCSelect:flag:flagID:)]) {
        [self.delegate ChooseStudentViewCSelect:model flag:self.mInt_flag flagID:self.mInt_flagID];
    }
    [utils popViewControllerAnimated:YES];
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [utils popViewControllerAnimated:YES];
}

//对人员1和分组2进行排序，
-(NSMutableArray *)userNameChineseSort:(NSMutableArray *)array Flag:(int)flag{
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[array count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        if (flag == 1) {
            StuInfoModel *model = [array objectAtIndex:i];
            chineseString.string=[NSString stringWithString:model.StdName];
            chineseString.stuInfoModel = model;
        }
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        if (flag == 1) {
            StuInfoModel *tempModel = ((ChineseString*)[chineseStringsArray objectAtIndex:i]).stuInfoModel;
            [result addObject:tempModel];
        }
    }
    
    return result;
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
