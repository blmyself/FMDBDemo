//
//  wywDatabaseCenter.m
//  FmdbDemo
//
//  Created by BL on 13-4-28.
//  Copyright (c) 2013年 bl. All rights reserved.
//

#import "wywDatabaseCenter.h"
#import "FMDatabaseQueue.h"

#define DB_NAME @"db.sqlite"
#define DB_FILE_PATH [PATH_OF_DOCUMENT stringByAppendingPathComponent:DB_NAME]

@implementation wywDatabaseCenter

+(wywDatabaseCenter *)sharedDatabaseCenter{
    static wywDatabaseCenter *sharedDatabaseCenterInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatabaseCenterInstance = [[self alloc]init];
    });
    
    return sharedDatabaseCenterInstance;
}

#pragma mark - 初始化数据库
-(void)initDB{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:DB_FILE_PATH] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:DB_FILE_PATH];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                debugLog(@"error when creating db table");
            } else {
                debugLog(@"succ to creating db table");
            }
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }
}

#pragma mark - 获取数据库对象
-(FMDatabase *)getDBInstance{
    //初始化数据库
    [self initDB];
    
    //创建数据库
    FMDatabase *db = [[FMDatabase alloc]initWithPath:DB_FILE_PATH];
    if (![db open]) {
        NSLog(@"数据库未能创建/打开");
        return nil;
    }
    return db;
}

#pragma mark - 插入用户
-(BOOL)insertUserWithUserName:(NSString *)userName andPwd:(NSString *)pwd{
    FMDatabase * db = [self getDBInstance];
    BOOL res  = NO;
    if (db) {
        NSString * sql = @"insert into user (name, password) values(?, ?)";
        res = [db executeUpdate:sql, userName, pwd];
        if (!res) {
            debugLog(@"error to insert db data");
        } else {
            debugLog(@"succ to insert db data");
        }
        [db close];
    }
    return res;
}

#pragma mark - 多线程插入用户
-(void)multithreadInsertUsers{
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:DB_FILE_PATH];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue111 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 100; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"queue222 %d", i];
                BOOL res = [db executeUpdate:sql, name, @"boy"];
                if (!res) {
                    debugLog(@"error to add db data: %@", name);
                } else {
                    debugLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
}

#pragma mark - 查询用户
-(NSMutableArray *)fetchAllUsers{
    FMDatabase * db = [self getDBInstance];
    NSMutableArray *result  = [NSMutableArray array];
    if (db) {
        NSString * sql = @"select * from user";
       FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int userId  = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * pwd =  [rs stringForColumn:@"password"];
            NSDictionary *rsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"id",name,@"name",pwd,@"password", nil];
            [result addObject:rsDic];
            debugLog(@"user id = %d, name = %@, pass = %@", userId, name, pwd);
        }
        [rs close];
        [db close];
    }
    return result;
}

#pragma mark - 删除用户
-(BOOL)deleteAllUsers{
    FMDatabase * db = [self getDBInstance];
    BOOL res = NO;
    if (db) {
        NSString * sql = @"delete from user";
        res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete db data");
        } else {
            debugLog(@"succ to delete db data");
        }
        [db close];
    }
    return res;
}

@end
