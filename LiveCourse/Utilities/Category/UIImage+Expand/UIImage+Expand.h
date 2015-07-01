//
//  UIImage+Expand.h
//  I8
//
//  Created by hvming on 13-7-17.
//  Copyright (c) 2013年 hvming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

CGFloat DegreesToRadians(CGFloat degrees);

CGFloat RadiansToDegrees(CGFloat radians);


@interface UIImage (Expand)

+ (void)saveOrginalImageToPath:(NSString *)filePath FromALAsset:(ALAsset *)asset;
+ (void)saveFullScreenImageAndThumbnailToDirPath:(NSString *)dirPath alasset:(ALAsset *)asset;
+ (NSData *)fullSizeDataForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;
+ (UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;

////////////////////////////////////////////////////////////////////////////////////

//方向纠正
- (UIImage *)fixOrientation;
//UIView to UIImage
+(UIImage *)convertToImageFromView:(UIView*)v;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

////////////////////////////////////////////////////////////////////////////////////

- (UIImage *)imageAtRect:(CGRect)rect;
//限制一个宽度来进行缩放
- (UIImage *)imageByScalingProportionallyToWidth:(CGFloat)constraintWidth;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

////////////////////////////////////////////////////////////////////////////////////

//改变image的颜色
-(UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;


////////////////////////////////////////////////////////////////////////////////////
//Alpha
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;


////////////////////////////////////////////////////////////////////////////////////
//RoundedCorner
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;


////////////////////////////////////////////////////////////////////////////////////

//Resize
- (UIImage *)croppedImage:(CGRect)bounds;
/*!
 * Returns a copy of this image that is squared to the thumbnail size.
 * If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
 */
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;




@end
