//
//  LDPublishDynamicViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDPublishDynamicViewController.h"
#import "LDSelectAtPersonViewController.h"
#import "LDStandardViewController.h"
#import "LDCreateTopicViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"
#import "LDSelectTopicViewController.h"
//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "MGSelectionTagView.h"
#import "LDSelectpersonpageVC.h"

#define kATFormat  @"@%@ "

@interface LDPublishDynamicViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,MGSelectionTagViewDelegate,MGSelectionTagViewDataSource,UIScrollViewDelegate,YBAttributeTapActionDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

//存储缩略图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, copy) NSString *path;

//存储水印图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *shuiyinArray;
@property (nonatomic, copy) NSString *shuiyinPath;

//发布动态的页面
@property (strong, nonatomic)  UIView *publishView;
@property (strong, nonatomic)  UILabel *textLabel;
@property (strong, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UILabel *numberLabel;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UILabel *personNumberLabel;

@property (strong, nonatomic)  MGSelectionTagView *tagView;

@property (nonatomic, strong)  NSArray *tags;

//话题的界面
@property (strong, nonatomic)  UIView *backView;
@property (strong, nonatomic)  UILabel *topicLabel;
@property (strong, nonatomic)  NSMutableArray *topicArray;

//@默认的view
@property (strong, nonatomic)  UIView *atView;

//提示语label
@property (nonatomic,strong) UILabel *warnLabel;

@property (copy, nonatomic)  NSString *state;

//选中@的人的UID的拼接
@property (copy, nonatomic)  NSString *selectUid;
@property (nonatomic,strong) NSMutableArray *selectuidArray;
//是否推荐
@property (nonatomic,assign) BOOL isrecommend;
@property (strong, nonatomic) NSMutableArray<NSString *> *comments;
@property (nonatomic,copy) NSString *atuname;
@property (nonatomic,strong) NSMutableArray *atunameArray;
@end

@implementation LDPublishDynamicViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发布动态";
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _pictureArray = [NSMutableArray array];
    self.shuiyinArray = [NSMutableArray array];
    self.topicArray = [NSMutableArray array];
    self.atunameArray = [NSMutableArray array];
    self.selectuidArray = [NSMutableArray array];
    _state = @"0";
    [self createScrollViewAndSubviews];
    if (_topicString.length != 0) {
        
        self.textView.text = _topicString;
        
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)self.textView.text.length];
        
        if (self.textView.text.length == 0) {
            
            [self.textLabel setHidden:NO];
        }else{
            [self.textLabel setHidden:YES];
        }
    }else{
        _topicString = @"";
        _topicTid = @"";
    }
    [self createButton];
}

