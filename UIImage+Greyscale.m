//
//  UIImage+Greyscale.m
//  Klepto
//
//  Created by Jonathan George on 4/25/09.
//  Copyright 2009 JDG. All rights reserved.
//

#import "UIImage+Greyscale.h"

@implementation UIImage (Greyscale)

- (UIImage *) convertToGreyscale {
	int colors = kGreen;
	int m_width = self.size.width;
	int m_height = self.size.height;

	uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(rgbImage,  m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGContextSetShouldAntialias(context, NO);
	CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [self CGImage]);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	// now convert to grayscale
	uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
	for(int y = 0; y < m_height; y++) {
		for(int x = 0; x < m_width; x++) {
			uint32_t rgbPixel=rgbImage[y*m_width+x];
			uint32_t sum=0,count=0;
			if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
			if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
			if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
			m_imageData[y*m_width+x]=sum/count;
		}
	}
	free(rgbImage);

	// convert from a gray scale image back into a UIImage
	uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);

	// process the image back to rgb
	for(int i = 0; i < m_height * m_width; i++) {
		result[i*4]=0;
		int val=m_imageData[i];
		result[i*4+1]=val;
		result[i*4+2]=val;
		result[i*4+3]=val;
	}

	// create a UIImage
	colorSpace = CGColorSpaceCreateDeviceRGB();
	context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	CGImageRelease(image);

	// make sure the data will be released by giving it to an autoreleased NSData
	[NSData dataWithBytesNoCopy:result length:m_width * m_height];

	return resultUIImage;
}

@end