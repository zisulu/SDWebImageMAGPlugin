//
//  MAGWebImageConfig.h
//  SDWebImageMAGPlugin
//
//  Created by appl on 2020/9/16.
//  Copyright © 2020 Lyeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>)
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#else
@import SDWebImageWebPCoder;
#endif
#import "UIImageView+MAGWebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGWebImageConfig : NSObject

+ (void)setupSDWebImage;

@end

NS_ASSUME_NONNULL_END
