//
//  CCQSportGPSSignalButton.h
//  sunduskXingyun
//
//  Created by 夜兔神威 on 16/10/25.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 GPS信号强度提示按钮
 
 IB_DESIGNABLE 表示该视图可以在 IB 中设置属性
 */
IB_DESIGNABLE
@interface CCQSportGPSSignalButton : UIButton
/**
 是否地图界面按钮
 */
@property (nonatomic, assign) IBInspectable BOOL isMapButton;
@end
