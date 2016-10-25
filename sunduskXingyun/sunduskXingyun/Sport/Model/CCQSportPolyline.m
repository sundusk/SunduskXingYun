//
//  CCQSportPolyline.m
//  sunduskXingyun
//
//  Created by 神威 on 16/10/22.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSportPolyline.h"

@implementation CCQSportPolyline

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor *)color{
    
    CCQSportPolyline *polyline = [self polylineWithCoordinates:coords count:count];
    
    polyline.color = color;
    
    return polyline;
}
@end
