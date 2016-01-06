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
#import "IQKeyboardManager.h"
#import "ShareHttp.h"
#import "NickNameModel.h"
#import "InvitationUserInfo.h"


@interface AddQuestionViewController ()<UITextViewDelegate>
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSArray *provinceArr;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITextField *selectedTF;
@property(nonatomic,strong)ProviceModel *proviceModel;
@property(nonatomic,assign)BOOL QFlag;
@property(nonatomic,assign)NSString *QId;
@property(nonatomic,strong)NickNameModel *nickNameModel;
@property(nonatomic,strong)InvitationUserInfo *invitationUserInfo;
@property(nonatomic,assign)NSRange cursorPosition;
@property(nonatomic,strong)NSString *deleteStr;
@end

@implementation AddQuestionViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//获取省份
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
    __weak AddQuestionViewController *weakSelf = self;
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        return weakSelf.dataArr.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        ProviceModel *model = [weakSelf.dataArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.CnName ;
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.mTableV_name.frame =  CGRectMake(weakSelf.selectedTF.frame.origin.x, weakSelf.selectedTF.frame.origin.y+30, 166, 0);
            
            
        } completion:^(BOOL finished){
            ProviceModel *model = [weakSelf.dataArr objectAtIndex:indexPath.row];
            weakSelf.selectedTF.text = model.CnName;
            weakSelf.selectedTF.tag = [model.CityCode integerValue];
            if(![model.CnName isEqualToString:@"请选择"])
            {
                weakSelf.proviceModel = model;

            }
        }];
        if([weakSelf.selectedTF isEqual:weakSelf.provinceTF])
        {
            weakSelf.regionTF.text = @"";
            weakSelf.countyTF.text = @"";
        }
        if([weakSelf.selectedTF isEqual:weakSelf.regionTF])
        {
            weakSelf.countyTF.text = @"";

        }
        weakSelf.isOpen = NO;
        
        
    }];
    
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:2];
    [self.mainScrollView addSubview:self.mTableV_name];

}

