//
//  LDAlertOtherDynamicViewController.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/8/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlertOtherDynamicViewController.h"
#import "LDStandardViewController.h"
#import "LDCertificateViewController.h"
#import "LDMemberViewController.h"
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

@interface LDAlertOtherDynamicViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate,MGSelectionTagViewDelegate,MGSelectionTagViewDataSource,YBAttributeTapActionDelegate> {
    
    NSMutableArray *_selectedPhotos;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
//删除图片时的数组
@property (nonatomic, strong) NSMutableArray *deleteArray;
//原来的独白内容
@property (nonatomic, copy) NSString *oldContent;
//存储缩略图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, copy) NSString *path;
//用于进行操作的水印数组
@property (nonatomic, strong) NSMutableArray *selectedSyArray;
//删除新添加图片时的数组
@property (nonatomic, strong) NSMutableArray *addArray;
//存储水印图数组及发布动态时上传的字符串
@property (nonatomic, strong) NSMutableArray *shuiyinArray;
@property (nonatomic, copy) NSString *shuiyinPath;

@property (strong, nonatomic)  UIView *publishView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *warnLabel;

@property (strong, nonatomic)  UIView *backView;
@property (strong, nonatomic)  UILabel *textLabel;
@property (strong, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UILabel *numberLabel;

@property (strong, nonatomic)  MGSelectionTagView *tagView;
@property (nonatomic, strong) NSArray *tags;

//话题的界面
@property (strong, nonatomic)  UIView *topicbackView;
@property (strong, nonatomic)  UILabel *topicLabel;
@property (strong, nonatomic)  NSMutableArray *topicArray;

//@默认的view
@property (strong, nonatomic)  UIView *atView;

//话题语句
@property (nonatomic,copy) NSString *topicStr;
@property (nonatomic,copy) NSString *contentStr;

//活动ID
@property (nonatomic,copy) NSString *topicTid;

@property (nonatomic,copy) NSString *atuid;
@property (nonatomic,copy) NSString *atuname;
@property (nonatomic,strong) NSMutableArray *atuidArray;
@property (nonatomic,strong) NSMutableArray *atunameArray;
@end

@implementation LDAlertOtherDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"编辑动态";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScrollViewAndSubviews];
    _selectedPhotos = [NSMutableArray array];
    _selectedSyArray = [NSMutableArray array];
    _addArray = [NSMutableArray array];
    _pictureArray = [NSMutableArray array];
    _shuiyinArray = [NSMutableArray array];
    _deleteArray = [NSMutableArray array];
    self.atuidArray = [NSMutableArray array];
    self.atunameArray = [NSMutableArray array];
    self.topicArray = [NSMutableArray array];
    [self.textLabel sizeToFit];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self createScanData];
    [self createButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (ISIPHONEX) {
        self.scrollView.frame = CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]);
        
    }else{
        self.scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH, CGRectGetHeight(self.scrollView.frame) + 20);
}

- (UIImagePickerController *)imagePickerVc {
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

/**
 创建界面
 */
-(void)createScrollViewAndSubviews
{
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
    
    [self.tagView reloadData:0];
    
    self.publishView  = [[UIView alloc] init];
    self.publishView.backgroundColor = [UIColor whiteColor];
    self.publishView.frame = CGRectMake(0, CGRectGetMaxY(self.topicLabel.frame), WIDTH, 203);
    self.publishView.frame = CGRectMake(0, 220, WIDTH, 203);
    
    [self.scrollView addSubview:self.publishView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, WIDTH - 16, 162)];

    self.textView.contentInset = UIEdgeInsetsMake(-8.f, 0.f, 0.f, 0.f);
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    [self.publishView addSubview:_textView];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, WIDTH - 24, 10)];
    _textLabel.text = @"分享我的Samer生活......（请勿使用露骨的项目词汇、大尺度文字描述、有偿收费描述、多人夫妻描述等！九年圣魔来之不易，需要同好们的共同呵护~）";
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.numberOfLines = 0;
    [_textLabel sizeToFit];
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.frame = CGRectMake(12, 8, WIDTH - 24, _textLabel.frame.size.height);
    _textLabel.textColor = [UIColor lightGrayColor];
    [_publishView addSubview:_textLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 127, 175, 119, 21)];
    _numberLabel.text = @"0/10000";
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [_publishView addSubview:_numberLabel];
    _atView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_publishView.frame), WIDTH, 41)];
    _atView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:_atView];
    [self configCollectionView:_atView];
    
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

