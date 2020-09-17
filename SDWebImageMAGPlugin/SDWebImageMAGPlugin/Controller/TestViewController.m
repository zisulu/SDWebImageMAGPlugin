//
//  TestViewController.m
//  SDWebImageMAGPlugin
//
//  Created by luwenlong on 2019/4/23.
//  Copyright © 2019 lyeah. All rights reserved.
//

#import "TestViewController.h"
#import "UIImageView+MAGWebCache.h"
#import "MAGWebImageConfig.h"

@interface MAGImageView : SDAnimatedImageView

- (void)setImagesWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock;

@end

@implementation MAGImageView

- (void)setImagesWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:completedBlock];
}

@end

@interface TestViewController ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) SDAnimatedImageView *imageView2;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MAGWebImageConfig setupSDWebImage];
    
    self.imageView1 = [UIImageView new];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView1];
    
    self.imageView2 = [SDAnimatedImageView new];
    self.imageView2.autoPlayAnimatedImage = NO;
    self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView2.magPreferedSize = CGSizeMake(100, 100);
    [self.view addSubview:self.imageView2];
    
    NSURL *staticWebPURL = [NSURL URLWithString:@"https://www.gstatic.com/webp/gallery/2.webp"];
    NSURL *animatedWebPURL = [NSURL URLWithString:@"http://littlesvr.ca/apng/images/world-cup-2014-42.webp"];
    NSURL *animatedGIFURL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556085525711&di=d384bbc45c79d4ff6dae4bd876070afe&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160825%2F2c3cd3f9145448bd843ab9fb5a624dd2_th.gif"];
    
    [self.imageView1 sd_setImageWithURL:staticWebPURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"%@:%@", @"Static WebP load success", imageURL);
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *webpData = [image sd_imageDataAsFormat:SDImageFormatWebP];
            if (webpData) {
                NSLog(@"%@", @"WebP encoding success");
            }
        });
    }];
//    [self.imageView2 sd_setImageWithURL:animatedWebPURL modifier:^NSURL * _Nullable(__kindof UIImageView * _Nonnull sd_imageView, NSURL * _Nullable originImageURL, SDWebImageContext * _Nonnull context) {
//        NSString *imageUrl = originImageURL.absoluteString;
//        imageUrl = [NSString stringWithFormat:@"%@?%@&width=%.0f&height=%.0f", imageUrl, @"params=12345", sd_imageView.magPreferedWidth, sd_imageView.magPreferedHeight];
//        return [NSURL URLWithString:imageUrl];
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image) {
//            NSLog(@"%@:%@", @"Animated WebP load success", imageURL.absoluteString);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.imageView2 startAnimating];
//                NSLog(@"Animated WebP startAnimating");
//            });
//        }
//    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.imageView1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2);
    self.imageView2.frame = CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2);
}

@end
