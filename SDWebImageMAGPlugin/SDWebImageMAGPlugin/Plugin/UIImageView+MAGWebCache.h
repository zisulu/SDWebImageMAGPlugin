//
//  UIImageView+MAGWebCache.h
//  SDWebImageMAGPlugin
//
//  Created by luwenlong on 2019/4/23.
//  Copyright © 2019 lyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>

NS_ASSUME_NONNULL_BEGIN

//BOOL 动图控制参数
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextAnimateKey;
//NSURL 只读，不可外部设置
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextOriginalURLKey;
//NSValue 传入则忽略magPreferedSize
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextPreferredSizeKey;
//UIColor 传入则忽略全局缺省背景颜色
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextPlaceholderColorKey;
//UIImage 传入则忽略全局缺省背景图片
FOUNDATION_EXPORT SDWebImageContextOption _Nonnull const MAGWebImageContextPlaceholderImageKey;

typedef NSURL *_Nullable(^MAGWebImageURLModifierBlock)(NSURL * _Nullable originImageURL, SDWebImageContext * _Nonnull context);

@interface SDWebImageManager (MAGWebCache)

/**
 全局图片url处理
 */
@property (nonatomic, copy, nullable) MAGWebImageURLModifierBlock magImageURLModifierBlock;

/**
 全局图片背景颜色
 */
@property (nonatomic, copy, nullable) UIColor *magGlobalPlaceholderColor;

/**
 全局图片背景图片
 */
@property (nonatomic, strong, nullable) UIImage *magGlobalPlaceholderImage;

@end

/**
 SDWebImage MAG扩展，定制内容：
 1.SDWebImageOptions 默认为 SDWebImageDecodeFirstFrameOnly，只展示第一帧
 2.提供全局和单独的block预处理url，例如：添加或去掉裁剪参数
 3.提供全局和单独设置图片背景色
 */
@interface UIImageView (MAGWebCache)

#pragma mark ---------- MAGExtends begin ----------

@property (nonatomic, assign) CGFloat   magPreferedWidth;           //图片显示宽度
@property (nonatomic, assign) CGFloat   magPreferedHeight;          //图片显示高度
@property (nonatomic, assign) CGSize    magPreferedSize;            //图片显示大小，用于优化加载需要的图片大小

/**
 * Get the original image URL.
 *
 * @note 由于定制可能会编辑图片URL，所以提供此参数获取未编辑的图片URL
 * 如果未进行编辑则 magOriginImageURL == sd_imageURL
 * 如果进行编辑则 magOriginImageURL == 未编辑的图片URL；sd_imageURL == 已编辑的图片URL
 */
@property (nonatomic, strong, readonly, nullable) NSURL *magOriginImageURL;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context
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
                    context:(nullable SDWebImageContext *)context
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

#pragma mark ---------- MAGExtends end ----------

#pragma mark ---------- SDWebImage begin ----------

- (void)mag_setImageWithURL:(nullable NSURL *)url;

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder;

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    options:(SDWebImageOptions)options;

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

#pragma mark ---------- SDWebImage end ----------

@end

NS_ASSUME_NONNULL_END
