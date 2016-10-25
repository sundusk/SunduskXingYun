//
//  CCQSportTracking.m
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSportTracking.h"

/// GPS 信号变化通知
NSString *const CCQSportGPSSignalChangedNotification = @"CCQSportGPSSignalChangedNotification";
@implementation CCQSportTracking{
    /// 起始点位置
    CLLocation *_startLocation;
    /// 所有运动线条模型的数组
    NSMutableArray <CCQSportTrackingLine *>*_trackingLines;
    
    /// GPS 之前定位到的点
    CLLocation *_gpsPreLocation;
}

- (instancetype)initWithType:(CCQSportType)type state:(CCQSportState)state {
    self = [super init];
    if (self) {
        _sportType = type;
        _sportState = state;
        
        _trackingLines = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 设置数据
- (void)setSportState:(CCQSportState)sportState {
    _sportState = sportState;
    
    // 判断状态类型，如果不是继续，需要清空起始点
    if (_sportState != CCQportStateContinue) {
        _startLocation = nil;
    }
}

#pragma mark - 计算型属性&公共方法
- (CLLocation *)sportStartLocation {
    // 返回运动轨迹线条数组中，第一个线条的起点
    return _trackingLines.firstObject.startLocation;
}

- (UIImage *)sportImage {
    
    UIImage *image;
    switch (_sportType) {
        case CCQSportTypeRun:
            image = [UIImage imageNamed:@"map_annotation_run"];
            break;
        case CCQSportTypeWalk:
            image = [UIImage imageNamed:@"map_annotation_walk"];
            break;
        case CCQSportTypeBike:
            image = [UIImage imageNamed:@"map_annotation_bike"];
            break;
    }
    
    return image;
}

/**
 监测 GPS 信号
 
 @return 返回 GPS 状态
 */
- (CCQSportGPSSignalState)gpsSignalWithLocation:(CLLocation *)location {
    
    CCQSportGPSSignalState state = CCQSportGPSSignalStateBad;
    
    // 1. 验证 speed 监测室内定位的情况 -1.00
    if (location.speed < 0) {
        [self postNotifyWithState:state];
        
        return state;
    }
    
    // NSLog(@"时间差值 %f", [[NSDate date] timeIntervalSinceDate:location.timestamp]);
    // 2. 判断是否有前一个记录点
    if (_gpsPreLocation == nil) {
        _gpsPreLocation = location;
        
        [self postNotifyWithState:state];
        
        return state;
    }
    
    // 测试两个定位点之间的时间差值
    NSTimeInterval delta = ABS([location.timestamp timeIntervalSinceDate:_gpsPreLocation.timestamp]);
    
    // 如果时间差值越大，意味着 GPS 的信号越差！时间差值如果在大概 1s 左右，意味着 GPS 的信号越好！
    // * 验证结论 - 真机验证结论 越接近 0 信号越好！
    // 1> 发送通知
    // 2> 在界面上注册通知并且更新 UI
    delta = ABS(delta - 1);
    
    // 3> 根据时间差值计算 GPS 强度枚举
    if (delta < 0.01) {
        state = CCQSportGPSSignalStateGood;
    } else if (delta < 1) {
        state = CCQSportGPSSignalStateNormal;
    }
    
    [self postNotifyWithState:state];
    
    // 3. 记录之前的点
    _gpsPreLocation = location;
    
    return state;

}

/**
 发送 GPS 信号强度枚举通知
 
 @param state GPS 信号强度枚举
 */
- (void)postNotifyWithState:(CCQSportGPSSignalState)state {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CCQSportGPSSignalChangedNotification object:@(state)];
}



/**
 追加用户当前位置
 
 @param location 地图定位到的位置
 
 @return 返回折线模型
 */
- (CCQSportPolyline *)appendLocation:(CLLocation *)location {
    
    // 测试时间戳
    // NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:location.timestamp]);
    

    // 判断 GPS 信号
    if ([self gpsSignalWithLocation:location] < CCQSportGPSSignalStateNormal) {
        return nil;
    }
    
    // 0. 判断速度是否发生变化 - 性能优化，室内定位，速度有可能为`负数`
    if (location.speed <= 0) {
        return nil;
    }
    
    // 判断定位的时间差值，暂时定义一个时间差值因子 - 性能优化（避免室内出现杂线）
    CGFloat factor = 2;
    if ([[NSDate date] timeIntervalSinceDate:location.timestamp] > factor) {
        // 如果超过时间差值，就认为定位的精度不够
        return nil;
    }
    
    // 1. 判断是否存在起始点
    if (_startLocation == nil) {
        
        _startLocation = location;
        
        return nil;
    }
    
    // 2. 创建追踪线条模型
    CCQSportTrackingLine *trackingLine = [[CCQSportTrackingLine alloc] initWithStartLocation:_startLocation endLocation:location];
    
    [_trackingLines addObject:trackingLine];
    
    // 测试`总`时长 - `KVC` - sum 能够计算数组中的汇总数据，返回类型是 NSNumber
    //NSLog(@"%@ %@", [_trackingLines valueForKeyPath:@"@sum.time"], [[_trackingLines valueForKeyPath:@"@sum.time"] class]);
    // NSLog(@"%f - %f - %f - %f", self.avgSpeed, self.maxSpeed, self.totalTime, self.totalDistance);
    
    // 3. 将当前位置设置成下一次的起始点
    _startLocation = location;
    
    // 4. 返回折线模型
    return trackingLine.polyine;
}

- (double)avgSpeed {
    return [[_trackingLines valueForKeyPath:@"@avg.speed"] doubleValue];
}

- (double)maxSpeed {
    return [[_trackingLines valueForKeyPath:@"@max.speed"] doubleValue];
}

- (double)totalTime {
    return [[_trackingLines valueForKeyPath:@"@sum.time"] doubleValue];
}

- (NSString *)totalTimeStr {
    
    NSInteger totalTime = (NSInteger)self.totalTime;
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60];
}

- (double)totalDistance {
    return [[_trackingLines valueForKeyPath:@"@sum.distance"] doubleValue];
}
@end
