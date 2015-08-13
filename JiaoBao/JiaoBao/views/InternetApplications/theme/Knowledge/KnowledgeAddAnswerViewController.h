//
//  KnowledgeAddAnswerViewController.h
//  JiaoBao
//
//  Created by Zqw on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "dm.h"
#import "utils.h"
#import "MBProgressHUD.h"
#import "KnowledgeTableViewCell.h"
#import "QuestionModel.h"
#import "KnowledgeHttp.h"
#import "UIImageView+WebCache.h"
#import "AnswerByIdModel.h"
#import "ELCImagePickerController.h"
#import "ShareHttp.h"
#include<AssetsLibrary/AssetsLibrary.h>

@interface KnowledgeAddAnswerViewController : UIViewController<MyNavigationDelegate,UITextViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) MyNavigationBar *mNav_navgationBar;//导航条
@property (nonatomic,strong) KnowledgeTableViewCell *mView_titlecell;//标题等
@property (nonatomic,strong) QuestionModel *mModel_question;//
@property (nonatomic,strong) QuestionDetailModel *mModel_questionDetail;
@property (nonatomic,weak) IBOutlet UITextView *mTextV_answer;//回答
@property (nonatomic,weak) IBOutlet UITextView *mTextV_content;//内容
@property (nonatomic,weak) IBOutlet UIButton *mBtn_submit;//提交
@property (nonatomic,weak) IBOutlet UIButton *mBtn_anSubmit;//匿名提交
@property (nonatomic,weak) IBOutlet UILabel *mLab_answer;//回答提示
@property (nonatomic,weak) IBOutlet UILabel *mLab_content;//内容提示
@property (nonatomic,strong) IBOutlet UIScrollView *mScrollV_view;//
@property (nonatomic,weak) IBOutlet UIButton *mBtn_photo;//照片
@property(nonatomic,assign)NSUInteger imageCount;//照片计数
@property (nonatomic,assign) int mInt_index;//记录添加了多少图片
@property (nonatomic,strong) NSMutableArray *mArr_pic;//添加的图片数组
@property(nonatomic,assign)int tfContentTag;

-(IBAction)mBtn_submit:(id)sender;
-(IBAction)mBtn_anSubmit:(id)sender;
-(IBAction)mBtn_photo:(id)sender;

@end
