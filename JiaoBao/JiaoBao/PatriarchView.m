//
//  PatriarchView.m
//  JiaoBao
//
//  Created by songyanming on 15/4/27.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "PatriarchView.h"
#import "CustomCell.h"

@implementation PatriarchView
-(void)seleForuth:(id)sender
{
    self.datasource = [sender object];
    for(int i=0;i<self.datasource.count;i++)
    {
        SMSTreeArrayModel *model =[self.datasource objectAtIndex:i];
        for(int i=0;i<model.smsTree.count;i++)
        {
            SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:i];
            NSLog(@"name = %@",subModel.name);
            
        }
        
    }

    [self.tableView reloadData];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleForuth:) name:@"seleForuth" object:nil];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [dm getInstance].width, 30)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"所在班级家长";
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y, [dm getInstance].width, 300) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.allowsSelection = NO;

    return self;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMSTreeArrayModel *model =[self.datasource objectAtIndex:0];
    
    
    return model.smsTree.count;
}
- (void)configureCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SMSTreeArrayModel *model =[self.datasource objectAtIndex:0];
    SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:indexPath.row];
    cell.nameLabel.text =subModel.name;

    
    
    
    
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"customCell"];
    if(cell == nil)
    {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = (CustomCell*)[cellArr objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