//获取地区或区县
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
//获取分类
-(void)GetAllCategory:(id)sender
{
    [MBProgressHUD hideHUDForView:self.view];
    NSDictionary *dic = [sender object];
    self.mArr_AllCategory =[dic objectForKey:@"array"] ;
    CategoryViewController *detailVC = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    detailVC.mArr_selectCategory = [[NSMutableArray alloc]initWithCapacity:0];

    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
    detailVC.categoryTF = self.categoryTF;
    detailVC.categoryId = self.categoryId;
    detailVC.classStr = [NSString stringWithUTF8String:object_getClassName(self)];
    detailVC.mArr_AllCategory = self.mArr_AllCategory;
    [self.navigationController presentViewController:detailVC animated:YES completion:^{
        //detailVC.view.superview.frame = CGRectMake(10, 44+30, [dm getInstance].width-20, [dm getInstance].height-84);
    }];
}
-(void)GetAtMeUsersWithuid:(id)sender
{
    NSDictionary *dic = [sender object];
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if([ResultCode integerValue] != 0)
    {
        [MBProgressHUD hideHUDForView:self.view];
        if([ResultCode integerValue]==999999){
            ResultDesc = @"不存在此邀请人";
            
        }
        [MBProgressHUD showError:ResultDesc];
        return;
    }
    else
    {
        NSArray *arr = [dic objectForKey:@"array"];
        if(arr.count>0)
        {
            //self.nickNameModel = [arr objectAtIndex:0];
            self.invitationUserInfo = [arr objectAtIndex:0];
            NSString *content = self.mTextV_content.text;
            for (int i=0; i<self.mArr_pic.count; i++) {
                UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
                NSString *temp = model.originalName;
                content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
            }
            content = [NSString stringWithFormat:@"<p>%@</p>",content];
            
            NSString *QFlagStr = [NSString stringWithFormat:@"%d",self.QFlag];
            [[KnowledgeHttp getInstance]NewQuestionWithCategoryId:self.categoryId Title:self.mText_title.text KnContent:content TagsList:@"" QFlag:QFlagStr AreaCode:self.AreaCode atAccIds:@""];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"不存在邀请人%@",self.atAccIdsTF.text];
            [MBProgressHUD showError:str];
            [MBProgressHUD hideHUDForView:self.view];
            //self.nickNameModel = nil;
            self.invitationUserInfo = nil;
        }
        
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //[IQKeyboardManager sharedManager].enable = NO;//控制整个功能是否启用
    //做bug服务器显示当前的哪个界面
    NSString *nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    [[NSUserDefaults standardUserDefaults]setValue:nowViewStr forKey:BUGFROM];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.mainScrollView.contentSize = self.mainScrollView.frame.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mInt_index = 1;
    //邀请指定的用户回答问题
    //获取邀请人
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetAtMeUsersWithuid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetAtMeUsersWithuid:) name:@"GetAtMeUsersWithuid" object:nil];
    //邀请回答
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AtMeForAnswerWithAccId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AtMeForAnswerWithAccId:) name:@"AtMeForAnswerWithAccId" object:nil];
    [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    self.QFlag = 1;
    [dm getInstance].addQuestionNoti = YES;


    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条

    //上传图片
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadImg:) name:@"UploadImg" object:nil];
    self.mArr_pic = [NSMutableArray array];
    self.selectedTF = self.provinceTF;
    self.categoryId = [NSMutableString stringWithString:@"1"];
    if([self.provinceTF.text isEqualToString:@""])
    {
        D("provinceTF_text = %@",self.provinceTF.text);

    }
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"添加问题"];
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NewQuestionWithCategoryId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NewQuestionWithCategoryId:) name:@"NewQuestionWithCategoryId" object:nil];

    
    self.mText_title.layer.borderWidth = .5;
    self.mText_title.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mText_title.layer.cornerRadius = 5;
    self.mText_title.layer.masksToBounds = YES;
    
    self.mTextV_content.layer.borderWidth = .5;
    self.mTextV_content.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //将图层的边框设置为圆脚
    self.mTextV_content.layer.cornerRadius = 5;
    self.mTextV_content.layer.masksToBounds = YES;
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"标题" attributes:nil];
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = [UIImage imageNamed:@"buttonView3"];
    textAttach.bounds=CGRectMake(3, 0, 10, 10);
    NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
    [str insertAttributedString:strA atIndex:2];

    self.ttitleLabel.attributedText = str;
    
    NSMutableAttributedString *str1=[[NSMutableAttributedString alloc] initWithString:@"问题描述" attributes:nil];
    
    self.contentLabel.attributedText = str1;
    
    NSMutableAttributedString *str2=[[NSMutableAttributedString alloc] initWithString:@"问题分类" attributes:nil];
    
    [str2 insertAttributedString:strA atIndex:4];
    self.categoryLabel.attributedText = str2;

}

