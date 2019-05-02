//
//  UIImageView+MAGWebCache.m
//  SDWebImageMAGPlugin
//
//  Created by appl on 2019/4/23.
//  Copyright © 2019 lyeah. All rights reserved.
//

#import "UIImageView+MAGWebCache.h"
#import <objc/runtime.h>

SDWebImageContextOption const MAGWebImageContextAnimateKey                              = @"animateEnabled";
SDWebImageContextOption const MAGWebImageContextWatermarkKey                            = @"watermarkEnabled";
SDWebImageContextOption const MAGWebImageContextOriginalURLKey                          = @"originalURL";
SDWebImageContextOption const MAGWebImageContextPreferredSizeKey                        = @"preferredSize";
SDWebImageContextOption const MAGWebImageContextGPColorIgnoredKey                       = @"globalPlaceholderColorIgnored";
SDWebImageContextOption const MAGWebImageContextGPImageIgnoredKey                       = @"globalPlaceholderImageIgnored";

static const char MAGWebImagePreferedWidthKey                          = '\0';
static const char MAGWebImagePreferedHieghtKey                         = '\0';
static const char MAGWebImageOriginalURLKey                            = '\0';
static const char MAGWebImageURLModifierBlockKey                       = '\0';
static const char MAGWebImageGlobalPlaceholderColorKey                 = '\0';
static const char MAGWebImageGlobalPlaceholderImageKey                 = '\0';

@implementation SDWebImageManager (MAGWebCache)

- (void)setMagImageURLModifierBlock:(MAGWebImageURLModifierBlock)magImageURLModifierBlock
{
    objc_setAssociatedObject(self, &MAGWebImageURLModifierBlockKey, magImageURLModifierBlock, OBJC_ASSOCIATION_RETAIN);
}

- (MAGWebImageURLModifierBlock)magImageURLModifierBlock
{
    return objc_getAssociatedObject(self, &MAGWebImageURLModifierBlockKey);
}

