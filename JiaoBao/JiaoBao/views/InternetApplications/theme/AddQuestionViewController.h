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
#import <AVFoundation/AVFoundation.h>



@interface AddQuestionViewController : UIViewController<MyNavigationDelegate,UIActionSheetDelegate,ELCAssetSelectionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)MyNavigationBar *mNav_navgationBar;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;//省输入框
@property (weak, nonatomic) IBOutlet UITextField *regionTF;//地区输入框
@property (weak, nonatomic) IBOutlet UITextField *countyTF;//区县输入框
@property(nonatomic,strong)NSMutableArray *mArr_AllCategory;//所有分类
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
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;//
@property (weak, nonatomic) IBOutlet UILabel *ttitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;//分类
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;//有证明过程按钮
- (IBAction)selectBtnAction:(id)sender;//有证明过程按钮方法

-(IBAction)mBtn_photo:(id)sender;//点击拍照方法
@property (weak, nonatomic) IBOutlet UIButton *addQuestionBtn;//发布问题按钮



- (IBAction)provinceBtnAction:(id)sender;//省
- (IBAction)regionBtnAction:(id)sender;//市
- (IBAction)countyBtnAction:(id)sender;//县
- (IBAction)categaryBtnAction:(id)sender;//选择分类
- (IBAction)addQuestionAction:(id)sender;//发布问题


@end
