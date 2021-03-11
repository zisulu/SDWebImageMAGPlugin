//
//  UIView+MAGWebCache.h
//  SDWebImageMAGPlugin
//
//  Created by appl on 2021/3/10.
//  Copyright © 2021 Lyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#elif __has_include("SDWebImage.h")
@import SDWebImage;
#endif
#if __has_include(<SDWebImageFLPlugin/SDWebImageFLPlugin.h>)
#import <SDWebImageFLPlugin/SDWebImageFLPlugin.h>
#elif __has_include("SDWebImageFLPlugin.h")
@import SDWebImageFLPlugin;
#endif

#define MAGSDWebImageEnabled (__has_include(<SDWebImage/SDWebImage.h>) || __has_include("SDWebImage.h"))
#define MAGSDFLPluginEnabled (__has_include(<SDWebImageFLPlugin/SDWebImageFLPlugin.h>) || __has_include("SDWebImageFLPlugin.h"))

NS_ASSUME_NONNULL_BEGIN

/// SDWebImage 的定制扩展，扩展方式 MethodSwizzing，扩展内容：
/// 1.提供全局和单独的 block 在进入 sd_internalSetImageWithURL: 流程之前修改url，例如：添加或去掉裁剪、水印等参数；
/// 2.提供全局背景颜色和全局缺省图片控制设置；
@interface UIView (MAGWebCache)

/// 图片显示宽度
@property (nonatomic, assign) CGFloat magPreferedWidth;

/// 图片显示高度
@property (nonatomic, assign) CGFloat magPreferedHeight;

/// 图片显示大小，用于优化加载需要的图片大小
@property (nonatomic, assign) CGSize magPreferedSize;

@end

#if MAGSDWebImageEnabled

/// BLOCK 传入一个 MAGWebImageURLModifierBlock，传入则无视 magGlobalImageURLModifierBlock
/// 若传入则忽略 magGlobalImageURLModifierBlock 和 MAGWebImageContextUseGlobalImageURLModifierKey
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextImageURLModifierKey;

/// BOOL 当且仅当 MAGWebImageContextImageURLModifierKey 未设置时生效
/// 设为 NO 则忽略 magGlobalImageURLModifierBlock
/// 设为 YES 或者不传则启用 magGlobalImageURLModifierBlock
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalImageURLModifierKey;

/// BOOL 不设置则默认为 YES，设为 YES 则取 magGlobalBackgroundColor
/// 若 magGlobalBackgroundColor 不存在则不处理，传入 NO 或者不传 则不处理
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalBackgroundColorKey;

/// BOOL 不设置则默认为 YES，当且仅当 placeholderImage 为 nil 时生效
/// 设为 YES 或者不传则取 magGlobalPlaceholderImage
/// 若 magGlobalPlaceholderImage 不存在则不处理，设为 NO 则只取 placeholderImage
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalPlaceholderImageKey;

typedef NSURL *_Nullable(^MAGWebImageURLModifierBlock)(__kindof UIView *magView, NSURL * _Nullable originImageURL, SDWebImageContext * _Nonnull context);

@interface SDWebImageManager (MAGWebCache)

/// 全局图片url处理
@property (nullable, nonatomic, copy) MAGWebImageURLModifierBlock magGlobalImageURLModifierBlock;

/// 全局背景颜色
@property (nullable, nonatomic, copy) UIColor *magGlobalBackgroundColor;

/// 全局缺省图片
@property (nullable, nonatomic, strong) UIImage *magGlobalPlaceholderImage;

@end

@interface SDWebImageDownloaderRequestModifier (MAGWebCache)

/// 因为 SDWebImageDownloaderRequestModifier 自身的构造方法必传 block
/// 所以这里包一层使用 block 构造一个 modifier，不传 block 则只做中转
/// @param block block
+ (instancetype)mag_webImageDownloaderRequestModifier:(nullable SDWebImageDownloaderRequestModifierBlock)block;

@end

@interface UIView (MAGWebCache_SDWebImageWrapper)

/// Get the original image URL.
/// @note 由于定制可能会修改图片URL，所以提供此参数获取未修改的图片URL；
/// 如果未进行修改则 magOriginImageURL == sd_imageURL == 未修改的图片URL；
/// 如果进行修改则 magOriginImageURL == 未修改的图片URL；sd_imageURL == 已修改的图片URL；
@property (nullable, nonatomic, strong, readonly) NSURL *magOriginImageURL;

@end

@interface NSData (MAGWebCache)

@property (nonatomic, readonly) BOOL mag_isGIF;
@property (nonatomic, readonly) BOOL mag_isWebP;

@end

@interface UIImage (MAGWebCache)

@property (nonatomic, readonly) BOOL mag_isGIF;
@property (nonatomic, readonly) BOOL mag_isWebP;

@end

#if MAGSDFLPluginEnabled

@interface FLAnimatedImageView (MAGWebCache_FLAnimatedImageWrapper)

/// 默认为 YES，参考 SDAnimatedImageView 的 autoPlayAnimatedImage 实现
/// 略有不同的是这里是交换 FL 内部的 setShouldAnimate: 实现的控制
/// 为 FLAnimatedImageView 增加控制自动播放的属性
/// 升级 FLAnimatedImageView 的时候需要注意是否出现冲突或变动
@property (nonatomic, assign) BOOL magAutoPlayAnimatedImage;

@end

#endif

#endif

NS_ASSUME_NONNULL_END
