//
//  LHRichMessageContent.m
//  RongIMDemo
//
//  Created by Bryan Yuan on 12/13/16.
//  Copyright © 2016 Bryan Yuan. All rights reserved.
//

#import "XYRichMessageContent.h"

@implementation XYRichMessageContent

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    XYRichMessageContent *msg = [[XYRichMessageContent alloc] init];

    NSString *imageName = dict[@"imageName"];
    if (imageName) {
        msg.imageName = imageName;
    }
    NSString *number = dict[@"number"];
    if (number) {
        msg.number = number;
    }

    return msg;
}

#pragma mark - RCMessageCoding

/*!
 将消息内容序列化，编码成为可传输的json数据
 
 @discussion
 消息内容通过此方法，将消息中的所有数据，编码成为json数据，返回的json数据将用于网络传输。
 */
- (NSData *)encode
{
    NSError *err;

    NSDictionary *dict = @{@"number":self.number,@"imageName":self.imageName};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        NSLog(@"encode error %@", err);
    }
    return jsonData;
}

/*!
 将json数据的内容反序列化，解码生成可用的消息内容
 
 @param data    消息中的原始json数据
 
 @discussion
 网络传输的json数据，会通过此方法解码，获取消息内容中的所有数据，生成有效的消息内容。
 */
- (void)decodeWithData:(NSData *)data
{
    NSError *err;
    //NSArray<NSString *> *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if (err) {
        NSLog(@"encode error %@", err);
    }
    if ([dict isKindOfClass:NSArray.class]) {
        return;
    }
//    NSArray<NSString *> *array = dict[@"imgArray"];
//    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
//    for (NSString *base64Str in array) {
//        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        UIImage *img = [UIImage imageWithData:data];
//        if (!img) {
//            img = [[UIImage alloc] init];
//        }
//        [mutableArr addObject:img];
//    }
//    self.imgArray = mutableArr;
    self.imageName = dict[@"imageName"];
    NSString *number = dict[@"number"];
    self.number = number;
//    NSNumber *ts = dict[@"timeStamp"];
//    self.dateSent = [NSDate dateWithTimeIntervalSince1970:ts.doubleValue];
}

/*!
 返回消息的类型名
 
 @return 消息的类型名
 
 @discussion 您定义的消息类型名，需要在各个平台上保持一致，以保证消息互通。
 
 @warning 请勿使用@"RC:"开头的类型名，以免和SDK默认的消息名称冲突
 */
+ (NSString *)getObjectName
{
    return @"ec:phoneinfo";
}

#pragma mark - RCMessagePersistentCompatible

/*!
 返回消息的存储策略
 
 @return 消息的存储策略
 
 @discussion 指明此消息类型在本地是否存储、是否计入未读消息数。
 */
+ (RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISCOUNTED;
}

#pragma mark - RCMessageContentView

/*!
 返回在会话列表和本地通知中显示的消息内容摘要
 
 @return 会话列表和本地通知中显示的消息内容摘要
 
 @discussion
 如果您使用IMKit，当会话的最后一条消息为自定义消息时，需要通过此方法获取在会话列表展现的内容摘要；
 当App在后台收到消息时，需要通过此方法获取在本地通知中展现的内容摘要。
 */
- (NSString *)conversationDigest
{
    return [NSString stringWithFormat:@"%@%@%@",self.imageName,@" × ",self.number];
    
}

@end
