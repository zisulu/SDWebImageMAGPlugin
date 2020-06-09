//
//  UIImageView+MAGWebCache.h
//  SDWebImageMAGPlugin
//
//  Created by luwenlong on 2019/4/23.
//  Copyright © 2019 lyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>

NS_ASSUME_NONNULL_BEGIN

/// BOOL 传入YES则取magGlobalBackgroundColor，若magGlobalBackgroundColor不存在则不处理，传入NO则不处理
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalBackgroundColorKey;
/// BOOL 当未传入placeholderImage时，设为YES则取magGlobalPlaceholderImage，若magGlobalPlaceholderImage不存在则不处理，设为NO则只取placeholderImage
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextUseGlobalPlaceholderImageKey;

typedef NSURL *_Nullable(^MAGWebImageURLModifierBlock)(__kindof UIView *sd_view, NSURL * _Nullable originImageURL, SDWebImageContext * _Nonnull context);

@interface SDWebImageManager (MAGWebCache)

/**
 全局图片url处理
 */
@property (nonatomic, copy, nullable) MAGWebImageURLModifierBlock magGlobalImageURLModifierBlock;

/**
 全局背景颜色
 */
@property (nonatomic, copy, nullable) UIColor *magGlobalBackgroundColor;

/**
 全局缺省图片
 */
@property (nonatomic, strong, nullable) UIImage *magGlobalPlaceholderImage;

@end

/**
 SDWebImage的MAG扩展，定制内容：
 1.提供全局和单独的block在进入下载流程之前修改url，例如：添加或去掉裁剪、水印等参数；
 2.提供全局背景颜色和全局缺省图片控制设置；
 */
@interface UIImageView (MAGWebCache)

@property (nonatomic, assign) CGFloat   magPreferedWidth;           //图片显示宽度
@property (nonatomic, assign) CGFloat   magPreferedHeight;          //图片显示高度
@property (nonatomic, assign) CGSize    magPreferedSize;            //图片显示大小，用于优化加载需要的图片大小

/**
 * Get the original image URL.
 *
 * @note 由于定制可能会修改图片URL，所以提供此参数获取未修改的图片URL；
 * 如果未进行修改则 magOriginImageURL == sd_imageURL == 未修改的图片URL；
 * 如果进行修改则 magOriginImageURL == 未修改的图片URL；sd_imageURL == 已修改的图片URL；
 */
@property (nonatomic, strong, readonly, nullable) NSURL *magOriginImageURL;

- (void)sd_setImageWithURL:(nullable NSURL *)url
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                   context:(nullable SDWebImageContext *)context
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                   context:(nullable SDWebImageContext *)context
                  modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
