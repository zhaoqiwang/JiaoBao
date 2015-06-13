//
//  MyNavigationBar.m
//  iUM
//
//  Created by chai longlong on 12-10-23.
//
//

#import "MyNavigationBar.h"
#import "dm.h"

#define LABEL_TEXT_FONTSIZE 15.0
#define BTN_GOBACK_TAG 1
#define BTN_RIGHT_TAG 2

#define BTN_LEFTSEGMENT_TAG 1
#define BTN_RIGHTSEGMENT_TAG 2

#define MAIN_TOPBAR_HEIGHT 44.0


@implementation MyNavigationBar
@synthesize label_Title = _label_Title;
@synthesize delegate = _delegate;
@synthesize roomId = _roomId;
@synthesize roomName = _roomName;
@synthesize img_L_H = _img_L_H;
@synthesize img_L_N = _img_L_N;
@synthesize img_R_H = _img_R_H;
@synthesize img_R_N = _img_R_N;
@synthesize btnDelegate=_btnDelegate;
@synthesize mainTitleLabel = _mainTitleLabel;
@synthesize subTitleLabel = _subTitleLabel;

- (void)dealloc{
    [_img_R_N release];
    [_img_R_H release];
    [_img_L_N release];
    [_img_L_H release];
    [_label_Title release];
    [_roomName release];
    [_subTitleLabel release];
    [_mainTitleLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark 自定义Segmented
- (id)init
{
    self = [super init];
    if (self) {
        [self setMyFrame];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navibar_bg" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        self.layer.contents = (id) image.CGImage;
    }
    return self;
}


-(id)initWithTitle:(NSString*)title{
    self = [super init];
    if (self) {
        [self setMyFrame];
        self.label_Title = [[UILabel alloc] init];
        
        self.label_Title.backgroundColor = [UIColor clearColor];
        self.label_Title.textAlignment = NSTextAlignmentCenter;
        self.label_Title.font = [UIFont systemFontOfSize:LABEL_TEXT_FONTSIZE];
        self.label_Title.textColor = [UIColor whiteColor];
        self.label_Title.frame = CGRectMake(([dm getInstance].width-150)/2, 14+[dm getInstance].statusBar, 150, 18);
        self.label_Title.text = title;
        self.backgroundColor = [UIColor colorWithRed:33/255.0 green:41/255.0 blue:43/255.0 alpha:1];
        // 如果需要背景透明加上下面这句
        //        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self addSubview:_label_Title];
    }
    
    return self;
}

-(id)initWithMainTitle:(NSString *)mainTitle andSubTitle:(NSString *)subTitle{
    self = [super init];
    if (self) {
        [self setMyFrame];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navibar_bg" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        self.layer.contents = (id) image.CGImage;
        
        self.mainTitleLabel = [[UILabel alloc]init];
        [self.mainTitleLabel setText:mainTitle];
//        if (subTitle.length>0) {
//            [self.mainTitleLabel setFrame:CGRectMake(85, 7+[dm getInstance].statusBar, 150, 18)];
//        }else{
//            self.mainTitleLabel.frame = CGRectMake(MAIN_TOPBAR_HEIGHT+20, (MAIN_TOPBAR_HEIGHT-LABEL_TEXT_FONTSIZE)/2+[dm getInstance].offsetValue-3, MAIN_WIDTH-2*MAIN_TOPBAR_HEIGHT-40, LABEL_TEXT_FONTSIZE);
//        }
        
        [self.mainTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainTitleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.mainTitleLabel setTextColor:[UIColor whiteColor]];
        self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mainTitleLabel];
         UILabel * subLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 30+[dm getInstance].statusBar, 150, 12)];
        self.subTitleLabel = subLabel;
        [subLabel release];
        [self.subTitleLabel setText:subTitle];
        [self.subTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.subTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.subTitleLabel setTextColor:[UIColor whiteColor]];
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

-(void)setSubTitleLabelText:(NSString *)titleText{
//    if (titleText.length>0) {
//        [self.mainTitleLabel setFrame:CGRectMake(85, 8+[dm getInstance].statusBar, 150, 18)];
//    }else{
//        self.mainTitleLabel.frame = CGRectMake(MAIN_TOPBAR_HEIGHT+20, (MAIN_TOPBAR_HEIGHT-LABEL_TEXT_FONTSIZE)/2+[dm getInstance].statusBar, MAIN_WIDTH-2*MAIN_TOPBAR_HEIGHT-40, LABEL_TEXT_FONTSIZE);
//    }
    [self.subTitleLabel setText:titleText];
}

-(id)initWithButtonTitle:(NSString *)title andImage:(UIImage *)image{
    self = [super init];
    if (self) {
        [self setMyFrame];
        
        btn_Title = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_Title setBackgroundColor:[UIColor clearColor]];
        [btn_Title.titleLabel setFont:[UIFont systemFontOfSize:LABEL_TEXT_FONTSIZE]];
        [btn_Title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_Title setTitle:title forState:UIControlStateNormal];
        [btn_Title addTarget:self action:@selector(titleBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//        btn_Title.frame =CGRectMake(0, 0+[dm getInstance].statusBar, 320, MAIN_TOPBAR_HEIGHT);
        btn_Title.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        triImageView = [[UIImageView alloc]initWithImage:image];
        [triImageView setFrame:CGRectMake(0, 0+[dm getInstance].statusBar, image.size.width, image.size.height)];
//        [triImageView setCenter:CGPointMake(btn_Title.frame.origin.x+btn_Title.frame.size.width+5, MAIN_TOPBAR_HEIGHT/2)];
        D("triW == %f",btn_Title.frame.origin.x+btn_Title.frame.size.width+5);
        [self addSubview:triImageView];
        [triImageView setHidden:YES];
        [triImageView release];
        triFlag = YES;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navibar_bg" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        self.layer.contents = (id) image.CGImage;
        // 如果需要背景透明加上下面这句
        //        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self addSubview:btn_Title];
        sliderImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0+[dm getInstance].statusBar, 116, 2)];
        
        [self addSubview:sliderImageV];
        [sliderImageV release];
    }
    
    return self;
}

