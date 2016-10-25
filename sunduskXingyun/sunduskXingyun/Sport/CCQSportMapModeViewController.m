//
//  CCQSportMapModeViewController.m
//  sunduskXingyun
//
//  Created by 夜兔神威 on 16/10/25.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSportMapModeViewController.h"

@interface CCQSportMapModeViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mapButtons;
@end

@implementation CCQSportMapModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置按钮的初始选中状态
    for (UIButton *btn in _mapButtons) {
        // 判断按钮的 tag 是否和 当前地图类型一致
        btn.selected = (btn.tag == _currentType);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectedMapMode:(UIButton *)sender{
    // 0. 判断按钮的 tag 是否与当前的地图类型一致
    if (sender.tag == _currentType) {
        return;
    }
    _currentType = sender.tag;
    
    // 1. 设置地图类型
    if (_didSelectedMapMode != nil) {
        _didSelectedMapMode(_currentType);
    }
    
    // 2. 设置按钮的选中状态
    for (UIButton *btn in _mapButtons) {
        // 判断和参数按钮是否一致
        btn.selected = (btn == sender);
    }

}

@end
