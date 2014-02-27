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
#import "UIImage+averageColor.h"

#define ClippedImageWidth  50
#define ClippedImageHeight 50

@interface AGViewController ()
@property (strong, nonatomic)UIView* picker;
@property (strong, nonatomic)UIImage* screenShot;

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
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.screenShot CGImage], clippedRect);
        UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
        
        self.picker.backgroundColor = [newImage imageAverageColor];
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

@end
