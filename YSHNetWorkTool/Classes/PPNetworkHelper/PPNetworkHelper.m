//
//  YSHApiRequest.m
//  YSHMobellaParents
//
//  Created by shuhui on 2019/1/8.
//  Copyright © 2019 cqdunyue. All rights reserved.
//



NSString * const YSHBundleIDProduct = @"com.vinacss.hibaby";
NSString * const YSHBundleIDIntegration = @"com.cqdunyue.hibaby.integration";
NSString * const YSHBundleIDDebug = @"com.cqdunyue.hibaby.debug";



#import "YSHLoginPasswordViewController.h"
#import "YSHLoginVerificationCodeViewController.h"
#import "YSHQiNiuApiRequest.h"
#import "YSHApiRequest.h"

@implementation YSHApiRequest


+(NSString *)QiNiuBaseUrl
{
    
    
    return  [AppConfig QiNiuBaseUrl];
    
}

+(NSInteger)developIndex
{
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:YSHBundleIDIntegration]) {
        return 1;
    }
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:YSHBundleIDDebug]) {
        return 2;
    }
    return 0;
}

+(NSString *)ysh_MainBaseUrl
{
    
   return   [AppConfig dy_baseUrlMain];
}
+(NSString *)ysh_WebUrl
{
    
    
    return   [AppConfig dy_urlH5];
}

+(void)ysh_addHeaderValue
{
    NSString * language  = kAppSINGLEManager.language;
    [self setValue:language forHTTPHeaderField:@"lang"];
    [self setValue:[YSHAPPTool getAppVersion] forHTTPHeaderField:@"appVersion"];
    NSString * token = kAppSINGLEManager.userModel.token;
    
    [PPNetworkHelper setValue:[YSHAPPTool isNullWithObj:token]==YES?@"":token forHTTPHeaderField:@"token"];
    NSString * studentId = kAppSINGLEManager.userModel.babyModel.studentId;
    if ([YSHAPPTool isNullWithObj:studentId]) {
        studentId = kAppSINGLEManager.userModel.studentId ;
    }
    studentId = [YSHAPPTool isNullWithObj:studentId]==YES?@"":studentId ;
    [PPNetworkHelper setValue:studentId forHTTPHeaderField:@"studentId"];
    YSHLog(@"Header \n token:%@ \n lang:%@ \n studentId:%@",token,language,studentId);
}
+(id)ysh_addCommonParams:(id)params
{
    
    if ([YSHAPPTool isNullWithObj:params]||![params isKindOfClass:[NSDictionary class]]) {
        params = @{}.mutableCopy;
    }
    
    NSMutableDictionary * tempDict = [params mutableCopy];
    
    if (![YSHAPPTool isNullWithObj:kAppSINGLEManager.userModel.babyModel.studentId]) {
        if ([YSHAPPTool isNullWithObj:tempDict[@"studentId"]]) {
            [tempDict setValue:kAppSINGLEManager.userModel.babyModel.studentId forKey:@"studentId"];
        }
        
    }
    
    YSHLog(@"params --- \n %@",[tempDict jsonStringEncoded]);
    
    return tempDict;
}

