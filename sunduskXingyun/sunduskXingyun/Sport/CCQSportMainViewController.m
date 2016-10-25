//
//  CCQSportMainViewController.m
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSportMainViewController.h"
#import "CCQSportSportingViewController.h"
#import "CCQSportTracking.h"
@interface CCQSportMainViewController ()

@end

@implementation CCQSportMainViewController

// 开始运动
- (IBAction)startSport:(UIButton *)sender {
    
    
    //1.根据按钮的tag 区分运动类型
    CCQSportType type = sender.tag;
    
    //2.从SB 加载监控控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CCQSportSporting" bundle:nil];
    CCQSportSportingViewController *vc = sb.instantiateInitialViewController;
    //3.设置运动类型
    vc.sportType = type;
    
    //4.展现控制器
    [self presentViewController:vc animated:YES completion:nil];
}


@end
