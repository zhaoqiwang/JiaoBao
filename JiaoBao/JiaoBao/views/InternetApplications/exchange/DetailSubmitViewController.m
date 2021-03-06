//
//  DetailSubmitViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/3/5.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "DetailSubmitViewController.h"
#import "SignInHttp.h"
#import "dm.h"
#import "SVProgressHUD.h"
#import "MobClick.h"
#import "SelectionCell.h"
#import "LoginSendHttp.h"
#import "IQKeyboardManager.h"



@interface DetailSubmitViewController ()
@property(nonatomic,strong)NSArray *nameArr;
//@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)NSMutableArray *tvArr;
@property(nonatomic,strong)UITextField *dateTextField;

@end

@implementation DetailSubmitViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:UMMESSAGE];
    [MobClick beginLogPageView:UMPAGE];
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [ dm getInstance].onlyGetInfo = @"0";
    [MobClick endLogPageView:UMMESSAGE];
    [MobClick endLogPageView:UMPAGE];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    [dm getInstance].onlyGetInfo = [dm getInstance].userInfo.UserID;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUpLoadResult:) name:@"getUpLoadResult" object:nil];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.secDatePicker.backgroundColor = [UIColor whiteColor];
    self.startTime.inputView = self.datePicker;
    self.endTime.inputView = self.secDatePicker;
    self.startTime.inputAccessoryView = self.toolBar;
    self.endTime.inputAccessoryView = self.SecToolBar;
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 3.0;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    self.textView2.layer.masksToBounds = YES;
    self.textView2.layer.cornerRadius = 3.0;
    self.textView2.layer.borderWidth = 1.0;
    self.textView2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.selectedDate.text = self.selectedStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSString *destDateString = [dateFormatter stringFromDate:currentDate];
    self.recordDate.text = destDateString;

    self.tvArr = [[NSMutableArray alloc]initWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChangedAction:) name:UITextViewTextDidChangeNotification object:nil];
    self.nameArr = [NSArray arrayWithObjects:@"工作地点",@"开始时间",@"结束时间",@"工作内容", nil];
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"填写信息"];
    [self.mNav_navgationBar setRightBtnTitle:@"提交"];
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *mArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<[dm getInstance].identity.count;i++)
    {
        Identity_model *model= [[dm getInstance].identity objectAtIndex:i];
        if([model.RoleIdName isEqualToString:@"家长"]|[model.RoleIdName isEqualToString:@"学生"])
        {

            
        }
        else
        {
            for(int i=0;i<model.UserUnits.count;i++)
            {
                Identity_UserUnits_model *model2 = [model.UserUnits objectAtIndex:i];
                [mArr addObject:model2.UnitName];
                [mArr2 addObject:model2];
                
            }
            
        }
        
    self.unitArr = mArr;
        if(mArr.count>0)
        {
            self.unitTF.text = [mArr objectAtIndex:0];
            self.UserUnits_model = [mArr2 objectAtIndex:0];
            
        }
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.unitTF.frame.origin.x, self.unitTF.frame.origin.y+30, 200, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
    return mArr.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }

            [cell.lb setText:[mArr objectAtIndex:indexPath.row]];
        
        
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];

        self.unitTF.text=cell.lb.text;
        self.mTableV_name.frame = CGRectMake(self.unitTF.frame.origin.x, self.unitTF.frame.origin.y+30, 200, 0);
        self.isOpen = NO;
        self.UserUnits_model = [mArr2 objectAtIndex:indexPath.row];
        NSString *unitID = self.UserUnits_model.UnitID;
        [dm getInstance].onlyGetInfo = @"1";
        [[LoginSendHttp getInstance]getUserInfoWith:[dm getInstance].jiaoBaoHao UID:unitID];


    }];
    
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:2];
    [self.view addSubview:self.mTableV_name];
}

    // Do any additional setup after loading the view from its nib.
}
-(void)navigationRightAction:(UIButton *)sender
{
    NSString *flagStr = [NSString stringWithFormat:@"%ld",self.dayInterval];
    dm *dmInsance = [dm getInstance];
    NSString *startStr = [NSString stringWithFormat:@"%@ %@",self.selectedStr,self.startTime.text];
    NSString *endStr = [NSString stringWithFormat:@"%@ %@",self.selectedStr,self.endTime.text];
    
    NSString *DetptID = [NSString stringWithFormat:@"%@",[self.groupDic objectForKey:@"GroupID"]];
    NSString *DetptName = [NSString stringWithFormat:@"%@",[self.groupDic objectForKey:@"GroupName"]];
//    NSString *unitID = [NSString stringWithFormat:@"%d",dmInsance.UID];
//    NSString *uType = [NSString stringWithFormat:@"%d",dmInsance.uType];
    NSString *unitName = self.UserUnits_model.UnitName;
    NSString *unitType = self.UserUnits_model.UnitType;
    NSString *unitID = self.UserUnits_model.UnitID;
    NSString *unitTypeName ;
    NSString *userID = [dm getInstance].onlyGetInfo;

    if([unitType integerValue] == 1)
    {
        unitTypeName = @"教育局人员";
    }
    else if ([unitType integerValue] == 2)
    {
        unitTypeName = @"老师";
    }
    else if ([unitType integerValue] == 3)
    {
        unitTypeName = @"家长";
    }
    else
    {
        unitTypeName = @"学生";
    }

    if(![utils isBlankString:self.textView.text]&&![utils isBlankString:self.textView2.text]&&![self.startTime.text isEqualToString:@""]&&![self.endTime.text isEqualToString:@""])
    {
        @try {

            
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:startStr,endStr,self.textView.text,self.textView2.text,@"0",self.recordDate.text,self.selectedDate.text,unitID,unitName,unitType,unitTypeName,DetptID,DetptName,@"0",@"未审核",userID,dmInsance.userInfo.UserName,flagStr,@"正常", nil] forKeys:[NSArray arrayWithObjects:@"dSdate",@"dEdate",@"sWorkPlace",@"sSubject",@"allday",@"dRecDate",@"dUpdateDate",@"UnitID",@"UnitName",@"UnitType",@"UnitTypeName",@"DetptID",@"DetptName",@"Checked",@"Checker",@"sRecorder",@"RecodrderName",@"Flag",@"FlagName",nil]];
            [[SignInHttp getInstance]uploadschedule:dic];
        }
        @catch (NSException *exception) {
            [MBProgressHUD showError:@"数据异常" toView:self.view];
            
        }
        @finally {
            
        }

        
    }
    else
    {
        [MBProgressHUD showError:@"不能为空" toView:self.view];

    }
    

    
}

