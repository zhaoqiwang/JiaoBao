//
//  StuErrViewController.m
//  JiaoBao
//
//  Created by SongYanming on 16/3/18.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "StuErrViewController.h"
#import "StuErrCell.h"
#import "StuErrModel.h"
#import "OnlineJobHttp.h"
#import "StuHWQsModel.h"
#import "TFHpple.h"
int cellRefreshCount, newHeight;
@interface StuErrViewController ()
@property(nonatomic,strong)NSArray *datasource;
@property(nonatomic,strong)NSMutableArray *webDataArr;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,assign)NSInteger mInt_index;
@end

@implementation StuErrViewController
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web_tag = %ld mInt_index = %ld" ,(long)webView.tag,self.mInt_index);
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];//修改百分比即可
    if(self.mInt_index<self.webDataArr.count){
        StuHWQsModel *model = [self.webDataArr objectAtIndex:self.mInt_index];
    model.cellHeight = webView.scrollView.contentSize.height*0.8+20;
        model.webFlag = YES;
        self.mInt_index++;

    
    }
    if(self.mInt_index==9){
        [self.tableVIew reloadData];

    }
    
}

-(void)GetStuHWQsWithHwInfoId:(id)sender{
    self.mInt_index++;
    StuHWQsModel *model = [sender object];
    model.QsCon = [model.QsCon stringByAppendingString:[NSString stringWithFormat:@"<p >作答：<span style=\"color:red \">%@</span><br />正确答案：%@<br />%@</p><br /><hr style=\"height:10px;border:none;border-top:1px solid #555555;\" />",model.QsAns,model.QsCorectAnswer,model.QsExplain]];
    if([model.QsCon isEqual:[NSNull null]]){
    }
    else{
       [self.webDataArr addObject:model];
        
    }
    
    
    if(self.mInt_index<self.datasource.count){
        StuErrModel *errModel = [self.datasource objectAtIndex:self.mInt_index];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:errModel.HwID QsId:errModel.QsID];
    }
    else{
        self.mInt_index=0;
        for(int i=0;i<self.webDataArr.count;i++){
            StuHWQsModel *subModel = [self.webDataArr objectAtIndex:i];
            NSLog(@"%d------nwoefiwenfewn = %@",i,subModel.QsCon);
        }
        [self.tableVIew reloadData];
    }

//    if(self.webDataArr.count == self.datasource.count){
//        NSArray *arr = [self.webDataArr sortedArrayUsingComparator:^NSComparisonResult(StuHWQsModel *p1, StuHWQsModel *p2){
//            int p1_int = [p1.QsId intValue];
//            NSNumber *p1_num = [NSNumber numberWithInt:p1_int ];
//            int p2_int = [p2.QsId intValue];
//            NSNumber *p2_num = [NSNumber numberWithInt:p2_int ];
//            return [p1_num compare:p2_num];
//        }];
//        self.webDataArr =[NSMutableArray arrayWithArray:arr];
 
        

    //}
    
}
-(void)GetStuErr:(id)sender{
    self.datasource = [sender object];
    //for (int i=0; i<self.datasource.count; i++) {
    if(self.datasource.count>0){
        StuErrModel *model = [self.datasource objectAtIndex:0];
        [[OnlineJobHttp getInstance]GetStuHWQsWithHwInfoId:model.HwID QsId:model.QsID];
        
    }


   // }

}
- (void)viewDidLoad {
    [super viewDidLoad];
        UINib * n= [UINib nibWithNibName:@"StuErrCell" bundle:[NSBundle mainBundle]];
        [self.tableVIew registerNib:n forCellReuseIdentifier:@"StuErrCell"];
    self.mInt_index = 0;
    self.webDataArr = [[NSMutableArray alloc]initWithCapacity:0];
        StuErrModel *model = [[StuErrModel alloc]init];
        model.StuId = @"3851578";
        model.IsSelf = @"1";
        model.PageIndex = @"1";
        model.PageSize = @"20";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuHWQsWithHwInfoId:) name:@"GetStuHWQsWithHwInfoId" object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetStuErr:) name:@"GetStuErr" object:nil];
    
        [[OnlineJobHttp getInstance]GetStuErr:model];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.webDataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        StuHWQsModel *model = [self.webDataArr objectAtIndex:indexPath.row];
    NSLog(@"Height----indexPath====%ld %ld",(long)indexPath.row,(long)model.cellHeight);

        return model.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell----indexPath====%ld",(long)indexPath.row);
        static NSString *indentifier = @"StuErrCell";
        StuErrCell *cell = (StuErrCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StuErrCell" owner:self options:nil];
            if ([nib count]>0) {
                cell = (StuErrCell *)[nib objectAtIndex:0];
            }
        }

    StuHWQsModel *model = [self.webDataArr objectAtIndex:indexPath.row];
    [cell.webView loadHTMLString:model.QsCon baseURL:nil];
    if(model.webFlag==NO){
        cell.webView.delegate = self;
        cell.webView.tag = indexPath.row;
    }
    else{
        //cell.webView.delegate = nil;
        //cell.webView.frame = CGRectMake(0, 0, [dm getInstance].width, model.cellHeight);
    }

        return cell;

}
-(void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
