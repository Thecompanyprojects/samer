//
//  WangConst.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/6/30.
//  Copyright © 2019 a. All rights reserved.
//

#import "WangConst.h"
//聊天室id
NSString * const roomidStr = @"10001";

//lat
NSString * const latitude = @"latitude";

//lng
NSString * const longitude = @"longitude";

//注册
NSString * const registernewrdUrl = @"Api/Users/registernewrd";

//发起聊天
NSString  * const getOpenChatRestrictAndInfoUrl = @"Api/Restrict/getOpenChatRestrictAndInfo";

//svip修改骚扰情况
NSString * const setVipSecretSitUrl = @"Api/users/setVipSecretSit";

//svip获取骚扰情况
NSString * const getVipSecretSitUrl = @"Api/users/getVipSecretSit";

//获取动态列表
NSString * const getDynamicListNewFiveUrl = @"Api/Dynamic/getDynamicListLatestFive350";

//获取用户列表
NSString * const userListNewthUrl = @"Api/index/userListNewth340";

//获取昵称历史列表
NSString * const getEditnicknameListUrl = @"Api/Users/getEditnicknameList";

//修改隐私设置
NSString * const setSecretSitUrl = @"Api/users/setSecretSit";

//获取隐私设置
NSString * const getSecretSitUrl = @"Api/users/getSecretSit";

//查看用户是否设置密码
NSString * const judgePhotoPwdUrl = @"Api/users/judgePhotoPwd";

//获取消息邮票信息
NSString * const getStampPageInfoUrl = @"Api/Restrict/getStampPageInfo";

//邮票购买验证
NSString * const stamp_ioshooks = @"Api/Ping/stamp_ioshooks";

//推顶卡购买验证
NSString * const topcard_ioshooks = @"Api/Ping/topcard_ioshooks";

//使用推顶卡-推顶动态
NSString * const useTopcard = @"Api/power/useTopcard";

//获取推顶卡信息
NSString * const getTopcardPaymentRs = @"Api/Controller/getTopcardPaymentRs";

//推顶卡记录查询
NSString * const getTopcardUsedRs = @"Api/users/getTopcardUsedRs";

//推顶卡余额
NSString * const getTopcardPageInfo = @"Api/users/getTopcardPageInfo";

//推顶卡购买记录
NSString * const buyTopcardPaymentRs = @"Api/users/getTopcardPaymentRs";

//点赞记录
NSString * const getLaudListNew = @"Api/Dynamic/getLaudListNew";

//评论记录
NSString * const getCommentListNew = @"Api/Dynamic/getCommentListNew";

//礼物记录
NSString * const getRewardListNew = @"Api/Dynamic/getRewardListNew";

//动态点赞
NSString * const laudDynamicNewrd = @"Api/Dynamic/laudDynamicNewrd";

//修改密码相册密码
NSString * const editPhotoPwd = @"Api/users/editPhotoPwd";

//设置备注
NSString * const markName = @"Api/users/markName";

//管理员备注
NSString * const editAdminmrak = @"Api/Power/editAdminmrak";

//关注用户
NSString * const setfollowOne = @"Api/friend/followOneBox";

//取消关注用户
NSString * const setoverfollow = @"Api/friend/overfollow";

//删除评论
NSString * const delComment = @"Api/Dynamic/delComment";

//充值魔豆兑换礼物魔豆
NSString * const changeexBeans = @"Api/Ping/exBeans";

//设置描述
NSString * const lmarkName = @"Api/users/lmarkName";

//大喇叭  推顶信息
NSString * const getTopcardUsedLb = @"Api/Users/getTopcardUsedLb";

//修改用户资料
NSString * const editInfo = @"Api/Users/editInfo";

//删除图片
NSString * const delPicture = @"Api/Api/delPicture";

//判断是否是会员
NSString * const getUserPowerInfoUrl = @"Api/Other/getUserPowerInfo";

//上传实时位置
NSString * const setLogintimeAndLocationUrl = @"Api/Other/setLogintimeAndLocation";

//获取礼物信息
NSString * const getMyPresentUrl = @"Api/Users/getMyPresent";

//获取魔豆数量
NSString * const getmywalletUrl = @"Api/Users/getmywallet";

//获取动态消息数量
NSString * const getUnreadNumUrl = @"Api/Dynamic/getUnreadNum";

//动态信息 评论列表
NSString * const getCommentedListUrl = @"Api/Dynamic/getCommentedList";

//单聊发红包
NSString * const giveRedbagUrl = @"Api/Ping/giveRedbag";