-(void)getUpLoadResult:(id)sender
{
    
    [MBProgressHUD hideHUDForView:self.view];
    if([[sender object] isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showError:[sender object] toView:self.view];
        return;
        
    }
    NSDictionary *dic = [sender object];
    NSString *str = [dic objectForKey:@"ResultDesc"];
    [MBProgressHUD showSuccess:str toView:self.view];
    self.textView.text = @"";
    self.textView2.text = @"";
    self.startTime.text = @"";
    self.endTime.text = @"";
    
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if([textView isEqual:self.textView2])
//    {
//        //self.mainView.frame.origin.y+self.textView2.frame.origin.y
//        self.mainView.frame = CGRectMake(0,self.mainView.frame.origin.y-90, self.mainView.frame.size.width, self.mainView.frame.size.height);
//    }
//    return YES;
//}
//
//-(BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    if([textView isEqual:self.textView2])
//    {
//        self.mainView.frame = CGRectMake(0,51 , self.mainView.frame.size.width, self.mainView.frame.size.height);
//    }
//    [self.view endEditing:YES];
//    return YES;
//    
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)textViewChangedAction:(id)sender
{
    //self.textView = (UITextView*)sender;
    //通过label高度控制cell高度
//    CGRect rect=[self.textView.text  boundingRectWithSize:CGSizeMake(190, 1000) options:NSStringDrawingUsesLineFragmentOrigin
//                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14
//                                                                                                                   ],NSFontAttributeName, nil]  context:nil];
//    self.textView.frame = CGRectMake(98, 75, 200, rect.size.height);
    
    
    
    
    //[self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4
    ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    
//        //通过label高度控制cell高度
//        CGRect rect=[[self.detailArr objectAtIndex:7] boundingRectWithSize:CGSizeMake(205, 1000) options:NSStringDrawingUsesLineFragmentOrigin
//                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]  context:nil];
//        
//        
//        return rect.size.height+20;
    return 0;
    
    
}




-(void)myNavigationGoback{
    [dm getInstance].addQuestionNoti = NO;
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.dateTextField = textField;
    return YES;
}
- (IBAction)cancelAction:(id)sender {
    [self.view endEditing:YES];

}

- (IBAction)doneAction:(id)sender {
    //NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString;


        if([self.dateTextField isEqual:self.startTime])
        {
            if(![self.endTime.text isEqualToString:@""] )
            {
                
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedAscending)
                {
                    destDateString = [dateFormatter stringFromDate:self.datePicker.date];
                    self.dateTextField.text = destDateString;
                    
                    
                    
                }
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedSame)
                {
                    destDateString = [dateFormatter stringFromDate:self.datePicker.date];
                    self.dateTextField.text = destDateString;
                    
                    
                    
                }
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedDescending)
                {
                    [MBProgressHUD showError:@"结束时间必须大于开始时间" toView:self.view];
                    
                }
                
                
            }
            else
            {
                destDateString = [dateFormatter stringFromDate:self.datePicker.date];
                self.dateTextField.text = destDateString;
                
            }
            
            
            
            
        }
        
        if([self.dateTextField isEqual:self.endTime])
        {
            if(![self.startTime.text isEqualToString:@""] )
            {
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedAscending)
                {
                    destDateString = [dateFormatter stringFromDate:self.secDatePicker.date];
                    self.dateTextField.text = destDateString;
                    
                    
                    
                }
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedSame)
                {
                    destDateString = [dateFormatter stringFromDate:self.secDatePicker.date];
                    self.dateTextField.text = destDateString;
                    
                    
                    
                }
                if([self.datePicker.date compare:self.secDatePicker.date]==NSOrderedDescending)
                {
                    [MBProgressHUD showError:@"结束时间必须大于开始时间" toView:self.view];
                }
                
                
            }
            
            else
            {
                destDateString = [dateFormatter stringFromDate:self.secDatePicker.date];
                self.dateTextField.text = destDateString;
                
            }
        }

        
    
    

    [self.view endEditing:YES];
}

- (IBAction)pullBtnAction:(id)sender {
    if(self.isOpen == NO)
    {
        self.isOpen = !self.isOpen;
        self.mTableV_name.frame = CGRectMake(self.unitTF.frame.origin.x, self.unitTF.frame.origin.y+30+45, 200,self.unitArr.count *30 );
        D("frame = %@",NSStringFromCGRect(self.mTableV_name.frame));
    }
    else
    {
        self.isOpen = !self.isOpen;
        self.mTableV_name.frame = CGRectMake(self.unitTF.frame.origin.x, self.unitTF.frame.origin.y+30, 200, 0);
    }
    
}
@end
