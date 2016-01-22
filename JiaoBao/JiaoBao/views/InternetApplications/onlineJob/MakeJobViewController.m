//
//  MakeJobViewController.m
//  JiaoBao
//
//  Created by Zqw on 15/10/14.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "MakeJobViewController.h"
#import "Loger.h"
#import "Reachability.h"
#import "MobClick.h"
#import "define_constant.h"
#import "OnlineJobHttp.h"
#import "AppDelegate.h"
#import "OtherItemsCell.h"
#import "OtherItemsModel.h"
#import "IQKeyboardManager.h"
#import "LoginSendHttp.h"
#import "PublishJobModel.h"
#import "utils.h"
#import "PublishJobCellTableViewCell.h"


@interface MakeJobViewController ()

@property(nonatomic,strong)AppDelegate *appDelegate;//用于获取数据库
@property(nonatomic,strong)UITextField *dateTF;//截止日期输入框
@property(nonatomic,strong)UITextField *titleTF;//标题更改输入框
@property(nonatomic,strong)CommMsgRevicerUnitListModel *mModel_unitList;
@property(nonatomic,strong)PublishJobModel *publishJobModel;


@end

@implementation MakeJobViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];

}

//在班级选择中，插入数据
-(void)getUnitClassNoticeMakeJob:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        int index = [[dic objectForKey:@"index"] intValue];
        NSArray *array = [dic objectForKey:@"array"];
//        NSMutableArray *tempArr = [NSMutableArray array];
        
        if (index == 1) {//关联的班级
            for (int i=0; i<self.mArr_sumData.count; i++) {
                TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
                if (node0.flag == 1) {
                    for (int m=0; m<array.count; m++) {
                        //第1根节点
                        TreeJob_node *node1 = [[TreeJob_node alloc]init];
                        node1.nodeLevel = 1;//节点所处层次
                        node1.type = 1;//节点类型
                        node1.flag = 101;//标注当前是哪个节点
                        node1.faType = node0.flag;//父节点
                        node1.isExpanded = FALSE;//节点是否展开
                        node1.mInt_index = self.mInt_index;//全局索引标识
                        self.mInt_index++;
                        UserClassModel *model = [array objectAtIndex:m];
                        TreeJob_class_model *temp1 =[[TreeJob_class_model alloc]init];
                        
                        for (int i=0; i<[dm getInstance].identity.count; i++) {
                            Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
                            if ([idenModel.RoleIdentity intValue]==2) {
                                for (int m=0; m<idenModel.UserUnits.count; m++) {
                                    Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:m];
                                    if ([userUnitsModel.UnitID intValue] ==[model.SchoolID intValue]) {
                                        temp1.mStr_className = [NSString stringWithFormat:@"%@[%@]",model.ClassName,userUnitsModel.UnitName];
                                        temp1.mStr_schoolName = userUnitsModel.UnitName;
                                    }
                                }
                            }
                        }
//                        if(self.saveJobModel.saveClass)
//                        {
//                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" classID == %@", model.ClassID];
//                            NSSet *filteredSet= [self.saveJobModel.saveClass filteredSetUsingPredicate:predicate];
//                            if(filteredSet.count>0)
//                            {
//                                SaveClassModel *classModel = [filteredSet anyObject];
//                                temp1.mInt_difficulty = [[NSString stringWithFormat:@"%@",classModel.doLv ]intValue];//难度
//                                temp1.mInt_class = [classModel.isSelected intValue];//是否选中
//                                temp1.mStr_tableId = model.ClassID;
//  
//                                
//                            }
//
//                            
//                        }
//                        else
//                        {


                        //}
                        temp1.mInt_difficulty = 2;//难度
                        temp1.mInt_class = 0;//是否选中
                        temp1.mStr_tableId = model.ClassID;
                        node1.nodeData = temp1;
                        //插入数据
//                        [node0.sonNodes addObject:node1];
                        [node0.sonNodes insertObject:node1 atIndex:0];
                    }
                }
            }
        }
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:1];
        TreeJob_level0_model *nodeData = node0.nodeData;
        if (node0.sonNodes.count>0) {
            nodeData.mStr_title = @"请选择班级";
        }else{
            nodeData.mStr_title = @"没有执教班级";
        }
        [self reloadDataForDisplayArray];
    }else{
        [MBProgressHUD showError:@"超时" toView:self.view];
    }
}
-(void)TecQswithchapterid:(id)sender
{
    NSString *result = [sender object];
    if([result isEqualToString:@"false"])
    {
        [MBProgressHUD showError:@"此章节没有题目"];
    }else if ([result isEqualToString:@"服务器异常"]){
        [MBProgressHUD showError:@"服务器异常"];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"是否发布%@",self.publishJobModel.homeworkName];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.delegate = self;

    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        for(int i=0;i<self.publishJobModel.classIDArr.count;i++)
        {
            TreeJob_class_model *model = [self.publishJobModel.classIDArr objectAtIndex:i];
            self.publishJobModel.Distribution = [NSString stringWithFormat:@"1:%@,2:%@",self.publishJobModel.SelNum,self.publishJobModel.InpNum];
            self.publishJobModel.classID = model.mStr_tableId;
            NSRange range = [model.mStr_className rangeOfString:@"["];
            NSString *clsName = [model.mStr_className substringToIndex:range.location];
            self.publishJobModel.className = clsName;
            if ([self.publishJobModel.HwType intValue]==3) {
                self.publishJobModel.Distribution = @"";
            }else if ([self.publishJobModel.HwType intValue]==1){
                self.publishJobModel.DoLv = [NSString stringWithFormat:@"%d",model.mInt_difficulty];
            }
            self.publishJobModel.classSel = [NSString stringWithFormat:@"%d",model.mInt_class];
            self.publishJobModel.schoolName = model.mStr_schoolName;
            D("kjlksfjdkj-=====%@,%@,%@",self.publishJobModel.HwType,self.publishJobModel.DoLv,self.publishJobModel.homeworkName);
            [[OnlineJobHttp getInstance]TecMakeHWWithPublishJobModel:self.publishJobModel];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//是否有题回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TecQswithchapterid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TecQswithchapterid:) name:@"TecQswithchapterid" object:nil];
//发布作业回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TecMakeHWWithPublishJobModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TecMakeHWWithPublishJobModel:) name:@"TecMakeHWWithPublishJobModel" object:nil];
    
    //获取执教班级
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUnitClassNoticeMakeJob" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnitClassNoticeMakeJob:) name:@"getUnitClassNoticeMakeJob" object:nil];
    
    //获取年级列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetGradeList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetGradeList:) name:@"GetGradeList" object:nil];
    //获取联动列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetUnionChapterList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUnionChapterList:) name:@"GetUnionChapterList" object:nil];
    //获取老师的自定义作业列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetDesHWList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetDesHWList:) name:@"GetDesHWList" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.mArr_sumData = [NSMutableArray array];
    self.mArr_display = [NSMutableArray array];
    self.mInt_index = 0;
    self.publishJobModel = [[PublishJobModel alloc] init];
    self.publishJobModel.HwType = @"1";
    self.publishJobModel.Additional = @"";
    self.publishJobModel.AdditionalDes = @"";
    self.publishJobModel.schoolName = [dm getInstance].mStr_unit;
    self.publishJobModel.TecName = [dm getInstance].TrueName;
    self.publishJobModel.IsRep = 1;
    self.publishJobModel.IsQsSms = 1;
    self.publishJobModel.IsSys = @"2";
    self.publishJobModel.teacherJiaobaohao = [dm getInstance].jiaoBaoHao;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateTime = [NSString stringWithFormat:@"%@ 23:00",dateStr];
    self.publishJobModel.ExpTime = dateTime;
    self.publishJobModel.DesId = @"";
    self.publishJobModel.Distribution = @"";
    self.publishJobModel.LongTime = @"20";
    
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"布置作业"];
    [self.mNav_navgationBar setGoBack];
    self.mNav_navgationBar.delegate = self;
    [self.view addSubview:self.mNav_navgationBar];
    
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    
    self.mTableV_work.frame = CGRectMake(0, self.mNav_navgationBar.frame.size.height-[dm getInstance].statusBar, [dm getInstance].width, [dm getInstance].height-self.mNav_navgationBar.frame.size.height+[dm getInstance].statusBar);
    self.mTableV_work.separatorStyle = UITableViewCellSelectionStyleNone;
    //添加默认数据
    [self addDefaultData];
    //统一作业，插入单独的难度行
    [self sigleDifficulty];
    //插入数据
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 1) {
            //统一作业，插入单独的难度行
            [node0.sonNodes addObject:self.sigleClassNode];
        }
    }
    [self reloadDataForDisplayArray];//初始化将要显示的数据
    //获取年级列表
    [[OnlineJobHttp getInstance]GetGradeList];
    //关联班级
    for (int i=0; i<[dm getInstance].identity.count; i++) {
        Identity_model *idenModel = [[dm getInstance].identity objectAtIndex:i];
        if ([idenModel.RoleIdentity intValue]==2) {
            for (int m=0; m<idenModel.UserUnits.count; m++) {
                Identity_UserUnits_model *userUnitsModel = [idenModel.UserUnits objectAtIndex:m];
                D("douifghdoj-====%@",userUnitsModel.UnitID);
                [[ShareHttp getInstance] shareHttpGetMyUserClassWith:[dm getInstance].jiaoBaoHao UID:userUnitsModel.UnitID Section:@"4"];
            }
        }
    }
}

