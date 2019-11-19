
//
//  LDswitchManager.m
//  ShengmoApp
//
//  Created by 王俊钢 on 2019/7/5.
//  Copyright © 2019 a. All rights reserved.
//

#import "LDswitchManager.h"
#import "FMDB.h"
#import "LDswitchModel.h"


@interface LDswitchManager()
@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,strong) NSString * dbPath;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation LDswitchManager

+ (instancetype)sharedClient
{
    static LDswitchManager *_sqlManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sqlManager = [[LDswitchManager alloc]init];
    });
    return _sqlManager;
}

/**
 建表
 */
-(void)firstchoose
{
    /** App判断第一次启动的方法 */
    NSString *key = @"isFirstDiscover";
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (!isFirst) {
        NSLog(@"是第一次启动");
        [self creatTable];
    } else {
        NSLog(@"不是第一次启动");
    }
}

/**
 建表
 */
-(void)creatTable
{
    //获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
    self.dbPath = fileName;
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_discoverData (id INTEGER PRIMARY KEY , nickname TEXT NOT NULL, imageUrl TEXT , uid TEXT , account TEXT , password TEXT ,token TEXT ,sex TEXT , sexual ,TEXT ,way TEXT , chatstatus TEXT);"];
        if (result){
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    };
    self.db=db;
}


/**
 插入数据

 @param model 数据模型
 */
-(void)insertInfowith:(LDswitchModel *)model
{
    BOOL isSuccess=[self.db open];
    if (!isSuccess) {
        NSLog(@"打开数据库失败");
    }
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    @try {
        NSString *sql = @"INSERT INTO t_discoverData (nickname,imageUrl,uid,account,password,token,sex,sexual,chatstatus,way) VALUES (?,?,?,?,?,?,?,?,?,?);";
        BOOL a = [self.db executeUpdate:sql,model.nickname,model.imageUrl,model.uid,model.account,model.password,model.token,model.sex,model.sexual,model.chatstatus,model.way];
        if (!a) {
            NSLog(@"插入失败1");
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [self.db rollback];
    }
    @finally {
        if (!isRollBack) {
            [self.db commit];
        }
    }
    NSLog(@"add-------%@",self.dbPath);
    [self.db close];
}


/**
 判断是否插入数据

 @return 是否插入数据
 */
-(BOOL)iscaninsert
{
    BOOL iscan = YES;
    NSMutableArray *arr = [self loaddata];
    if (arr.count>=5) {
        iscan = NO;
    }
    else
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
        
        FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
        if (![dataBase open]) {
            NSLog(@"打开数据库失败");
            
        }
        FMResultSet *resultSet = [dataBase executeQuery:@"select * from t_discoverData"];
        while ([resultSet next]) {
            
            NSString *newUid = [resultSet stringForColumn:@"uid"];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] isEqualToString:newUid]) {
                //存在
                iscan = NO;
                [MBProgressHUD showMessage:@"该账号已添加"];
            }
            else
            {
                //不存在
                iscan = YES;
            }
            
        }
        [dataBase close];
    }
    return iscan;
}

/**
 清空数据库内容
 */
-(void)deletefromData
{
    
    BOOL result = [self.db executeUpdate:@"DELETE FROM t_discoverData"];
    if (result) {
        NSLog(@"delete from 't_student' success");
        
    } else {
        
    }
    [self.db close];
    
}

-(void)deletefromuid:(NSString *)uid
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        NSLog(@"打开数据库失败");
        
    }
    NSString *sql = @"DELETE FROM t_discoverData WHERE uid = ?";
    BOOL result = [dataBase executeUpdate:sql,uid];
    if (result) {
        NSLog(@"delete from 'uid' success");
        
    } else {

    }
    [dataBase close];
}


// 更新数据 更新名字
- (void)updateDataWithuserId:(NSString *)uid andnickname:(NSString *)nickname {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = @"UPDATE t_discoverData SET nickname = ? WHERE  uid = ?";
        BOOL res = [dataBase executeUpdate:sql, nickname, uid];
        if (!res) {
            NSLog(@"数据修改失败");
        }
        [dataBase close];
    }
}

//更新数据 更新头像
- (void)updateDataWithuserId:(NSString *)uid andimageUrl:(NSString *)imageUrl {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = @"UPDATE t_discoverData SET imageUrl = ? WHERE  uid = ?";
        BOOL res = [dataBase executeUpdate:sql, imageUrl, uid];
        if (!res) {
            NSLog(@"数据修改失败");
        }
        [dataBase close];
    }
}

//更新数据 更新密码

- (void)updateDataWithuserId:(NSString *)uid andpassword:(NSString *)password {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if ([dataBase open]) {
        NSString *sql = @"UPDATE t_discoverData SET password = ? WHERE  uid = ?";
        BOOL res = [dataBase executeUpdate:sql, password, uid];
        if (!res) {
            NSLog(@"数据修改失败");
        }
        [dataBase close];
    }
}

/**
 读取数据
 
 @return 读取表中数据
 */
-(NSMutableArray *)loaddata
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"userData.sqlite"];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        NSLog(@"打开数据库失败");
        return [NSMutableArray new];
    }
    
    FMResultSet *resultSet = [dataBase executeQuery:@"select * from t_discoverData"];
    self.dataArray = [NSMutableArray array];
    while ([resultSet next]) {
        
        LDswitchModel *model = [LDswitchModel new];
        model.uid = [resultSet stringForColumn:@"uid"];
        model.nickname = [resultSet stringForColumn:@"nickname"];
        model.imageUrl = [resultSet stringForColumn:@"imageUrl"];
        model.account = [resultSet stringForColumn:@"account"];
        model.password = [resultSet stringForColumn:@"password"];
        model.token = [resultSet stringForColumn:@"token"];
        model.sex = [resultSet stringForColumn:@"sex"];
        model.sexual = [resultSet stringForColumn:@"sexual"];
        model.chatstatus = [resultSet stringForColumn:@"chatstatus"];
        model.way = [resultSet stringForColumn:@"way"];
        [self.dataArray addObject:model];
    }
    [dataBase close];
    return self.dataArray;
}

/**
 * 判断是否是会员
 */
-(void)getVipStatusData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,getUserPowerInfoUrl];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        
        if (integer == 2000) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"vip"]] forKey:@"vip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"svip"]] forKey:@"svip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"is_volunteer"]] forKey:@"is_volunteer"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"is_admin"]] forKey:@"is_admin"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"realname"]] forKey:@"realname"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"bkvip"]] forKey:@"bkvip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObj[@"data"][@"blvip"]] forKey:@"blvip"];

        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"vip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"svip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_volunteer"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_admin"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"realname"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"bkvip"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"blvip"];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}
@end