//邀请指定的用户回答问题
-(void)AtMeForAnswerWithAccId:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *ResultCode = [dic objectForKey:@"ResultCode"];
    NSString *ResultDesc = [dic objectForKey:@"ResultDesc"];
    if ([ResultCode integerValue] ==0)
    {
        if(self.invitationUserInfo)
        {
            if([self.invitationUserInfo.NickName isEqual:[NSNull null]])
            {
                self.invitationUserInfo.NickName = self.atAccIdsTF.text;
            }
            NSString *message = [NSString stringWithFormat:@"邀请%@成功",self.invitationUserInfo.NickName];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发布问题成功" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            self.provinceTF.text = @"";
            self.regionTF.text = @"";
            self.countyTF.text = @"";
            self.mTextV_content.text = @"";
            self.mText_title.text = @"";
            self.atAccIdsTF.text = @"";
            self.categoryTF.text = @"";
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            [dm getInstance].addQuestionNoti = NO;
            
            //输入框弹出键盘问题
            IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
            manager.enable = NO;//控制整个功能是否启用
            manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
            manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
            manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
            [utils popViewControllerAnimated:YES];
        }
        else
        {
            self.provinceTF.text = @"";
            self.regionTF.text = @"";
            self.countyTF.text = @"";
            self.mTextV_content.text = @"";
            self.mText_title.text = @"";
            self.atAccIdsTF.text = @"";
            self.categoryTF.text = @"";
            [MBProgressHUD showError:@"发布问题成功"];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            [dm getInstance].addQuestionNoti = NO;
            
            //输入框弹出键盘问题
            IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
            manager.enable = NO;//控制整个功能是否启用
            manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
            manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
            manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
            [utils popViewControllerAnimated:YES];
            

        }
        
        
    }else
    {
        if([ResultCode integerValue]==999999){
            ResultDesc = @"不存在此邀请人";
        }
        [MBProgressHUD showError:ResultDesc] ;

    }
}
//发布问题回调
-(void)NewQuestionWithCategoryId:(id)sender
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
        self.QId = [dic objectForKey:@"Data"];
        if([self.atAccIdsTF.text isEqualToString:@""])
        {
            self.provinceTF.text = @"";
            self.regionTF.text = @"";
            self.countyTF.text = @"";
            self.mTextV_content.text = @"";
            self.mText_title.text = @"";
            self.atAccIdsTF.text = @"";
            self.categoryTF.text = @"";
            [MBProgressHUD showSuccess:ResultDesc];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
            [dm getInstance].addQuestionNoti = NO;
            
            //输入框弹出键盘问题
            IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
            manager.enable = NO;//控制整个功能是否启用
            manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
            manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
            manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gotoView:) userInfo:nil repeats:NO];
            
        }
        else
        {
            [[KnowledgeHttp getInstance] AtMeForAnswerWithAccId:self.invitationUserInfo.JiaoBaoHao qId:self.QId];
            
        }

    }
}
-(void)gotoView:(id)sender{
    NSTimer *timer = sender;
    [timer invalidate];
    timer =nil;
    [self myNavigationGoback];

    
}
//点击省份
- (IBAction)provinceBtnAction:(id)sender {
    JoinUnit
    NoNickName
    [self.view endEditing:YES];
    self.selectedTF = self.provinceTF;
    self.dataArr = self.provinceArr;
    [self.mTableV_name reloadData];

    if(self.isOpen == NO)
    {
           [UIView animateWithDuration:0.3 animations:^{
              int h = self.mainScrollView.frame.size.height-self.provinceTF.frame.size.height-self.provinceTF.frame.origin.y;
               if(44*self.dataArr.count>h)
               {
                           self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, h);
               }
               else
               {
                    self.mTableV_name.frame =  CGRectMake(self.provinceTF.frame.origin.x, self.provinceTF.frame.origin.y+30, 166, 44*self.dataArr.count);
               }

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

    //self.mainScrollView.contentSize = self.mainScrollView.frame.size;
    
}
//点击地区
- (IBAction)regionBtnAction:(id)sender {
    JoinUnit
    NoNickName
    [self.view endEditing:YES];
    if([self.provinceTF.text isEqualToString:@""]||[self.provinceTF.text isEqualToString:@"请选择"])
    {
        return;
    }
    self.selectedTF = self.regionTF;
    self.countyTF.text = @"";
    if(![self.regionTF.text isEqualToString:@"请选择"]){
        [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"1"];

    }
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            int h = self.mainScrollView.frame.size.height-self.selectedTF.frame.size.height-self.selectedTF.frame.origin.y;
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, h);
            
            
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
//点击区县
- (IBAction)countyBtnAction:(id)sender {
    JoinUnit
    NoNickName
    [self.view endEditing:YES];
    if([self.provinceTF.text isEqualToString:@""]||[self.regionTF.text isEqualToString:@""]||[self.provinceTF.text isEqualToString:@"请选择"]||[self.regionTF.text isEqualToString:@"请选择"])
    {
        return;
    }
    self.selectedTF = self.countyTF;
    if(![self.countyTF.text isEqualToString:@"请选择"]){
        [[KnowledgeHttp getInstance]knowledgeHttpGetCity:self.proviceModel.CityCode level:@"2"];
    }
    if(self.isOpen == NO)
    {
        [UIView animateWithDuration:0.3 animations:^{
            int h = self.mainScrollView.frame.size.height-self.selectedTF.frame.size.height-self.selectedTF.frame.origin.y;
            self.mTableV_name.frame =  CGRectMake(self.selectedTF.frame.origin.x, self.selectedTF.frame.origin.y+30, 166, h);

            
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
//点击分类
- (IBAction)categaryBtnAction:(id)sender {
    JoinUnit
    NoNickName
    [[KnowledgeHttp getInstance]GetAllCategory];
    [MBProgressHUD showMessage:@"" toView:self.view];


}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    JoinUnitTextF
    NoNickNameTextF
}

- (IBAction)selectBtnAction:(id)sender {
    JoinUnit
    NoNickName
    UIButton *btn = self.selectBtn;
    if([[btn imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"selected"]])
    {
        [btn setImage:[UIImage imageNamed:@"blank"] forState:UIControlStateNormal];
        self.QFlag = 0;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        self.QFlag = 1;
    }
    
}
//点击拍照
-(IBAction)mBtn_photo:(id)sender{
    JoinUnit
    NoNickName
    self.cursorPosition = [self.mTextV_content selectedRange];

    [self.mTextV_content resignFirstResponder];
    [self.mText_title resignFirstResponder];
    if(self.mArr_pic.count>=20)
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你只能上传20张图片" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertview show];
        return;
    }
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
}

//点击发布问题
- (IBAction)addQuestionAction:(id)sender {
    JoinUnit
    NoNickName
   [self.view endEditing:YES];
    if([utils isBlankString:self.mText_title.text])
    {
        [MBProgressHUD showError:@"请添写标题"];
        return;
    }
    if(self.mText_title.text.length>100)
    {
        [MBProgressHUD showError:@"标题不能超过100字"];
        return;
    }
    if ([dm getInstance].NickName1.length==0) {
        [MBProgressHUD showError:@"请去个人中心设置昵称" toView:self.view];
        return;
    }

    if([utils isBlankString:self.categoryTF.text])
    {
        [MBProgressHUD showError:@"请选择分类"];
        return;
    }


    if([self.provinceTF.text isEqualToString:@"请选择"]||[self.provinceTF.text isEqualToString:@""]){
        self.AreaCode = @"";
    }
    else if ([self.regionTF.text isEqualToString:@"请选择"]||[self.regionTF.text isEqualToString:@""]){
        self.AreaCode = [NSString stringWithFormat:@"%ld",self.provinceTF.tag];
    }
    else if ([self.countyTF.text isEqualToString:@"请选择"]||[self.countyTF.text isEqualToString:@""]){
        self.AreaCode = [NSString stringWithFormat:@"%ld",self.regionTF.tag];
    }else{
        self.AreaCode = [NSString stringWithFormat:@"%ld",self.countyTF.tag];
    }
    if([self.atAccIdsTF.text isEqualToString: @""])
    {
        for (long i=self.mArr_pic.count-1; i<self.mArr_pic.count; i--) {
            UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
            NSRange range = NSMakeRange(model.cursorPosition.location, 1);
            //NSString *temp = model.originalName;
            //content = [content stringByReplacingOccurrencesOfString:temp withString:model.url];
            NSMutableAttributedString *strz =  [[NSMutableAttributedString alloc]initWithAttributedString: self.mTextV_content.attributedText];
            [strz replaceCharactersInRange:range withString:model.url];
            self.mTextV_content.attributedText = strz;
            
        }
        NSString *content = self.mTextV_content.text;

        if (content.length>4000) {
            [MBProgressHUD showError:@"您输入内容字数过多" toView:self.view];
            return;
        }
//        content = [NSString stringWithFormat:@"<p>%@</p>",content];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\n"] withString:@"</br>"];
        content = [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\r"] withString:@"</br>"];
        NSString *QFlagStr = [NSString stringWithFormat:@"%d",self.QFlag];
        [MBProgressHUD showMessage:@"" toView:self.view];
        [[KnowledgeHttp getInstance]NewQuestionWithCategoryId:self.categoryId Title:self.mText_title.text KnContent:content TagsList:@"" QFlag:QFlagStr AreaCode:self.AreaCode atAccIds:@""];
    }
    else
    {
        [[KnowledgeHttp getInstance]GetAtMeUsersWithuid:self.atAccIdsTF.text catid:self.categoryId];
        [MBProgressHUD showMessage:@"" toView:self.view];
        
    }

}
//点击开始编辑：
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //先判断是否加入单位，没有，则不能进行交互
    JoinUnitTextV
    //没有昵称，不能交互
    NoNickNameTextV

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //输入删除时
    if ([text isEqualToString:@""]) {
        if([textView isEqual:self.mTextV_content]){
            for (int i=0; i<self.mArr_pic.count; i++) {
                UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
                if(range.length==1){
                    if(range.location < model.cursorPosition.location){
                        model.cursorPosition = NSMakeRange(model.cursorPosition.location-1, model.cursorPosition.length);
                    }
                    else{
                        if(range.location == model.cursorPosition.location ){
                            [self.mArr_pic removeObject:model];
                        }
                        
                    }
                } else{
                    if(range.location<=model.cursorPosition.location&&range.location+range.length>model.cursorPosition.location){
                        [self.mArr_pic removeObject:model];

                    }
                    else if(range.location<=model.cursorPosition.location&&range.location+range.length<=model.cursorPosition.location){
                        model.cursorPosition = NSMakeRange(model.cursorPosition.location-range.length, model.cursorPosition.length);

                    }else if(range.location>model.cursorPosition.location){
                        
                    }
                }


            }
            
        }


        
        return YES;
    }

    if([textView isEqual:self.mText_title])
    {
        if(range.location==99&&text.length==1)
        {
            NSLog(@"text = %@",text);

            if([text isEqualToString:@"➋"])
            {
                text = @"a";
            }else if([text isEqualToString:@"➌"]){
               text = @"d";
            }else if([text isEqualToString:@"➍"]){
                text = @"g";
            }else if([text isEqualToString:@"➎"]){
                text = @"j";
            }else if([text isEqualToString:@"➏"]){
                text = @"m";
            }else if([text isEqualToString:@"➐"]){
                text = @"p";
            }else if([text isEqualToString:@"➑"]){
                text = @"t";
            }else if([text isEqualToString:@"➒"]){
                text = @"w";
            }else if([text isEqualToString:@"☻"]){
                text = @"^";
            }else {
            }
        }
        NSString *Sumstr = [NSString stringWithFormat:@"%@%@",textView.text,text];
            if(Sumstr.length>99)
            {
                textView.text = [Sumstr substringToIndex:100];
                self.titleTF.hidden = YES;
                return NO;
            }
        if ([text isEqualToString:@"\n"]) {
            textView.text = [NSString stringWithFormat:@"%@ ",textView.text];
            self.titleTF.hidden = YES;
            // Be sure to test for equality using the "isEqualToString" message
            
            // Return FALSE so that the final '\n' character doesn't get added
            return NO;
        }
    }
    else{
        for (int i=0; i<self.mArr_pic.count; i++) {
            UploadImgModel *model = [self.mArr_pic objectAtIndex:i];
                if(range.location <= model.cursorPosition.location){
                    model.cursorPosition = NSMakeRange(model.cursorPosition.location+range.length, model.cursorPosition.length);
                }



        }
        
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{

    if([textView isEqual:self.mText_title])
    {
        if([textView.text isEqualToString:@""])
        {
            self.titleTF.hidden = NO;
        }
        else
        {
            self.titleTF.hidden = YES;
            
        }
        
    }
    if([textView isEqual:self.mTextV_content])
    {
        if([textView.text isEqualToString:@""])
        {
            self.knContentTF.hidden = NO;
        }
        else
        {
            self.knContentTF.hidden = YES;
            
        }
        
    }

    if([textView isEqual:self.mText_title])
    {
        if(textView.text.length>100)
        {
            textView.text = [textView.text substringToIndex:100];
        }
    }


    
}

-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [dm getInstance].addQuestionNoti = NO;
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}
#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                {
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = NO;
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    }
                    //                    self.tfContentTag = self.mArr_pic.count;
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 2: //相册
                {
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    
                    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                    
                    elcPicker.imagePickerDelegate = self;
                    [self presentViewController:elcPicker animated:YES completion:nil];
                }
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                
                elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 10
                elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
                elcPicker.imagePickerDelegate = self;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
            
        }
        
        
    }
}

//上传图片回调
-(void)UploadImg:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view];
    NSMutableDictionary *dic = noti.object;
    NSString *flag = [dic objectForKey:@"flag"];
    if ([flag integerValue]==0) {
        self.imageCount--;
        UploadImgModel *model = [dic objectForKey:@"model"];
        if(self.imageCount == 0)
        {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
            NSInteger index = self.cursorPosition.location;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
            NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index-1]];
            UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithAttributedString:self.mTextV_content.attributedText];
            NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
            textAttach.image = image;
            textAttach.bounds=CGRectMake(0, 0, 30, 30);
            model.cursorPosition = self.cursorPosition;
            NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:textAttach];
            [str insertAttributedString:strA atIndex:index];
            model.attributedString = strA;
            self.mTextV_content.attributedText = str;
            [self.mArr_pic addObject:model];

            NSArray *arr = [self.mArr_pic sortedArrayUsingComparator:^NSComparisonResult(UploadImgModel *p1, UploadImgModel *p2){

                            NSNumber *p1_num = [NSNumber numberWithInteger:p1.cursorPosition.location ];
                            NSNumber *p2_num = [NSNumber numberWithInteger:p2.cursorPosition.location ];

                            return [p1_num compare:p2_num];
            }];
            self.mArr_pic =[NSMutableArray arrayWithArray:arr];
            
        }
    }else{
        [MBProgressHUD showError:@"失败" toView:self.view];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageCount = 1;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    [MBProgressHUD showMessage:@"正在上传" toView:self.view];
    
    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    image = [self fixOrientation:image];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
    //判断文件夹是否存在
    if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData *imageData = UIImageJPEGRepresentation(image,0);
    NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
    D("图片路径是：%@",imgPath);
    
    
    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
    if (!yesNo) {//不存在，则直接写入后通知界面刷新
        BOOL result = [imageData writeToFile:imgPath atomically:YES];
        for (;;) {
            if (result) {
                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                
                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                break;
            }
        }
    }else {
        //存在
        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
        if (blDele) {//删除成功后，写入，通知界面
            BOOL result = [imageData writeToFile:imgPath atomically:YES];
            for (;;) {
                if (result) {
                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                    
                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                    break;
                }
            }
        }
    }
    
    self.mInt_index ++;
    self.knContentTF.hidden = YES;

}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    self.imageCount = info.count;
    if(info.count>0)
    {
        [MBProgressHUD showMessage:@"正在上传图片" toView:self.view];

    }
    [self dismissViewControllerAnimated:YES completion:^{
        //发送选中图片上传请求
        if (info.count>0) {
            D("info.count-===%lu",(unsigned long)info.count);
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件名
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *tempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"file-%@",[dm getInstance].jiaoBaoHao]];
        //判断文件夹是否存在
        if(![fileManager fileExistsAtPath:tempPath]) {//如果不存在
            [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    NSData *imageData = UIImageJPEGRepresentation(image,0);
                    NSString *imgPath=[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"[图片%d].png",self.mInt_index]];
                    D("图片路径是：%@",imgPath);
                    BOOL yesNo=[[NSFileManager defaultManager] fileExistsAtPath:imgPath];
                    if (!yesNo) {//不存在，则直接写入后通知界面刷新
                        BOOL result = [imageData writeToFile:imgPath atomically:YES];
                        for (;;) {
                            if (result) {
                                NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                
                                [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];
                                //                                self.mTextV_content.text = [NSString stringWithFormat:@"%@%@",self.mTextV_content.text,name];
                                self.mInt_index ++;
                                break;
                            }
                        }
                    }else {
                        //存在
                        BOOL blDele= [fileManager removeItemAtPath:imgPath error:nil];//先删除
                        if (blDele) {//删除成功后，写入，通知界面
                            BOOL result = [imageData writeToFile:imgPath atomically:YES];
                            for (;;) {
                                if (result) {
                                    NSString *name = [NSString stringWithFormat:@"[图片%d]",self.mInt_index];
                                    [[ShareHttp getInstance] shareHttpUploadSectionImgWith:imgPath Name:name];

                                    self.mInt_index ++;
                                    
                                    break;
                                }
                            }
                        }
                    }
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            }
            else {
                NSLog(@"Uknown asset type");
            }
            timeSp = [NSString stringWithFormat:@"%d",[timeSp intValue] +1];
        }
        
        
    }];
    self.knContentTF.hidden = YES;
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
