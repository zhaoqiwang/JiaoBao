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
        if(model.smsTree.count == 0)
        {
            //[self removeFromSuperview];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"progress" object:@"无权限"];

        }
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
    headerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    label.text = @"  所有管辖学校家长";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(self.frame.size.width-10-36*2-15, 9, 14, 14);
    [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.rightBtn];
    
    self.mBtn_all = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mBtn_all.frame = CGRectMake(self.frame.size.width-10-36*2, 0, 36, 30);
    [self.mBtn_all setTitle:@"全选" forState:UIControlStateNormal];
    [self.mBtn_all setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.mBtn_all.titleLabel.font = [UIFont systemFontOfSize:12];
    //[self.mBtn_all setBackgroundColor:BtnColor];
    [self.mBtn_all addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.mBtn_all];
    UIButton *bigButton2 =[UIButton buttonWithType:UIButtonTypeCustom];
    bigButton2.frame = CGRectMake(self.frame.size.width-10-36*2-15, 0, 65, 40);
    [bigButton2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bigButton2];
    bigButton2.tag = 0;
    
    
    UIButton *mBtn_invertSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    mBtn_invertSelect.frame = CGRectMake(self.frame.size.width-15-36, 0, 36, 30);
    [mBtn_invertSelect setTitle:@"反选" forState:UIControlStateNormal];
    mBtn_invertSelect.titleLabel.font = [UIFont systemFontOfSize:12];
    mBtn_invertSelect.titleLabel.textAlignment = NSTextAlignmentCenter;
    [mBtn_invertSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    mBtn_invertSelect.tag = 1;
    [mBtn_invertSelect addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:mBtn_invertSelect];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, [dm getInstance].width, 300) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.allowsSelection = YES;
    

    return self;
    
}

-(void)clickBtn:(id)sender
{
    UIButton *btn = sender;
    if(btn.tag == 0)
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        self.allSelSymbol = 1;
        SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
        for(int i=0;i<model.smsTree.count;i++)
        {
            SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:i];
            subModel.mInt_select = 1;
        }
        
    }
    if(btn.tag == 1)
    {
        if(self.allSelSymbol == 1)
        {
            [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
            self.allSelSymbol = 0;
            SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
            for(int i=0;i<model.smsTree.count;i++)
            {
                SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:i];
                subModel.mInt_select = 0;
            }
        }
        else if(self.allSelSymbol ==0)
        {
            [self.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            self.allSelSymbol = 1;
            SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
            for(int i=0;i<model.smsTree.count;i++)
            {
                SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:i];
                subModel.mInt_select = 1;
            }
            
        }
        else if (self.allSelSymbol == 2)
        {
            SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
            for(int i=0;i<model.smsTree.count;i++)
            {
                SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:i];
                if(subModel.mInt_select == 0)
                {
                    subModel.mInt_select = 1;

                    
                }
                else
                {
                    subModel.mInt_select = 0;

                }
                

                
            }
            
        }
    }
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
    
    
    return model.smsTree.count;
}
- (void)configureCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
    SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:indexPath.row];
    cell.nameLabel.text =subModel.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(subModel.mInt_select ==0)
    {
        [cell.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];

        
    }

    
    
    
    
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    SMSTreeArrayModel *model =[self.datasource objectAtIndex:1];
    SMSTreeUnitModel *subModel = [model.smsTree objectAtIndex:indexPath.row];
    if(self.allSelSymbol == 0)
    {
        if(model.smsTree.count ==1)
        {
            self.allSelSymbol = 1;
        }
        else
        {
            self.allSelSymbol = 2;

            
        }
        subModel.mInt_select = 1;
        [cell.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];

            
        

    }
    else if(self.allSelSymbol == 1)
    {
        if(model.smsTree.count ==1)
        {
            self.allSelSymbol = 0;
        }
        else
        {
            self.allSelSymbol = 2;
            
            
        }
        subModel.mInt_select = 0;
        [cell.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
            
        
    }
    else if(self.allSelSymbol == 2)
    {
        if(subModel.mInt_select == 0)
        {
            subModel.mInt_select = 1;
            BOOL symbol = subModel.mInt_select;

            for(int i=0;i<model.smsTree.count;i++)
            {
                SMSTreeUnitModel *subModel2 = [model.smsTree objectAtIndex:i];
                symbol = subModel2.mInt_select;

                if(symbol == NO)
                {
                    return;
                }
                
            }
            if(symbol == YES)
            {
                self.allSelSymbol = 1;
                
            }
            else
            {
                self.allSelSymbol = 2;
                
            }
        }
        else
        {
            subModel.mInt_select = 0;
            BOOL symbol = subModel.mInt_select;
            
            for(int i=0;i<model.smsTree.count;i++)
            {
                SMSTreeUnitModel *subModel2 = [model.smsTree objectAtIndex:i];
                symbol = subModel2.mInt_select;
                
                if(symbol == YES)
                {
                    return;
                }
                
            }
            if(symbol == YES)
            {
                self.allSelSymbol = 2;
                
            }
            else
            {
                self.allSelSymbol = 0;
                
            }


            
        }
        
        
    }
//    if(![[cell.rightBtn imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"selected.png"]])
//    {
//        [cell.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
//        subModel.mInt_select = 1;
//        
//
//        
//    }
//    else
//    {
//        [cell.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
//        subModel.mInt_select = 0;
//
//        
//    }
    NSLog(@"allSelSymbol = %lu",(unsigned long)self.allSelSymbol);
    if(self.allSelSymbol == 1)
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.rightBtn setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];

    }
    [self.tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