//单聊收红包
NSString * const takeRedbagUrl = @"Api/Ping/takeRedbag";

//搜索用户
NSString * const searchUserNewthUrl = @"Api/index/searchUserNewth340";

//清空动态信息数量
NSString * const clearUnreadNumAllUrl = @"api/dynamic/clearUnreadNumAll";

//群聊发放收费礼物
NSString * const RewardOneUrl = @"Api/friend/RewardOne";

//群聊发放免费系统礼物
NSString * const RewardOneBasicG = @"Api/friend/RewardOneBasicG";

//获取管理员备注信息
NSString * const getadminmarkUrl = @"/Api/Power/adminmark";

//获取个人信息
NSString * const getUserInfoUrl = @"Api/friend/getUserInfo340";

//身份证认证
NSString * const setrealidcardUrl = @"Api/Other/setrealidcard";

//获取身份证信息
NSString * const getrealidstateUrl = @"Api/Other/getrealidstate";

//金魔豆兑换邮票
NSString * const  stamp_baansUrl = @"Api/Ping/stamp_baans";

//金魔豆兑换推顶卡
NSString * const  topcard_baansUrl = @"Api/Ping/topcard_baans_android";

//金魔豆兑换VIP
NSString * const vip_beansUrl = @"Api/Ping/vip_beans";

//金魔豆兑换SVIP
NSString * const svip_beansUrl = @"Api/Ping/svip_beans";

//动态详情
NSString * const getDynamicdetailFiveUrl = @"Api/Dynamic/getDynamicdetailNewFive350";

//大喇叭消息
NSString * const getPresentMsgUrl = @"api/dynamic/getPresentMsg";

//各种小红点数量
NSString * const getRedDutNumUrl = @"Api/other/getRedDutNewNum350";

//动态上传图片
NSString * const dynamicPicUploadUrl = @"Api/Api/dynamicPicUpload350";

//邮票代理
NSString * const useStampToChatNewUrl = @"Api/Restrict/useStampToChatNew";

//获取广告信息
NSString * const getSlideMoreUrl = @"Api/Other/getSlideMore";

//签到
NSString * const getSignTimesInWeeksUrl = @"Api/Draw/getSignTimesInWeeks";

//第三方登录
NSString * const charge_openidUrl = @"api/users/charge_openid";

//更多新闻公告
NSString * const getBasicNewsListUrl = @"Api/Index/getBasicNewsList";

//更多问题资讯
NSString * const getQuestionsListUrl = @"Api/Index/getSamerNewsList";

//第三方切换账号
NSString * const login_thirdUrl = @"Api/Users/login_third";

//我的收藏
NSString * const getCollectDynamicListUrl = @"api/dynamic/getCollectDynamicList";

//获取绑定状态
NSString * const getBindingStateUrl = @"Api/Users/getBindingState";

//绑定邮箱
NSString * const bindingEmailUrl = @"Api/Users/bindingEmail";

//获取验证码
NSString * const sendMailCode_regUrl = @"api/api/sendMailCode_reg";

//第三方绑定
NSString * const bindingOtherUrl = @"Api/Users/bindingOther";

//解除第三方绑定
NSString * const removeOtherUrl = @"Api/Users/removeOther";

//修改密码
NSString * const editPwdUrl = @"Api/Users/editPwd";

//意见反馈
NSString * const suggestUrl = @"Api/Other/suggest";

//判断是否可以发布，评论
NSString * const judgeDynamicNewrdUrl =@"Api/Dynamic/judgeDynamicNewrd";

//发布的动态  顶部消息
NSString * const getDynamicAndTopicCountUrl = @"api/friend/getDynamicAndTopicCount";

//参与的评论  消息数据
NSString * const getCommentedListOnUserInfoUrl = @"api/dynamic/getCommentedListOnUserInfo";

//群发红包
NSString * const qunGiveRedbagUrl = @"api/Ping/qunGiveRedbag";

//群领红包
NSString * const qunGetRedbagUrl = @"api/Ping/qunGetRedbag";

//群红包列表
NSString * const getQunRedbagListUrl = @"api/Ping/getQunRedbagList";

//群红包判断是否领取过
NSString * const yetRedbagUrl = @"api/ping/yetRedbag";

//获取用户头像姓名
NSString * const getHeadAndNicknameUrl = @"Api/Other/getHeadAndNickname";

//发布动态
NSString * const sendDynamicUrl = @"Api/Dynamic/sendDynamic";

//@好友列表
NSString * const getatlisturl = @"Api/Friend/Getatlist";

