//
//  RCDGroupAnnouncementViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/14.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDGroupAnnouncementViewController.h"
#import "UIColor+RCColor.h"
#import "MBProgressHUD.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDGroupAnnouncementViewController ()

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation RCDGroupAnnouncementViewController

- (instancetype)init {
    
  self = [super init];
    
  if (self) {
      
    self.AnnouncementContent = [[UITextViewAndPlaceholder alloc] initWithFrame:CGRectZero];
    self.AnnouncementContent.delegate = self;
    self.AnnouncementContent.font = [UIFont systemFontOfSize:16.f];
    self.AnnouncementContent.textColor = [UIColor colorWithHexString:@"000000" alpha:1.0];
    self.AnnouncementContent.myPlaceholder = @"请编辑内容";
    self.AnnouncementContent.frame = CGRectMake(5, 8, WIDTH - 10, HEIGHT/2 - 100);
 
    [self.view addSubview:self.AnnouncementContent];
    
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.rightBtn =
  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
  self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 50, 34)];
  self.rightLabel.text = @"完成";
  [self.rightBtn addSubview:self.rightLabel];
  [self.rightBtn addTarget:self
                 action:@selector(clickRightBtn:)
       forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightButton =
  [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn ];
  [self.rightLabel setTextColor:[UIColor darkGrayColor]];
  self.rightBtn .userInteractionEnabled = NO;
  self.navigationItem.rightBarButtonItem = rightButton;
  
  self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5" alpha:1];
  
  self.navigationItem.title = @"@所有人";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) navigationButtonIsCanClick:(BOOL)isCanClick
{
  if (isCanClick == NO) {
      
    self.rightBtn.userInteractionEnabled = NO;
      
  }else{
      
    self.rightBtn.userInteractionEnabled = YES;
  }
}

-(void)clickRightBtn:(id)sender
{
  [self navigationButtonIsCanClick:NO];
  BOOL isEmpty = [self isEmpty:self.AnnouncementContent.text];
  if (isEmpty == YES) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:@"该公告会通知全部群成员，是否发布？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"发布",nil];
  alert.tag = 102;
  [alert show];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
  NSInteger number = [textView.text length];
    
  if (number == 0) {
      
    self.rightBtn.userInteractionEnabled = NO;
      
    [self.rightLabel setTextColor:[UIColor darkGrayColor]];
  }
    
  if (number > 0) {
      
    self.rightBtn.userInteractionEnabled = YES;
      
    self.rightLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    
}
  if (number > 500) {
      
    textView.text = [textView.text substringToIndex:500];
      
  }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
  [self navigationButtonIsCanClick:YES];
    
  switch (alertView.tag) {
    case 101:
    {
      switch (buttonIndex) {
        case 1:
        {
          _AnnouncementContent.editable = NO;
          dispatch_after(
                         dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                             [self.navigationController popViewControllerAnimated:YES];
                           });
        }
          break;
          
        default:
          break;
      }
    }
      break;
      
      case 102:
    {
      switch (buttonIndex) {
        case 1:
        {
          self.AnnouncementContent.editable = NO;
          //发布中的时候显示转圈的进度
          [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//          self.hud.yOffset = -46.f;
//          self.hud.minSize = CGSizeMake(120, 120);
//          self.hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
//          self.hud.margin = 0;
//          [self.hud show:YES];
          //发布成功后，使用自定义图片
          NSString *txt = [NSString stringWithFormat: @"@所有人\n%@",self.AnnouncementContent.text];
          //去除收尾的空格
          txt = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
          //去除收尾的换行
          txt = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
          RCTextMessage *announcementMsg = [RCTextMessage messageWithContent:txt];
          announcementMsg.mentionedInfo = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_All userIdList:nil mentionedContent:nil];
          [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP
                                targetId:self.GroupId
                                 content:announcementMsg
                             pushContent:nil
                                pushData:nil
                                 success:^(long messageId) {
                                   dispatch_after(
                                                  dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                                        
                                                    dispatch_after(
                                                                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                                                                       
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    //显示成功的图片后返回
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                     });
                                                  });
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                   message:@"群公告发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                   [alert show];
                                 }];
          
        }
          break;
          
        default:
          break;
      }
    }
      break;
      
    default:
      break;
  }
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isEmpty:(NSString *) str {
  
  if (!str) {
      
    return YES;
      
  } else {
    //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
    NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    
    if ([trimedString length] == 0) {
        
      return YES;
        
    } else {
        
      return NO;
        
    }
  }
}

@end
