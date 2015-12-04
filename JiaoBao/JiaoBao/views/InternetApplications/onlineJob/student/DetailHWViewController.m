//
//  DetailHWViewController.m
//  JiaoBao
//
//  Created by songyanming on 15/10/29.
//  Copyright © 2015年 JSY. All rights reserved.
//

#import "DetailHWViewController.h"
#import "utils.h"
#import "OnlineJobHttp.h"
#import "DetialHWCell.h"
#import "StuHomeWorkModel.h"
#import "StuHWQsModel.h"
#import "WebViewJavascriptBridge.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import "IQKeyboardManager.h"
#import "StuSubModel.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface DetailHWViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *subArr;//提交的题目
@property(nonatomic,strong)NSMutableArray *errQuestionArr;//做错的题目 0:没做的 1:正确 2：错误
@property(nonatomic,assign)NSUInteger selectedBtnTag;
@property(nonatomic,strong)StuHomeWorkModel *stuHomeWorkModel;
@property(nonatomic,strong)StuHWQsModel *stuHWQsModel;
@property(nonatomic,strong)NSMutableArray *datasource;
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,assign)float webHeight;

@end

@implementation DetailHWViewController
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if(self.collectionView.contentSize.height>136)
    {
        self.height.constant = 136;
    }
    else
    {
        self.height.constant = self.collectionView.contentSize.height;

    }

}

-(void)GetStuHWWithHwInfoId:(id)sender
{
    self.stuHomeWorkModel = [sender object];
    NSArray *arr = [self.stuHomeWorkModel.QsIdQId componentsSeparatedByString:@"|"];
    for(int i=0;i<arr.count;i++)
    {
        NSString *QsIdQIdStr = [arr objectAtIndex:i];
        NSArray *QsIdQIdArr = [QsIdQIdStr componentsSeparatedByString:@"_"];
        NSString *QsIdQId,*QsIdQId2,*QsIdQId3;
        if(QsIdQIdArr.count>3)
        {
            QsIdQId = [QsIdQIdArr objectAtIndex:0];
            QsIdQId2 = [QsIdQIdArr objectAtIndex:2];
            QsIdQId3 = [QsIdQIdArr objectAtIndex:3];
            [self.datasource addObject:QsIdQId];
            [self.subArr addObject:QsIdQId2];
            [self.errQuestionArr addObject:QsIdQId3];
        }
        
    }
    if(self.datasource.count<20)
    {
        [self.qNum setTitle:[NSString stringWithFormat:@"1-%ld",self.datasource.count] forState:UIControlStateNormal];
    }
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    if(self.datasource.count == 1)
    {
        [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    self.mTableV_name = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, 0)] ;
    [self.mTableV_name initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView,NSInteger section){
        NSInteger count = [self.stuHomeWorkModel.Qsc integerValue];
        NSInteger cellCount = count/20;
        NSInteger cellCount2 = count%20;
        if(cellCount2==0)
        {
            cellCount = count/20;
        }
        else
        {
            cellCount = count/20+1;
        }
        return cellCount;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"];
            cell.frame = CGRectMake(0, 0, self.qNum.frame.size.width, 25);
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        if((indexPath.row+1)*20<[self.stuHomeWorkModel.Qsc integerValue])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.row*20+1,(indexPath.row+1)*20];

        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.row*20+1,[self.stuHomeWorkModel.Qsc integerValue]];
        }
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            SelectionCell *cell = (SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
            self.mTableV_name.frame =  CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, 0);
            [self.qNum setTitle:cell.textLabel.text forState:UIControlStateNormal];
            self.isOpen = NO;
            NSIndexPath *index_path = [NSIndexPath indexPathForItem:indexPath.row*20 inSection:0];
            [self.collectionView reloadData];
            [self.collectionView selectItemAtIndexPath:index_path animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index_path.row]];

        } completion:^(BOOL finished){

        }];
    }];
    [self.mTableV_name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.mTableV_name.layer setBorderWidth:1];
    [self.view addSubview:self.mTableV_name];
    D("0----=-======%@,%lu",self.stuHomeWorkModel.hwinfoid,(unsigned long)self.datasource.count);
    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:0]];
    [MBProgressHUD showMessage:@"" toView:self.view];

}
-(void)GetStuHWQsWithHwInfoId:(id)sender
{
    self.stuHWQsModel = [sender object];

    NSString *webHtml;
    if(self.isSubmit == 1)
    {
        if([self.stuHWQsModel.QsAns isEqualToString:self.stuHWQsModel.QsCorectAnswer])
        {
            webHtml = [self.stuHWQsModel.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:green\">%@</span><br />正确答案：%@<br />%@</p>",self.stuHWQsModel.QsAns,self.stuHWQsModel.QsCorectAnswer,self.stuHWQsModel.QsExplain]];
            
        }
        else
        {
            webHtml = [self.stuHWQsModel.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:red \">%@</span><br />正确答案：%@<br />%@</p>",self.stuHWQsModel.QsAns,self.stuHWQsModel.QsCorectAnswer,self.stuHWQsModel.QsExplain]];
        }

    }
    else
    {
        webHtml = self.stuHWQsModel.QsCon;
    }
    if([webHtml isEqual:[NSNull null]])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.webView loadHTMLString:@"" baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    }

    else
    {
        [self.webView loadHTMLString:webHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

    }

}
-(void)StuSubQsWithHwInfoId:(id)sender
{
    StuSubModel *model = [sender object];
    if([model.reNum integerValue] == 0)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:self.TabID];

