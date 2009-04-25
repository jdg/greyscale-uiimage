//
//  UIImage+Greyscale.h
//  Klepto
//
//  Created by Jonathan George on 4/25/09.
//  Copyright 2009 JDG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kRed   = 1,
	kGreen = 2,
	kBlue  = 4
} ColorMask;

@interface UIImage (Greyscale)

- (UIImage *) convertToGreyscale;

@end