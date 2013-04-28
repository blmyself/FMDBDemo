//
//  wywViewController.m
//  FmdbDemo
//
//  Created by BL on 13-4-28.
//  Copyright (c) 2013年 bl. All rights reserved.
//

#import "wywViewController.h"
#import "wywDatabaseCenter.h"

@interface wywViewController ()

@end

@implementation wywViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertData:(id)sender {
    wywDatabaseCenter * dataCenter = [wywDatabaseCenter sharedDatabaseCenter];
    [dataCenter insertUserWithUserName:@"BILLY" andPwd:@"1234"];
}

- (IBAction)featchData:(id)sender {
    wywDatabaseCenter * dataCenter = [wywDatabaseCenter sharedDatabaseCenter];
   NSMutableArray * rs_arr =  [dataCenter fetchAllUsers];
    NSLog(@"featch rs:%@",rs_arr);
}

- (IBAction)multithreadInsertData:(id)sender {
    wywDatabaseCenter * dataCenter = [wywDatabaseCenter sharedDatabaseCenter];
    [dataCenter multithreadInsertUsers];
}

- (IBAction)deleteAllData:(id)sender {
    wywDatabaseCenter * dataCenter = [wywDatabaseCenter sharedDatabaseCenter];
    [dataCenter deleteAllUsers];
}
@end
