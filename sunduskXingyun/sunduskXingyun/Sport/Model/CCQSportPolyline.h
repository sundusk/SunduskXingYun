//
//  CCQSportPolyline.h
//  sunduskXingyun
//
//  Created by 神威 on 16/10/22.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

/**
 自定义折线模型，增加了颜色的属性
 */
@interface CCQSportPolyline : MAPolyline

/**
 折线的颜色
 */
@property (strong , nonatomic) UIColor *color;


/**
 构造函数

 @param coords 坐标数组
 @param count  坐标数组的容量
 @param color  折线的颜色

 @return 折线模型
 */
+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor*)color;
@end
