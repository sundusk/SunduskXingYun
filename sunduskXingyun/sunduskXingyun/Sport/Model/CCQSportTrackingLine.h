//
//  CCQSportTrackingLine.h
//  sunduskXingyun
//
//  Created by 神威 on 16/10/22.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCQSportPolyline.h"
#import <MAMapKit/MAMapKit.h>
/**
 轨迹追踪线条模型，记录起始点和结束点
 */
@interface CCQSportTrackingLine : NSObject

/**
 起始点
 */
@property (strong , nonatomic , readonly) CLLocation *startLocation;

/**
 结束点
 */
@property (strong , nonatomic , readonly) CLLocation *endLocation;

/**
 描述起始点和结束点之间的折线模型
 */
@property (nonatomic , readonly) CCQSportPolyline *polyine;


/**
 起始点和结束点之间的平均速度   单位是  公里 / 每小时
 */
@property (nonatomic , readonly) double speed;


/**
 起始点和结束点之间的时间差值  单位 ： 公里
 */
@property (nonatomic , readonly) NSTimeInterval time;

/**
 起始点和结束点之间的距离
 */
@property (nonatomic , readonly) double distance;
/**
 使用起始点和结束点，实例化线条模型

 @param startLocation 起始点
 @param endLocation   结束点

 @return 轨迹追踪线条模型
 */
- (instancetype)initWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation;


@end