-(UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

-(void)createScrollViewAndSubviews{
    if (ISIPHONEX) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    }else{
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5" alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 21)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"参与话题(可选,正确分类将获得更多曝光)";
    [self.backView addSubview:label];
    
    [self.scrollView addSubview:self.backView];
    
    [self prepareDataSource];
    [self setupViewUI];
    [self.backView addSubview:self.tagView];
    
    _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tagView.frame) + 10, WIDTH - 20, 0)];
    _topicLabel.numberOfLines = 0;
    _topicLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.backView addSubview:_topicLabel];
    
    if (self.index != 0) {
        
        [self.tagView reloadData:self.index];
        
    }else{
        
        [self.tagView reloadData:0];
    }
    self.publishView  = [[UIView alloc] init];
    self.publishView.backgroundColor = [UIColor whiteColor];
    self.publishView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), WIDTH, 223);
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, WIDTH - 16, 182)];
    self.textView.contentInset = UIEdgeInsetsMake(-8.f, 0.f, 0.f, 0.f);
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    [self.publishView addSubview:self.textView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, WIDTH - 24, 10)];
    _textLabel.text = @"分享我的Samer生活......（请勿使用露骨的项目词汇、大尺度文字描述、有偿收费描述、多人夫妻描述等！九年圣魔来之不易，需要同好们的共同呵护~）";
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.numberOfLines = 0;
    [_textLabel sizeToFit];
     _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.frame = CGRectMake(12, 8, WIDTH - 24, _textLabel.frame.size.height);
    _textLabel.textColor = [UIColor lightGrayColor];
    [_publishView addSubview:_textLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 127, 175+20, 119, 21)];
    _numberLabel.text = @"0/10000";
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [_publishView addSubview:_numberLabel];
    
    UIView *oneLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _publishView.frame.size.height - 1, WIDTH, 1)];
    oneLineView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [_publishView addSubview:oneLineView];
    
    [self.scrollView addSubview:_publishView];
    
    _atView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_publishView.frame), WIDTH, 41)];
    _atView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_atView];
    
    UILabel *istopLab = [[UILabel alloc] init];
    istopLab.textColor = [UIColor lightGrayColor];
    istopLab.frame = CGRectMake(12, 14, 80, 20);
    istopLab.text = @"是否推荐";
    istopLab.font = [UIFont systemFontOfSize:14];
    [_atView addSubview:istopLab];
    
    UISwitch * swi = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH-68, 6,0, 0)];
    
    [swi addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1) {
        swi.on = YES;
        self.isrecommend = YES;
    }
    else
    {
        swi.on = NO;
        self.isrecommend = NO;
    }
    [_atView addSubview:swi];
    [self configCollectionView:_atView];
}

-(void)changeColor:(UISwitch *)swi{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue] == 1) {
        
        if (swi.isOn) {
            swi.on = NO;
            self.isrecommend = NO;
        }
        else
        {
            swi.on = YES;
            self.isrecommend = YES;
        }
        
    }
    else
    {
        swi.on = NO;
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"推荐功能限SVIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];

        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:nil];
    }
}

- (void)setupViewUI {
    self.tagView = [[MGSelectionTagView alloc] initWithFrame:CGRectMake(0, 40,WIDTH,162)];
    self.tagView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5" alpha:1];
    self.tagView.dataSource = self;
    self.tagView.delegate = self;
    self.tagView.itemBackgroundImage = [UIImage imageNamed:@"buttonNormal"];
    self.tagView.itemSelectedBackgroundImage = [UIImage imageNamed:@"buttonSelected.jpg"];
    self.tagView.maxSelectNum = 1;
}

#pragma mark - Data

- (void)prepareDataSource {
    
    self.tags = @[@"推荐",@"杂谈",@"兴趣",@"爆照",@"交友",@"生活",@"情感",@"官方"];
}

#pragma mark - MGSelectionTagViewDataSource

- (NSInteger)numberOfTagsInSelectionTagView:(MGSelectionTagView *)tagView {
    
    return self.tags.count;
}

- (NSString *)tagView:(MGSelectionTagView *)tagView titleForIndex:(NSInteger)index {
    
    return [self.tags objectAtIndex:index];
}

/**
 *  标识index位置的tag是否选中
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isTagSelectedForIndex:(NSInteger)index {
    
    return NO;
}

/**
 *  标识index位置的tag是否“其他”（设置了“其他”tag会在选择时产生互斥）
 *
 */
- (BOOL)tagView:(MGSelectionTagView *)tagView isOtherTagForIndex:(NSInteger)index {
    
    return NO;
}

#pragma mark - MGSelectionTagViewDelegate

- (void)tagView:(MGSelectionTagView *)tagView tagTouchedAtIndex:(NSInteger)index {

    if ([self.tagView indexesOfSelectionTags].count != 0) {
        
        [self getTopicData:[NSString stringWithFormat:@"%d",[[self.tagView indexesOfSelectionTags][0] intValue]]];
        
    }else{
        
        //点击了话题或者点击了选中的tag
        [self clickTagViewOrTopic];
    }
}

/**
   点击了话题或者点击了选中的tag
 */

