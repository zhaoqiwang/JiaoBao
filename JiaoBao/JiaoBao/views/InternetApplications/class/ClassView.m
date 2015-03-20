//
//  ClassView.m
//  JiaoBao
//
//  Created by Zqw on 15-3-19.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView
@synthesize mArr_list,mTableV_list;

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        self.mTableV_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [dm getInstance].width, self.frame.size.height) style:UITableViewStyleGrouped];
        self.mTableV_list.delegate=self;
        self.mTableV_list.dataSource=self;
//        [self.mTableV_list setSeparatorStyle:UITableViewStyleGrouped];
        [self addSubview:self.mTableV_list];
        
    }
    return self;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;//section头部高度
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 54;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"WorkViewListCell";
    WorkViewListCell *cell = (WorkViewListCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkViewListCell" owner:self options:nil] lastObject];
        cell.frame = CGRectMake(0, 0, [dm getInstance].width, 54);
    }
    
    cell.mImgV_head.frame = CGRectMake(10, 7, 40, 40);
    //未读数量
    cell.mImgV_unRead.hidden = YES;
    cell.mLab_unRead.hidden = YES;
    //姓名
    cell.mLab_name.frame = CGRectMake(cell.mImgV_head.frame.origin.x+cell.mImgV_head.frame.size.width+10, 10, [dm getInstance].width-60, 20);
    //时间
    cell.mLab_time.hidden = YES;
    //内容
    cell.mLab_content.hidden = YES;
    //分割线
    cell.mLab_line.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            [cell.mImgV_head setImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_%ld",(long)indexPath.row]]];
            switch (indexPath.row) {
                case 0:
                    cell.mLab_name.text = @"我的学校";
                    break;
                case 1:
                    cell.mLab_name.text = @"本地学校";
                    break;
                case 2:
                    cell.mLab_name.text = @"关注的学校";
                    break;
                case 3:
                    cell.mLab_name.text = @"全部学校";
                    break;
                default:
                    break;
            }
            return cell;
        }
        case 1:{
            [cell.mImgV_head setImage:[UIImage imageNamed:[NSString stringWithFormat:@"classView_%ld",(long)indexPath.row]]];
            switch (indexPath.row) {
                case 0:
                    cell.mLab_name.text = @"拍照发布";
                    break;
                default:
                    break;
            }
            return cell;
        }
        default:
            break;
    }
    return cell;
}
//点击选择文件列表中的某一行时执行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger row=[indexPath row];
    switch (indexPath.section) {
        case 0:{
            switch (row) {
                case 0:{
                    
                    break;
                }
                case 1: {
                    
                    break;
                }
                case 2:{
                    break;
                }
                default:
                    break;
            }
            break;
        }
            default:
            break;
    }
}

@end