-(void)setSliderImageViewImage:(int)type{
    switch (type) {
        case 1:
        {
            UIImage * sliderImage = [UIImage imageNamed:@"sliderLeftImage"];
            [sliderImageV setHidden:NO];
            [sliderImageV setImage:sliderImage];
            [sliderImageV setFrame:CGRectMake((320-sliderImage.size.width)/2, 35+[dm getInstance].statusBar, sliderImage.size.width, sliderImage.size.height)];
        }
            break;
        case 2:
        {
            UIImage * sliderImage = [UIImage imageNamed:@"sliderRightImage"];
            [sliderImageV setHidden:NO];
            [sliderImageV setImage:sliderImage];
            [sliderImageV setFrame:CGRectMake((320-sliderImage.size.width)/2, 35+[dm getInstance].statusBar, sliderImage.size.width, sliderImage.size.height)];
        }
            break;
        case 3:
            [sliderImageV setHidden:YES];
            break;
        default:
            break;
    }
}

-(void)titleBtnTap:(UIButton *)sender{
    if (_btnDelegate !=nil && [_btnDelegate respondsToSelector:@selector(MyBtnTitleTap:)]) {
        [_btnDelegate MyBtnTitleTap:sender];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [triImageView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }];
}

-(void)setTitleBtnWithTitleString:(NSString *)titleStr{
    
    [btn_Title setTitle:titleStr forState:UIControlStateNormal];
//    CGSize titleSize = [titleStr sizeWithFont:[UIFont boldSystemFontOfSize:LABEL_TEXT_FONTSIZE]];
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:LABEL_TEXT_FONTSIZE]];
    //限制按钮最大和最小值
    if (titleSize.width>140) {
        titleSize = CGSizeMake(140, titleSize.height);
    }else if(titleSize.width<40){
        titleSize = CGSizeMake(40, titleSize.height);
    }
}