-(void)clickTagViewOrTopic{
    
    [_topicArray removeAllObjects];
    _topicLabel.text = @"";
    _topicLabel.frame = CGRectMake(10, CGRectGetMaxY(self.tagView.frame) + 10, WIDTH - 20, 0);
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)self.textView.text.length];
    if (self.textView.text.length == 0) {
        [self.textLabel setHidden:NO];
    }else{
        [self.textLabel setHidden:YES];
    }
    [self getDynamicHeight];
}

/**
 获取每个话题下的话题数
 */

-(void)getTopicData:(NSString *)pid{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"api/dynamic/getTopicEight"];
    
    NSDictionary *parameters = @{@"pid":pid};
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 3000) {
            
            _topicLabel.text = @"";
            
            _topicLabel.frame = CGRectMake(10, CGRectGetMaxY(self.tagView.frame) + 10, WIDTH - 20, 0);
            
        }else{
            
            _topicLabel.text = @"";
            
            if (_topicArray.count > 0) {
                
                [_topicArray removeAllObjects];
            }
            
            [_topicArray addObjectsFromArray:responseObj[@"data"]];
            
            NSMutableArray *titleArray = [NSMutableArray array];
            
            for (int i = 0; i < [responseObj[@"data"] count]; i++) {
                
                [titleArray addObject:[NSString stringWithFormat:@"#%@#",responseObj[@"data"][i][@"title"]]];
                
                if (i == 0) {
                    
                    _topicLabel.text = [NSString stringWithFormat:@"#%@#",responseObj[@"data"][0][@"title"]];
                    
                }else{
                    
                    _topicLabel.text = [NSString stringWithFormat:@"%@    #%@#",_topicLabel.text,responseObj[@"data"][i][@"title"]];
                }
                
            }
            
            NSArray *colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
            
            // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_topicLabel.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:10];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_topicLabel.text length])];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [_topicLabel.text length])];
            
            for (int i = 0; i <titleArray.count; i++) {
                
                NSRange range;
                
                range = [_topicLabel.text rangeOfString:[NSString stringWithFormat:@"%@",titleArray[i]]];
                
                if (range.location != NSNotFound) {
                    
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0)) range:range];
                    
                }else{
                    
                    NSLog(@"Not Found");
                    
                }
            }
            
            if (titleArray.count >= 35) {
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"[更多]"];
                
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [string length])];
                
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [string length])];
                
                [attributedString appendAttributedString:string];
                
                [titleArray addObject:@"[更多]"];
            }
            self.topicLabel.attributedText = attributedString;
            [self.topicLabel yb_addAttributeTapActionWithStrings:titleArray delegate:self];
            self.topicLabel.enabledTapEffect = NO;
            [self.topicLabel sizeToFit];
            _topicLabel.frame = CGRectMake(10, CGRectGetMaxY(self.tagView.frame) + 10, WIDTH - 20, self.topicLabel.frame.size.height);
        }
        [self getDynamicHeight];
    } failed:^(NSString *errorMsg) {
        _topicLabel.text = @"";
        _topicLabel.frame = CGRectMake(10, CGRectGetMaxY(self.tagView.frame) + 10, WIDTH - 20, 0);
        [self getDynamicHeight];
    }];
}

//富文本文字可点击delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([string isEqualToString:@"认证会员"]) {

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
            
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            cvc.type = @"2";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else{
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getidstate"];
            
            NSDictionary *parameters;
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                if (integer == 2000) {
                    
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    
                    cvc.type = @"2";
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                    
                }else if(integer == 2001){
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待~"];
                    
                    
                }else if (integer == 2002){
                    
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    
                    cvc.where = @"4";
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
            
        }
        
        
    }else if ([string isEqualToString:@"VIP会员"]){
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else{
        
        if ([string isEqualToString:@"[更多]"]) {
            
            LDSelectTopicViewController *tvc = [[LDSelectTopicViewController alloc] init];
            
            tvc.title = self.tags[[[self.tagView indexesOfSelectionTags][0] intValue]];
            
            tvc.pid = [NSString stringWithFormat:@"%d",[[self.tagView indexesOfSelectionTags][0] intValue] + 1];
            
            tvc.block = ^(NSString *title, NSString *tid) {
                
                _topicTid = tid;
                
                //点击了话题标题后输入框的文字改变
                [self changeTopicToTextViewWithString:[NSString stringWithFormat:@"#%@#",title]];
            };
            
            [self.navigationController pushViewController:tvc animated:YES];
            
        }else{
            
            _topicTid = [NSString stringWithFormat:@"%@",_topicArray[index][@"tid"]];
            
            //点击了话题标题后输入框的文字改变
            [self changeTopicToTextViewWithString:string];
        }
        
        //删除对应话题的选中状态
        [self.tagView changeSomeoneSelectedState];
        
    }
    
}

