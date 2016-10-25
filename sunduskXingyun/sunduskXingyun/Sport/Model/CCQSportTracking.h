//
//  CCQSportTracking.h
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCQSportTrackingLine.h"
/// GPS 信号变化通知
extern NSString *const CCQSportGPSSignalChangedNotification;
/// 运动类型枚举
typedef enum : NSUInteger {
    CCQSportTypeRun,
    CCQSportTypeWalk,
    CCQSportTypeBike,
} CCQSportType;

/// 运动状态枚举
typedef enum : NSUInteger {
    CCQSportStatePause,
    CCQportStateContinue,
    CCQportStateFinish,
} CCQSportState;
/// GPS信号状态
typedef enum : NSUInteger {
    CCQSportGPSSignalStateDisconnect,
    CCQSportGPSSignalStateBad,
    CCQSportGPSSignalStateNormal,
    CCQSportGPSSignalStateGood
} CCQSportGPSSignalState;


/**
 单次运动轨迹追踪模型
 */
@interface CCQSportTracking : NSObject

/**
 使用运动类型实例化追踪模型
 
 @param type type
 
 @return 追踪模型
 */
- (instancetype)initWithType:(CCQSportType)type state:(CCQSportState)state;

/**
 运动类型
 */
@property (nonatomic, assign, readonly) CCQSportType sportType;

/**
 运动状态
 */
@property (nonatomic, assign) CCQSportState sportState;

/**
 运动的起点
 */
@property (nonatomic, readonly) CLLocation *sportStartLocation;

/**
 运动图像
 */
@property (nonatomic, strong, readonly) UIImage *sportImage;

/**
 追加用户当前位置，返回折线模型
 
 @param location location
 
 @return 折线模型
 */
- (CCQSportPolyline *)appendLocation:(CLLocation *)location;

/**
 平均速度
 */
@property (nonatomic, readonly) double avgSpeed;
/**
 最大速度
 */
@property (nonatomic, readonly) double maxSpeed;
/**
 总时长
 */
@property (nonatomic, readonly) double totalTime;
/**
 总时长 00:00:00 格式的字符串
 */
@property (nonatomic, readonly) NSString *totalTimeStr;
/**
 总距离
 */
@property (nonatomic, readonly) double totalDistance;
@end