//        NSString *strHtml = [model.HWHTML stringByAppendingString:@"<br /><button type='button' onclick ='buttonClick'>继续</button><script>function buttonClick(){alert(\"事件\");}</script>"];
        if([self.navBarName isEqualToString:@"做作业"])
        {
            NSString *html = [model.HWHTML stringByAppendingString:@"<HTML><br /><br /><div div style=\"TEXT-ALIGN: center\"><script>function clicke(){}</script><input type=\"button\" onClick=\"clicke()\" style = \"font-size:12px\" value=\"继续做作业\"/></div></HTML>"];
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }
        else
        {
            NSString *html = [model.HWHTML stringByAppendingString:@"<HTML><br /><br /><div div style=\"TEXT-ALIGN: center\"><script>function clicke(){}</script><input type=\"button\" onClick=\"clicke()\" style = \"font-size:12px\" value=\"继续做练习\"/></div></HTML>"];
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        }

  
        self.isSubmit = YES;
        self.previousBtn.enabled = NO;
        self.nextBtn.enabled = NO;
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交成功" message:@"本次作业得分： 100\r\n本次作业学力：10\r\n所有科目平均学历值：500\r\n" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//            NSString *lJs = @"document.documentElement.innerHTML";
//            NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
//            NSLog(@"html = %@",html);
        //[MBProgressHUD showSuccess:@"提交作业成功" toView:self.view];
    }

}
- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor redColor];
    [alertView addSubview:myView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.subArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.errQuestionArr = [[NSMutableArray alloc]initWithCapacity:0];
    //self.webView.scrollView.scrollEnabled = NO;
    if(self.isSubmit == YES)
    {
        self.previousBtn.enabled = NO;
        self.nextBtn.enabled = NO;
//        self.webView.userInteractionEnabled = NO;
//        self.webView.scrollView.scrollEnabled = YES;
    }
    //self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    self.qNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.qNum.layer.borderWidth = 1;
    self.qNum.layer.cornerRadius = 0.2;
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
    //键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    //获取作业信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StuSubQsWithHwInfoId:) name:@"StuSubQsWithHwInfoId" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StuSubQsWithHwInfoId:) name:@"StuSubQsWithHwInfoId" object:nil];

    //获取作业信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWWithHwInfoId:) name:@"GetStuHWWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];
    //输入框弹出键盘问题
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:self.navBarName];
    self.hwNameLabel.text = self.hwName;
    self.mNav_navgationBar.delegate = self;
    [self.mNav_navgationBar setGoBack];
    [self.view addSubview:self.mNav_navgationBar];
    [[OnlineJobHttp getInstance] GetStuHWWithHwInfoId:self.TabID];

    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetialHWCell" bundle:nil]forCellWithReuseIdentifier:@"DetailHWCell"];
    // Do any additional setup after loading the view from its nib.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateViewConstraints];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([self.stuHWQsModel.QsT isEqualToString:@"1"])
    {
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        for(int i=0;i<inputCount;i++)
        {
            if(self.isSubmit == YES)//如果作业已经完成
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *valueStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if([valueStr isEqualToString:@"radio"])
                {
                    NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                    [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                }

            }

            else//如果作业没有完成
            {
                if([self.FlagStr isEqualToString:@"2"])
                {
                    NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                    [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                }

            }
            NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
            NSString *valueStr = [self.webView stringByEvaluatingJavaScriptFromString:value];

            if([valueStr isEqualToString:self.stuHWQsModel.QsAns])//如果radio的值等于正确答案
            {
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked = true",i];
                if([self.FlagStr isEqualToString:@"1"])//如果当前界面是学生界面
                {
                    if(self.isSubmit == YES)//学生界面且作业已经提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];

                    }
                    
                    else//学生界面且作业没有提交
                    {
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];

                    }
                }
                else
                {
                    if(self.isSubmit == YES)//家长界面且作业已经提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        [self.webView stringByEvaluatingJavaScriptFromString:checkStr];


                    }
                    else//家长界面且作业没有提交
                    {
                        NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                        [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                    }
                }
            }
        
    }
    }
    else if ([self.stuHWQsModel.QsT isEqualToString:@"2"])
    {
        NSArray *textArr;
        NSLog(@"dfrnflre;gm;r = %@",self.stuHWQsModel.QsAns);
        if([self.stuHWQsModel.QsAns isEqual:[NSNull null]])
        {
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            for(int i=1;i<inputCount;i++)
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if([typeStr isEqualToString:@"text"])
                {
                    if([self.FlagStr isEqualToString:@"1"])
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];

                    }
                }
            }
        }
        else
        {
            textArr = [self.stuHWQsModel.QsAns componentsSeparatedByString:@"," ];
            NSLog(@"textArr_num = %@",[textArr objectAtIndex:textArr.count-1]);
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            for(int i=1;i<inputCount;i++)
            {
                
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if([typeStr isEqualToString:@"text"])
                {
                    NSString *checkStr;
                    if(i<=textArr.count)
                    {
                        checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,[textArr objectAtIndex:i-1]];
                    }
                    else
                    {
                        checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,@""];
                    }
                    
                    NSLog(@"checkStr = %@",checkStr);
                    if([self.FlagStr isEqualToString:@"1"])
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                        }
                        
                        else
                        {
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                        }
                    }
                    else
                    {
                        if(self.isSubmit == YES)
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                            [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                            
                            
                        }
                        
                        else
                        {
                            NSString *disabled = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].disabled = true",i];
                            [self.webView stringByEvaluatingJavaScriptFromString:disabled];
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
        }

        
    }
    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    content[@"clicke"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更UI
             [self.navigationController popViewControllerAnimated:YES];
        });
       
        
        
    };

    
}
#pragma mark - Collection View Data Source
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{

    return self.datasource.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetialHWCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailHWCell" forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
    if([self.FlagStr integerValue]==1){
        if(self.isSubmit == 0&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]!=0)
        {
            cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
            
        }
        else if (self.isSubmit == 0&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]== 0)
        {
             cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        
        else if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
            cell.numLabel.textColor = [UIColor redColor];
            cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        
        else if (self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==0)
        {
            //cell.numLabel.textColor = [UIColor redColor];
            //cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
            cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];

        }
        
        else
        {
          cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];      }
        }
    
    else
    {
        if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
           cell.numLabel.textColor = [UIColor redColor];
          cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];

           //cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        
        else if (self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==0)
        {
             cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            //cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];
        }
        
        else
        {
            cell.numLabel.backgroundColor = [UIColor colorWithRed:164/255.0 green:234/255.0 blue:183/255.0 alpha:1];

           //cell.numLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
    }

    if(cell.selected == YES)
    {
        cell.numLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:55/255.0 alpha:1];
    }
    
    else
    {
        if(self.isSubmit == 1&&[[self.errQuestionArr objectAtIndex:indexPath.row]integerValue]==2)
        {
            cell.numLabel.textColor = [UIColor redColor];
        }
        
        else
        {
            cell.numLabel.textColor = [UIColor blackColor];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
        self.previousBtn.enabled = NO;
    }
    else
    {
        self.previousBtn.enabled = YES;
    }
    if(self.isSubmit ==  YES)
    {
        self.previousBtn.enabled = NO;
        self.nextBtn.enabled = NO;
    }
    if(indexPath.row+1 == [self.stuHomeWorkModel.Qsc integerValue])
    {
        [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    else
    {
        [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
    if(self.datasource.count>self.selectedBtnTag)//最后一题要做判断
    {
        if([self.stuHWQsModel.QsT isEqualToString:@"1"])
        {
            BOOL isFinish = false;
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            for(int i=0;i<inputCount;i++)
            {
                NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
                NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
                if(![typeStr isEqualToString:@"radio"])
                {
                    continue;
                }
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked",i];
                
                //            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByName('TopicRadio')[%d].checked",i];
                NSString *isChecked = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                NSLog(@"isChecked = %@",isChecked);
                if([isChecked isEqualToString:@"true"])
                {

                    NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                    NSString *answer = [self.webView stringByEvaluatingJavaScriptFromString:value];
                    if(self.isSubmit == NO)
                    {
                        if(self.datasource.count-1==self.selectedBtnTag)
                        {
                            
                        }
                        else
                        {
                            
                            [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
                            //[self.collectionView reloadData];
                        }
 
                    }

                    isFinish = YES;
                    
                }
                
                
            }

            
        }
        else
        {
            BOOL isFinish = false;
            NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
            NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
            NSString *answer = @"";
            for(int i=0;i<inputCount;i++)
            {
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
                NSString *content;
                if(i == inputCount-1)
                {
                    content = [value stringByAppendingString:@""];
                }
                else
                {
                    content = [value stringByAppendingString:@","];
                    
                }
                NSLog(@"content = %@",content);
                if(i>0&&i<inputCount-1)
                {
                    if([content isEqualToString:@","]== NO)
                    {
                        isFinish = YES;
                    }
                    answer =[answer stringByAppendingString:content];
                    
                }
                else if (i==inputCount-1)
                {
                    if([content isEqualToString:@""]== NO)
                    {
                        isFinish = YES;
                    }
                    answer =[answer stringByAppendingString:content];
                }
                
            }
            if(isFinish == false)
            {

            }
            else
            {
                if(self.datasource.count-1==self.selectedBtnTag)
                {
//                    [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                }
                
                else
                {
                    if(self.isSubmit == NO)
                    {

                        [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                        [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
                        //[self.collectionView reloadData];

                    }

                }
                
            }
            
        }
    }

    DetialHWCell *cell = (DetialHWCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:55/255.0 alpha:1];
    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:indexPath.row]];
    [MBProgressHUD showMessage:@"" toView:self.view];
    self.selectedBtnTag = indexPath.row;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self changeQuestionRange:[cell.numLabel.text intValue]-1];
 
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetialHWCell *cell = (DetialHWCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor blackColor];
    cell.selected = NO;
    
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(51, 24);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(void)dealloc
{
    
}
//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //输入框弹出键盘问题
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;//控制整个功能是否启用
//    manager.shouldResignOnTouchOutside = NO;//控制点击背景是否收起键盘
//    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义
//    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条
    [utils popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)previousBtnAction:(id)sender {
    [self.nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    UIButton *btn = (UIButton*)sender;
    if(self.selectedBtnTag == 0)
    {
        btn.enabled = NO;
    }
    else
    {
        btn.enabled = YES;
        self.selectedBtnTag--;
        if(self.selectedBtnTag == 0)
        {
            btn.enabled = NO;
        }
        NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
        [self changeQuestionRange:(int)index.row];

        [MBProgressHUD showMessage:@"" toView:self.view];
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop ];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];

    }

}

- (IBAction)nextBtnAction:(id)sender {
    UIButton *btn = (UIButton*)sender;

    if(self.datasource.count>self.selectedBtnTag)//最后一题要做判断
    {
    if([self.stuHWQsModel.QsT isEqualToString:@"1"])
    {
        BOOL isFinish = false;
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        for(int i=0;i<inputCount;i++)
        {
            NSString *type = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].type",i];
            NSString *typeStr = [self.webView stringByEvaluatingJavaScriptFromString:type];
            if(![typeStr isEqualToString:@"radio"])
            {
                continue;
            }
            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked",i];

//            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByName('TopicRadio')[%d].checked",i];
            NSString *isChecked = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            NSLog(@"isChecked = %@",isChecked);
            if([isChecked isEqualToString:@"true"])
            {
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag+1 inSection:0];
                [self.collectionView reloadData];

                NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                NSString *answer = [self.webView stringByEvaluatingJavaScriptFromString:value];
//                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                self.selectedBtnTag++;
                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    [btn setTitle:@"提交" forState:UIControlStateNormal];
                }
                else
                {
                    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }

                isFinish = YES;
                if(self.datasource.count==self.selectedBtnTag-1)
                {
                    self.previousBtn.enabled = YES;

                    [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                    [MBProgressHUD showMessage:@"" toView:self.view];
                }
                
                else
                {
                self.previousBtn.enabled = YES;
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag-1] Answer:answer];
                [MBProgressHUD showMessage:@"" toView:self.view];
                if(index.row<self.datasource.count)
                {
                    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];
                    [self changeQuestionRange:(int)index.row];

//                    }

                }
                }

            }

            
        }
        if(isFinish == false)
        {
            [MBProgressHUD showError:@"题目没有完成，无法提交"];
            return;
        }
        else
        {
            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag-1 withObject:@"1"];
            
        }

    }
    else
    {
        BOOL isFinish = false;
        NSString *inputNum = [NSString stringWithFormat:@"document.getElementsByTagName('input').length"];
        NSUInteger inputCount = [[self.webView stringByEvaluatingJavaScriptFromString:inputNum]integerValue];
        NSString *answer = @"";
        for(int i=0;i<inputCount;i++)
        {
            NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
            NSString *value = [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            NSString *content;
            if(i>0)
            {
                if([value isEqualToString:@""]== NO)
                {
                    isFinish = YES;
                }
                if(i == inputCount-1)
                {
                    content = [value stringByAppendingString:@""];
                }
                else
                {
                    content = [value stringByAppendingString:@","];
                    
                }
                answer =[answer stringByAppendingString:content];
                
                NSLog(@"content = %@",content);
                
            }

        }
        if(isFinish == false)
        {
            [MBProgressHUD showError:@"题目没有完成，无法提交"];
            return;
        }
        else
        {
            [self.errQuestionArr replaceObjectAtIndex:self.selectedBtnTag withObject:@"1"];
            self.previousBtn.enabled = YES;

            if(self.datasource.count-1==self.selectedBtnTag)
            {
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                [MBProgressHUD showMessage:@"" toView:self.view];
                [self.collectionView reloadData];
            }
            
            else
            {
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                [MBProgressHUD showMessage:@"" toView:self.view];
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                self.selectedBtnTag++;
                [self changeQuestionRange:(int)self.selectedBtnTag];

                if(self.selectedBtnTag+1>= [self.stuHomeWorkModel.Qsc integerValue])
                {
                    [btn setTitle:@"提交" forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                }
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            }

        }
 
    }
    }
//    if(self.selectedBtnTag == 0)
//    {
//        [MBProgressHUD showError:@"没有上一题了"];
//        return;
//    }


}
- (IBAction)qNumQustion:(id)sender {
    if(self.isOpen == YES)
    {
        self.mTableV_name.frame =  CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, 0);
        self.isOpen = NO;
    }
    else
    {
        NSInteger count = self.datasource.count;
        NSInteger cellCount = count/20;
        NSInteger cellCount2 = count%20;
        if(cellCount2==0)
        {
            cellCount = count/20;
        }
        else
        {
            cellCount = count/20+1;
        }
        self.mTableV_name.frame =  CGRectMake(self.qNum.frame.origin.x, self.qNum.frame.origin.y+self.qNum.frame.size.height, self.qNum.frame.size.width, cellCount*25);
        self.isOpen = YES;
    }
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    self.view.frame = CGRectMake(0, -self.collectionView.frame.size.height-self.collectionView.frame.origin.y+30, [dm getInstance].width, self.view.frame.size.height);
    
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
     self.view.frame = CGRectMake(0, 0, [dm getInstance].width, self.view.frame.size.height);

}
-(void)changeQuestionRange:(int)num
{
    int a = (int)(num)/20;
    if((a+1)*20<self.datasource.count)
    {
        NSString *aStr = [NSString stringWithFormat:@"%d-%d",20*a+1,(a+1)*20];
        [self.qNum setTitle:aStr forState:UIControlStateNormal];
        NSIndexPath *index = [NSIndexPath indexPathForRow:a inSection:0];
        [self.mTableV_name selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        NSString *aStr = [NSString stringWithFormat:@"%d-%lu",20*a+1,(unsigned long)self.datasource.count];
        [self.qNum setTitle:aStr forState:UIControlStateNormal];
        NSIndexPath *index = [NSIndexPath indexPathForRow:a inSection:0];
        [self.mTableV_name selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

@end
