//
//  YSHViewController.m
//  YSHNetWorkTool
//
//  Created by 793983383@qq.com on 12/11/2018.
//  Copyright (c) 2018 793983383@qq.com. All rights reserved.
//

#import "YSHViewController.h"

@interface YSHViewController ()

@end

@implementation YSHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    [YSHNetWorkTool DELETE:@"http://hibabytest.vinacss.com:8081/v1/test/test" parameters:@{} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [YSHNetWorkTool PUT:@"http://hibabytest.vinacss.com:8081/v1/test/test" parameters:@{} success:^(id responseObject) {

    } failure:^(NSError *error) {
        
    }];

   
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