-(void)closePopView{
    [UIView animateWithDuration:0.3 animations:^{
        [triImageView layer].transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
    }];
}

- (id)initWithRoomName:(NSString *)name RoomId:(int)roomId
{
    self = [super init];
    if (self) {
        self.roomName = name;
        self.roomId = roomId;
    }
    return self;
}


-(id)initWithName:(NSString *)title Tel:(NSString *)tel HeadImg:(UIImage *)img{
    self = [super init];
    if (self) {
        [self setMyFrame];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meinv.png"]];
        imgView.frame = CGRectMake(100, 5+[dm getInstance].statusBar, 30, 30);
        [self addSubview:imgView];
        [imgView release];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = title;
        label.frame = CGRectMake(100+30+10, 5+[dm getInstance].statusBar, 100, 18);
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        [label release];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor whiteColor];
        label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:12];
        label1.text = tel;
        label1.frame = CGRectMake(100+30+10, 5+18+[dm getInstance].statusBar, 100, 13);
        label1.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label1];
        [label1 release];
    }
    
    return self;
}


-(void)setGoBack{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0+[dm getInstance].statusBar, 60, MAIN_TOPBAR_HEIGHT);
    button.imageEdgeInsets = UIEdgeInsetsMake(15,-10,10,12);
    [button setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    button.tag = BTN_GOBACK_TAG;
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}
-(void)leftBtnAction:(NSString *)title
{
    [self.leftBtn removeFromSuperview];
    self.leftBtn = nil;
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(5, 0+[dm getInstance].statusBar, 200, MAIN_TOPBAR_HEIGHT);
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12,0,10,12);
    //self.leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    self.leftBtn.tag = BTN_GOBACK_TAG;
    [self.leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    
}

-(void)goBack{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(myNavigationGoback)]) {
        [_delegate myNavigationGoback];
    }
}