//添加默认数据
-(void)addDefaultData{
    //第0根节点
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:@"模式选择",@"班级选择",@"年级选择",@"科目选择",@"教版选择",@"章节选择",@"选择题",@"填空题",@"自定义",@"其他项目",@"短信勾选",@"作业发布", nil];
    for (int i=0; i<tempArr.count; i++) {
        TreeJob_node *node0 = [[TreeJob_node alloc]init];
        node0.nodeLevel = 0;//节点所处层次
        node0.type = 0;//节点类型
        node0.flag = i;//标注当前是哪个节点
        node0.mInt_index = self.mInt_index;//全局索引标识
        self.mInt_index++;
        node0.isExpanded = FALSE;//节点是否展开
        TreeJob_level0_model *temp0 =[[TreeJob_level0_model alloc]init];
        temp0.mStr_name = [tempArr objectAtIndex:i];
        if (i==8) {//自定义
            temp0.mStr_title = @"请选择自定义作业";
        }else if (i==6||i==7){
            temp0.mStr_title = @"10";
            self.publishJobModel.SelNum = @"10";
            self.publishJobModel.InpNum = @"10";
        }else if (i==1){
            temp0.mStr_title = @"没有执教班级";
        }
        node0.nodeData = temp0;//当前节点数据
        
        [self.mArr_sumData addObject:node0];
    }
    [self insertOtherItems];
}

//获取老师的自定义作业列表
-(void)GetDesHWList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 8) {
            [node0.sonNodes removeAllObjects];
            for (int m=0; m<array.count; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = 801;//标注当前是哪个节点
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                HomeworkModel *temp1 =[array objectAtIndex:m];
                if (m==0) {
                    TreeJob_level0_model *nodeData = node0.nodeData;
                    nodeData.mStr_title = temp1.homeworkName;
                    nodeData.mStr_id = temp1.TabID;
                    self.publishJobModel.GradeCode = temp1.TabID;
                    self.publishJobModel.GradeName = temp1.homeworkName;
                    self.publishJobModel.DesId = temp1.TabID;
                    temp1.mInt_select = 1;
                }else{
                    temp1.mInt_select = 0;
                }
                node1.nodeData = temp1;
                //塞入数据
                [node0.sonNodes addObject:node1];
            }
            if (array.count==0) {
                self.publishJobModel.DesId = @"";
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//插入其他项目
-(void)insertOtherItems
{
    if(self.mArr_sumData.count>5)
    {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:9];
        if (node0.flag == 9) {
            for (int m=0; m<3; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = (m+1)*100;
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
//                OtherItemsModel *temp1 =[[OtherItemsModel alloc]init];
//                temp1.title = [NSString stringWithFormat:@"标题更改"];
//                temp1.tf_content = @"";
//                node1.nodeData = temp1;
                if (m == 2) {
                    TreeJob_level0_model *nodeData = [[TreeJob_level0_model alloc] init];
                    nodeData.mStr_name = @"作业时长";
                    nodeData.mStr_title = @"20";
                    self.publishJobModel.LongTime = @"20";
                    node1.nodeData = nodeData;
                }
                //塞入数据
                [node0.sonNodes addObject:node1];
            }
        }
    }
}

//获取年级列表
-(void)GetGradeList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableArray *array = noti.object;
    if (array.count==0) {
        [MBProgressHUD showError:@"年级列表为空"];
    }
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
        if (node0.flag == 2) {
            for (int m=0; m<array.count; m++) {
                //第1根节点
                TreeJob_node *node1 = [[TreeJob_node alloc]init];
                node1.nodeLevel = 1;//节点所处层次
                node1.type = 1;//节点类型
                node1.flag = 201;//标注当前是哪个节点
                node1.faType = node0.flag;//父节点
                node1.isExpanded = FALSE;//节点是否展开
                node1.mInt_index = self.mInt_index;//全局索引标识
                self.mInt_index++;
                GradeModel *temp1 =[array objectAtIndex:m];
                if (m==0) {
                    TreeJob_level0_model *nodeData = node0.nodeData;
                    nodeData.mStr_title = temp1.GradeName;
                    nodeData.mStr_id = temp1.GradeCode;
                    self.publishJobModel.GradeCode = temp1.GradeCode;
                    self.publishJobModel.GradeName = temp1.GradeName;
                    temp1.mInt_select = 1;
                    [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:temp1.GradeCode subCode:@"0" uId:@"0" flag:@"0"];
                }else{
                    temp1.mInt_select = 0;
                }
                node1.nodeData = temp1;
                //塞入数据
                [node0.sonNodes addObject:node1];
            }
        }
    }
    [self reloadDataForDisplayArray];
}

//获取联动列表
-(void)GetUnionChapterList:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    NSMutableArray *array1 = [dic objectForKey:@"args1"];//科目列表
    NSMutableArray *array2 = [dic objectForKey:@"args2"];//教版
    NSMutableArray *array3 = [dic objectForKey:@"args3"];//章节
    if ([flag intValue]==0) {//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 3) {//往科目选择中插入
                [self addChapterList:node0 array:array1 flag:301 type:1];
            }else if (node0.flag == 4) {//往教版选择中插入
                [self addChapterList:node0 array:array2 flag:401 type:2];
            }else if (node0.flag == 5) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:501 type:3];
            }
        }
    }else if ([flag intValue]==1){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 4) {//往教版选择中插入
                [self addChapterList:node0 array:array2 flag:401 type:2];
            }else if (node0.flag == 5) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:501 type:3];
            }
        }
    }else if ([flag intValue]==2){//
        for (int i=0; i<self.mArr_sumData.count; i++) {
            TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:i];
            if (node0.flag == 5) {//往章节选择中插入
                [self addChapterList:node0 array:array3 flag:501 type:3];
            }
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    self.publishJobModel.homeworkName = [NSString stringWithFormat:@"%@%@%@作业",dateStr,self.publishJobModel.subjectName,self.publishJobModel.chapterName];
    [self reloadDataForDisplayArray];
    //获取自定义作业
    if (self.mInt_modeSelect ==3) {
        D("self.publishJobModel.chapterID-=000==%@",self.publishJobModel.chapterID);
        if ([self.publishJobModel.chapterID intValue]>0) {
            [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:self.publishJobModel.chapterID teacherJiaobaohao:[dm getInstance].jiaoBaoHao];
        }
    }
}

-(void)addChapterList:(TreeJob_node *)node0 array:(NSMutableArray *)array flag:(int)flag type:(int)type{
    [node0.sonNodes removeAllObjects];
    for (int m=0; m<array.count; m++) {
        //第1根节点
        TreeJob_node *node1 = [[TreeJob_node alloc]init];
        node1.nodeLevel = 1;//节点所处层次
        node1.type = 1;//节点类型
        node1.flag = flag;//标注当前是哪个节点
        node1.faType = node0.flag;//父节点
        node1.isExpanded = FALSE;//节点是否展开
        node1.mInt_index = self.mInt_index;//全局索引标识
        self.mInt_index++;
        if (type==1) {
            SubjectModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.subjectName;
                nodeData.mStr_id = temp1.subjectCode;
                self.publishJobModel.subjectName = temp1.subjectName;
                self.publishJobModel.subjectCode = temp1.subjectCode;
                self.publishJobModel.VersionName = @"";
                self.publishJobModel.VersionCode = @"0";
                self.publishJobModel.chapterName = @"";
                self.publishJobModel.chapterID = @"0";
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }else if (type==2){
            VersionModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.VersionName;
                nodeData.mStr_id = temp1.TabID;
                self.publishJobModel.VersionName = temp1.VersionName;
                self.publishJobModel.VersionCode = temp1.TabID;
                self.publishJobModel.chapterName = @"";
                self.publishJobModel.chapterID = @"0";
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }else if (type==3) {
            ChapterModel *temp1 =[array objectAtIndex:m];
            if (m==0) {
                TreeJob_level0_model *nodeData = node0.nodeData;
                nodeData.mStr_title = temp1.chapterName;
                nodeData.mStr_id = temp1.TabID;
                self.publishJobModel.chapterName = temp1.chapterName;
                self.publishJobModel.chapterID = temp1.TabID;
                temp1.mInt_select = 1;
            }else{
                temp1.mInt_select = 0;
            }
            node1.nodeData = temp1;
        }
        //塞入数据
        [node0.sonNodes addObject:node1];
    }
}

