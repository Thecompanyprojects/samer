//
//  LDShareView.m
//  ShengmoApp
//
//  Created by 爱无界 on 2017/6/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDShareView.h"
#import "AppDelegate.h"

@interface LDShareView ()<TencentSessionDelegate>{
    
    TencentOAuth *_tencentOAuth;
}

//分享弹出视图
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,assign) BOOL share;//标记弹出框是否弹起 YES 是弹起 NO是不弹起
@property (nonatomic,copy) NSString *comeFrom;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *shareId;

@end

@implementation LDShareView

-(instancetype)init{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

//用户点击后弹出视图
-(void)controlViewShowAndHide:(UIViewController *)viewController{

    if (viewController != nil) {
        
        [viewController.tabBarController.view addSubview:self];
        
    }
    
    self.share = !self.share;
    
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    
    if (self.share) {
        
        self.frame = CGRectMake(0,0, WIDTH, HEIGHT);
        
    }else{
        
        self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    }
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
    
}

//分享视图#pragma mark --- 分享弹出视图
- (UIView *)createBottomView:(NSString *)come andNickName:(NSString *)name andPicture:(NSString *)pic andId:(NSString *)shareId{
    
    _comeFrom = come;
    _name = name;
    _pic = pic;
    _shareId = shareId;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtomView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.bottomView addGestureRecognizer:tap];
    
    [self addSubview:self.bottomView];
    
    /* 创建视图，显示到bottom的底部 */
    
    NSArray *imgArray = @[@"微博分享",@"微信分享",@"朋友圈分享",@"QQ分享",@"QQ空间分享"];
    
    CGFloat viewY;
    
    if (ISIPHONEX) {
        
        viewY = HEIGHT - 1.38 * 50 - 60 - 34;
        
    }else{
        
        viewY = HEIGHT - 1.38 * 50 - 60;
    }
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, viewY, WIDTH, 1.38 * 50 + 60)];
    
    view.backgroundColor =[UIColor whiteColor];
    
    [self.bottomView addSubview:view];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, WIDTH - 30, 30)];
    
    [view addSubview:labelTitle];
    
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.textColor = [UIColor lightGrayColor];
    labelTitle.text = @"分享到";
    labelTitle.textAlignment = NSTextAlignmentLeft;
    
    UIView *blackLineF = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.38 * 50 - 20, WIDTH, 1)];
    
    blackLineF.backgroundColor = [UIColor lightGrayColor];
    
    [view addSubview:blackLineF];
    
    for (int i = 0; i < imgArray.count; i++) {
        
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake( (WIDTH - 250)/6 + i *(WIDTH - 250)/6 + 50 * i, view.frame.size.height - 1.38 * 50 - 10, 50, 1.38 * 50)];
        
        btn.tag = 1000000 + i;
        
        [btn setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
    }
    
    return self;
}

//点击分享后跳入分享的界面
-(void)shareBtnAction:(UIButton *)sender{
    
    [self tapButtomView];
    
    if ([_comeFrom isEqualToString:@"Mine"]) {
        
        NSString *shareUrl = [PICHEADURL stringByAppendingString:@"share.png"];
        [self createShare:sender andTitle:@"Samer" andDescription:@"Samer——专业亚文化交友APP诞生了！刚上线就很火爆~" andPicImage:[UIImage imageNamed:@"圣魔logo"] andWebUrl:@"www.shengmo.cn" andImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareUrl]] andImageUrl:[NSURL URLWithString:shareUrl]];
        
    }else if([_comeFrom isEqualToString:@"Dynamic"]){
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/dynamic/did/",_shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"%@ 在Samer发布了精彩的动态",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
        
    }else if ([_comeFrom isEqualToString:@"Group"]){
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/group/did/",_shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"邀请你加入群组: %@,快快加入吧~",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
    }else if([_comeFrom isEqualToString:@"Infomation"]){
        NSString *url = [NSString stringWithFormat:@"%@%@%@",PICHEADURL,@"Home/Share/user/did/",_shareId];
        [self createShare:sender andTitle:@"分享了一个链接" andDescription:[NSString stringWithFormat:@"%@ 的个人主页，快来Samer关注Ta~",_name] andPicImage:nil andWebUrl:[NSString stringWithFormat:@"%@",url] andImageData:[self compressPicture] andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pic]]];
    
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

//分享到相应的平台
-(void)createShare:(UIButton *)button andTitle:(NSString *)title andDescription:(NSString *)description andPicImage:(UIImage *)image andWebUrl:(NSString *)webUrl andImageData:(NSData *)imageData andImageUrl:(NSURL *)imageUrl{

    if ((button.tag - 1000000) == 0) {
        
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURI;
        authRequest.scope = @"all";
        
        WBMessageObject *message = [WBMessageObject message];
        //WBWebpageObject *webpage = [WBWebpageObject object];
        
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
        
        //        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
        
    }else if ((button.tag - 1000000)==1){//分享给微信好友
        
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
        
    }else if ((button.tag - 1000000) == 2){// 微信朋友圈
        
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
        
        
    }else if ((button.tag - 1000000) == 3){//qq 好友
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1109831381" andDelegate:self];
        
        NSString *url = webUrl;
        //分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description :description previewImageURL:imageUrl];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"%d",sent);
        
    }else if ((button.tag - 1000000) == 4){//qq空间
        
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

-(void)tapButtomView{
    
    self.share = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    //设置动画时长
    [UIView setAnimationDuration:0.0];
    
    self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
    
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
    
}


@end