-(void)setRightBtn:(UIImage*)img heighlightImg:(UIImage *)heighImg{
    UIButton *button = (UIButton*) [self viewWithTag:BTN_RIGHT_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-img.size.width)/2-10, (MAIN_TOPBAR_HEIGHT-img.size.height)/2+[dm getInstance].statusBar, img.size.width, img.size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
//    [button setBackgroundImage:heighImg forState:UIControlStateHighlighted];
    button.tag = BTN_RIGHT_TAG;
    [button addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    //    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"n_navrbar_line.png"]];
    //    imgView.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT, 0, 2, MAIN_TOPBAR_HEIGHT);
    //    [self addSubview:imgView];
    //    PP_RELEASE(imgView);
}

//不需要高亮效果
-(void)setRightBtn:(UIImage*)img{
    UIButton *button = (UIButton*) [self viewWithTag:BTN_RIGHT_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-img.size.width)/2-10, (MAIN_TOPBAR_HEIGHT-img.size.height)/2+[dm getInstance].statusBar, img.size.width, img.size.height);
    button.frame = CGRectMake([dm getInstance].width-44, [dm getInstance].statusBar, 44, 44);
//    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setImage:img forState:UIControlStateNormal];
    button.tag = BTN_RIGHT_TAG;
    [button addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)setRightBtnTitle:(NSString *)title{
    
    UIButton *button = (UIButton*) [self viewWithTag:BTN_RIGHT_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize btnSize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.frame = CGRectMake([dm getInstance].width-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-btnSize.width)/2-10, (MAIN_TOPBAR_HEIGHT-btnSize.height)/2+[dm getInstance].statusBar, btnSize.width, btnSize.height);
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = BTN_RIGHT_TAG;
    [button addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

//背景图片无文字
-(void)setRightBtn:(UIImage *)img Title:(NSString *)title FontSize:(float)size{
    size = 18;//强制统一
    CGSize btnSize = [title sizeWithFont:[UIFont systemFontOfSize:size]];
    btnSize.width += 12;
    
    UIButton *button = (UIButton*) [self viewWithTag:BTN_RIGHT_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:img forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.tag = BTN_RIGHT_TAG;
//    if (btnSize.width<55) {
//        button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-btnSize.width)/2-20, (MAIN_TOPBAR_HEIGHT-44)/2+[dm getInstance].offsetValue, 55, 44);
//    }else{
//        button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-btnSize.width)/2-20, (MAIN_TOPBAR_HEIGHT-44)/2+[dm getInstance].offsetValue, btnSize.width, 44);
//    }
    
    [button addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)rightbtnAction:(UIButton *)sender{
    if (_delegate != nil &&[_delegate respondsToSelector:@selector(navigationRightAction:)]) {
        [_delegate navigationRightAction:sender];
    }
}

-(void)setMyFrame
{
    self.frame = CGRectMake(0, 0, [dm getInstance].width, MAIN_TOPBAR_HEIGHT+[dm getInstance].statusBar);
}

-(void)setMyFrameBy:(CGRect)frame
{
    self.frame = frame;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setBackBtnTitle:(NSString *)backBtnTitle
{
    NSString *title = @"返回";
    CGSize btnSize = [title sizeWithFont:[UIFont systemFontOfSize:18]];
    btnSize.width += 12;
    
    UIButton *button = (UIButton*) [self viewWithTag:BTN_RIGHT_TAG];
    if (button) {
        [button removeFromSuperview];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.tag = BTN_RIGHT_TAG;
    //    if (btnSize.width<55) {
    //        button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-btnSize.width)/2-20, (MAIN_TOPBAR_HEIGHT-44)/2+[dm getInstance].offsetValue, 55, 44);
    //    }else{
    //        button.frame = CGRectMake(MAIN_WIDTH-MAIN_TOPBAR_HEIGHT+(MAIN_TOPBAR_HEIGHT-btnSize.width)/2-20, (MAIN_TOPBAR_HEIGHT-44)/2+[dm getInstance].offsetValue, btnSize.width, 44);
    //    }
    
    [button addTarget:self action:@selector(rightbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
//    NSString * btnTitleStr = [NSString stringWithFormat:@"  %@",backBtnTitle];
//    [(UIButton *)[self viewWithTag:BTN_GOBACK_TAG] setTitle:btnTitleStr forState:UIControlStateNormal];
//    if (backBtnTitle.length==3) {
//        btnTitleStr = [NSString stringWithFormat:@"    %@",backBtnTitle];
//        CGSize btnSize = [btnTitleStr sizeWithFont:[UIFont systemFontOfSize:16]];
//        //        btnSize.width += 12;
//        [(UIButton *)[self viewWithTag:BTN_GOBACK_TAG] setFrame:CGRectMake(5, ((UIButton *)[self viewWithTag:BTN_GOBACK_TAG]).frame.origin.y, btnSize.width+9, ((UIButton *)[self viewWithTag:BTN_GOBACK_TAG]).frame.size.height)];
//    }
//    if (backBtnTitle.length==4) {
//        btnTitleStr = [NSString stringWithFormat:@"    %@",backBtnTitle];
//        CGSize btnSize = [btnTitleStr sizeWithFont:[UIFont systemFontOfSize:16]];
//        //        btnSize.width += 12;
//        [(UIButton *)[self viewWithTag:BTN_GOBACK_TAG] setFrame:CGRectMake(5, ((UIButton *)[self viewWithTag:BTN_GOBACK_TAG]).frame.origin.y, btnSize.width+10, ((UIButton *)[self viewWithTag:BTN_GOBACK_TAG]).frame.size.height)];
//    }

}


@end
