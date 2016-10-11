//
//  OpenCVWrapper.m
//  PhotoFilters&Text
//
//  Created by Saurabh Singh on 20/08/16.
//  Copyright © 2016 Saurabh Singh. All rights reserved.
//
//Implement function

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>

@implementation OpenCVWrapper

+(NSString *) openCVVersionString
{
    return [NSString stringWithFormat:@"OpenCV version %s",CV_VERSION];
}

@end
