//
//  CCQSportMapViewController.h
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCQSportTracking.h"
/// 运动地图控制器
@interface CCQSportMapViewController : UIViewController

/**
 本次运动轨迹追踪模型
 */
@property (nonatomic, strong) CCQSportTracking *sportTracking;

/**
 地图视图
 */
@property (nonatomic, weak, readonly) MAMapView *mapView;
@end
