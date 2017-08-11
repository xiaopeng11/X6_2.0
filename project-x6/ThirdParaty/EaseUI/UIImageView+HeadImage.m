/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


#import "UIImageView+HeadImage.h"


@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"pho-moren"];
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactList = [userdefaults objectForKey:X6_Contactlist];
    for (NSDictionary *dic in contactList) {
        if ([[dic valueForKey:@"username"] isEqualToString:username] || [[dic valueForKey:@"nickname"] isEqualToString:username]) {
            [self sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"avatar"]] placeholderImage:placeholderImage];
            return;
        }  else {
            [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
        }
    }
    
}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactList = [userdefaults objectForKey:X6_Contactlist];
    for (NSDictionary *dic in contactList) {
        if ([[dic valueForKey:@"username"] isEqualToString:username] || [[dic valueForKey:@"nickname"] isEqualToString:username]) {
            [self setText:[dic valueForKey:@"nickname"]];
            [self setNeedsLayout];
            return;
        } else {
            [self setText:username];
        }
    }

}

@end
