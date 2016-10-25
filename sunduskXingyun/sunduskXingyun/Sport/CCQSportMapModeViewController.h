//
//  CCQSportMapModeViewController.h
//  sunduskXingyun
//
//  Created by 夜兔神威 on 16/10/25.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
/**
 地图模式选择控制器
 */

@interface CCQSportMapModeViewController : UIViewController

/**
 选中地图类型
 */
@property (nonatomic, copy) void (^didSelectedMapMode)(MAMapType mapType);

/**
 当前地图显示类型
 */
@property (nonatomic, assign) MAMapType currentType;

@end