/**
 * 点击了话题标题后输入框的文字改变
 */
-(void)changeTopicToTextViewWithString:(NSString *)string{
    
    if (self.textView.text.length == 0) {
        
        self.textView.text = string;
        
        _topicString = string;
        
    }else{
        
        if (_topicString.length == 0) {
            
            _topicString = string;
            
            self.textView.text = [NSString stringWithFormat:@"%@%@",_topicString,self.textView.text];
            
        }else if (_topicString.length != 0){
            
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.textView.text];
            
            self.textView.text = [str substringFromIndex:_topicString.length];
            
            _topicString = string;
            
            self.textView.text = [NSString stringWithFormat:@"%@%@",_topicString,self.textView.text];
        }
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)self.textView.text.length];
    
    if (self.textView.text.length == 0) {
        
        [self.textLabel setHidden:NO];
        
    }else{
        
        [self.textLabel setHidden:YES];
    }
}


/**
 更新scrollView的长度
 */
-(void)getDynamicHeight{
    
    if (_topicLabel.frame.size.height == 0) {
        
        self.backView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(_topicLabel.frame));
        
    }else{
        
        self.backView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(_topicLabel.frame) + 10);
    }

    CGRect rectFrame;
    
    //更改发布view的frame的y值
    rectFrame = self.publishView.frame;
    rectFrame.origin.y = CGRectGetMaxY(self.backView.frame);
    self.publishView.frame = rectFrame;
    
    //更改@view的frame的y值
    rectFrame = self.atView.frame;
    rectFrame.origin.y = CGRectGetMaxY(_publishView.frame);
    self.atView.frame = rectFrame;

    //更改提示label的frame的y值
    rectFrame = self.warnLabel.frame;
    rectFrame.origin.y = CGRectGetMaxY(_atView.frame) + 10;
    self.warnLabel.frame = rectFrame;
 
    //更改图片的frame的y值
    rectFrame = self.collectionView.frame;
    rectFrame.origin.y = CGRectGetMaxY(_warnLabel.frame) + 10;
    self.collectionView.frame = rectFrame;
    
    CGFloat dynamicH;
    if (CGRectGetMaxY(_collectionView.frame) > [self getIsIphoneX:ISIPHONEX]) {
        dynamicH = CGRectGetMaxY(_collectionView.frame) + 90;
    }else{
        dynamicH = HEIGHT + 20;
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH, dynamicH);
}

//textview代理方法
#pragma mark  textView的代理方法

#pragma mark - Private

- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = self.textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [self.textLabel setHidden:NO];
    }else{
        [self.textLabel setHidden:YES];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if (textView.text.length >= 10000) {
            
            textView.text = [textView.text substringToIndex:10000];
            
            self.numberLabel.text = @"10000/10000";
            
        }else{
            
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)textView.text.length];
            
        }
    }
    
    if (textView.text.length!=0) {
        NSRange range = textView.selectedRange;
        NSString *str = [textView.text substringWithRange:NSMakeRange(range.location-1, 1)];
        if ([str isEqualToString:@"@"]) {
            
            NSMutableString *newText = [[NSMutableString alloc] initWithString:self.textView.text];
            [newText deleteCharactersInRange:NSMakeRange(range.location-1, 1)];
            
            LDSelectpersonpageVC *VC = [LDSelectpersonpageVC new];
            VC.newblock = ^(NSMutableArray * _Nonnull allUid, NSMutableArray * _Nonnull nameArr, int personNumber) {
                if (personNumber == 0) {
                    
                    NSString *nameText = [nameArr componentsJoinedByString:@""];
                    NSMutableString *mustr1 = newText.mutableCopy;
                    [mustr1 insertString:nameText atIndex:range.location-1];
                    
                    self.textView.text = mustr1;
                    self.textView.text = [self.textView.text stringByAppendingString:@" "];

                    [self.atunameArray addObjectsFromArray:nameArr];
                    [self.selectuidArray addObjectsFromArray:allUid];
                    
                    self.atuname = [self.atunameArray componentsJoinedByString:@","];
                    self.selectUid = [self.selectuidArray componentsJoinedByString:@","];
                    
                }
              
                if (allUid.count==0) {

                    self.textView.text = newText;
                }
            };
            VC.returnblock = ^{
                
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    if (textView.text.length < 1)
    {
        // 高亮输入框中的@
        UITextView *textView = self.textView;
        NSRange range = textView.selectedRange;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];
        NSArray *matches = [self findAllAt];
        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(match.range.location, match.range.length - 1)];
        }
        textView.attributedText = string;
        textView.selectedRange = range;
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {

    }
}

/**
 *  光标位置删除
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@""] && _topicString.length != 0) {
        [self deleteString:textView];
    }

    // 判断删除的是一个@中间的字符就整体删除
    NSMutableString *string = [NSMutableString stringWithString:textView.text];
    NSArray *matches = [self findAllAt];
    
    BOOL inAt = NO;
    NSInteger index = range.location;
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            inAt = YES;
            index = match.range.location;
            NSString *str2 = [string substringWithRange:match.range];
            [string replaceCharactersInRange:match.range withString:@""];
            NSInteger inde =[self.atunameArray indexOfObject:str2];
            
            NSMutableArray *atuidArray = [NSMutableArray new];
            
            if (self.topicString.length==0) {
                if (self.atunameArray.count>=inde) {
                    [self.atunameArray removeObjectAtIndex:inde];
                    atuidArray = [self.selectUid componentsSeparatedByString:@","].mutableCopy;
                    [atuidArray removeObjectAtIndex:inde];
                }
            }
            else
            {
                  if (self.atunameArray.count>=inde) {
                      [self.atunameArray removeObjectAtIndex:inde];
                      atuidArray = [self.selectUid componentsSeparatedByString:@","].mutableCopy;
                      [atuidArray removeObjectAtIndex:inde];
                  }
            }
            if (self.atunameArray.count!=0) {
                self.atuname = [self.atunameArray componentsJoinedByString:@","];
            }
            if (atuidArray.count!=0) {
                self.selectUid = [atuidArray  componentsJoinedByString:@","];
            }
            break;
        }
    }
    
    if (inAt)
    {
        textView.text = string;
        textView.selectedRange = NSMakeRange(index, 0);
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    // 光标不能点落在@词中间
    NSRange ranges = textView.selectedRange;
    NSArray *matches = [self findAllAt];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location+1, match.range.length-1);
        if (NSLocationInRange(ranges.location, newRange))
        {
            textView.selectedRange = NSMakeRange(match.range.location + match.range.length-1, 0);
            
            break;
        }
    }
}

- (void)deleteString:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        NSUInteger location  = textView.selectedRange.location;
        NSString *head = [textView.text substringToIndex:location];
        if (location > 0) {
            if ([head isEqualToString:_topicString]) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@",textView.text];
                textView.text = [str substringFromIndex:head.length];
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)textView.text.length];
                textView.selectedRange = NSMakeRange(0,0);
                _topicString = @"";
                _topicTid = @"";
            }else{
                //判断如果修改了话题则话题失效
                if (location < _topicString.length) {
                    _topicString = @"";
                    _topicTid = @"";
                }
            }
        } else {
            textView.selectedRange = NSMakeRange(0,0);
        }
    }
    if (self.textView.text.length == 0) {
        [self.textLabel setHidden:NO];
    }else{
        [self.textLabel setHidden:YES];
    }
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)configCollectionView:(UIView *)atView{
    
    _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(atView.frame) + 10, 300, 21)];
    _warnLabel.font = [UIFont systemFontOfSize:14];
    _warnLabel.textColor = [UIColor lightGrayColor];
    _warnLabel.text = @"请勿上传大尺度图片及调教照";
    [self.scrollView addSubview:_warnLabel];
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
//    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (WIDTH - 2 * _margin - 24) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_warnLabel.frame) + 10, WIDTH - 20, _itemWH + 2 * _margin) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(6, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];

}

-(void)createTopicButtonClick{
    LDCreateTopicViewController *tvc = [[LDCreateTopicViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count == 9) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加图片"];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.textView resignFirstResponder];
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                //拍照  调用相机
                [self takePhoto];
            }];
            UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                [self pushImagePickerController];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                
            }];
            if (PHONEVERSION.doubleValue >= 8.3) {
                [cancelAction setValue:MainColor forKey:@"_titleTextColor"];
                [photoAction setValue:MainColor forKey:@"_titleTextColor"];
                [cameraAction setValue:MainColor forKey:@"_titleTextColor"];
            }
            [alertController addAction:cameraAction];
            [alertController addAction:photoAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    [self thumbnaiWithImage:_selectedPhotos andAssets:_selectedAssets];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.barItemTextColor = TextCOLOR;
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    if (_selectedAssets.count > 0) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.maxImagesCount = 9;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    // 5. Single selection mode, valid when maxImagesCount = 1
    // 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            return [self takePhoto];
            
        });
    } else { // 调用相机
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.delegate = self;
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.barItemTextColor = TextCOLOR;
        tzImagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [UIImage fixOrientation:image];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (/* DISABLES CODE */ (NO)) { // 不允许裁剪,不去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.allowCrop = NO;
                            imagePicker.needCircleCrop = NO;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                            
                        } else {
                            
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if(@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self thumbnaiWithImage:photos andAssets:assets];
}
//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    _selectedPhotos = [NSMutableArray arrayWithArray:imageArray];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = YES;
    [self changeFrame:imageArray];
    [_collectionView reloadData];
}

