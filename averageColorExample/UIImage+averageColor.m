//
//  UIImage+averageColor.m
//  averageColorExample
//
//  Created by Jingting Wang on 2/27/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import "UIImage+averageColor.h"

@implementation UIImage (averageColor)

-(CGSize)mySize
{
    return self.size;
}


-(UIColor *)imageAverageColor:(CGSize)imageSize {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int ClippedImageWidth = (int)imageSize.width;
    int ClippedImageHeight = (int)imageSize.height;
    
    unsigned char croppedImage[4 * ClippedImageWidth * ClippedImageHeight];
    CGContextRef context = CGBitmapContextCreate(croppedImage, ClippedImageWidth, ClippedImageHeight, 8, ClippedImageWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Drawing the image to the context, make sure the image size is equal to context rect size
    CGContextDrawImage(context, CGRectMake(0, 0, ClippedImageWidth, ClippedImageHeight), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    float averagedAlphaTotal = 0.0;
    float averagedRedTotal = 0.0;
    float averagedGreenTotal = 0.0;
    float averagedBlueTotal = 0.0;
    
    for (int i = 0; i < sizeof(croppedImage) / 4; i++) {
        averagedRedTotal += croppedImage[i * 4];
        averagedGreenTotal += croppedImage[i * 4 + 1];
        averagedBlueTotal += croppedImage[i * 4 + 2];
        averagedAlphaTotal += croppedImage[i * 4 + 3];
    }
    
    return [UIColor colorWithRed:averagedRedTotal / sizeof(croppedImage) * 4 / 255.0
                           green:averagedGreenTotal / sizeof(croppedImage) * 4 / 255.0
                            blue:averagedBlueTotal / sizeof(croppedImage) * 4 / 255.0
                           alpha:averagedAlphaTotal / sizeof(croppedImage)* 4 /255.0];
    
}


// reference http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/
@end
