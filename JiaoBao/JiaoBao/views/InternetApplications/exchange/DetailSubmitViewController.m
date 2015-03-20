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


@interface DetailSubmitViewController ()
@property(nonatomic,strong)NSArray *nameArr;
//@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)NSMutableArray *tvArr;
@property(nonatomic,strong)UITextField *dateTextField;

@end

@implementation DetailSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSString *unitID = [NSString stringWithFormat:@"%d",dmInsance.UID];
    NSString *uType = [NSString stringWithFormat:@"%d",dmInsance.uType];
    NSLog(@"=%@- =%@-=%@-=%@",self.textView.text,self.textView2.text,self.startTime.text,self.endTime.text);
    if(![self.textView.text isEqualToString:@""]&&![self.textView2.text isEqualToString:@""]&&![self.startTime.text isEqualToString:@""]&&![self.endTime.text isEqualToString:@""])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:startStr,endStr,self.textView.text,self.textView2.text,@"0",self.recordDate.text,self.selectedDate.text,unitID,dmInsance.mStr_unit,uType,dmInsance.mStr_unit,DetptID,DetptName,@"0",@"未审核",dmInsance.userInfo.UserID,dmInsance.userInfo.UserName,flagStr,@"正常", nil] forKeys:[NSArray arrayWithObjects:@"dSdate",@"dEdate",@"sWorkPlace",@"sSubject",@"allday",@"dRecDate",@"dUpdateDate",@"UnitID",@"UnitName",@"UnitType",@"UnitTypeName",@"DetptID",@"DetptName",@"Checked",@"Checker",@"sRecorder",@"RecodrderName",@"Flag",@"FlagName",nil]];
        [utils logDic:dic];
        [[SignInHttp getInstance]uploadschedule:dic];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"不能为空"];
    }
    

    
}

-(void)getUpLoadResult:(id)sender
{
    NSDictionary *dic = [sender object];
    NSString *str = [dic objectForKey:@"ResultDesc"];
    [SVProgressHUD showSuccessWithStatus:str];
    
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *destDateString;
    if([self.dateTextField isEqual:self.startTime])
    {
        if(self.textView2.text)
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
                
                [SVProgressHUD showErrorWithStatus:@"结束时间必须大于开始时间"];
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
        if(self.textView.text)
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
                
                [SVProgressHUD showErrorWithStatus:@"结束时间必须大于开始时间"];
            }
            
            
        }
        
        else
        {
            destDateString = [dateFormatter stringFromDate:self.datePicker.date];
            self.dateTextField.text = destDateString;
            
        }
    }


    [self.view endEditing:YES];
}

@end