-(void)createScanData{

    NSString *url = [PICHEADURL stringByAppendingString:getDynamicdetailFiveEditUrl];
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:latitude],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:longitude]};
        
    }else{
        
        parameters = @{@"did":_did,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
    }
    
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2000 && integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            
        }else{
            
            _oldContent = responseObj[@"data"][@"content"];
            
            if ([responseObj[@"data"][@"content"] length] != 0) {
                
                self.contentStr =  responseObj[@"data"][@"content"];
                
                self.atuid = responseObj[@"data"][@"atuid"];
                self.atuname = responseObj[@"data"][@"atuname"];
                if (self.atuid.length!=0) {
                    self.atuidArray = [self.atuid  componentsSeparatedByString:@","].mutableCopy;
                }
                if (self.atuname.length!=0) {
                    self.atunameArray = [self.atuname componentsSeparatedByString:@","].mutableCopy;
                }

                NSString *newStr = [NSString stringWithFormat:@"%@",responseObj[@"data"][@"topictitle"]];
                if (newStr.length==0) {
                    self.topicStr = @"";
                }
                else
                {
                    self.topicStr = [NSString stringWithFormat:@"%@%@%@",@"#",responseObj[@"data"][@"topictitle"],@"#"];
                }
                self.textView.text = [NSString stringWithFormat:@"%@%@",self.topicStr,self.contentStr];
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/10000",(unsigned long)self.textView.text.length];
                self.topicTid = responseObj[@"data"][@"tid"];
                if (self.textView.text.length == 0) {
                    [self.textLabel setHidden:NO];
                }else{
                    [self.textLabel setHidden:YES];
                }
            }else{
                self.textView.text = @"";
                self.numberLabel.text = [NSString stringWithFormat:@"%d/10000",0];
                [self.textLabel setHidden:NO];
            }
            //用于进行删除添加图片操作的数组
            [_selectedPhotos addObjectsFromArray:responseObj[@"data"][@"pic"]];
            [_selectedSyArray  addObjectsFromArray:responseObj[@"data"][@"sypic"]];
            
            //用于对比是否图片更改的原始数组
            [_pictureArray addObjectsFromArray:responseObj[@"data"][@"pic"]];
            [_shuiyinArray addObjectsFromArray:responseObj[@"data"][@"sypic"]];
            
            [self changeFrame:_selectedPhotos];
            [_collectionView reloadData];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
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
                
                self.topicTid = [NSString stringWithFormat:@"%@",_topicArray[index][@"tid"]];
               // 点击了话题标题后输入框的文字改变
                [self changeTopicToTextViewWithString:[NSString stringWithFormat:@"#%@#",title]];
            };
            
            [self.navigationController pushViewController:tvc animated:YES];
            
        }else{
            
             self.topicTid = [NSString stringWithFormat:@"%@",_topicArray[index][@"tid"]];
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
        _topicStr = string;
    }else{
        if (_topicStr.length == 0) {
            _topicStr = string;
            self.textView.text = [NSString stringWithFormat:@"%@%@",_topicStr,self.textView.text];
        }else if (_topicStr.length != 0){
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.textView.text];
            self.textView.text = [str substringFromIndex:_topicStr.length];
            _topicStr = string;
            self.textView.text = [NSString stringWithFormat:@"%@%@",_topicStr,self.textView.text];
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
        if (range.location==0) {
            return;
        }
        NSString *str = [textView.text substringWithRange:NSMakeRange(range.location-1, 1)];
        if ([str isEqualToString:@"@"]&&str.length!=0) {

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
                    [self.atuidArray addObjectsFromArray:allUid];
                    
                    self.atuname = [self.atunameArray componentsJoinedByString:@","];
                    self.atuid = [self.atuidArray  componentsJoinedByString:@","];
                    
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
}

/**
 *  光标位置删除
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
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
            if (self.topicStr.length==0) {
                 if (self.atunameArray.count>=inde) {
                     [self.atunameArray removeObjectAtIndex:inde];
                     [self.atuidArray removeObjectAtIndex:inde];
                 }
            }
            else
            {
                if (self.atunameArray.count>=inde) {
                    [self.atunameArray removeObjectAtIndex:inde];
                    [self.atuidArray removeObjectAtIndex:inde];
                }
            }
            if (self.atunameArray.count!=0) {
                self.atuname = [self.atunameArray componentsJoinedByString:@","];
            }
            if (self.atuidArray.count!=0) {
                 self.atuid = [self.atuidArray  componentsJoinedByString:@","];
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

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)configCollectionView:(UIView *)atView{
    
    _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textView.frame) + 10, 300, 21)];
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
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(6, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell22"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
          //[self.view endEditing:YES];
    }
}

-(void)changeFrame:(NSArray *)imageArray{
    
    if (imageArray.count <= 2) {
        _collectionView.frame = CGRectMake(10, 275, WIDTH - 20, _itemWH + 2 * _margin);
    }else if(imageArray.count <= 5 && imageArray.count > 2){
        _collectionView.frame = CGRectMake(10, 275, WIDTH - 20, 2 * _itemWH + 3 * _margin);
    }else if (imageArray.count <= 9 && imageArray.count > 5){
        _collectionView.frame = CGRectMake(10, 275, WIDTH - 20, 3 * _itemWH + 4 * _margin);
    }
    [self getDynamicHeight];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count == 9) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell22" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加图片"];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        cell.deleteBtn.hidden = YES;
    } else {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_selectedPhotos[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    }else{
        __weak typeof(self) weakSelf=self;
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:indexPath.row imagesBlock:^NSArray *{
            return weakSelf.selectedSyArray;
        }];
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.barItemTextColor = TextCOLOR;
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    
    imagePickerVc.cropRect = CGRectMake(0, (HEIGHT - WIDTH)/2, WIDTH, WIDTH);
    
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
                self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];
            
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
                        if (/* DISABLES CODE */ (NO)) { // 不允许裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                            imagePicker.needCircleCrop = NO;
                            //                            imagePicker.circleCropRadius = 100;
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
    
    NSArray *photos = @[image];
    [self thumbnaiWithImage:photos andAssets:nil];
   
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

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self thumbnaiWithImage:photos andAssets:assets];

}

