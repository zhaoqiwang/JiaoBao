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

@interface DetailHWViewController ()
@property(nonatomic,strong)NSMutableArray *subArr;//提交的题目
@property(nonatomic,assign)BOOL selectedFlag;//被选择的标志
@property(nonatomic,assign)NSUInteger selectedBtnTag;
@property(nonatomic,strong)StuHomeWorkModel *stuHomeWorkModel;
@property(nonatomic,strong)StuHWQsModel *stuHWQsModel;
@property(nonatomic,strong)NSMutableArray *datasource;
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,strong)TableViewWithBlock *mTableV_name;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)BOOL isSelCell;
@property(nonatomic,assign)BOOL isSubmit;

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
        NSString *QsIdQId;
        if(QsIdQIdArr.count>0)
        {
            QsIdQId = [QsIdQIdArr objectAtIndex:0];
            [self.datasource addObject:QsIdQId];
        }
    }
    if(self.datasource.count<20)
    {
        [self.qNum setTitle:[NSString stringWithFormat:@"1-%ld",self.datasource.count] forState:UIControlStateNormal];
    }
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
        NSLog(@"num = %@",cell.textLabel.text);
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

    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:0]];
    [MBProgressHUD showMessage:@"" toView:self.view];


}
-(void)GetStuHWQsWithHwInfoId:(id)sender
{
    self.stuHWQsModel = [sender object];


//    NSString *urlStr = @"http://www.baidu.com";
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    [self.webView loadHTMLString:self.stuHWQsModel.QsCon baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];

}
-(void)StuSubQsWithHwInfoId:(id)sender
{
    StuSubModel *model = [sender object];
    if([model.reNum integerValue] == 0)
    {
        [MBProgressHUD showSuccess:@"提交作业成功" toView:self.view];
    }
//    if(self.isSelCell == YES)
//    {
//        return;
//    }
//
//    if([self.stuHomeWorkModel.Qsc integerValue]== self.selectedBtnTag+1)
//    {
//        [MBProgressHUD showSuccess:@"提交作业成功" toView:self.view];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    self.qNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.qNum.layer.borderWidth = 1;
    self.qNum.layer.cornerRadius = 0.2;
    self.datasource = [[NSMutableArray alloc]initWithCapacity:0];
    //获取作业信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StuSubQsWithHwInfoId:) name:@"StuSubQsWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(StuSubQsWithHwInfoId:) name:@"StuSubQsWithHwInfoId" object:nil];

    //获取作业信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWWithHwInfoId:) name:@"GetStuHWWithHwInfoId" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];
//    //输入框弹出键盘问题
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;//控制整个功能是否启用
//    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘
//    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
//    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    //添加导航条
    self.mNav_navgationBar = [[MyNavigationBar alloc] initWithTitle:@"做作业"];
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

            NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
            NSString *valueStr = [self.webView stringByEvaluatingJavaScriptFromString:value];

            if([valueStr isEqualToString:self.stuHWQsModel.QsAns])
            {
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].checked = true",i];
                [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            }
        
    }
    }
    else if ([self.stuHWQsModel.QsT isEqualToString:@"2"])
    {
        NSArray *textArr;
        NSLog(@"dfrnflre;gm;r = %@",self.stuHWQsModel.QsAns);
        if([self.stuHWQsModel.QsAns isEqual:[NSNull null]])
        {
            return;
        }
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
                NSString *checkStr = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value = '%@'",i,[textArr objectAtIndex:i-1]];
                NSLog(@"checkStr = %@",checkStr);
                [self.webView stringByEvaluatingJavaScriptFromString:checkStr];
            }

            
        }
        
    }

    
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
    if(cell.selected == YES)
    {
        cell.numLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:55/255.0 alpha:1];
    }
    else
    {
        cell.numLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    self.isSelCell = YES;
    if(indexPath.row == 0)
    {
        self.previousBtn.enabled = NO;
    }
    else
    {
        self.previousBtn.enabled = YES;
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
                    [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];

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
                NSString *content = [value stringByAppendingString:@","];
                NSLog(@"content = %@",content);
                if(i>0)
                {
                    if([content isEqualToString:@","]== NO)
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

                    [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];

                }
                
            }
            
        }
    }

    DetialHWCell *cell = (DetialHWCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.numLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:55/255.0 alpha:1];
    [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:indexPath.row]];
    NSLog(@"huoqu = %@ %@",self.stuHomeWorkModel.hwinfoid,[self.datasource objectAtIndex:indexPath.row]);
    [MBProgressHUD showMessage:@"" toView:self.view];
    self.selectedBtnTag = indexPath.row;
    

//    NSString *lJs = @"document.documentElement.innerHTML";
//    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
//    NSLog(@"html = %@",html);
    cell.selected = YES;
 
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

//导航条返回按钮回调
-(void)myNavigationGoback{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


- (IBAction)previousBtnAction:(id)sender {
    self.isSelCell = NO;
    UIButton *btn = (UIButton*)sender;

    if(self.selectedBtnTag == 0)
    {
        btn.enabled = NO;
        [MBProgressHUD showError:@"没有上一题了"];
        return;
    }
    else
    {
        btn.enabled = YES;
        self.selectedBtnTag--;
        NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
        [self.collectionView reloadData];
        
        [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }

}

- (IBAction)nextBtnAction:(id)sender {
    self.isSelCell = NO;
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

                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
                [self.collectionView reloadData];
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                NSString *value = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%d].value",i];
                NSString *answer = [self.webView stringByEvaluatingJavaScriptFromString:value];
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                self.selectedBtnTag++;
                if(self.selectedBtnTag> [self.stuHomeWorkModel.Qsc integerValue])
                {
                    [btn setTitle:@"提交" forState:UIControlStateNormal];
                    self.isSubmit = YES;
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                    self.isSubmit = NO;
                }

                isFinish = YES;
                if(self.datasource.count==self.selectedBtnTag-1)
                {
                    
                }
                
                else
                {
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:index.row]];
                [MBProgressHUD showMessage:@"" toView:self.view];
                }

            }

            
        }
        if(isFinish == false)
        {
            [MBProgressHUD showError:@"题目没有完成，无法提交"];
            return;
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
            NSString *content = [value stringByAppendingString:@","];
            NSLog(@"content = %@",content);
            if(i>0)
            {
                if([content isEqualToString:@","]== NO)
                {
                    isFinish = YES;
                }
                answer =[answer stringByAppendingString:content];
                
            }

        }
        if(isFinish == false)
        {
            [MBProgressHUD showError:@"题目没有完成，无法提交"];
            return;
        }
        else
        {
            if(self.datasource.count-1==self.selectedBtnTag)
            {
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
            }
            
            else
            {
                [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag+1]];
                [MBProgressHUD showMessage:@"" toView:self.view];
                [[OnlineJobHttp getInstance]StuSubQsWithHwInfoId:self.stuHomeWorkModel.hwinfoid QsId:[self.datasource objectAtIndex:self.selectedBtnTag] Answer:answer];
                self.selectedBtnTag++;
                if(self.selectedBtnTag+1> [self.stuHomeWorkModel.Qsc integerValue])
                {
                    [btn setTitle:@"提交" forState:UIControlStateNormal];
                    self.isSubmit = YES;
                }
                else
                {
                    [btn setTitle:@"下一题" forState:UIControlStateNormal];
                    self.isSubmit = NO;
                }
                NSIndexPath *index = [NSIndexPath indexPathForItem:self.selectedBtnTag inSection:0];
                [self.collectionView reloadData];
                
                [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
@end