-(void)changeFrame:(NSArray *)imageArray{
    if (imageArray.count <= 2) {
        self.collectionView.frame = CGRectMake(10, 275, WIDTH - 20, _itemWH + 2 * _margin);
    }else if(imageArray.count <= 5 && imageArray.count > 2){
        self.collectionView.frame = CGRectMake(10, 275, WIDTH - 20, 2 * _itemWH + 3 * _margin);
    }else if (imageArray.count <= 9 && imageArray.count > 5){
        self.collectionView.frame = CGRectMake(10, 275, WIDTH - 20, 3 * _itemWH + 4 * _margin);
    }
    [self getDynamicHeight];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [self changeFrame:_selectedPhotos];
    [_collectionView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(sendButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
    }else{
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)leftButtonOnClick
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消发布动态？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [control addAction:action0];
    [control addAction:action1];
    [self presentViewController:control animated:YES completion:^{
        
    }];
}

-(void)sendButtonOnClick:(UIButton *)button{
    [self.pictureArray removeAllObjects];
    button.userInteractionEnabled = NO;
    if (_selectedPhotos.count ==0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self createData:@"" andShuiyin:@"" andButton:button];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self uploadImageForIndex:0 andButton:button];
    }
}

- (void)uploadImageForIndex:(NSInteger)index andButton:(UIButton *)button{

    if (index < _selectedPhotos.count) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];

        [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,dynamicPicUploadUrl] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            NSData *imageData = UIImageJPEGRepresentation(_selectedPhotos[index], 1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];

        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [_pictureArray addObject:responseObject[@"data"][@"slimg"]];
            [_shuiyinArray addObject:responseObject[@"data"][@"syimg"]];
            if (_selectedPhotos.count == _pictureArray.count) {
                for (int i = 0; i < _pictureArray.count; i++) {
                    if (i == 0) {
                        self.path = _pictureArray[0];
                    }else{
                        self.path = [NSString stringWithFormat:@"%@,%@",self.path,_pictureArray[i]];
                    }
                }
                if (_selectedPhotos.count == _shuiyinArray.count) {
                    for (int i = 0; i < _shuiyinArray.count; i++) {
                        if (i == 0) {
                            self.shuiyinPath = _shuiyinArray[0];
                        }else{
                            self.shuiyinPath = [NSString stringWithFormat:@"%@,%@",self.shuiyinPath,_shuiyinArray[i]];
                        }
                    }
                }
                [self createData:self.path andShuiyin:self.shuiyinPath andButton:button];
            }else{
                [self uploadImageForIndex:index + 1 andButton:button];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    }
}

