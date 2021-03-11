//
//  UIView+MAGWebCache.m
//  SDWebImageMAGPlugin
//
//  Created by appl on 2021/3/10.
//  Copyright © 2021 Lyeah. All rights reserved.
//

#import "UIView+MAGWebCache.h"
#import <objc/runtime.h>

@implementation UIView (MAGWebCache)

static const char MAGWebImagePreferedWidthKey = '\0';
static const char MAGWebImagePreferedHieghtKey = '\0';

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

static const char MAGWebImageAutoPlayAnimatedImagKey = '\0';

- (BOOL)magAutoPlayAnimatedImage
{
    BOOL result = NO;
    NSNumber *autoPlayAnimatedImage = (NSNumber *)objc_getAssociatedObject(self, &MAGWebImageAutoPlayAnimatedImagKey);
    if (autoPlayAnimatedImage) {
        result = [autoPlayAnimatedImage boolValue];
    } else {
        [self setMagAutoPlayAnimatedImage:result];
    }
    return result;
}

- (void)setMagAutoPlayAnimatedImage:(BOOL)magAutoPlayAnimatedImage
{
    objc_setAssociatedObject(self, &MAGWebImageAutoPlayAnimatedImagKey, @(magAutoPlayAnimatedImage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#if MAGSDWebImageEnabled

SDWebImageContextOption const MAGWebImageContextImageURLModifierKey                     = @"mag_imageURLModifier";
SDWebImageContextOption const MAGWebImageContextUseGlobalImageURLModifierKey            = @"mag_useGlobalImageURLModifier";
SDWebImageContextOption const MAGWebImageContextUseGlobalBackgroundColorKey             = @"mag_useGlobalBackgroundColor";
SDWebImageContextOption const MAGWebImageContextUseGlobalPlaceholderImageKey            = @"mag_useGlobalPlaceholderImage";

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

@implementation UIView (MAGWebCache_SDWebImageWrapper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sd_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:);
        SEL newSelector = @selector(mag_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method newMethod = class_getInstanceMethod(self, newSelector);
        if (!originalMethod || !newMethod) return;
        
        class_addMethod(self,
                        originalSelector,
                        class_getMethodImplementation(self, originalSelector),
                        method_getTypeEncoding(originalMethod));
        class_addMethod(self,
                        newSelector,
                        class_getMethodImplementation(self, newSelector),
                        method_getTypeEncoding(newMethod));
        
        method_exchangeImplementations(class_getInstanceMethod(self, originalSelector),
                                       class_getInstanceMethod(self, newSelector));
    });
}

- (void)mag_internalSetImageWithURL:(nullable NSURL *)url
                   placeholderImage:(nullable UIImage *)placeholder
                            options:(SDWebImageOptions)options
                            context:(nullable SDWebImageContext *)context
                      setImageBlock:(nullable SDSetImageBlock)setImageBlock
                           progress:(nullable SDImageLoaderProgressBlock)progressBlock
                          completed:(nullable SDInternalCompletionBlock)completedBlock
{
    /// 保存初始URL
    self.magOriginImageURL = url;
    if (!context) {
        context = [NSDictionary dictionary];
    }
    SDWebImageMutableContext *mutableContext = [context mutableCopy];
    if ([self isKindOfClass:[SDAnimatedImageView class]]) {
        /// SDAnimatedImageView
    } else
#if MAGSDFLPluginEnabled
    if ([self isKindOfClass:[FLAnimatedImageView class]]) {
        /// FLAnimatedImageView
    } else
#endif
    {
        /// Common UIImageView or Others
        if (![self magAutoPlayAnimatedImage]) {
            if (options != kNilOptions) {
                if (options&SDWebImageDecodeFirstFrameOnly) {
                    /// 已经包含则不处理
                } else {
                    options = options&SDWebImageDecodeFirstFrameOnly;
                }
            } else {
                options = SDWebImageDecodeFirstFrameOnly;
            }
        }
    }
    /// 全局背景色
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
    /// 全局缺省图片
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
    /// 链接 Modifier
    MAGWebImageURLModifierBlock modifierBlock = nil;
    if (mutableContext[MAGWebImageContextImageURLModifierKey]) {
        /// 传入则使用局部 Modifier
        modifierBlock = mutableContext[MAGWebImageContextImageURLModifierKey];
    } else {
        /// 是否启用全局 Modifier
        BOOL useGlobalImageURLModifier = YES;
        if (mutableContext[MAGWebImageContextUseGlobalImageURLModifierKey]) {
            useGlobalImageURLModifier = [mutableContext[MAGWebImageContextUseGlobalImageURLModifierKey] boolValue];
        }
        if (useGlobalImageURLModifier) {
            SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
            if (imageManager.magGlobalImageURLModifierBlock) {
                modifierBlock = imageManager.magGlobalImageURLModifierBlock;
            }
        }
    }
    context = [mutableContext copy];
    if (modifierBlock) {
        url = modifierBlock(self, self.magOriginImageURL, context);
    }
    [self mag_internalSetImageWithURL:url
                     placeholderImage:placeholder
                              options:options
                              context:context
                        setImageBlock:setImageBlock
                             progress:progressBlock
                            completed:completedBlock];
}

static const char MAGWebImageOriginalURLKey = '\0';

- (void)setMagOriginImageURL:(NSURL * _Nullable)magOriginImageURL
{
    objc_setAssociatedObject(self, &MAGWebImageOriginalURLKey, magOriginImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSURL *)magOriginImageURL
{
    return (NSURL *)objc_getAssociatedObject(self, &MAGWebImageOriginalURLKey);
}

@end

@implementation NSData (MAGWebCache)

- (BOOL)mag_isGIF
{
    SDImageFormat format = [NSData sd_imageFormatForImageData:self];
    return (format == SDImageFormatGIF);
}

- (BOOL)mag_isWebP
{
    SDImageFormat format = [NSData sd_imageFormatForImageData:self];
    return (format == SDImageFormatWebP);
}

@end

@implementation UIImage (MAGWebCache)

- (BOOL)mag_isGIF
{
    SDImageFormat format = [self sd_imageFormat];
    return (format == SDImageFormatGIF);
}

- (BOOL)mag_isWebP
{
    SDImageFormat format = [self sd_imageFormat];
    return (format == SDImageFormatWebP);
}

@end

#if MAGSDFLPluginEnabled

@implementation FLAnimatedImageView (MAGWebCache_FLAnimatedImageWrapper)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL originalSelector = @selector(setShouldAnimate:);
#pragma clang diagnostic pop
        SEL newSelector = @selector(mag_setShouldAnimate:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method newMethod = class_getInstanceMethod(self, newSelector);
        if (!originalMethod || !newMethod) return;
        
        class_addMethod(self,
                        originalSelector,
                        class_getMethodImplementation(self, originalSelector),
                        method_getTypeEncoding(originalMethod));
        class_addMethod(self,
                        newSelector,
                        class_getMethodImplementation(self, newSelector),
                        method_getTypeEncoding(newMethod));
        
        method_exchangeImplementations(class_getInstanceMethod(self, originalSelector),
                                       class_getInstanceMethod(self, newSelector));
    });
}

- (void)mag_setShouldAnimate:(BOOL)animated
{
    BOOL result = self.magAutoPlayFLAnimatedImage && animated;
    [self mag_setShouldAnimate:result];
}

static const char MAGWebImageFLAutoPlayAnimatedImagKey = '\0';

- (BOOL)magAutoPlayFLAnimatedImage
{
    BOOL result = YES;
    NSNumber *autoPlayAnimatedImage = (NSNumber *)objc_getAssociatedObject(self, &MAGWebImageFLAutoPlayAnimatedImagKey);
    if (autoPlayAnimatedImage) {
        result = [autoPlayAnimatedImage boolValue];
    } else {
        [self setMagAutoPlayFLAnimatedImage:result];
    }
    return result;
}

- (void)setMagAutoPlayFLAnimatedImage:(BOOL)magAutoPlayFLAnimatedImage
{
    objc_setAssociatedObject(self, &MAGWebImageFLAutoPlayAnimatedImagKey, @(magAutoPlayFLAnimatedImage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#endif

#endif