//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _isSelectOriginalPhoto = NO;
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,dynamicPicUploadUrl] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSData *imageData = UIImageJPEGRepresentation(imageArray[0], 0.1);
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"retcode"] intValue]==2000) {
            [_selectedPhotos addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"slimg"]]];
            [self.selectedSyArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"syimg"]]];
            [self.addArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"slimg"]]];
            [self.addArray addObject:[NSString stringWithFormat:@"%@%@",PICHEADURL,responseObject[@"data"][@"syimg"]]];
            
            [self changeFrame:_selectedPhotos];
            [self.collectionView reloadData];
        }
        else
        {
             [MBProgressHUD showMessage:@"上传失败,请稍后再试"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"上传失败,请稍后再试"];
    }];
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    [_deleteArray addObject:_selectedPhotos[sender.tag]];
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    
    if (_selectedSyArray.count > 0) {
        
        [_deleteArray addObject:_selectedSyArray[sender.tag]];
        [_selectedSyArray removeObjectAtIndex:sender.tag];
    }
    [self changeFrame:_selectedPhotos];
    [_collectionView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    if (@available(iOS 11.0, *)) {
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
    }else{
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [areaButton addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)buttonOnClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出编辑?"    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        if (_addArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [self deleteAddPicWith:_addArray[0] andSign:0];
        }
    }];
    if (PHONEVERSION.doubleValue >= 8.3) {
        [action setValue:MainColor forKey:@"_titleTextColor"];
        [setAction setValue:MainColor forKey:@"_titleTextColor"];
    }
    [alert addAction:action];
    [alert addAction:setAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 选择图片后不修改图片,删除新上传的图片
 */
-(void)deleteAddPicWith:(NSString *)filename andSign:(int)i{

    NSDictionary *parameters = @{@"filename":filename};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            if (i + 1 == _addArray.count) {
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self deleteAddPicWith:_addArray[i + 1] andSign:i + 1];
            }
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/**
 * 更换或添加了照片,点击提交确认修改
 */
-(void)backButtonOnClick:(UIButton *)button{
    
    if (_textView.text.length == 0 && _pictureArray.count == 0) {
        
         [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"不能将全部内容都删除~"];
        
    }else{
        
        NSString *path;
        
        NSString *sypath;
        
        if ([[self getPicpathAndSypathWithArray:_pictureArray] isEqualToString:[self getPicpathAndSypathWithArray:_selectedPhotos]]) {
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            path = [self getPicpathAndSypathWithArray:_pictureArray];
            
            sypath = [self getPicpathAndSypathWithArray:_shuiyinArray];
            
            [self uploadpic:path andSypic:sypath];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            if (_deleteArray.count != 0) {
                
                [self deletePicUrl:_deleteArray[0] andSign:0];
                
            }else{
                
                path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                
                sypath = [self getPicpathAndSypathWithArray:_selectedSyArray];
                
                [self uploadpic:path andSypic:sypath];
            }
        }
    }
}

/**
 * 拼接编辑后的动态图片路径
 */

-(NSString *)getPicpathAndSypathWithArray:(NSMutableArray *)array{
    
    NSString *picPath = [NSString string];
    
    if (array.count == 0) {
        
        picPath = @"";
        
    }else{
        NSMutableArray *newArray = [NSMutableArray new];
//        NSString *changeSgr = [array firstObject];
//        if ([changeSgr containsString:@":888"]) {
//            for (int i =0; i<array.count; i++) {
//
//                NSString *strs = [array objectAtIndex:i];
//                NSString *str  = [strs stringByReplacingOccurrencesOfString:@":888"withString:@""];
//
//                [newArray addObject:str];
//            }
//        }
//        else
//        {
            newArray = array.mutableCopy;
//        }
        if (array.count == 1) {
            NSString *strs = [newArray firstObject];
            if([strs rangeOfString:HTTPPICHEADURL].location !=NSNotFound)
            {
                picPath = [newArray[0] componentsSeparatedByString:HTTPPICHEADURL][1];
            }
            else
            {
                picPath = [newArray[0] componentsSeparatedByString:PICHEADURL][1];
            }
        }else{
            for (int i = 0; i < array.count; i++) {
                if (i == 0) {
                    NSString *strs = [newArray firstObject];
                    if([strs rangeOfString:HTTPPICHEADURL].location !=NSNotFound)
                    {
                        picPath = [newArray[0] componentsSeparatedByString:HTTPPICHEADURL][1];
                    }
                    else
                    {
                       picPath = [newArray[0] componentsSeparatedByString:PICHEADURL][1];
                    }
                }else{
                    NSString *strs = [newArray objectAtIndex:i];
                    if([strs rangeOfString:HTTPPICHEADURL].location !=NSNotFound)
                    {
                         picPath = [NSString stringWithFormat:@"%@,%@",picPath,[newArray[i] componentsSeparatedByString:HTTPPICHEADURL][1]];
                    }
                    else
                    {
                         picPath = [NSString stringWithFormat:@"%@,%@",picPath,[newArray[i] componentsSeparatedByString:PICHEADURL][1]];
                    }
                }
            }
        }
    }
    return picPath;
}

/**
 * 删除编辑后的动态图片
 */

-(void)deletePicUrl:(NSString *)filename andSign:(int)i{
    
    NSDictionary *parameters = @{@"filename":filename};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:delPicture] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer == 2000) {
            if (i + 1 == _deleteArray.count) {
                NSString *path = [self getPicpathAndSypathWithArray:_selectedPhotos];
                NSString *sypath = [self getPicpathAndSypathWithArray:_selectedSyArray];
                [self uploadpic:path andSypic:sypath];
            }else{
                [self deletePicUrl:_deleteArray[i + 1] andSign:i + 1];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

/**
 * 上传编辑后的动态
 */
-(void)uploadpic:(NSString *)path andSypic:(NSString *)sypath{

    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Power/editDynamic"];
    NSString *content;
    
    if (self.topicStr.length==0) {
        if ([_oldContent isEqualToString:self.textView.text]) {
            content = _oldContent;
        }else{
            content = self.textView.text;
        }
    }
    else
    {
        content  = [self.textView.text substringFromIndex:self.topicStr.length];
    }
  
    NSLog(@"content---%@",content);
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":self.did,@"content":content?:@"",@"pic":path,@"sypic":sypath,@"tid":self.topicTid?:@"",@"atuid":self.atuid?:@"",@"atuname":self.atuname?:@""};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        
        if (integer != 2001) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑失败~"];
        }else{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"编辑动态成功" object:nil];
            if (self.block) {
                self.block(@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
         [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
