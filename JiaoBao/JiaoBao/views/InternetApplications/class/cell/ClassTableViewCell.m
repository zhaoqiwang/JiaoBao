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
#import "MobClick.h"

@implementation ClassTableViewCell

@synthesize mImgV_head,mLab_name,mLab_class,mLab_assessContent,mView_background,mImgV_airPhoto,mLab_content,mLab_time,mLab_click,mLab_clickCount,mLab_assess,mLab_assessCount,mLab_like,mLab_likeCount,mView_img,mImgV_0,mImgV_1,mImgV_2,delegate,mModel_class,ClassDelegate,headImgDelegate,mBtn_comment;

- (void)awakeFromNib {

//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
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
    return [self cellFloat:indexPath];
}

//在每个section中，显示多少cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mModel_class.Thumbnail.count==1) {
        self.mImgV_0.hidden = NO;
        self.mImgV_1.hidden = YES;
        self.mImgV_2.hidden = YES;
    }else if (self.mModel_class.Thumbnail.count==2){
        self.mImgV_0.hidden = NO;
        self.mImgV_1.hidden = NO;
        self.mImgV_2.hidden = YES;
    }else if (self.mModel_class.Thumbnail.count>=3){
        self.mImgV_0.hidden = NO;
        self.mImgV_1.hidden = NO;
        self.mImgV_2.hidden = NO;
    }
    NSUInteger num = self.mModel_class.mArr_comment.count;
    return num;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        //这时myCell对象已经通过自定义xib文件生成了
        if ([nib count]>0) {
            cell = (CommentCell *)[nib objectAtIndex:0];
            //加判断看是否成功实例化该cell，成功的话赋给cell用来返回。
        }
        //添加图片点击事件
        //若是需要重用，需要写上以下两句代码
        UINib * n= [UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]];
        [self.tableview registerNib:n forCellReuseIdentifier:indentifier];
    }
    commentsListModel *tempModel = [self.mModel_class.mArr_comment objectAtIndex:indexPath.row];

    NSString *string1 = tempModel.UserName;
    NSString *string2 = tempModel.Commnets;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *name = [NSString stringWithFormat:@"<font size=13 color='#3229CA'>%@：</font> <font size=13 color=black>%@</font>",string1,string2];
    

    NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];
//    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-65, 1000)];
//    CGRect rect=[string boundingRectWithSize:CGSizeMake([dm getInstance].width-65, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
//                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]  context:nil];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, [dm getInstance].width-65, 100)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];
    
    label.text = string;
    
    CGSize size11 = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    
//    label.frame =CGRectMake(10, 100, 300, size.height);

//    cell.contentLabel.frame = CGRectMake(0, cell.contentLabel.frame.origin.y, [dm getInstance].width-65, size.height+5);
    cell.contentLabel.frame = CGRectMake(0, 0, [dm getInstance].width-65, size11.height+5);
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



    cell.frame = CGRectMake(0, 0, [dm getInstance ].width, size11.height+3);
    
    
    return cell;
}

-(CGFloat)cellFloat:(NSIndexPath *)indexPath{
    CGFloat tempFloat =0;
    commentsListModel *tempModel = [self.mModel_class.mArr_comment objectAtIndex:indexPath.row];
    NSString *string1 = tempModel.UserName;
    NSString *string2 = tempModel.Commnets;
    string1 = [string1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    string2 = [string2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    
    NSString *string = [NSString stringWithFormat:@"%@:%@",string1,string2];
//    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([dm getInstance].width-65, 1000)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, [dm getInstance].width-65, 100)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];
    
    label.text = string;
    
    CGSize size11 = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
//    tempFloat = size.height+3;
    tempFloat = size11.height+3;
    return tempFloat;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.headImgDelegate didSelectedCell];
}

-(void)initModel{
    self.mModel_class = [mModel_class init];
}

//给头像添加点击事件
-(void)thumbImgClick
{
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
    [MobClick event:@"ClassView_HeadImgTapPress" label:@""];
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
