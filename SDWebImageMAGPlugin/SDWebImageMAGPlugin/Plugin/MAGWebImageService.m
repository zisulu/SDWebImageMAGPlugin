//
//  MAGWebImageConfig.m
//  SDWebImageMAGPlugin
//
//  Created by appl on 2020/9/16.
//  Copyright © 2020 Lyeah. All rights reserved.
//

#import "MAGWebImageConfig.h"
#import "SDWebImageDownloaderRequestModifier+MAGWebCache.h"

@implementation MAGWebImageConfig

+ (void)setupSDWebImage
{
    /// 支持 webp
    [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
    SDWebImageDownloaderRequestModifier *requestModifier = [SDWebImageDownloaderRequestModifier mag_webImageDownloaderRequestModifier:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        if (request.URL && request.URL.query.length == 0) {
            NSString *url = request.URL.absoluteString;
            url = [url stringByAppendingFormat:@"?%@", @"params=12345"];
            NSURL *modifiedURL = [NSURL URLWithString:url];
            /// modifiedURLRequest 的配置必须保持和 request 一模一样
            NSMutableURLRequest *modifiedURLRequest = [NSMutableURLRequest requestWithURL:modifiedURL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
            modifiedURLRequest.HTTPShouldHandleCookies = request.HTTPShouldHandleCookies;
            modifiedURLRequest.HTTPShouldUsePipelining = request.HTTPShouldUsePipelining;
            modifiedURLRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            return [modifiedURLRequest copy];
        }
        return request;
    }];
#endif
    [[SDWebImageDownloader sharedDownloader] setRequestModifier:requestModifier];
}

@end
