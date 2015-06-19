//
//  ClassTableViewCell.m
//  JiaoBao
//
//  Created by Zqw on 15-3-26.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "CommentCell.h"
#import "dm.h"
#import "ClassTableViewCell.h"
#import "utils.h"

@implementation ClassTableViewCell

@synthesize mImgV_head,mLab_name,mLab_class,mLab_assessContent,mView_background,mImgV_airPhoto,mLab_content,mLab_time,mLab_click,mLab_clickCount,mLab_assess,mLab_assessCount,mLab_like,mLab_likeCount,mView_img,mImgV_0,mImgV_1,mImgV_2,delegate,mModel_class,ClassDelegate,headImgDelegate,mBtn_comment;

- (void)awakeFromNib {

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
//    self.moreBtn.enabled = NO;
   // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TableViewdelegate&&TableViewdataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"model = %@",self.mModel_class.mArr_comment);
    UITableViewCell *cell= [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {

        return cell.frame.size.height;
        
    }
    return 30;
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger num = self.mModel_class.mArr_comment.count;
    return num;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"tableview_superview = %@",[[tableView superview]superview]);
//    ClassTableViewCell *classCell = (ClassTableViewCell*)[[tableView superview]superview];
//    NSLog(@"cell = %@",classCell);
    static NSString *indentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    commentsListModel *tempModel = [self.mModel_class.mArr_comment objectAtIndex:indexPath.row];

    NSString *string1 = tempModel.UserName;
    NSString *string2 = tempModel.Commnets;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *name = [NSString stringWithFormat:@"<font size=13 color='#3229CA'>%@：</font> <font size=13 color=black>%@</font>",string1,string2];
    

    NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];

    CGRect rect=[string boundingRectWithSize:CGSizeMake([dm getInstance].width-65, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]  context:nil];

    cell.contentLabel.frame = CGRectMake(0, cell.contentLabel.frame.origin.y, [dm getInstance].width-65, rect.size.height+5);
    NSMutableDictionary *row4 = [NSMutableDictionary dictionary];
    [row4 setObject:name forKey:@"text"];
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[row4 objectForKey:@"text"]];
    cell.contentLabel.componentsAndPlainText = componentsDS;
//    if(self.mModel_class.mArr_comment.count<indexPath.row)
//    {
//        
//    }
//    else
//    {
//    NSArray *arr = [ self.mModel_class.mArr_comment objectAtIndex:indexPath.row];
//    }

    //cell.contentLabel.text = string;



    cell.frame = CGRectMake(0, 0, [dm getInstance ].width, rect.size.height+3);
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.headImgDelegate didSelectedCell];
}


//给头像添加点击事件
-(void)thumbImgClick
{
    self.mModel_class = [mModel_class init];
    self.mImgV_0.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick0:)];
    [self.mImgV_0 addGestureRecognizer:tap];
    
    self.mImgV_1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick1:)];
    [self.mImgV_1 addGestureRecognizer:tap2];
    
    self.mImgV_2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgClick2:)];
    [self.mImgV_2 addGestureRecognizer:tap3];
    
    //
    [self.mBtn_comment addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mLab_assessContent.userInteractionEnabled = YES;
    self.mLab_content.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mLab_assessContentPress:)];
    [self.mLab_assessContent addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mLab_assessContentPress:)];
    [self.mLab_content addGestureRecognizer:tap5];
}

-(void)mLab_assessContentPress:(UIGestureRecognizer *)gest{
    [self.headImgDelegate ClassTableViewCellContentPress:self];
}

-(void)commentClick:(UIButton *)btn{
    [self.delegate ClassTableViewCellCommentBtn:self Btn:btn];
}

-(void)tapImgClick0:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress0:self ImgV:self.mImgV_0];
}

-(void)tapImgClick1:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress1:self ImgV:self.mImgV_1];
}

-(void)tapImgClick2:(UIGestureRecognizer *)gest{
    [delegate ClassTableViewCellTapPress2:self ImgV:self.mImgV_2];
}

//给班级添加点击事件
-(void)classLabClick{
    self.mLab_class.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classLabClick:)];
    [self.mLab_class addGestureRecognizer:tap];
}

-(void)classLabClick:(UIGestureRecognizer *)gest{
    [ClassDelegate ClassTableViewCellClassTapPress:self];
}

//给头像添加点击事件
-(void)headImgClick{
    self.mImgV_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgClick:)];
    [self.mImgV_head addGestureRecognizer:tap];
}

-(void)headImgClick:(UIGestureRecognizer *)gest{
    [headImgDelegate ClassTableViewCellHeadImgTapPress:self];
}

//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}

- (IBAction)moreBtnAction:(id)sender
{
    //[utils pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>];
    [self.headImgDelegate ClassTableViewCellContentPress:self];
}
@end
