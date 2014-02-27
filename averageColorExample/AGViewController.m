//
//  AGViewController.m
//  averageColorExample
//
//  Created by Jingting Wang on 2/25/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import "AGViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define ClippedImageWidth  50
#define ClippedImageHeight 50

@interface AGViewController ()
@property (strong, nonatomic)UIView* picker;
@property (strong, nonatomic)UIImage* screenShot;
@property (strong, nonatomic)UIImage* myImage;

@end

@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dress2.png"]];
    
    UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width,self.view.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    self.screenShot = screenShot;
    UIGraphicsEndImageContext();
    
    self.picker = [[UIView alloc]initWithFrame:CGRectMake(70, 150, ClippedImageWidth, ClippedImageHeight)];
    [self.view addSubview:self.picker];
    self.picker.backgroundColor = [UIColor clearColor];
    self.picker.layer.borderColor = [[UIColor blueColor]CGColor];
    self.picker.layer.borderWidth = 3.0;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(onPan:)];
    [self.picker addGestureRecognizer:panRecognizer];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.screenShot];
}

-(void)onPan:(UIPanGestureRecognizer*)pan
{
    CGPoint offset = [pan translationInView:self.view];
    CGPoint center = pan.view.center;
    
    center.x += offset.x;
    center.y += offset.y;
    pan.view.center = center;
    
    [pan setTranslation:CGPointZero inView:self.view];
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        CGRect clippedRect  = CGRectMake(self.picker.frame.origin.x, self.picker.frame.origin.y, ClippedImageWidth, ClippedImageHeight);
        NSLog(@"x %f, y%f", self.picker.frame.origin.x, self.picker.frame.origin.y);

        CGImageRef imageRef = CGImageCreateWithImageInRect([self.screenShot CGImage], clippedRect);
        
        UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
        self.myImage = newImage;
        self.picker.backgroundColor = [UIColor colorWithPatternImage:newImage];
        self.picker.backgroundColor = [self averageColor];
    }
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)captureView:(UIView *)view withArea:(CGRect)screenRect {
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.myImage = newImage;
    return newImage;
}


- (UIColor *)averageColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char croppedImage[4 * ClippedImageWidth * ClippedImageHeight];
    CGContextRef context = CGBitmapContextCreate(croppedImage, ClippedImageWidth, ClippedImageHeight, 8, ClippedImageWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, ClippedImageWidth, ClippedImageHeight), self.myImage.CGImage);
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