+(NSURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters success:(PPHttpRequestSuccess)success failure:(PPHttpRequestFailed)failure
{
   NSURLSessionTask * task = [self request:URL isShowHud:NO message:nil method:@"POST" parameters:parameters success:success failure:failure];
    
    return task ;
    
}
+(NSURLSessionTask *)POST:(NSString *)URL isShowHud:(BOOL)isShowHud
                  message:(NSString *)message
               parameters:(id)parameters
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure
{
    NSURLSessionTask * task = [self request:URL isShowHud:isShowHud message:message method:@"POST" parameters:parameters success:success failure:failure];
    
    return task ;
    
}

+(NSURLSessionTask *)GET:(NSString *)URL isShowHud:(BOOL)isShowHud
                  message:(  NSString *)message
               parameters:( id)parameters
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure
{
    NSURLSessionTask * task = [self request:URL isShowHud:isShowHud message:message method:@"GET" parameters:parameters success:success failure:failure];
    
    return task ;
}
+(NSURLSessionTask *)PUT:(NSString *)URL isShowHud:(BOOL)isShowHud
                 message:(  NSString *)message
              parameters:( id)parameters
                 success:(PPHttpRequestSuccess)success
                 failure:(PPHttpRequestFailed)failure
{
    NSURLSessionTask * task = [self request:URL isShowHud:isShowHud message:message method:@"PUT" parameters:parameters success:success failure:failure];
    
    return task ;
}
+(NSURLSessionTask *)DELETE:(NSString *)URL isShowHud:(BOOL)isShowHud
                 message:(  NSString *)message
              parameters:( id)parameters
                 success:(PPHttpRequestSuccess)success
                 failure:(PPHttpRequestFailed)failure
{
    NSURLSessionTask * task = [self request:URL isShowHud:isShowHud message:nil method:@"DELETE" parameters:parameters success:success failure:failure];
    
    return task ;
}


+(NSURLSessionTask *)GET:(NSString *)URL parameters:(id)parameters success:(PPHttpRequestSuccess)success failure:(PPHttpRequestFailed)failure
{
    NSURLSessionTask * task = [self request:URL isShowHud:NO message:nil method:@"GET" parameters:parameters success:success failure:failure];
    
    return task ;
    
}



+(NSURLSessionTask *)request:(NSString *)url
                   isShowHud:(BOOL)isShowHud
                     message:(NSString *)message
                      method:(NSString *)method
                  parameters:(id)parameters
                     success:(PPHttpRequestSuccess)success
                     failure:(PPHttpRequestFailed)failure

{
    
    [self ysh_addHeaderValue];
    parameters = [self ysh_addCommonParams:parameters];
    
    MBProgressHUD *hud ;
    if (isShowHud) {
        hud = [MBProgressHUD showHUDAddedTo:kAppWindow animated:YES];
    }
    if (message) {
        hud.label.text = message;
    }
    
    
    NSString * baseUrl = [NSString stringWithFormat:@"%1$@/%2$@",[self ysh_MainBaseUrl],kURL_VERSION];
    if ([AppConfig developIndex] == YHNetworkConfigTypeDebug) {
        //            如果是开发 是否需要mock
        if (DevelopIsUseMock==1) {
            NSString * mockUrl = @"https://475d9c43-392f-432a-a69a-5413624f1b11.mock.pstmn.io";
            baseUrl = mockUrl ;
        }
        
        
    }
    
    if ([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"]) {
        
    }else{
        url = [NSString stringWithFormat:@"%1$@%2$@",baseUrl,url];
    }
    
    if ([method isEqualToString:@"POST"]) {
        [super POST:url parameters:parameters success:^(id responseObject) {
             [hud hideAnimated:YES];
            BOOL obj = [self ysh_errorHandlingCode:responseObject];
           
            if ( obj == NO) {
                failure(nil);
            }else{
                success(responseObject) ;
            }
        } failure:^(NSError *error) {
             [hud hideAnimated:YES];
            [self failureHandle:error];
            failure(error);
        }];
    }
    if ([method isEqualToString:@"GET"]) {
        [super GET:url parameters:parameters success:^(id responseObject) {
            [hud hideAnimated:YES];
            BOOL obj = [self ysh_errorHandlingCode:responseObject];
            if ( obj == NO) {
                failure(nil);
            }else{
                success(responseObject) ;
            }
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [self failureHandle:error];
            failure(error);
        }];
    }
//    同步加载数据
    if ([method isEqualToString:@"GET_TB"]) {
        
      
        [super GETSynchron:url parameters:parameters success:^(id responseObject) {
            [hud hideAnimated:YES];
            success(responseObject) ;
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [self failureHandle:error];
            failure(error);
        }];
    }
    if ([method isEqualToString:@"PUT"]) {
        [super PUT:url parameters:parameters success:^(id responseObject) {
            [hud hideAnimated:YES];
            BOOL obj = [self ysh_errorHandlingCode:responseObject];
            if ( obj == NO) {
                failure(nil);
            }else{
                success(responseObject) ;
            }
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [self failureHandle:error];
            failure(error);
        }];
    }
    if ([method isEqualToString:@"DELETE"]) {
        [super DELETE:url parameters:parameters success:^(id responseObject) {
            [hud hideAnimated:YES];
            BOOL obj = [self ysh_errorHandlingCode:responseObject];
            if ( obj == NO) {
                failure(nil);
            }else{
                success(responseObject) ;
            }
        } failure:^(NSError *error) {
             [hud hideAnimated:YES];
            [self failureHandle:error];
            failure(error);
        }];
    }
    
    return nil;
}


+ (NSURLSessionTask *)CatcheGET:(NSString *)URL
                parameters:(id)parameters
             responseCache:(PPHttpRequestCache)responseCache
                   success:(PPHttpRequestSuccess)success
                   failure:(PPHttpRequestFailed)failure
{
    
    NSString * key = [NSString stringWithFormat:@"%@%@%@",kAppSINGLEManager.userModel.parentId,kAppSINGLEManager.userModel.schoolId,kAppSINGLEManager.userModel.babyModel.studentId];
    NSString * cacheUrl = [NSString stringWithFormat:@"%@%@",URL,key];
    //读取缓存
    if (responseCache!=nil) {
        id catcherData = [PPNetworkCache httpCacheForURL:cacheUrl parameters:parameters];
        if (catcherData) {
            responseCache(catcherData) ;
        }
    }
   
    
    NSURLSessionTask * task = [self request:URL isShowHud:NO message:nil method:@"GET" parameters:parameters success:^(id responseObject) {
        success(responseObject) ;
        responseCache!=nil ? [PPNetworkCache setHttpCache:responseObject URL:cacheUrl parameters:parameters] : nil;
    } failure:^(NSError *error) {
        failure(error);
    }];
    
   
    
    return task ;
    
}




+(void)ysh_QiNiu_uploadImages:(NSArray<UIImage *> *)images
                         type:(NSInteger)type
                      success:(PPHttpRequestSuccess)success
                      failure:(PPHttpRequestFailed)failure
{
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kAppWindow animated:YES];
    // Set the bar determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"file_uploading_tips", @"七牛上传图片");
    if (images.count==0||images==nil) {
        return;
    }
    
    [YSHQiNiuApiRequest  ysh_uploadImages:images type:type progress:^(CGFloat progress) {
        [MBProgressHUD HUDForView:kAppWindow].progress = progress;
        
        hud.label.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    } success:^(NSArray * imgArrStr) {
        [hud setHidden:YES];
        if (success) {
            success(imgArrStr);
        }
    } failure:^{
        [hud setHidden:YES];
        if (failure) {
            failure(nil);
        }
    } ];
    
    
    
    
}



+ (void)ysh_GETSynchronPath:(NSString *)Path
                 parameters:(id __nullable)parameters
                    success:(PPHttpRequestSuccess)success
                    failure:(PPHttpRequestFailed)failure
{
    NSError *error1 ;
    __block  NSError * blockError1 = error1;
    id responseObject1 ;
    __block  id blockResponseObject1 = responseObject1;
    
    
    [self request:Path isShowHud:NO message:nil method:@"GET_TB" parameters:parameters success:^(id responseObject) {
        blockResponseObject1= responseObject ;
    } failure:^(NSError *error) {
        blockError1 = error ;
    }];
  
    
    
    
    
    
    if (error1) {
        [self failureHandle:error1];
        failure(error1);
    }else{
        BOOL obj = [self ysh_errorHandlingCode:blockResponseObject1];
        if ( obj == NO) {
            failure(nil);
        }else{
            success(blockResponseObject1) ;
        }
    }
    
    
    
    
    
    
    
}






+(BOOL)ysh_errorHandlingCode:(id)responseObject
{
    BOOL flag = NO;
    if (kAppWindow) {
        flag = YES;
    }
    
    YSHRespone * obj =  [YSHRespone modelWithJSON:responseObject];
    if (!obj) {
        if (flag) {
            [SHProgressHUD showError:NSLocalizedString(@"network_dataError_tips", nil)];
        }
        return NO;
    }
    
    if ([obj isKindOfClass:[YSHRespone class]]) {
        NSInteger code = obj.code;
        
        
        //        code == 0成功 其他都是失败 code == 1  Mobella_user_confirm 用户初次登录
        if (code == 0 || code == 1) {
            
            return YES;
        }
        
        
        else{
            NSString * msg = responseObject[@"msg"];
            if (code == 200||code ==31||code ==30 ) {
                if (flag) {
                    [YSHAlertTool ysh_AlertControllerTitle:nil message:msg style:UIAlertControllerStyleAlert callBlock:^(NSInteger tag) {
                        
                    } confirmButtonTitle:NSLocalizedString(@"m01_p04_btn_confirm", nil) cancelButtonTitle:nil otherButtonTitlesArray:nil];
                }
                
            }
            else if (code == 120)
            {
                if (flag) {
                    YSHLoginVerificationCodeViewController * vc = [YSHLoginVerificationCodeViewController ysh_getVCWithStoryboardName:@"Login" identifier:@"YSHLoginVerificationCodeViewController"];
                    vc.ysh_isSmgLogin = YES;
                    UIViewController * currentVC = [YSHAPPTool topViewController];
                    if ([currentVC isKindOfClass:[YSHLoginPasswordViewController class]] ) {
                        YSHLoginPasswordViewController * currVC =( YSHLoginPasswordViewController *)currentVC;
                        vc.phone = currVC.phone;
                        [currentVC.navigationController pushViewController:vc animated:YES];

                    }
                }
                
            }
            else
                
            {
                //         4token 无效       去首页 1003 宝宝服务过期
                if (code == 4 || code == 1003||code == 122 ) {
                    [YSHAPPTool ysh_toLogin];
                    
                }
                
                if ( code == 122) {

                    [YSHAlertTool ysh_AlertControllerTitle:nil message:msg style:UIAlertControllerStyleAlert callBlock:^(NSInteger tag) {
                    
                    } confirmButtonTitle:NSLocalizedString(@"m01_p04_btn_confirm", nil) cancelButtonTitle:nil otherButtonTitlesArray:nil];
                    
                    
                    
                }else{
                    
                    if (flag) {
                        [SHProgressHUD showError:msg];
                    }
                }
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
        }
    }
    
    return  NO;
}


+(void)failureHandle:(NSError *)error
{
    NSLog(@"error---%@",error);
    if ([NSThread isMainThread]) {
        if (kAppWindow) {
            [SHProgressHUD showError:NSLocalizedString(@"msg_connection_timeout", @"网络异常，请稍后重试")];
        }
    }
    
    
}


+(id)modelWithResp:(id)Resp modelClassStr:(NSString *)modelClassStr
{
    id data = Resp[@"data"];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray * tempArr = [NSArray modelArrayWithClass:NSClassFromString(modelClassStr) json:data];
        return tempArr;
    }else{
        id obj = [NSClassFromString(modelClassStr) modelWithJSON:data];
        return obj;
    }
}


@end