- (void)setMagGlobalPlaceholderColor:(UIColor *)magGlobalPlaceholderColor
{
    objc_setAssociatedObject(self, &MAGWebImageGlobalPlaceholderColorKey, magGlobalPlaceholderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)magGlobalPlaceholderColor
{
    return objc_getAssociatedObject(self, &MAGWebImageGlobalPlaceholderColorKey);
}

- (void)setMagGlobalPlaceholderImage:(UIImage *)magGlobalPlaceholderImage
{
    objc_setAssociatedObject(self, &MAGWebImageGlobalPlaceholderImageKey, magGlobalPlaceholderImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)magGlobalPlaceholderImage
{
    return objc_getAssociatedObject(self, &MAGWebImageGlobalPlaceholderImageKey);
}

@end

@implementation UIImageView (MAGWebCache)

#pragma mark ---------- MAGExtends begin ----------

- (void)setMagPreferedWidth:(CGFloat)preferedWidth
{
    objc_setAssociatedObject(self, &MAGWebImagePreferedWidthKey, [NSNumber numberWithFloat:preferedWidth], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)magPreferedWidth
{
    return [objc_getAssociatedObject(self, &MAGWebImagePreferedWidthKey) floatValue];
}

- (void)setMagPreferedHeight:(CGFloat)preferedHeight
{
    objc_setAssociatedObject(self, &MAGWebImagePreferedHieghtKey, [NSNumber numberWithFloat:preferedHeight], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)magPreferedHeight
{
    return [objc_getAssociatedObject(self, &MAGWebImagePreferedHieghtKey) floatValue];
}

- (void)setMagPreferedSize:(CGSize)magPreferedSize
{
    CGFloat width = magPreferedSize.width;
    CGFloat height = magPreferedSize.height;
    self.magPreferedWidth = width;
    self.magPreferedHeight = height;
}

- (CGSize)magPreferedSize
{
    return CGSizeMake(self.magPreferedWidth, self.magPreferedHeight);
}

- (void)setMagOriginImageURL:(NSURL * _Nullable)magOriginImageURL
{
    objc_setAssociatedObject(self, &MAGWebImageOriginalURLKey, magOriginImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSURL *)magOriginImageURL
{
    return (NSURL *)objc_getAssociatedObject(self, &MAGWebImageOriginalURLKey);
}

- (void)mag_setImageWithURL:(NSURL *)url
                    context:(SDWebImageContext *)context
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:context modifier:nil progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:context modifier:nil progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:nil modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:0 context:nil modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:options context:nil modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:context modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:nil modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:context modifier:modifierBlock progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:nil modifier:modifierBlock progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:0 context:nil modifier:modifierBlock progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:nil modifier:modifierBlock progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 context:context modifier:modifierBlock progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:nil modifier:modifierBlock progress:progressBlock completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                    options:(SDWebImageOptions)options
                    context:(nullable SDWebImageContext *)context
                   modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                   progress:(nullable SDImageLoaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_internalSetImageWithURL:url
                     placeholderImage:placeholder
                              options:options
                              context:context
                             modifier:modifierBlock
                        setImageBlock:nil
                             progress:progressBlock
                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                if (completedBlock) {
                                    completedBlock(image, error, cacheType, imageURL);
                                }
                            }];
}

- (void)mag_internalSetImageWithURL:(nullable NSURL *)url
                   placeholderImage:(nullable UIImage *)placeholder
                            options:(SDWebImageOptions)options
                            context:(nullable SDWebImageContext *)context
                           modifier:(nullable MAGWebImageURLModifierBlock)modifierBlock
                      setImageBlock:(nullable SDSetImageBlock)setImageBlock
                           progress:(nullable SDImageLoaderProgressBlock)progressBlock
                          completed:(nullable SDInternalCompletionBlock)completedBlock
{
    if (!context) {
        context = [NSDictionary dictionary];
    }
    SDWebImageMutableContext *mutableContext = [context mutableCopy];
    if ([self isKindOfClass:[SDAnimatedImageView class]]) {
        Class animatedImageClass = [SDAnimatedImage class];
        mutableContext[SDWebImageContextAnimatedImageClass] = animatedImageClass;
    }
    if (!mutableContext[MAGWebImageContextAnimateKey]) {
        //没设置则默认只加载第一帧
        mutableContext[MAGWebImageContextAnimateKey] = @(NO);
    }
    if (!mutableContext[MAGWebImageContextWatermarkKey]) {
        //没设置则默认没有水印
        mutableContext[MAGWebImageContextWatermarkKey] = @(NO);
    }
    if (!mutableContext[MAGWebImageContextPreferredSizeKey]) {
        //没有设置则取self.magPreferedSize
        mutableContext[MAGWebImageContextPreferredSizeKey] = [NSValue valueWithCGSize:self.magPreferedSize];
    }
    if (!mutableContext[MAGWebImageContextGPColorIgnoredKey]) {
        //没设置则默认不忽略全局背景颜色
        mutableContext[MAGWebImageContextGPColorIgnoredKey] = @(NO);
    }
    if (!mutableContext[MAGWebImageContextGPImageIgnoredKey]) {
        //没设置则默认不忽略全局背景图片
        mutableContext[MAGWebImageContextGPImageIgnoredKey] = @(NO);
    }
    //保存初始URL
    self.magOriginImageURL = url;
    if (self.magOriginImageURL) {
        //存在则保存
        mutableContext[MAGWebImageContextOriginalURLKey] = self.magOriginImageURL;
    }
    //是否需要只展示图片第一帧
    BOOL decodeFirstFrame = options & SDWebImageDecodeFirstFrameOnly;
    if (decodeFirstFrame) {
        //如果主动传入SDWebImageDecodeFirstFrameOnly
        //说明希望只显示第一帧，所以强行纠正参数值
        mutableContext[MAGWebImageContextAnimateKey] = @(NO);
    } else {
        //如果没有主动传入SDWebImageDecodeFirstFrameOnly
        //根据MAGWebImageContextAnimateKey参数来控制是否显示第一帧
        BOOL animateEnabled = [mutableContext[MAGWebImageContextAnimateKey] boolValue];
        if (!animateEnabled) {
            options |= SDWebImageDecodeFirstFrameOnly;
        } else {
            //不处理
        }
    }
    BOOL globalColorIgnored = [mutableContext[MAGWebImageContextGPColorIgnoredKey] boolValue];
    if (!globalColorIgnored) {
        //不忽略则尝试设置全局背景颜色
        SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
        if (imageManager.magGlobalPlaceholderColor) {
            self.backgroundColor = imageManager.magGlobalPlaceholderColor;
        }
    }
    BOOL globalImageIgnored = [mutableContext[MAGWebImageContextGPColorIgnoredKey] boolValue];
    if (!globalImageIgnored) {
        //不忽略则尝试设置全局背景图片
        if (!placeholder) {
            //没有传入缺省图片，则设置全局缺省图片
            SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
            if (imageManager.magGlobalPlaceholderImage) {
                placeholder = imageManager.magGlobalPlaceholderImage;
            }
        }
    }
    context = [mutableContext copy];
    if (modifierBlock) {
        //如果实现了modifierBlock，则忽略SDWebImageManager的imageURLModifierBlock
        url = modifierBlock(self.magOriginImageURL, context);
    } else {
        SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
        if (imageManager.magImageURLModifierBlock) {
            url = imageManager.magImageURLModifierBlock(self.magOriginImageURL, context);
        } else {
            //不处理
        }
    }
    [self sd_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                             context:context
                       setImageBlock:nil
                            progress:progressBlock
                           completed:completedBlock];
}

#pragma mark ---------- MAGExtends end ----------

- (void)mag_setImageWithURL:(nullable NSURL *)url
{
    [self mag_setImageWithURL:url modifier:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder
{
    [self mag_setImageWithURL:url placeholderImage:placeholder modifier:nil];
}

- (void)mag_setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options
{
    [self mag_setImageWithURL:url options:options modifier:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options modifier:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options context:(nullable SDWebImageContext *)context
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:context modifier:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url modifier:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder modifier:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options modifier:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options modifier:nil progress:progressBlock completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options context:(nullable SDWebImageContext *)context progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:context modifier:nil progress:progressBlock completed:completedBlock];
}

@end