//统一作业，插入单独的难度行
-(void)sigleDifficulty{
    //第1根节点
    self.sigleClassNode = [[TreeJob_node alloc]init];
    self.sigleClassNode.nodeLevel = 1;//节点所处层次
    self.sigleClassNode.type = 1;//节点类型
    self.sigleClassNode.flag = 9999;//标注当前是哪个节点
    self.sigleClassNode.faType = 1;//父节点
    self.sigleClassNode.isExpanded = FALSE;//节点是否展开
    self.sigleClassNode.mInt_index = self.mInt_index;//全局索引标识
    self.mInt_index++;
    TreeJob_class_model *temp1 =[[TreeJob_class_model alloc]init];
    temp1.mStr_className = @"一年级2班";
    temp1.mInt_difficulty = 2;
    self.publishJobModel.DoLv = @"2";
    temp1.mInt_class = 0;
    self.sigleClassNode.nodeData = temp1;
}

//初始化将要显示的数据
-(void)reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (TreeJob_node *node in self.mArr_sumData) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeJob_node *node2 in node.sonNodes){
                [tmp addObject:node2];
                if (node2.flag == 501) {
                    ChapterModel *model = node2.nodeData;
                    [self addArrayChapter:model array:tmp];
                }
            }
        }
    }
    self.mArr_display = [NSArray arrayWithArray:tmp];
    [self.mTableV_work reloadData];
}
-(void)addArrayChapter:(ChapterModel *)model array:(NSMutableArray *)array{
    if (model.isExpanded) {
        for (ChapterModel *temp1 in model.array) {
            [array addObject:temp1];
            [self addArrayChapter:temp1 array:array];
        }
    }
}
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr_display.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"TreeJob_default_TableViewCell";
    static NSString *indentifier2 = @"TreeJob_class_TableViewCell";
    static NSString *ModeSelectionIndentifier = @"ModeSelectionIndentifier";//模式选择cell重用标志
    static NSString *MessageSelectionIndentifier = @"MessageSelectionIndentifier";//短信勾选cell重用标志
    static NSString *PublishJobIdentifier = @"PublishJobIdentifier";//作业发布cell
    static NSString *TreeJob_sigleSelect_indentifier = @"TreeJob_sigleSelect_TableViewCell";//年级、科目、教版、章节的单选cell
    static NSString *OtherItemIdentifer = @"OtherItemIdentifer";//其他项目cell重用标志
    static NSString *TreeJob_questionCount_TableViewCellIdentifer = @"TreeJob_questionCount_TableViewCell";//其他项目cell重用标志
    static NSString *TreeJob_workTime_TableViewCellIdentifer = @"TreeJob_workTime_TableViewCell";//作业时长
    
