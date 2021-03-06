//
//  ADVTheme.m
//  MovieBeam
//
//  Created by Tope Abayomi on 07/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "HLTheme.h"

@implementation HLTheme

+ (NSString*)boldFont{
    return @"Avenir-Black";
}

+ (NSString*)mainFont{
    return @"Avenir-Light";
}

+ (UIColor*)mainColor{
    
    //return [UIColor colorWithRed:(74.0/255.0) green:(165.0/255.0) blue:(254.0/255.0) alpha:1.0];
   // return [UIColor colorWithRed:(1.0/255.0) green:(109.0/255.0) blue:(215.0/255.0) alpha:1.0];
    return [UIColor colorWithRed:(3.0/255.0) green:(130.0/255.0) blue:(254.0/255.0) alpha:1.0];

   // return [UIColor colorWithRed:(253.0/255.0) green:(92.0/255.0) blue:(89.0/255.0) alpha:1.0];
}

+(UIColor *)secondColor{
    
    return [UIColor colorWithRed:(74.0/255.0) green:(165.0/255.0) blue:(254.0/255.0) alpha:1.0];
}

+(UIColor *)buttonColor{
    
    return [UIColor colorWithRed:(255.0/255.0) green:(118.0/255.0) blue:(102.0/255.0) alpha:1.0];

}

+(UIColor *)textColor{
    
    return [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    
}


+(UIColor *)emptyBackgroundColor{
    
     return [UIColor colorWithRed:(1.0/255.0) green:(109.0/255.0) blue:(215.0/255.0) alpha:1.0];

}

+ (UIColor*)foregroundColor{
    return [UIColor whiteColor];
}

+ (UIColor*)viewBackgroundColor{
    return [UIColor colorWithWhite:0.95f alpha:1.0f];
}

+ (UIImage *)progressTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-track"];
    return image;
}

+ (UIImage *)progressProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-fill"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    return image;
}

+ (UIImage *)progressPercentTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progressTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14.0, 30.0, 14.0, 30.0)];
    return image;
}

+ (UIImage *)progressPercentProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progressProgress"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)];
    return image;
}

+ (UIImage *)progressPercentProgressValueImage {
    UIImage *image = [UIImage imageNamed:@"progressValue"];
    return image;
}

+(void)customizeTheme{
    
   // [UINavigationBar appearance].tintColor = [self mainColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[self mainColor]];
    NSMutableDictionary* navbarAttributes = [NSMutableDictionary dictionary];
    navbarAttributes[NSFontAttributeName] = [UIFont fontWithName:[self boldFont] size:19.0f];
    navbarAttributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1.0f alpha:1.0f];
    [UINavigationBar appearance].titleTextAttributes = navbarAttributes;
    
   [[UITabBar appearance] setTintColor:[self mainColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
  //  UITabBar* tabBarAppearance = [UITabBar appearance];
//    [tabBarAppearance setSelectionIndicatorImage:[[UIImage imageNamed:@"tab_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
  //  tabBarAppearance.tintColor = [self mainColor];
    NSMutableDictionary* segmentAttributes = [NSMutableDictionary dictionary];
    segmentAttributes[NSFontAttributeName] = [UIFont fontWithName:[self mainFont] size:12.0f];
    [[UISegmentedControl appearance] setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
    
    UISlider *sliderAppearance = [UISlider appearance];
    
    
    UIImage* sliderMinTrackImage = [[UIImage imageNamed:@"sliderMinTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    UIImage* sliderMaxTrackImage = [[UIImage imageNamed:@"sliderMinTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    UIImage* sliderThumbImage = [[UIImage imageNamed:@"sliderThumb"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    
    [sliderAppearance setThumbImage:sliderThumbImage forState:UIControlStateNormal];
    [sliderAppearance setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [sliderAppearance setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
    
}

+(void)customizeTabBar:(UITabBar*)tabBar{
    
    int index = 1;
    for (UITabBarItem* tabItem in tabBar.items) {
        NSString* imageName = [NSString stringWithFormat:@"tab%d", index++];
        tabItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(5.0, 0.0, -5.0, 0.0);
        tabItem.imageInsets = insets;
    }
}

@end
