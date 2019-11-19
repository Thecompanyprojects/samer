//
//  YSActionSheetView.m
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import "YSActionSheetView.h"
#import "ShareTableViewCell.h"
#import "AppDelegate.h"
#import "LDSharefriendVC.h"
#import "ShareTableViewCell2.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SafeAreaHeight (([[UIScreen mainScreen] bounds].size.height-812)?0:34)

#define SPACE 10

@interface YSActionSheetView()<UITableViewDelegate,UITableViewDataSource,TencentSessionDelegate>{
    
    TencentOAuth *_tencentOAuth;
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, strong) NSMutableArray * buttonsArr;

@end

@implementation YSActionSheetView

-(instancetype)initNYSView
{
    if (self = [super init]) {
        
        [self craetUI];
    }
    return self;
    
}

- (void)craetUI {
    self.buttonsArr =[[NSMutableArray alloc]initWithCapacity:0];
    self.frame = [UIScreen mainScreen].bounds;
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:self.maskView];
    [ap.keyWindow addSubview:self.tableView];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .0;
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_maskView addGestureRecognizer:singleTap];
    }
    return _maskView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

#pragma mark TableViewDel

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (self.isTwo) {
            return 260;
        }
        else
        {
            return 140;
        }
        
        return 260;
    }
    else
    {
        return 44;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0)
    {
        if (self.isTwo) {
            ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top_Cell"];
            
            if (!cell)
            {
                cell=[[ShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top_Cell"];
            }
            cell.isTwo = self.isTwo;
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 10;
            
            [cell.shareBtn1 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn3 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn4 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn5 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn6 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn7 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.buttonsArr addObject:cell.shareBtn1];
            [self.buttonsArr addObject:cell.shareBtn2];
            [self.buttonsArr addObject:cell.shareBtn3];
            [self.buttonsArr addObject:cell.shareBtn4];
            [self.buttonsArr addObject:cell.shareBtn5];
            if (self.isTwo) {
                [self.buttonsArr addObject:cell.shareBtn6];
//                [self.buttonsArr addObject:cell.shareBtn7];
            }
            
            [self.buttonsArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:1.1 delay:0.05 * (idx +1) usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    obj.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
            }];
            return cell;
        }
        else
        {
            ShareTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"top_Cell"];
            
            if (!cell)
            {
                cell=[[ShareTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top_Cell"];
            }

            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 10;
            
            [cell.shareBtn1 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn3 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn4 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn5 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          
            
            [self.buttonsArr addObject:cell.shareBtn1];
            [self.buttonsArr addObject:cell.shareBtn2];
            [self.buttonsArr addObject:cell.shareBtn3];
            [self.buttonsArr addObject:cell.shareBtn4];
            [self.buttonsArr addObject:cell.shareBtn5];

            [self.buttonsArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:1.1 delay:0.05 * (idx +1) usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    obj.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
            }];
            return cell;
        }
        return [UITableViewCell new];
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottom_Cell"];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottom_Cell"];
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"取消";
        cell.layer.cornerRadius = 10;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return SPACE;
    }
    else
    {
        return 15;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    CGFloat selfHeight ;
    if (section==0)
    {
        selfHeight = SPACE ;
    }
    else
    {
        selfHeight = 15 ;
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, selfHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}


-(void)shareBtnClick:(YSActionSheetButton *)btn
{
    switch (btn.tag) {
        case 0:
            [self shareBtnAction:btn];
            break;
        case 1:
             [self shareBtnAction:btn];
            break;
            
        case 2:
             [self shareBtnAction:btn];
            break;
            
        case 3:
             [self shareBtnAction:btn];
            break;
            
        case 4:
             [self shareBtnAction:btn];
            break;
            
        case 5:
        {
            [self.delegate customActionSheetButtonClick:btn];
        }
            break;

            
        default:
            break;
    }
    [self dismiss];
}


//点击分享后跳入分享的界面
-(void)shareBtnAction:(UIButton *)sender{

    if ([_comeFrom isEqualToString:@"Mine"]) {
        
        NSString *shareUrl = [PICHEADURL stringByAppendingString:@"share.png"];
        self.shareId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        [self createShare:sender andTitle:@"Samer" andDescription:@"Samer——专业亚文化交友APP诞生了！刚上线就很火爆~" andPicImage:[UIImage imageNamed:@"圣魔logo"] andWebUrl:@"shengmo.cn" andImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareUrl]] andImageUrl:[NSURL URLWithString:shareUrl]];
        
    }else if([_comeFrom isEqualToString:@"Dynamic"]){
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/dynamic/did/",self.shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"%@ 在Samer发布了精彩的动态",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
        
    }else if ([_comeFrom isEqualToString:@"Group"]){
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/group/gid/",self.shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"邀请你加入群组: %@,快快加入吧~",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
        
    }else if([_comeFrom isEqualToString:@"Infomation"]){
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/user/uid/",self.shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"%@ 的个人主页，快来Samer关注Ta~",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
        
    }
}

