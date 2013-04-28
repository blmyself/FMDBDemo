//
//  User.h
//  FmdbDemo
//
//  Created by BL on 13-4-28.
//  Copyright (c) 2013年 bl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@end
