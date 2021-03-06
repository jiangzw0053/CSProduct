//
//  CSBaseRequest.m
//  CSProduct
//
//  Created by zhiwei jiang on 2017/11/26.
//  Copyright © 2017年 zhiwei jiang. All rights reserved.
//

#import "CSWebRequest.h"

@implementation CSWebRequest

- (NSString *)baseUrl{
    return @"http://10.16.9.163:8081/";
}
- (NSString *)requestUrl{
    return _httpDetailUrl;
}

- (CSRequestMethod)requestMethod{
    return _method;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return _httpHeaderFieldDictionary;
}

- (CSRequestSerializerType)requestSerializerType {
    return CSRequestSerializerTypeJSON;
}

- (BOOL)isSecretRequest{
    return YES;
}

-(BOOL)needUrlFilters{
    return NO;
}

@end
