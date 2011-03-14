//
//  ArtexpoStylesheet.m
//  TTTwitter
//
//  Created by Milo Winningham on 3/5/10.
//  Copyright 2010 Art Market Tools. All rights reserved.
//

#import "ArtexpoStylesheet.h"
#import "Three20Style/Three20Style.h"


@implementation ArtexpoStylesheet

- (UIFont*)tableSummaryFont {
  return [UIFont systemFontOfSize:15];
}

- (UIColor *)navigationBarTintColor {
  return [UIColor colorWithRed:11.0/255.0 green:142.0/255.0 blue:187.0/255.0 alpha:1.0];
}

- (UIColor *)toolbarTintColor {
  return [self navigationBarTintColor];
}

- (UIColor *)tabTintColor {
  return [self navigationBarTintColor];
}

-(UIColor *)tabBarTintColor {
  return [self navigationBarTintColor];
}

@end
