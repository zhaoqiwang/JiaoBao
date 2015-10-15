//
//  AddQuestionViewController.h
//  JiaoBao
//
//  Created by songyanming on 15/8/11.
//  Copyright (c) 2015年 JSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationBar.h"
#import "ELCImagePickerController.h"
#include<AssetsLibrary/AssetsLibrary.h>


@interface AddQuestionViewController : UIViewController<MyNavigationDelegate,UIActionSheetDelegate,ELCAssetSelectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;//省输入框
@property (weak, nonatomic) IBOutlet UITextField *regionTF;//地区输入框
@property (weak, nonatomic) IBOutlet UITextField *countyTF;//区县输入框
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;//
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;//分类输入框
@property(nonatomic,strong)NSMutableString *categoryId;//分类id
@property (weak, nonatomic) IBOutlet UITextField *titleTF;//标题输入框

@property (weak, nonatomic) IBOutlet UITextField *knContentTF;//描述输入框
@property (weak, nonatomic) IBOutlet UITextField *atAccIdsTF;//邀请回答输入框
@property(nonatomic,strong)NSString *AreaCode;//地区编码
@property (nonatomic,weak) IBOutlet UITextView *mTextV_content;//内容
@property (weak, nonatomic) IBOutlet UITextView *mText_title;//标题输入框
@property(nonatomic,assign)int imageCount,mInt_index;//拍照时用到
@property(nonatomic,strong)NSMutableArray *mArr_pic;//图片数组
@property(nonatomic,assign)int tfContentTag;//记录图片数量
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;//
@property (weak, nonatomic) IBOutlet UILabel *ttitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;//分类
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnAction:(id)sender;

-(IBAction)mBtn_photo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *placehold_title;

@property (weak, nonatomic) IBOutlet UILabel *placehold_content;


- (IBAction)provinceBtnAction:(id)sender;
- (IBAction)regionBtnAction:(id)sender;
- (IBAction)countyBtnAction:(id)sender;
- (IBAction)categaryBtnAction:(id)sender;
- (IBAction)addQuestionAction:(id)sender;


@end