//分享到相应的平台
-(void)createShare:(UIButton *)button andTitle:(NSString *)title andDescription:(NSString *)description andPicImage:(UIImage *)image andWebUrl:(NSString *)webUrl andImageData:(NSData *)imageData andImageUrl:(NSURL *)imageUrl{
    
    if ((button.tag) == 0) {
        
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURI;
        authRequest.scope = @"all";
        
        WBMessageObject *message = [WBMessageObject message];
        
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = imageData;
        
        if ([title isEqualToString:@"圣魔斯慕"]) {
            
            message.text = [NSString stringWithFormat:@"%@ http://%@", description,webUrl];
            
        }else{
            
            message.text = [NSString stringWithFormat:@"%@ %@", description,webUrl];
        }
        
        message.imageObject = imageObject;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
        
        request.userInfo = @{@"ShareMessageFrom":@"LDShareAppViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
        
    }else if ((button.tag)==1){//分享给微信好友
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        
        if (image == nil) {
            
            message.thumbData = imageData;
            
        }else{
            
            [message setThumbImage:image];
        }
        
        WXWebpageObject *webPageObject = [WXWebpageObject object];
        webPageObject.webpageUrl = webUrl;
        message.mediaObject = webPageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;//分享到好友会话
        [WXApi sendReq:req];
        
    }else if ((button.tag) == 2){// 微信朋友圈
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        if (image == nil) {
            
            message.thumbData = imageData;
            
        }else{
            
            [message setThumbImage:image];
        }
        WXWebpageObject *webPageObject = [WXWebpageObject object];
        webPageObject.webpageUrl = webUrl;
        message.mediaObject = webPageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        
        req.scene = WXSceneTimeline;//分享朋友圈
        [WXApi sendReq:req];
        
        
    }else if ((button.tag) == 3){//qq 好友
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1109831381" andDelegate:self];
        
        NSString *url = webUrl;
        //分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description :description previewImageURL:imageUrl];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"%d",sent);
        
    }else if ((button.tag) == 4){//qq空间
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1109831381" andDelegate:self];
        
        NSString *url = webUrl;
        //分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageURL:imageUrl];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        
        //        将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",sent);
    }
}

//判断图片是否大于32k,大于的话压缩
-(NSData *)compressPicture{
    NSData * reduceData;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
    CGFloat dataKBytes = data.length/1024.0;
    if (dataKBytes > 32) {
        UIImage *image = [UIImage imageWithData:data];
        UIImage *scaleImage = [self scaleToSize:image size:CGSizeMake(100, 100)];
        data = UIImageJPEGRepresentation(scaleImage, 1.0);
        reduceData = data;
    }else{
        reduceData = data;
    }
    return reduceData;
}

//缩小图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)show {
    if (self.isTwo) {
        _tableView.frame = CGRectMake(SPACE, Screen_height, Screen_Width - (SPACE * 2), 260+44 +(SPACE * 2));
    }
    else
    {
        _tableView.frame = CGRectMake(SPACE, Screen_height, Screen_Width - (SPACE * 2), 140+44 +(SPACE * 2));
    }
    [UIView animateWithDuration:.35 animations:^{
        _maskView.alpha = .3;
        CGRect rect = _tableView.frame;
        rect.origin.y -= _tableView.bounds.size.height;
        //适配iPhone X
        rect.origin.y -= SafeAreaHeight;
        _tableView.frame = rect;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.15 animations:^{
        
        _maskView.alpha = .0;
        
        CGRect rect = _tableView.frame;
        rect.origin.y += _tableView.bounds.size.height;
        
        //适配iPhone X
        rect.origin.y += SafeAreaHeight;
        
        _tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

-(void)handleSingleTap
{
    [self dismiss];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC =appRootVC;
        while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