#pragma mark - 发布动态

-(void)createData:(NSString *)path andShuiyin:(NSString *)shuiyinPath andButton:(UIButton *)button{
    
    NSString *topic;
    NSString *tid;;
    if (self.textView.text.length == 0) {
        topic = @"";
        tid = @"";
    }else{
        if (_topicString.length != 0) {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.textView.text];
            topic = [str substringFromIndex:_topicString.length];
            if (topic.length == 0) {
                topic = @"";
            }
            tid = _topicTid;
        }else{
            topic = self.textView.text;
            tid = @"";
        }
    }
    if (_selectUid.length == 0) {
        _selectUid = @"";
    }
    if (topic.length == 0 && path.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请输入内容或添加图片后发布~"];
    }else{
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,sendDynamicUrl];
        NSDictionary *parameters;
        NSString *recommend = [NSString new];
        if (self.isrecommend) {
            recommend = @"1";
        }
        else
        {
            recommend = @"0";
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:longitude],@"content":topic,@"pic":path,@"tid":tid,@"sypic":shuiyinPath,@"atuid":_selectUid,@"recommend":recommend,@"atuname":self.atuname?:@""};
            
        }else{
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"content":topic,@"pic":path,@"tid":tid,@"sypic":shuiyinPath,@"atuid":_selectUid,@"recommend":recommend,@"atuname":self.atuname?:@""};
        }
        
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            
            if (integer != 2000) {
                button.userInteractionEnabled = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                
                button.userInteractionEnabled = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failed:^(NSString *errorMsg) {
            button.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 多图上传

/*- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
 // 构造 NSURLRequest
 NSError* error = NULL;
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",PICHEADURL,dynamicPicUploadUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
 [formData appendPartWithFileData:imageData name:@"file" fileName:@"someFileName" mimeType:@"multipart/form-data"];
 } error:&error];
 
 // 可在此处配置验证信息
 
 // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
 } completionHandler:completionBlock];
 
 return uploadTask;
 }
 
 - (void)runDispatchTest{
 // 需要上传的数据
 NSArray* images = _selectedPhotos;
 
 // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
 NSMutableArray* result = [NSMutableArray array];
 for (UIImage* image in images) {
 [result addObject:[NSNull null]];
 NSLog(@"%@",image);
 }
 
 dispatch_group_t group = dispatch_group_create();
 
 for (NSInteger i = 0; i < images.count; i++) {
 
 dispatch_group_enter(group);
 
 NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
 if (error) {
 NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
 dispatch_group_leave(group);
 } else {
 NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
 @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
 result[i] = responseObject;
 }
 dispatch_group_leave(group);
 }
 }];
 [uploadTask resume];
 }
 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
 NSLog(@"上传完成!");
 for (id response in result) {
 NSLog(@"%@", response);
 }
 });
 }*/

@end