//    static NSString *indentifier1 = @"TreeView_Level1_Cell";
//    static NSString *indentifier2 = @"TreeView_Level2_Cell";
    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
    if ([node1 isKindOfClass:[ChapterModel class]]) {
        ChapterModel *model = [self.mArr_display objectAtIndex:indexPath.row];
            TreeJob_sigleSelect_TableViewCell *cell = (TreeJob_sigleSelect_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_sigleSelect_indentifier];
            if (cell == nil) {
                cell = [[TreeJob_sigleSelect_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_sigleSelect_indentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_sigleSelect_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_sigleSelect_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_sigleSelect_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_sigleSelect_indentifier];
            }
            cell.delegate = self;
            cell.model = model;
            [self loadDataForSigleSelectTreeViewCell1:cell with:model flag:501];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
    }
    TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
    if(node.type == 0){//类型为0的cell,一级列表
        if (node.flag == 0) {//模式选择
            Mode_Selection_Cell *cell = (Mode_Selection_Cell *)[tableView dequeueReusableCellWithIdentifier:ModeSelectionIndentifier];
            if (cell == nil) {
                cell = [[Mode_Selection_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ModeSelectionIndentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Mode_Selection_Cell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (Mode_Selection_Cell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"Mode_Selection_Cell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:ModeSelectionIndentifier];
            }
            cell.delegate = self;
//            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
//            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 6||node.flag==7){//选择题、填空题
            TreeJob_questionCount_TableViewCell *cell = (TreeJob_questionCount_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_questionCount_TableViewCellIdentifer];
            if (cell == nil) {
                cell = [[TreeJob_questionCount_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_questionCount_TableViewCellIdentifer];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_questionCount_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_questionCount_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_questionCount_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_questionCount_TableViewCellIdentifer];
            }
            cell.node = node;
            cell.delegate = self;
            [self loadDataForQuestionCountTreeViewCell:cell with:node flag:node.flag];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 10){//短信勾选
            MessageSelectionCell *cell = (MessageSelectionCell *)[tableView dequeueReusableCellWithIdentifier:MessageSelectionIndentifier];
            if (cell == nil) {
                cell = [[MessageSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageSelectionIndentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageSelectionCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (MessageSelectionCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"MessageSelectionCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:MessageSelectionIndentifier];
            }
            cell.delegate = self;
//            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
//            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 11){//作业发布
            PublishJobCellTableViewCell *cell = (PublishJobCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PublishJobIdentifier];
            if (cell == nil) {
                cell = [[PublishJobCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PublishJobIdentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PublishJobCellTableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (PublishJobCellTableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"PublishJobCellTableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:PublishJobIdentifier];
            }
            cell.delegate = self;
//            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
//            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else{//其余下拉cell
            TreeJob_default_TableViewCell *cell = (TreeJob_default_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[TreeJob_default_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_default_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_default_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_default_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:indentifier];
            }
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }
    }else if(node.type == 1){//类型为1的cell,2级列表
        if (node.flag == 101||node.flag ==9999) {//班级选择cell
            TreeJob_class_TableViewCell *cell = (TreeJob_class_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier2];
            if (cell == nil) {
                cell = [[TreeJob_class_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_class_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_class_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_class_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:indentifier2];
            }
            cell.delegate = self;
            cell.node = node;
            [self loadDataForClassTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.flag == 201||node.flag == 301||node.flag == 401||node.flag == 501||node.flag == 801) {//年级、科目、教版、章节的单选cell//自定义作业
            TreeJob_sigleSelect_TableViewCell *cell = (TreeJob_sigleSelect_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_sigleSelect_indentifier];
            if (cell == nil) {
                cell = [[TreeJob_sigleSelect_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_sigleSelect_indentifier];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_sigleSelect_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_sigleSelect_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_sigleSelect_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_sigleSelect_indentifier];
            }
            cell.delegate = self;
            cell.model = node;
            [self loadDataForSigleSelectTreeViewCell:cell with:node flag:node.flag];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }
        else if(node.flag ==100||node.flag == 200)
        {
            OtherItemsCell *cell = (OtherItemsCell *)[tableView dequeueReusableCellWithIdentifier:OtherItemIdentifer];
            if (cell == nil) {
                cell = [[OtherItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OtherItemIdentifer];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherItemsCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (OtherItemsCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
//                UINib * n= [UINib nibWithNibName:@"OtherItemsCell" bundle:[NSBundle mainBundle]];
//                [self.mTableV_work registerNib:n forCellReuseIdentifier:OtherItemIdentifer];
            }
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
            
        }
        else if (node.flag == 300)//作业时长
        {
            TreeJob_workTime_TableViewCell *cell = (TreeJob_workTime_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TreeJob_workTime_TableViewCellIdentifer];
            if (cell == nil) {
                cell = [[TreeJob_workTime_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TreeJob_workTime_TableViewCellIdentifer];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreeJob_workTime_TableViewCell" owner:self options:nil];
                //这时myCell对象已经通过自定义xib文件生成了
                if ([nib count]>0) {
                    cell = (TreeJob_workTime_TableViewCell *)[nib objectAtIndex:0];
                    //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
                }
                
                //添加图片点击事件
                //若是需要重用，需要写上以下两句代码
                UINib * n= [UINib nibWithNibName:@"TreeJob_workTime_TableViewCell" bundle:[NSBundle mainBundle]];
                [self.mTableV_work registerNib:n forCellReuseIdentifier:TreeJob_workTime_TableViewCellIdentifer];
            }
            cell.delegate = self;
            [self loadDataForWorkTimeTreeViewCell:cell with:node flag:node.flag];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
    if ([node1 isKindOfClass:[TreeJob_node class]]) {
        TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
        if (node.type == 0) {
            if (self.mInt_modeSelect==0||self.mInt_modeSelect==1||self.mInt_modeSelect == 2) {//个性作业,//统一作业、AB卷
                if (node.flag==8) {//自定义作业
                    return 0;
                }
                else if (node.flag == 11)
                {
                    return 150;
                }
            }else if (self.mInt_modeSelect==3){//自定义作业
                if (node.flag==6||node.flag==7) {
                    return 0;
                }
                else if (node.flag == 11)
                {
                    return 150;
                }
            }
            return 44;
        }else if (node.type == 1){
            if (node.flag == 101) {
                if (self.mInt_modeSelect == 0) {//个性作业
                    return 65;
                }else{//统一作业、自定义作业
                    return 35;
                }
            }else if (node.flag == 9999){//
                if (self.mInt_modeSelect == 1||self.mInt_modeSelect == 2) {//统一作业、AB卷
                    return 35;
                }
                return 0;
            }else if(node.flag == 300){
                return 70;
            }else{
                return 35;
            }
        }
    }else{
        return 35;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id node1 = [self.mArr_display objectAtIndex:indexPath.row];
    if ([node1 isKindOfClass:[TreeJob_node class]]) {
        TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
        if(node.type == 0){
            TreeJob_node *node = [self.mArr_display objectAtIndex:indexPath.row];
            if (node.sonNodes.count== 0) {
                if (node.flag==1) {
                    [MBProgressHUD showError:@"没有执教班级" toView:self.view];
                }else if (node.flag ==2){
                    [MBProgressHUD showError:@"年级为空" toView:self.view];
                }else if (node.flag ==3){
                    [MBProgressHUD showError:@"科目为空" toView:self.view];
                }else if (node.flag ==4){
                    [MBProgressHUD showError:@"教版为空" toView:self.view];
                }else if (node.flag ==5){
                    [MBProgressHUD showError:@"章节为空" toView:self.view];
                }else if (node.flag ==8){
                    [MBProgressHUD showError:@"自定义作业为空" toView:self.view];
                }
            }else{
                if (node.flag==501) {
                    ChapterModel *model = node.nodeData;
                    [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
                }else{
                    [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                }
            }
        }else{
            if (node.flag==501) {
                ChapterModel *model = node.nodeData;
                [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
            }else{
                [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
            }
        }
    }else{
        ChapterModel *model = [self.mArr_display objectAtIndex:indexPath.row];
        [self reloadDataForDisplayArrayChangeAt1:model.TabID];//修改章节cell的状态(关闭或打开)
    }
}

-(void) reloadDataForDisplayArrayChangeAt1:(NSString *)tableID{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == 5){
            for(TreeJob_node *node2 in node.sonNodes){
                ChapterModel *model = node2.nodeData;
                if ([model.TabID isEqualToString:tableID]) {
                        model.isExpanded = !model.isExpanded;
                        break;
                }else{
                    [self addArrayChapter1:[tableID intValue] array:model.array];
                }
            }
        }
    }
    [self reloadDataForDisplayArray];
}

-(void)addArrayChapter1:(NSInteger)tableID array:(NSMutableArray *)array{
    for (ChapterModel *temp1 in array) {
        if ([temp1.TabID intValue]==tableID) {
            temp1.isExpanded = !temp1.isExpanded;
            break;
        }else{
            [self addArrayChapter1:tableID array:temp1.array];
        }
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    if(node.type == 0){
        TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
        
        if (node.flag == 9){//其他项目
            cell0.mLab_title.hidden = NO;
            cell0.mLab_select.hidden = YES;
            cell0.mImg_pic.hidden = NO;
            cell0.mLab_line.hidden = NO;
            TreeJob_level0_model *nodeData = node.nodeData;
            cell0.mLab_title.text = nodeData.mStr_name;
            cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
        }else if (node.flag == 8){
            if (self.mInt_modeSelect==0||self.mInt_modeSelect==1||self.mInt_modeSelect == 2) {//个性、统一、AB卷
                cell0.mLab_title.hidden = YES;
                cell0.mLab_select.hidden = YES;
                cell0.mLab_line.hidden = YES;
                cell0.mImg_pic.hidden = YES;
            }else{//自定义作业
                cell0.mLab_title.hidden = NO;
                cell0.mLab_select.hidden = NO;
                cell0.mLab_line.hidden = NO;
                cell0.mImg_pic.hidden = NO;
                TreeJob_level0_model *nodeData = node.nodeData;
                cell0.mLab_title.text = nodeData.mStr_name;
                cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
                cell0.mLab_select.text = nodeData.mStr_title;
                cell0.mLab_select.frame = CGRectMake(90, 15, [dm getInstance].width-110, 21);
            }
        }else{
            cell0.mLab_title.hidden = NO;
            cell0.mLab_select.hidden = NO;
            cell0.mLab_line.hidden = NO;
            cell0.mImg_pic.hidden = NO;
            TreeJob_level0_model *nodeData = node.nodeData;
            cell0.mLab_title.text = nodeData.mStr_name;
            cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
            cell0.mLab_select.text = nodeData.mStr_title;
            cell0.mLab_select.frame = CGRectMake(90, 15, [dm getInstance].width-110, 21);
        }
        cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 20, 10, 10);
        if (node.isExpanded) {
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
        }else{
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
        }
    }else if (node.type == 1){
        if(node.flag ==100)
        {
            OtherItemsCell *cell0 = (OtherItemsCell*)cell;
            cell0.titleLabel.text = @"标题更改";
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];;
//            cell0.textField.text = [NSString stringWithFormat:@"%@%@%@作业",dateStr,self.publishJobModel.subjectName,self.publishJobModel.chapterName];
            cell0.textField.text = self.publishJobModel.homeworkName;
            self.titleTF = cell0.textField;
            
        }
        else if (node.flag == 200)
        {
            OtherItemsCell *cell0 = (OtherItemsCell*)cell;
            cell0.titleLabel.text = @"截止时间";
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//            NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
            cell0.textField.text = self.publishJobModel.ExpTime;
            cell0.textField.inputView = self.datePicker;
            self.dateTF = cell0.textField;
            cell0.textField.inputAccessoryView = self.toolBar;
        }
        else if(node.flag == 300)
        {
            
        }
        else
        {
            TreeJob_default_TableViewCell *cell0 = (TreeJob_default_TableViewCell*)cell;
            TreeJob_level0_model *nodeData = node.nodeData;
            cell0.mLab_title.text = nodeData.mStr_name;
            cell0.mLab_title.frame = CGRectMake(20, 15, 80, 21);
        }

    }
}

//作业时长
-(void)loadDataForWorkTimeTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node flag:(int)flag{
    TreeJob_workTime_TableViewCell *cell0 = (TreeJob_workTime_TableViewCell*)cell;
    TreeJob_level0_model *model = node.nodeData;
    cell0.mLab_title.text = model.mStr_name;
    cell0.mInt_count = [model.mStr_title intValue];
    for (SigleBtnView *view in cell0.subviews) {
        if ([view.class isSubclassOfClass:SigleBtnView.class]) {
            if (view.tag == cell0.mInt_count) {
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
            }else{
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
            }
        }
    }
}

//选择题、填空题
-(void)loadDataForQuestionCountTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node flag:(int)flag{
    TreeJob_questionCount_TableViewCell *cell0 = (TreeJob_questionCount_TableViewCell*)cell;
    TreeJob_level0_model *model = node.nodeData;
    if (self.mInt_modeSelect==0||self.mInt_modeSelect==1||self.mInt_modeSelect == 2) {//个性、统一、AB卷
        cell0.mLab_title.hidden = NO;
        cell0.sigleBtn1.hidden = NO;
        cell0.sigleBtn2.hidden = NO;
        cell0.sigleBtn3.hidden = NO;
        cell0.sigleBtn4.hidden = NO;
        cell0.mLab_line.hidden = NO;
    }else{//自定义
        cell0.mLab_title.hidden = YES;
        cell0.sigleBtn1.hidden = YES;
        cell0.sigleBtn2.hidden = YES;
        cell0.sigleBtn3.hidden = YES;
        cell0.sigleBtn4.hidden = YES;
        cell0.mLab_line.hidden = YES;
    }
    cell0.mLab_title.text = model.mStr_name;
    cell0.mInt_count = [model.mStr_title intValue];
    for (SigleBtnView *view in cell0.subviews) {
        if ([view.class isSubclassOfClass:SigleBtnView.class]) {
           if (view.tag == cell0.mInt_count) {
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
            }else{
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
            }
        }
    }
}

-(void)loadDataForSigleSelectTreeViewCell1:(UITableViewCell*)cell with:(ChapterModel*)model flag:(int)flag{
    TreeJob_sigleSelect_TableViewCell *cell0 = (TreeJob_sigleSelect_TableViewCell*)cell;
    NSString *name = @"";
    if (flag==501){//章节
//        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.chapterName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.chapterName;
    }
    
    if (cell0.sigleBtn.mInt_flag ==1) {
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
    }else{
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
    }
    cell0.mLab_line.frame = CGRectMake(20, 0, [dm getInstance].width-20, .5);
    CGSize titleSize = [name sizeWithFont:[UIFont systemFontOfSize:12]];
    if ([dm getInstance].width-40-(30+20*model.mInt_flag)<titleSize.width+16) {
        titleSize.width = [dm getInstance].width-40-(30+20*model.mInt_flag);
    }
    cell0.sigleBtn.mLab_title.frame = CGRectMake(16, 0, titleSize.width, cell0.sigleBtn.mLab_title.frame.size.height);
    if (flag==501) {//章节
//        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.frame = CGRectMake(30+20*model.mInt_flag, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
        
        if (model.array.count>0) {
            cell0.mImg_pic.hidden = NO;
            cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 10, 10, 10);
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            if (model.isExpanded) {
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            }else{
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
            }
        }else{
            cell0.mImg_pic.hidden = YES;
        }
    }else{
        cell0.mImg_pic.hidden = YES;
        cell0.sigleBtn.frame = CGRectMake(30, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
    }
}

-(void)loadDataForSigleSelectTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node flag:(int)flag{
    TreeJob_sigleSelect_TableViewCell *cell0 = (TreeJob_sigleSelect_TableViewCell*)cell;
    NSString *name = @"";
    if (flag==201) {//年级
        GradeModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.GradeName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.GradeName;
    }else if (flag==301){//科目
        SubjectModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.subjectName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.subjectName;
    }else if (flag==401){//教版
        VersionModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.VersionName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.VersionName;
    }else if (flag==501){//章节
        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.chapterName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.chapterName;
    }else if (flag==801){//自定义作业
        HomeworkModel *model = node.nodeData;
        cell0.sigleBtn.mLab_title.text = model.homeworkName;
        cell0.sigleBtn.mInt_flag = model.mInt_select;//是否选择
        name = model.homeworkName;
    }
    
    if (cell0.sigleBtn.mInt_flag ==1) {
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
    }else{
        [cell0.sigleBtn.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
    }
    cell0.mLab_line.frame = CGRectMake(20, 0, [dm getInstance].width-20, .5);
    CGSize titleSize = [name sizeWithFont:[UIFont systemFontOfSize:12]];
    if ([dm getInstance].width-40<titleSize.width+16) {
        titleSize.width = [dm getInstance].width-40-16;
    }
    cell0.sigleBtn.mLab_title.frame = CGRectMake(16, 0, titleSize.width, cell0.sigleBtn.mLab_title.frame.size.height);
    if (flag==501) {//章节
        ChapterModel *model = node.nodeData;
        cell0.sigleBtn.frame = CGRectMake(30+20*model.mInt_flag, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
        if (model.array.count>0) {
            cell0.mImg_pic.hidden = NO;
            cell0.mImg_pic.frame = CGRectMake([dm getInstance].width-20, 10, 10, 10);
            [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            if (model.isExpanded) {
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down0"]];
            }else{
                [cell0.mImg_pic setImage:[UIImage imageNamed:@"homework_down1"]];
            }
        }else{
            cell0.mImg_pic.hidden = YES;
        }
    }else{
        cell0.mImg_pic.hidden = YES;
        cell0.sigleBtn.frame = CGRectMake(30, 8, cell0.sigleBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleBtn.frame.size.height);
    }
}

-(void) loadDataForClassTreeViewCell:(UITableViewCell*)cell with:(TreeJob_node*)node{
    TreeJob_class_TableViewCell *cell0 = (TreeJob_class_TableViewCell*)cell;
    TreeJob_class_model *nodeData = node.nodeData;
    cell0.sigleClassBtn.mLab_title.text = nodeData.mStr_className;
    cell0.sigleClassBtn.mInt_flag = nodeData.mInt_class;//班级是否选择
    cell0.mInt_diff = nodeData.mInt_difficulty;//难度
    
    if (self.mInt_modeSelect == 0) {//个性作业
        if (node.flag == 9999) {//专门的难度行
            cell0.mLab_line.hidden = YES;
            cell0.sigleClassBtn.hidden = YES;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
        }else{//所有显示
            cell0.mLab_line.hidden = NO;
            cell0.sigleClassBtn.hidden = NO;
            cell0.mLab_nanDu.hidden = NO;
            cell0.sigleBtn1.hidden = NO;
            cell0.sigleBtn2.hidden = NO;
            cell0.sigleBtn3.hidden = NO;
            cell0.sigleBtn4.hidden = NO;
            cell0.sigleBtn5.hidden = NO;
            
            cell0.sigleClassBtn.frame = CGRectMake(30, 10, cell0.sigleClassBtn.frame.size.width, 21);
            //难度
            cell0.mLab_nanDu.frame = CGRectMake(30, 35, cell0.mLab_nanDu.frame.size.width, 21);
            cell0.sigleBtn1.frame = CGRectMake(30+cell0.mLab_nanDu.frame.size.width, 35, cell0.sigleBtn1.frame.size.width, 21);
            cell0.sigleBtn2.frame = CGRectMake(cell0.sigleBtn1.frame.origin.x+cell0.sigleBtn2.frame.size.width+20, 35, cell0.sigleBtn2.frame.size.width, 21);
            cell0.sigleBtn3.frame = CGRectMake(cell0.sigleBtn2.frame.origin.x+cell0.sigleBtn3.frame.size.width+20, 35, cell0.sigleBtn3.frame.size.width, 21);
            cell0.sigleBtn4.frame = CGRectMake(cell0.sigleBtn3.frame.origin.x+cell0.sigleBtn4.frame.size.width+20, 35, cell0.sigleBtn4.frame.size.width, 21);
            cell0.sigleBtn5.frame = CGRectMake(cell0.sigleBtn4.frame.origin.x+cell0.sigleBtn5.frame.size.width+20, 35, cell0.sigleBtn5.frame.size.width, 21);
        }
    }else if (self.mInt_modeSelect == 1||self.mInt_modeSelect == 2) {//统一作业,AB卷
        if (node.flag == 9999) {//专门的难度行
            cell0.mLab_line.hidden = NO;
            cell0.sigleClassBtn.hidden = YES;
            cell0.mLab_nanDu.hidden = NO;
            cell0.sigleBtn1.hidden = NO;
            cell0.sigleBtn2.hidden = NO;
            cell0.sigleBtn3.hidden = NO;
            cell0.sigleBtn4.hidden = NO;
            cell0.sigleBtn5.hidden = NO;
            self.publishJobModel.DoLv = [NSString stringWithFormat:@"%d",cell0.mInt_diff];
            //难度
            cell0.mLab_nanDu.frame = CGRectMake(30, 8, cell0.mLab_nanDu.frame.size.width, 21);
            cell0.sigleBtn1.frame = CGRectMake(30+cell0.mLab_nanDu.frame.size.width, 10, cell0.sigleBtn1.frame.size.width, 21);
            cell0.sigleBtn2.frame = CGRectMake(cell0.sigleBtn1.frame.origin.x+cell0.sigleBtn2.frame.size.width+20, 10, cell0.sigleBtn2.frame.size.width, 21);
            cell0.sigleBtn3.frame = CGRectMake(cell0.sigleBtn2.frame.origin.x+cell0.sigleBtn3.frame.size.width+20, 10, cell0.sigleBtn3.frame.size.width, 21);
            cell0.sigleBtn4.frame = CGRectMake(cell0.sigleBtn3.frame.origin.x+cell0.sigleBtn4.frame.size.width+20, 10, cell0.sigleBtn4.frame.size.width, 21);
            cell0.sigleBtn5.frame = CGRectMake(cell0.sigleBtn4.frame.origin.x+cell0.sigleBtn5.frame.size.width+20, 10, cell0.sigleBtn5.frame.size.width, 21);
        }else{//光班级行
            cell0.mLab_line.hidden = NO;
            cell0.sigleClassBtn.hidden = NO;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
            cell0.sigleClassBtn.frame = CGRectMake(30, 8, cell0.sigleClassBtn.frame.size.width, 21);
        }
    }else{//自定义作业
        if (node.flag == 9999) {//专门的难度行
            cell0.mLab_line.hidden = YES;
            cell0.sigleClassBtn.hidden = YES;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
        }else{//光班级行
            cell0.mLab_line.hidden = NO;
            cell0.sigleClassBtn.hidden = NO;
            cell0.mLab_nanDu.hidden = YES;
            cell0.sigleBtn1.hidden = YES;
            cell0.sigleBtn2.hidden = YES;
            cell0.sigleBtn3.hidden = YES;
            cell0.sigleBtn4.hidden = YES;
            cell0.sigleBtn5.hidden = YES;
            cell0.sigleClassBtn.frame = CGRectMake(30, 8, cell0.sigleClassBtn.frame.size.width, 21);
        }
    }
    //班级
    if (cell0.sigleClassBtn.mInt_flag ==1) {
        [cell0.sigleClassBtn.mImg_head setImage:[UIImage imageNamed:@"selected"]];
    }else{
        [cell0.sigleClassBtn.mImg_head setImage:[UIImage imageNamed:@"blank"]];
    }
    CGSize titleSize = [nodeData.mStr_className sizeWithFont:[UIFont systemFontOfSize:12]];
    cell0.sigleClassBtn.mLab_title.frame = CGRectMake(16, 0, titleSize.width, cell0.sigleClassBtn.mLab_title.frame.size.height);
    cell0.sigleClassBtn.frame = CGRectMake(30, 8, cell0.sigleClassBtn.mLab_title.frame.origin.x+titleSize.width, cell0.sigleClassBtn.frame.size.height);
    //难度
    for (SigleBtnView *view in cell0.subviews) {
        if ([view.class isSubclassOfClass:SigleBtnView.class]) {
            if (view.tag == 0) {
                
            }else if (view.tag == cell0.mInt_diff) {
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect1"]];
            }else{
                [view.mImg_head setImage:[UIImage imageNamed:@"sigleSelect0"]];
            }
        }
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == row){
            node.isExpanded = !node.isExpanded;
        }
//        for(TreeJob_node *node2 in node.sonNodes){
//            if(node2.flag == row){
//                node2.isExpanded = !node2.isExpanded;
//            }
//        }
    }
    [self reloadDataForDisplayArray];
}

-(void)modeSelectionActionWithButtonTag:(NSUInteger)tag//0个性 1统一 2AB卷 3自定义
{
    self.mInt_modeSelect = (int)tag;
    TreeView_node *tempNode7 = [self.mArr_sumData objectAtIndex:8];
    if(tag == 0)
    {
        self.publishJobModel.HwType = @"1";
        tempNode7.isExpanded = NO;
    }
    else if (tag == 1)
    {
        self.publishJobModel.HwType = @"4";
        tempNode7.isExpanded = NO;
    }
    else if (tag == 2)
    {
        self.publishJobModel.HwType = @"2";
        tempNode7.isExpanded = NO;
    }
    else if (tag == 3)
    {
        self.publishJobModel.HwType = @"3";
    }
    //获取自定义作业
    if (self.mInt_modeSelect ==3) {
        if ([self.publishJobModel.chapterID intValue]>0) {
            [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:self.publishJobModel.chapterID teacherJiaobaohao:[dm getInstance].jiaoBaoHao];
        }
    }
    [self reloadDataForDisplayArray];
    //给当前的全局难度赋值
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == 1){
            for (TreeJob_node *node1 in node.sonNodes) {
                if (node1.flag == 9999) {//专门的难度行
                    TreeJob_class_model *nodeData = node1.nodeData;
                    self.publishJobModel.DoLv = [NSString stringWithFormat:@"%d",nodeData.mInt_difficulty];
                }
            }
        }
    }
}

-(void)MessageSelectionActionWithButtonTag0:(NSUInteger)tag0 tag1:(NSUInteger)tag1//tag0家长通知 tag1反馈（0是没选中 1是选中）
{
    self.mInt_parent = (int)tag0;
    self.mInt_feedback = (int)tag1;
    self.publishJobModel.IsQsSms = tag0;
    self.publishJobModel.IsRep = tag1;
}

//班级cell的回调
-(void)TreeJob_class_TableViewCellClick:(TreeJob_class_TableViewCell *)treeJob_class_TableViewCell{
    [self.publishJobModel.classIDArr removeAllObjects];
    NSString *mStr = @"";
    
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node = [self.mArr_sumData objectAtIndex:i];
        if (node.flag == 1) {
            for (TreeJob_node *node1 in node.sonNodes) {
                //改变是否选中
                if (node1.mInt_index == treeJob_class_TableViewCell.node.mInt_index) {
                    TreeJob_class_model *nodeData = node1.nodeData;
                    nodeData.mInt_class = treeJob_class_TableViewCell.sigleClassBtn.mInt_flag;
                    nodeData.mInt_difficulty = treeJob_class_TableViewCell.mInt_diff;
//                    nodeData.mStr_tableId =
                }
            }
            //修改publishJobModel中的班级数组
            for (TreeJob_node *node1 in node.sonNodes) {
                //改变是否选中
                TreeJob_class_model *nodeData = node1.nodeData;
                if (nodeData.mInt_class ==1) {
                    [self.publishJobModel.classIDArr addObject:nodeData];
                }
            }
        }
    }
    //修改选中班级显示
    TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:1];
    for (TreeJob_node *node1 in node0.sonNodes) {
        TreeJob_class_model *nodeData = node1.nodeData;
        if (nodeData.mInt_class==1) {
            if (mStr.length>0) {
                mStr = [NSString stringWithFormat:@"%@,%@",mStr,nodeData.mStr_className];
            }else{
                mStr = [NSString stringWithFormat:@"%@",nodeData.mStr_className];
            }
        }
    }
    if (mStr.length==0) {
        if (node0.sonNodes.count>0) {
            mStr = @"请选择班级";
        }else{
            mStr = @"没有执教班级";
        }
    }
    TreeJob_level0_model *nodeData = node0.nodeData;
    nodeData.mStr_title = mStr;
    [self reloadDataForDisplayArray];
}

//作业时长回调
-(void)TreeJob_workTime_TableViewCellClick:(TreeJob_workTime_TableViewCell *)treeJob_workTime_TableViewCell{
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node = [self.mArr_sumData objectAtIndex:i];
        if (node.flag==9) {
            for (TreeJob_node *node1 in node.sonNodes) {
                if (node1.flag ==300) {
                    TreeJob_level0_model *model = node1.nodeData;
                    model.mStr_title = [NSString stringWithFormat:@"%d",treeJob_workTime_TableViewCell.mInt_count];
                    self.publishJobModel.LongTime = model.mStr_title;
                }
            }
        }
    }
}

//选择题、填空题的回调
-(void)TreeJob_questionCount_TableViewCellClick:(TreeJob_questionCount_TableViewCell *)treeJob_questionCount_TableViewCell{
    for (int i=0; i<self.mArr_sumData.count; i++) {
        TreeJob_node *node = [self.mArr_sumData objectAtIndex:i];
        TreeJob_node *tempNode = treeJob_questionCount_TableViewCell.node;
        if (node.flag == tempNode.flag) {
            TreeJob_level0_model *model = node.nodeData;
            model.mStr_title = [NSString stringWithFormat:@"%d",treeJob_questionCount_TableViewCell.mInt_count];
        }
    }
    //选择题个数
    TreeJob_node *node0 = [self.mArr_sumData objectAtIndex:6];
    TreeJob_level0_model *model0 = node0.nodeData;
    self.publishJobModel.SelNum = model0.mStr_title;
    //填空题个数
    TreeJob_node *node1 = [self.mArr_sumData objectAtIndex:7];
    TreeJob_level0_model *model1 = node1.nodeData;
    self.publishJobModel.InpNum = model1.mStr_title;
}

-(void) reloadDataForDisplayArrayChangeAt2:(NSString *)tableID{
    for (TreeJob_node *node in self.mArr_sumData) {
        if(node.flag == 5){
            for(TreeJob_node *node2 in node.sonNodes){
                ChapterModel *model1 = node2.nodeData;
                if ([model1.TabID isEqualToString:tableID]) {
                    model1.mInt_select = 1;
                    TreeJob_level0_model *nodeData = node.nodeData;
                    nodeData.mStr_title = model1.chapterName;
                    nodeData.mStr_id = model1.TabID;
                    self.publishJobModel.chapterName = model1.chapterName;
                    self.publishJobModel.chapterID = model1.TabID;
                    [self addArrayChapter2:[tableID intValue] array:model1.array node:node];
                    //获取自定义作业
                    if (self.mInt_modeSelect ==3) {
                        //清掉自定义作业列表
                        TreeView_node *tempNode7 = [self.mArr_sumData objectAtIndex:8];
                        TreeJob_level0_model *tempModel7 = tempNode7.nodeData;
                        tempModel7.mStr_title = @"没有自定义作业";
                        tempModel7.mStr_id = 0;
                        [tempNode7.sonNodes removeAllObjects];
                        D("self.publishJobModel.chapterID-===%@",self.publishJobModel.chapterID);
                        if ([self.publishJobModel.chapterID intValue]>0) {
                            [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:self.publishJobModel.chapterID teacherJiaobaohao:[dm getInstance].jiaoBaoHao];
                        }
                    }
                }else{
                    model1.mInt_select = 0;
                    [self addArrayChapter2:[tableID intValue] array:model1.array node:node];
                }
            }
        }
    }
//    [self reloadDataForDisplayArray];
}

-(void)addArrayChapter2:(NSInteger)tableID array:(NSMutableArray *)array node:(TreeJob_node *)node{
    for (ChapterModel *model1 in array) {
        if ([model1.TabID intValue]==tableID) {
            model1.mInt_select = 1;
            TreeJob_level0_model *nodeData = node.nodeData;
            nodeData.mStr_title = model1.chapterName;
            nodeData.mStr_id = model1.TabID;
            self.publishJobModel.chapterName = model1.chapterName;
            self.publishJobModel.chapterID = model1.TabID;
            [self addArrayChapter2:tableID array:model1.array node:node];
            //获取自定义作业
            if (self.mInt_modeSelect ==3) {
                //清掉自定义作业列表
                TreeView_node *tempNode7 = [self.mArr_sumData objectAtIndex:8];
                TreeJob_level0_model *tempModel7 = tempNode7.nodeData;
                tempModel7.mStr_title = @"没有自定义作业";
                tempModel7.mStr_id = 0;
                [tempNode7.sonNodes removeAllObjects];
                D("self.publishJobModel.chapterID-===%@",self.publishJobModel.chapterID);
                if ([self.publishJobModel.chapterID intValue]>0) {
                    [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:self.publishJobModel.chapterID teacherJiaobaohao:[dm getInstance].jiaoBaoHao];
                }
            }
        }else{
            model1.mInt_select = 0;
            [self addArrayChapter2:tableID array:model1.array node:node];
        }
    }
}

//年级、科目、教版、章节的单选cell回调
-(void)TreeJob_sigleSelect_TableViewCellClick:(TreeJob_sigleSelect_TableViewCell *)treeJob_sigleSelect_TableViewCell{
    id temp = treeJob_sigleSelect_TableViewCell.model;
    if ([temp isKindOfClass:[ChapterModel class]]) {
        ChapterModel *model = treeJob_sigleSelect_TableViewCell.model;
        [self reloadDataForDisplayArrayChangeAt2:model.TabID];
    }else if ([temp isKindOfClass:[TreeJob_node class]]) {
        TreeJob_node *tempNode = treeJob_sigleSelect_TableViewCell.model;
        for (TreeJob_node *node in self.mArr_sumData) {
            if (node.flag == tempNode.faType&&node.flag==2)  {//年级
                for (TreeView_node *node1 in node.sonNodes) {
                    GradeModel *model = node1.nodeData;
                    GradeModel *model1 = tempNode.nodeData;
                    if ([model.GradeCode intValue]==[model1.GradeCode intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.GradeName;
                        nodeData.mStr_id = model1.GradeCode;
                        self.publishJobModel.GradeCode = model1.GradeCode;
                        self.publishJobModel.GradeName = model1.GradeName;
                        
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:model1.GradeCode subCode:@"0" uId:@"0" flag:@"0"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:3];
                        TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                        tempModel1.mStr_title = @"没有科目";
                        tempModel1.mStr_id = 0;
                        TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:4];
                        TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                        tempModel2.mStr_title = @"没有教版";
                        tempModel2.mStr_id = 0;
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:5];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        self.publishJobModel.subjectName = tempModel1.mStr_title;
                        self.publishJobModel.subjectCode = tempModel1.mStr_id;
                        self.publishJobModel.VersionName = @"";
                        self.publishJobModel.VersionCode = @"0";
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }else if (node.flag == tempNode.faType&&node.flag==3) {//科目
                for (TreeView_node *node1 in node.sonNodes) {
                    SubjectModel *model = node1.nodeData;
                    SubjectModel *model1 = tempNode.nodeData;
                    if ([model.subjectCode intValue]==[model1.subjectCode intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.subjectName;
                        nodeData.mStr_id = model1.subjectCode;
                        self.publishJobModel.subjectName = model1.subjectName;
                        self.publishJobModel.subjectCode = model1.subjectCode;
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        
                        TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:2];
                        TreeJob_level0_model *tempModel = tempNode.nodeData;
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:model1.subjectCode uId:@"0" flag:@"1"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode2 = [self.mArr_sumData objectAtIndex:4];
                        TreeJob_level0_model *tempModel2 = tempNode2.nodeData;
                        tempModel2.mStr_title = @"没有教版";
                        tempModel2.mStr_id = 0;
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:5];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        self.publishJobModel.VersionName = @"";
                        self.publishJobModel.VersionCode = @"0";
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }else if (node.flag == tempNode.faType&&node.flag==4) {//教版
                for (TreeView_node *node1 in node.sonNodes) {
                    VersionModel *model = node1.nodeData;
                    VersionModel *model1 = tempNode.nodeData;
                    if ([model.TabID intValue]==[model1.TabID intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.VersionName;
                        nodeData.mStr_id = model1.TabID;
                        self.publishJobModel.VersionName = model1.VersionName;
                        self.publishJobModel.VersionCode = model1.TabID;
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        TreeView_node *tempNode = [self.mArr_sumData objectAtIndex:2];
                        TreeJob_level0_model *tempModel = tempNode.nodeData;
                        TreeView_node *tempNode1 = [self.mArr_sumData objectAtIndex:3];
                        TreeJob_level0_model *tempModel1 = tempNode1.nodeData;
                        [[OnlineJobHttp getInstance]GetUnionChapterListWithgCode:tempModel.mStr_id subCode:tempModel1.mStr_id uId:model1.TabID flag:@"2"];
                        [MBProgressHUD showMessage:@"" toView:self.view];
                        //给默认空值
                        TreeView_node *tempNode3 = [self.mArr_sumData objectAtIndex:5];
                        TreeJob_level0_model *tempModel3 = tempNode3.nodeData;
                        tempModel3.mStr_title = @"没有章节";
                        tempModel3.mStr_id = 0;
                        self.publishJobModel.chapterName = @"";
                        self.publishJobModel.chapterID = @"0";
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }else if (node.flag == tempNode.faType&&node.flag==5) {//章节
                for (TreeView_node *node1 in node.sonNodes) {
                    ChapterModel *model = node1.nodeData;
                    ChapterModel *model1 = tempNode.nodeData;
                    if ([model.TabID intValue]==[model1.TabID intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.chapterName;
                        nodeData.mStr_id = model1.TabID;
                        self.publishJobModel.chapterName = model1.chapterName;
                        self.publishJobModel.chapterID = model1.TabID;
                        D("asjfgasgkljaskl-=====%@",model1.TabID);
//                        [self addArrayChapter2:[model1.TabID intValue] array:model1.array node:node];
//                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                        [self reloadDataForDisplayArrayChangeAt2:model1.TabID];
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }else if (node.flag == tempNode.faType&&node.flag==8) {//自定义作业
                for (TreeView_node *node1 in node.sonNodes) {
                    HomeworkModel *model = node1.nodeData;
                    HomeworkModel *model1 = tempNode.nodeData;
                    if ([model.TabID intValue]==[model1.TabID intValue]) {
                        model.mInt_select = 1;
                        TreeJob_level0_model *nodeData = node.nodeData;
                        nodeData.mStr_title = model1.homeworkName;
                        nodeData.mStr_id = model1.TabID;
                        self.publishJobModel.DesId = model1.TabID;
                        [self reloadDataForDisplayArrayChangeAt:node.flag];//修改cell的状态(关闭或打开)
                    }else{
                        model.mInt_select = 0;
                    }
                }
            }
        }
        
        if (tempNode.faType==8) {//点击了自定义作业
            
        }else{
            //清掉自定义作业列表
            TreeView_node *tempNode7 = [self.mArr_sumData objectAtIndex:8];
            TreeJob_level0_model *tempModel7 = tempNode7.nodeData;
            tempModel7.mStr_title = @"没有自定义作业";
            tempModel7.mStr_id = 0;
            [tempNode7.sonNodes removeAllObjects];
            //获取自定义作业
            if (self.mInt_modeSelect ==3) {
                D("self.publishJobModel.chapterID-===%@",self.publishJobModel.chapterID);
                if ([self.publishJobModel.chapterID intValue]>0) {
                    [[OnlineJobHttp getInstance]GetDesHWListWithChapterID:self.publishJobModel.chapterID teacherJiaobaohao:[dm getInstance].jiaoBaoHao];
                }
            }
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    self.publishJobModel.homeworkName = [NSString stringWithFormat:@"%@%@%@作业",dateStr,self.publishJobModel.subjectName,self.publishJobModel.chapterName];
    [self reloadDataForDisplayArray];
    
}

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
//    if([textField isEqual:self.dateTF])
//    {
//        textField.inputAccessoryView = self.toolBar;
//        textField.inputView = self.datePicker;
//    }
//    else
//    {
//        textField.inputView = nil;
//        textField.inputAccessoryView = nil;
//    }
}
//如果输入超过规定的字数100，就不再让输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Any new character added is passed in as the "text" parameter
    //输入删除时
//    self.publishJobModel.homeworkName = textField.text;
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textField resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    return TRUE;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.dateTF])
    {
        //self.publishJobModel.ExpTime = textField.text;
    }
    else
    {
        //去掉前后空格
        NSString *textName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.publishJobModel.homeworkName = textName;
    }
}


- (IBAction)cancelBtnAction:(id)sender {
    [self.dateTF resignFirstResponder];
}

- (IBAction)doneBtnAction:(id)sender {
    [self.dateTF resignFirstResponder];
    NSDate *nowDate = [NSDate date];
    NSComparisonResult result = [self.datePicker.date compare:nowDate];
    if(result == NSOrderedAscending)
    {
        [MBProgressHUD showError:@"时间过期"];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:self.datePicker.date];

    self.dateTF.text = dateStr;
    self.publishJobModel.ExpTime = dateStr;
    
}
-(void)PublishJob
{
    int int_All = [self.publishJobModel.SelNum intValue]+[self.publishJobModel.InpNum intValue];
    self.publishJobModel.AllNum =[NSString stringWithFormat:@"%d",int_All];
    NSString *textName;
    if ([self.titleTF isFirstResponder]) {
        textName = self.titleTF.text;
    }else{
        textName = self.publishJobModel.homeworkName;
    }
    textName = [textName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.publishJobModel.homeworkName = textName;
    if(self.publishJobModel.classIDArr.count == 0)
    {
        [MBProgressHUD showError:@"请选择班级"];
        return ;
    }
    if(!self.publishJobModel.chapterID)
    {
        [MBProgressHUD showError:@"请选择章节"];
        return ;
    }
    if([self.publishJobModel.chapterID integerValue]==0)
    {
        [MBProgressHUD showError:@"没有章节"];
        return;
    }
    if([self.publishJobModel.HwType isEqualToString:@"3"])
    {
        
        if([self.publishJobModel.DesId isEqualToString:@""])
        {
            [MBProgressHUD showError:@"请选择自定义作业"];
            return ;
        }
        self.publishJobModel.DoLv = @"3";
    }
    if([utils isBlankString:self.publishJobModel.homeworkName])
    {
        [MBProgressHUD showError:@"请输入作业标题"];
        return ;
    }
    if([utils isBlankString:self.publishJobModel.ExpTime])
    {
        [MBProgressHUD showError:@"请选择截止日期"];
        return ;
    }
    if (self.publishJobModel.homeworkName.length<6||self.publishJobModel.homeworkName.length>49) {
        [MBProgressHUD showError:@"作业名称要求6到49个字符"];
        return ;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:self.publishJobModel.ExpTime];
    NSDate *nowDate = [NSDate date];
    NSComparisonResult result = [date compare:nowDate];
    if(result == NSOrderedAscending)
    {
        [MBProgressHUD showError:@"时间过期"];
        return;
    }
    [[OnlineJobHttp getInstance]TecQswithchapterid:self.publishJobModel.chapterID];
}

-(void)TecMakeHWWithPublishJobModel:(id)sender
{
    NSString *result = [sender object];
    if([result isEqualToString:@"成功"])
    {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"发布作业成功" toView:self.view];
    }
    else
    {
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"发布作业失败" toView:self.view];
    }

    
//        NSError* error;
//        //从appdelegate获取数据数据库上下文
//        self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        //通过查询语句获取数据列表
//        NSFetchRequest* request=[[NSFetchRequest alloc] init];
//        NSEntityDescription* JobModelList=[NSEntityDescription entityForName:@"SaveJobModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//        [request setEntity:JobModelList];
//        NSPredicate * qcondition= [NSPredicate predicateWithFormat:@"teacherJiaobaohao = %@",[dm getInstance].jiaoBaoHao ];
//        [request setPredicate:qcondition];
//        NSMutableArray* mutableFetchResult=[[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    
//        if(mutableFetchResult.count == 0)
//        {
//            //数据库添加数据
//            self.saveJobModel = (SaveJobModel*)[NSEntityDescription insertNewObjectForEntityForName:@"SaveJobModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//
//        }
//        else
//        {
//            if(mutableFetchResult.count>0)
//            {
//
//                    self.saveJobModel = [mutableFetchResult objectAtIndex:0];
//        
//
//
//            }
//        }
//    
//        self.saveJobModel.gradeName = self.publishJobModel.GradeName;
//        self.saveJobModel.gradeCode = self.publishJobModel.GradeCode;
//        self.saveJobModel.subjectName = self.publishJobModel.subjectName;
//        self.saveJobModel.subjectID = self.publishJobModel.subjectCode;
//        self.saveJobModel.versionName = self.publishJobModel.VersionName;
//        self.saveJobModel.versionID = self.publishJobModel.VersionCode;
//        self.saveJobModel.chapterName = self.publishJobModel.chapterName;
//        self.saveJobModel.teacherJiaobaohao = [NSString stringWithFormat:@"%@" ,self.publishJobModel.teacherJiaobaohao];
//        self.saveJobModel.chapterID = self.publishJobModel.chapterID;
//        self.saveJobModel.allNum = self.publishJobModel.AllNum;
//        self.saveJobModel.selNum = self.publishJobModel.SelNum;
//        self.saveJobModel.inpNum = self.publishJobModel.InpNum;
//        self.saveJobModel.distribution = self.publishJobModel.Distribution;
//        self.saveJobModel.longTime = self.publishJobModel.LongTime;
//        self.saveJobModel.expTime = self.publishJobModel.ExpTime;
//        self.saveJobModel.homeworkName = self.publishJobModel.homeworkName;
//        self.saveJobModel.additional = self.publishJobModel.Additional;
//        self.saveJobModel.additionalDes = self.publishJobModel.AdditionalDes;
//        self.saveJobModel.hwType = self.publishJobModel.HwType;
//        self.saveJobModel.isQsSms = [NSNumber numberWithBool:self.publishJobModel.IsAnSms];
//        self.saveJobModel.isQsSms = [NSNumber numberWithBool:self.publishJobModel.IsQsSms];
//        self.saveJobModel.isRep = [NSNumber numberWithBool:self.publishJobModel.IsRep];
//        self.saveJobModel.tecName = self.publishJobModel.TecName;
//        self.saveJobModel.desId = self.publishJobModel.DesId;
//    NSFetchRequest* request2=[[NSFetchRequest alloc] init];
//    NSEntityDescription* saveClassModelList=[NSEntityDescription entityForName:@"SaveClassModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    [request2 setEntity:saveClassModelList];
//    NSMutableArray* mutableFetchResult2=[[self.appDelegate.managedObjectContext executeFetchRequest:request2 error:&error] mutableCopy];
//    if(mutableFetchResult2.count>0)
//    {
//        for(SaveClassModel *obj in mutableFetchResult2)
//        {
//            [self.appDelegate.managedObjectContext deleteObject:obj];
//            
//        }
//    }
//    [self.appDelegate.managedObjectContext save:&error];
//    for(int i=0;i<self.publishJobModel.classIDArr.count;i++)
//    {
//
//        SaveClassModel *saveClassModel = (SaveClassModel*)[NSEntityDescription insertNewObjectForEntityForName:@"SaveClassModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//        TreeJob_class_model *model = [self.publishJobModel.classIDArr objectAtIndex:i];
//        saveClassModel.classNam = model.mStr_className;
//        saveClassModel.classID = model.mStr_tableId;
//        saveClassModel.isSelected = [NSString stringWithFormat:@"%d",model.mInt_class];
//        saveClassModel.doLv =[NSNumber numberWithInt:model.mInt_difficulty];
//        [self.saveJobModel addSaveClassObject:saveClassModel];
//        
//    }
//        BOOL isSaveSuccess=[self.appDelegate.managedObjectContext save:&error];
//        if (!isSaveSuccess)
//        {
//            NSLog(@"Error:%@",error);
//        }else{
//            NSLog(@"Save successful!");
//        }
//        NSDictionary *dic = [self.saveJobModel propertiesDic];
//    
    
}
//-(void)getPublishJobModel
//{
//    NSError* error;
//    //从appdelegate获取数据数据库上下文
//    self.appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    //通过查询语句获取数据列表
//    NSFetchRequest* request=[[NSFetchRequest alloc] init];
//    NSEntityDescription* JobModelList=[NSEntityDescription entityForName:@"SaveJobModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    [request setEntity:JobModelList];
//    NSPredicate * qcondition= [NSPredicate predicateWithFormat:@"teacherJiaobaohao = %@",[dm getInstance].jiaoBaoHao ];
//    [request setPredicate:qcondition];
//    NSMutableArray* mutableFetchResult=[[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    
//    if(mutableFetchResult.count == 0)
//    {
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        
//        self.publishJobModel.GradeName = self.saveJobModel.gradeName;
//        self.publishJobModel.GradeCode = self.saveJobModel.gradeCode;
//        self.publishJobModel.subjectName = self.saveJobModel.subjectName;
//        self.publishJobModel.subjectCode = self.saveJobModel.subjectID;
//        self.publishJobModel.VersionName = self.saveJobModel.versionName;
//        self.publishJobModel.VersionCode = self.saveJobModel.versionID;
//        self.publishJobModel.chapterName = self.saveJobModel.chapterName;
//        self.publishJobModel.teacherJiaobaohao = self.saveJobModel.teacherJiaobaohao;
//        self.publishJobModel.chapterID = self.saveJobModel.chapterID;
//        self.publishJobModel.AllNum = self.saveJobModel.allNum;
//        self.publishJobModel.SelNum = self.saveJobModel.selNum;
//        self.publishJobModel.InpNum = self.saveJobModel.inpNum;
//        self.publishJobModel.Distribution = self.saveJobModel.distribution;
//        self.publishJobModel.LongTime = self.saveJobModel.longTime;
//        self.publishJobModel.ExpTime = self.saveJobModel.expTime;
//        self.publishJobModel.homeworkName = self.saveJobModel.homeworkName;
//        self.publishJobModel.Additional = self.saveJobModel.additional;
//        self.publishJobModel.AdditionalDes = self.saveJobModel.additionalDes;
//        self.publishJobModel.HwType = self.saveJobModel.hwType;
//        self.publishJobModel.IsAnSms = [[numberFormatter stringFromNumber: self.saveJobModel.isAnSms]integerValue];
//        self.publishJobModel.IsQsSms = [[numberFormatter stringFromNumber: self.saveJobModel.isQsSms]integerValue];
//        self.publishJobModel.IsRep = [[numberFormatter stringFromNumber: self.saveJobModel.isRep]integerValue];
//        self.publishJobModel.TecName = self.saveJobModel.tecName;
//        self.publishJobModel.DesId = self.saveJobModel.desId;
//        for(SaveClassModel *model in self.saveJobModel.saveClass)
//        {
//            TreeJob_class_model *classModel = [[TreeJob_class_model alloc]init];
//            classModel.mStr_tableId = model.classID;
//            classModel.mStr_className = model.classNam;
//            classModel.mInt_difficulty = [[NSString stringWithFormat:@"%@",model.doLv]intValue];
//            classModel.mInt_class = [[NSString stringWithFormat:@"%@",model.isSelected]intValue];
//            [self.publishJobModel.classIDArr addObject:classModel];
//        }
//
//    }
//    else
//    {
//        self.saveJobModel = [mutableFetchResult objectAtIndex:0];
//        
//    }
//
//    
//}

@end
