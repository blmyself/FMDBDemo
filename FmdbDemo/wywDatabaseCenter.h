//
//  wywDatabaseCenter.h
//  FmdbDemo
//
//  Created by BL on 13-4-28.
//  Copyright (c) 2013年 bl. All rights reserved.
//

/*数据库单例封装*/

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface wywDatabaseCenter : NSObject

+(wywDatabaseCenter *)sharedDatabaseCenter;
-(void)initDB;
-(FMDatabase *)getDBInstance;

//Sqlite CRUD Methods
-(BOOL)insertUserWithUserName:(NSString *)userName andPwd:(NSString *)pwd;
-(void)multithreadInsertUsers;
-(NSMutableArray *)fetchAllUsers;
-(BOOL)deleteAllUsers;
@end
