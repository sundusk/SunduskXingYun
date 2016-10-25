//
//  CCQSportSportingViewController.m
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//
///测试
#import "CCQSportSportingViewController.h"
#import "CCQSportMapViewController.h"

@interface CCQSportSportingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mapButton;

/**
 运动地图控制器
 */
@property (strong , nonatomic) CCQSportMapViewController *mapViewController;

@end

@implementation CCQSportSportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setupMapViewController];
}

// 所有子控件布局完成，适合进一步设置其他控件的位置
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 设置罗盘位置
    CGFloat x = _mapButton.center.x - _mapViewController.mapView.compassSize.width * 0.5;
    CGFloat y = _mapButton.center.y - _mapViewController.mapView.compassSize.height * 0.5;
    
    _mapViewController.mapView.compassOrigin = CGPointMake(x, y);
    
}
#pragma mark - 监听方法
- (IBAction)showMapViewController {
    
   
    
    // 3. 模拟展现
    [self presentViewController:_mapViewController animated:YES completion:nil];
    
 
}
/**
 修改运动状态

 @param button button
 */
- (IBAction)changeSportState:(UIButton *)button{
    
    
    //修改地图控制器的运动状态
    _mapViewController.sportTracking.sportState = button.tag;
    
}


#pragma mark - 设置界面

/// 设置地图视图控制器

- (void)setupMapViewController{

    // 1. 通过 storyboard 实例化地图控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CCQSportSporting" bundle:nil];
    
    _mapViewController = [sb instantiateViewControllerWithIdentifier:@"sportMapViewController"];
    
    // 设置运动轨迹模型
    _mapViewController.sportTracking = [[CCQSportTracking alloc] initWithType:_sportType state:CCQportStateContinue];
}

@end
