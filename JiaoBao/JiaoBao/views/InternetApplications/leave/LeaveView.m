//
//  LeaveView.m
//  JiaoBao
//
//  Created by Zqw on 16/3/12.
//  Copyright © 2016年 JSY. All rights reserved.
//

#import "LeaveView.h"

@implementation LeaveView

- (id)initWithFrame1:(CGRect)frame{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = frame;
        
        self.mArr_leave = [NSMutableArray array];
        //表格
        self.mTableV_leave = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height)];
        self.mTableV_leave.delegate = self;
        self.mTableV_leave.dataSource = self;
        [self addSubview:self.mTableV_leave];
    }
    return self;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
    return self.mArr_leave.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CMainCell = @"CMainCell";     //  0
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];      //   1
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];    //  2
    }
    
    // Config your cell
//    cell.textlabel.text = @"hahhahah";    //  3
    cell.textLabel.text = @"iausdhflakhfol";
    
    return cell;
    return 0;
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