//聊天室成员列表
NSString * const chatroomUserlistUrl = @"api/power/chatroomUserlist";

//判断在聊天室中是否是管理员
NSString * const chatroomUserinfoUrl = @"api/power/chatroomUserinfo";

//聊天室踢出
NSString * const chatroomUserBlockAction =@"api/power/chatroomUserBlockAction";

//聊天室禁言
NSString * const chatroomUserGagAction = @"api/power/chatroomUserGagAction";

//关于隐身状态
NSString * const placeIntercalateUrl = @"api/users/placeIntercalate";

//访客记录
NSString * const getReadListUrl = @"Api/friend/getReadList";

//写入访客记录
NSString * const writeVisitRecordUrl = @"api/friend/writeVisitRecord";

//获取我的信息
NSString * const getmineinfoUrl =  @"Api/users/getmineinfo";

//首次注册女用户权限判断
NSString * const getGirlStateUrl = @"Api/users/getGirlState";

//标记 取消标记
NSString * const setDynamicAuditMarkUrl = @"Api/dynamic/setDynamicAuditMark";

//悄悄关注
NSString * const followOneBoxQuietUrl = @"api/friend/followOneBoxQuiet";

//取消悄悄关注
NSString * const overfollowquietUrl = @"api/friend/overfollowquiet";

//获取悄悄关注列表
NSString * const getFollowListQueitUrl = @"api/friend/getFollowListQueit";

//悄悄关注人数
NSString * const getFollowCountQueitUrl = @"Api/friend/getFollowCountQueit";

//设置全隐身
NSString * const hideStateSwitchUrl = @"Api/users/hideStateSwitch";

//群组成员
NSString * const getGroupMemberUrl = @"Api/friend/getGroupMember";

//个人主页admin显示
NSString * const detailMobileUrl = @"Api/users/detailMobile";

//评论动态
NSString * const sendCommentNewredUrl = @"Api/Dynamic/sendCommentNewred";

//编辑动态  获取详情
NSString * const getDynamicdetailFiveEditUrl = @"Api/Dynamic/getDynamicdetailNewFiveEdit350";

//清理超过7天未登陆用户
NSString * const shotOffmoreUrl = @"Api/friend/shotOffmore";

//动态大喇叭红点数字
NSString * const getBigPresentNumUrl = @"api/dynamic/getBigPresentNum350";

//判断是否开启聊天室
NSString * const chatroomOpenOrCloseUrl = @"api/power/chatroomOpenOrClose";

//上麦操作
NSString * const chatroomUpMicrophoneUrl = @"api/power/chatroomUpMicrophone";

//下麦操作
NSString * const chatroomDownMicrophoneUrl = @"api/power/chatroomDownMicrophone";

//获取好友  关注
NSString * const newgetFollewingListUrl = @"Api/friend/getFollewingList350";

//群组消息
NSString * const getGroupMsgUrl = @"Api/friend/getGroupMsg350";

//添加分组
NSString * const addfriendgroupUrl = @"api/friendgroup/addfriendgroup";

//获取分组
NSString * const getfriendgrouplistUrl = @"api/friendgroup/friendgrouplist";

//分组排序
NSString * const friendgroupsortUrl = @"api/friendgroup/friendgroupsort";

//删除分组
NSString * const delfriendgroupUrl = @"api/friendgroup/delfriendgroup";

//修改分组名称
NSString * const updfriendgroupUrl = @"api/friendgroup/updfriendgroup";

//添加用户进分组
NSString * const setfgusersUrl =  @"api/friendgroup/setfgusers";

//批量添加用户进分组
NSString * const setfgsusersUrl =  @"api/friendgroup/setfgsusers";

//将用户移除分组
NSString * const delfgusersUrl = @"api/friendgroup/delfgusers";

//获取分组内好友列表
NSString * const getgfuserslistUrl = @"api/friendgroup/getgfuserslist";

//公益头条
NSString * const topnewUrl = @"api/index/topnew";

//话题列表
NSString * const getTopicListUrl = @"api/dynamic/getTopicList";

//获取聊吧信息
NSString * const getChatInfoUrl = @"api/power/getChatInfo";

//修改群名称
NSString * const editGroupCardNameUrl = @"Api/friend/editGroupCardName";

//排麦列表
NSString * const getChatListMicUrl = @"api/power/getChatListMic";

//修改聊天室连麦人数
NSString * const editChatMicNumUrl = @"api/power/editChatMicNum";
@implementation WangConst

@end
