//
//  UIImageView+MAGWebCache.h
//  magapp-x
//
//  Created by appl on 2020/9/17.
//  Copyright © 2020 lyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>)
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#else
@import SDWebImageWebPCoder;
#endif

NS_ASSUME_NONNULL_BEGIN

/// 为了项目适配，保证都走到mag_setImageWithURL
#ifndef sd_setImageWithURL
#define sd_setImageWithURL mag_setImageWithURL
#endif

/// BOOL 传入YES则取magGlobalBackgroundColor，若magGlobalBackgroundColor不存在则不处理，传入NO则不处理
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalBackgroundColorKey;
/// BOOL 当未传入placeholderImage时，设为YES则取magGlobalPlaceholderImage，若magGlobalPlaceholderImage不存在则不处理，设为NO则只取placeholderImage
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalPlaceholderImageKey;

typedef NSURL *_Nullable(^MAGWebImageURLModifierBlock)(__kindof UIImageView *mag_imageView, NSURL * _Nullable originImageURL, SDWebImageContext * _Nonnull context);

@interface SDWebImageManager (MAGWebCache)

/// 全局图片url处理
@property (nonatomic, copy, nullable) MAGWebImageURLModifierBlock magGlobalImageURLModifierBlock;

/// 全局背景颜色
@property (nonatomic, copy, nullable) UIColor *magGlobalBackgroundColor;

/// 全局缺省图片
@property (nonatomic, strong, nullable) UIImage *magGlobalPlaceholderImage;

@end

@interface SDWebImageDownloaderRequestModifier (MAGWebCache)

/// 因为 SDWebImageDownloaderRequestModifier 自身的构造方法必传 block
/// 所以这里包一层使用 block 构造一个 modifier，不传 block 则只做中转
/// @param block block
+ (instancetype)mag_webImageDownloaderRequestModifier:(nullable SDWebImageDownloaderRequestModifierBlock)block;

@end

@interface NSData (MAGWebCache)

@property (nonatomic, readonly) BOOL mag_isGIF;

@end

@interface UIImage (MAGWebCache)

@property (nonatomic, readonly) BOOL mag_isGIF;

@end

/// SDWebImage的MAG扩展，定制内容：
/// 1.提供全局和单独的block在进入下载流程之前修改url，例如：添加或去掉裁剪、水印等参数；
/// 2.提供全局背景颜色和全局缺省图片控制设置；
@interface UIImageView (MAGWebCache)

@property (nonatomic, assign) CGFloat   magPreferedWidth;           //图片显示宽度
@property (nonatomic, assign) CGFloat   magPreferedHeight;          //图片显示高度
@property (nonatomic, assign) CGSize    magPreferedSize;            //图片显示大小，用于优化加载需要的图片大小

/// Get the original image URL.
/// @note 由于定制可能会修改图片URL，所以提供此参数获取未修改的图片URL；
/// 如果未进行修改则 magOriginImageURL == mag_imageURL == 未修改的图片URL；
/// 如果进行修改则 magOriginImageURL == 未修改的图片URL；mag_imageURL == 已修改的图片URL；
@property (nonatomic, strong, readonly, nullable) NSURL *magOriginImageURL;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

/// 使用 mag_ 包一层 SDWebImage 的 API 目的是方便定制
@interface UIImageView (MAGWebCache_SDWebImageWrapper)

- (void)mag_setImageWithURL:(nullable NSURL *)url;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
