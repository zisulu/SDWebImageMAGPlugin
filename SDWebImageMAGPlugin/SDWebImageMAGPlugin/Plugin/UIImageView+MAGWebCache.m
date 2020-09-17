//
//  UIImageView+MAGWebCache.m
//  SDWebImageMAGPlugin
//
//  Created by luwenlong on 2019/4/23.
//  Copyright © 2019 lyeah. All rights reserved.
//

#import "UIImageView+MAGWebCache.h"
#import <objc/runtime.h>

SDWebImageContextOption const MAGWebImageContextUseGlobalBackgroundColorKey             = @"mag_useGlobalBackgroundColor";
SDWebImageContextOption const MAGWebImageContextUseGlobalPlaceholderImageKey            = @"mag_useGlobalPlaceholderImage";

static const char MAGWebImagePreferedWidthKey                          = '\0';
static const char MAGWebImagePreferedHieghtKey                         = '\0';
static const char MAGWebImageOriginalURLKey                            = '\0';
static const char MAGWebImageURLModifierBlockKey                       = '\0';
static const char MAGWebImageGlobalPlaceholderColorKey                 = '\0';
static const char MAGWebImageGlobalPlaceholderImageKey                 = '\0';

@implementation SDWebImageManager (MAGWebCache)

- (void)setMagGlobalImageURLModifierBlock:(MAGWebImageURLModifierBlock)magGlobalImageURLModifierBlock
{
    objc_setAssociatedObject(self, &MAGWebImageURLModifierBlockKey, magGlobalImageURLModifierBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MAGWebImageURLModifierBlock)magGlobalImageURLModifierBlock
{
    return objc_getAssociatedObject(self, &MAGWebImageURLModifierBlockKey);
}

- (void)setMagGlobalBackgroundColor:(UIColor *)magGlobalBackgroundColor
{
    objc_setAssociatedObject(self, &MAGWebImageGlobalPlaceholderColorKey, magGlobalBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)magGlobalBackgroundColor
{
    return objc_getAssociatedObject(self, &MAGWebImageGlobalPlaceholderColorKey);
}

- (void)setMagGlobalPlaceholderImage:(UIImage *)magGlobalPlaceholderImage
{
    objc_setAssociatedObject(self, &MAGWebImageGlobalPlaceholderImageKey, magGlobalPlaceholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)magGlobalPlaceholderImage
{
    return objc_getAssociatedObject(self, &MAGWebImageGlobalPlaceholderImageKey);
}

@end

@implementation SDWebImageDownloaderRequestModifier (MAGWebCache)

+ (instancetype)mag_webImageDownloaderRequestModifier:(SDWebImageDownloaderRequestModifierBlock)block
{
    SDWebImageDownloaderRequestModifier *requestModifier = [SDWebImageDownloaderRequestModifier requestModifierWithBlock:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        if (block) {
            return block(request);
        }
        return request;
    }];
    return requestModifier;
}

@end

@implementation NSData (MAGWebCache)

- (BOOL)mag_isGIF
{
    SDImageFormat format = [NSData sd_imageFormatForImageData:self];
    return (format == SDImageFormatGIF);
}

@end

@implementation UIImage (MAGWebCache)

- (BOOL)mag_isGIF
{
    return (self.images != nil);
}

@end

@implementation UIImageView (MAGWebCache)

#pragma mark ---------- MAGExtends begin ----------

- (void)setMagPreferedWidth:(CGFloat)preferedWidth
{
    objc_setAssociatedObject(self, &MAGWebImagePreferedWidthKey, [NSNumber numberWithFloat:preferedWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)magPreferedWidth
{
    return [objc_getAssociatedObject(self, &MAGWebImagePreferedWidthKey) floatValue];
}

- (void)setMagPreferedHeight:(CGFloat)preferedHeight
{
    objc_setAssociatedObject(self, &MAGWebImagePreferedHieghtKey, [NSNumber numberWithFloat:preferedHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    /// 保存初始URL
    self.magOriginImageURL = url;
    BOOL useGlobalBackgroundColor = YES;
    if (mutableContext[MAGWebImageContextUseGlobalBackgroundColorKey]) {
        /// 是否使用全局背景颜色
        useGlobalBackgroundColor = [mutableContext[MAGWebImageContextUseGlobalBackgroundColorKey] boolValue];
    }
    if (useGlobalBackgroundColor) {
        SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
        if (imageManager.magGlobalBackgroundColor) {
            self.backgroundColor = imageManager.magGlobalBackgroundColor;
        }
    }
    /// 缺省图片
    if (!placeholder) {
        BOOL useGlobalPlaceholderImage = YES;
        if (mutableContext[MAGWebImageContextUseGlobalPlaceholderImageKey]) {
            /// 是否使用全局缺省图片
            useGlobalPlaceholderImage = [mutableContext[MAGWebImageContextUseGlobalPlaceholderImageKey] boolValue];
        }
        if (useGlobalPlaceholderImage) {
            SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
            if (imageManager.magGlobalPlaceholderImage) {
                placeholder = imageManager.magGlobalPlaceholderImage;
            }
        }
    }
    context = [mutableContext copy];
    if (modifierBlock) {
        /// 如果实现了modifierBlock，则忽略SDWebImageManager的imageURLModifierBlock
        url = modifierBlock(self, self.magOriginImageURL, context);
    } else {
        SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
        if (imageManager.magGlobalImageURLModifierBlock) {
            url = imageManager.magGlobalImageURLModifierBlock(self, self.magOriginImageURL, context);
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

@end


@implementation UIImageView (MAGWebCache_SDWebImageWrapper)

- (void)mag_setImageWithURL:(nullable NSURL *)url
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options context:(nullable SDWebImageContext *)context
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:context progress:nil completed:nil];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:nil progress:progressBlock completed:completedBlock];
}

- (void)mag_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                   context:(nullable SDWebImageContext *)context
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self mag_setImageWithURL:url placeholderImage:placeholder options:options context:nil modifier:nil progress:progressBlock completed:completedBlock];
}

@end
