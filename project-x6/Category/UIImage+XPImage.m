//
//  UIImage+XPImage.m
//  project-x6
//
//  Created by Apple on 16/3/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIImage+XPImage.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIImage (XPImage)

+ (void)load
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
          method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)), class_getClassMethod(self, @selector(XPImageNamed:)));
    });
}

+ (UIImage *)XPImageNamed:(NSString *)imageName
{

    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resoures.bundle/Resoures"];
    NSString *filepath = [path stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:filepath];
  
    return image;

}
@end
