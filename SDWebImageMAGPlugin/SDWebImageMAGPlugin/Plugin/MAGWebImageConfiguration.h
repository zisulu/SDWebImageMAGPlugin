//
//  MAGWebImageConfiguration.h
//  SDWebImageMAGPlugin
//
//  Created by appl on 2020/9/16.
//  Copyright © 2020 Lyeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+MAGWebCache.h"
#if __has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>)
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#elif __has_include("SDWebImageWebPCoder.h")
@import SDWebImageWebPCoder;
#endif

#define MAGSDWebPCoderEnabled (__has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>) || __has_include("SDWebImageWebPCoder.h"))

NS_ASSUME_NONNULL_BEGIN

@interface MAGWebImageConfiguration : NSObject

+ (void)setupSDWebImage;

@end

NS_ASSUME_NONNULL_END
