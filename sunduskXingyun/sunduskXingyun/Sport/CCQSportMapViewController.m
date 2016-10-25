//
//  CCQSportMapViewController.m
//  sunduskXingyun
//
//  Created by 神威 on 16/10/21.
//  Copyright © 2016年 ccq. All rights reserved.
//

#import "CCQSportMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CCQSportTrackingLine.h"
#import "CCQCircleAnimator.h"
#import "CCQSportMapModeViewController.h"
#import "CCQSportMapModeViewController.h"
@interface CCQSportMapViewController ()<MAMapViewDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation CCQSportMapViewController{
    /// 是否设置大头针
    BOOL _hasSetStartLocation;
    /// 同心圆转场动画器
    CCQCircleAnimator *_circleAnimator;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        // 设置转场代理
        _circleAnimator = [CCQCircleAnimator new];
        self.transitioningDelegate = _circleAnimator;
    }
    
    
    
    
    return self;
}
- (void)awakeFromNib{
     [super awakeFromNib];
     [self setupMapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
   
}

#pragma mark - 监听方法
- (IBAction)closeMapView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - popover
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // 1.判断跳转控制器的类型
    if(![segue.destinationViewController isKindOfClass:[CCQSportMapModeViewController class]]){
        return;
    }
    
    CCQSportMapModeViewController *vc = (CCQSportMapModeViewController *)segue.destinationViewController;
    
    // 2.验证popover 和传统模态之间的区别，如果要自定义 popover 的样式，就可以通过 popoverPresentationController
    NSLog(@"%@",vc.popoverPresentationController);
    
    // 3.设置代理
    vc.popoverPresentationController.delegate = self;
    
    // 4.设置喜欢的大小，如果width设置为0，宽度交给系统设置
    vc.preferredContentSize = CGSizeMake(0, 120);
    // 5. 设置地图视图的显示模式
    [vc setDidSelectedMapMode:^(MAMapType type) {
        self.mapView.mapType = type;
    }];
    
    // 6. 设置 vc 的当前显示模式
    vc.currentType = _mapView.mapType;

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    // 不让系统自适应
    return UIModalPresentationNone;
}

#pragma mark - MAMapViewDelegate
    
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    // 0. 判断 `位置数据` 是否变化 - 不一定是经纬度变化！
    if (!updatingLocation) {
        return;
    }
    
    // 1. 判断运动状态，只有`继续`才需要绘制运动轨迹
    if (_sportTracking.sportState != CCQportStateContinue) {
        return;
    }
    
    // 将用户位置设置在地图视图的中心点
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    
    // 大概 1s 更新一次！
    // NSLog(@"%@ %p", userLocation.location, userLocation.location);
    
    // 在所有的地图框架中，在最开始定位的时候，尤其在室内定位非常糟糕，通常位置不准确！
    // 当用户在 户外 运动 的时候，定位会非常准确！
    // 判断起始位置是否存在
    if (!_hasSetStartLocation && _sportTracking.sportStartLocation != nil) {
        _hasSetStartLocation = YES;
        
        // 1. 实例化大头针
        MAPointAnnotation *annotaion = [MAPointAnnotation new];
        
        // 2. 指定坐标位置
        annotaion.coordinate = _sportTracking.sportStartLocation.coordinate;
        
        // 3. 添加到地图视图
        [mapView addAnnotation:annotaion];
    }
    
    // 绘制轨迹模型
    [mapView addOverlay:[_sportTracking appendLocation:userLocation.location]];
    
    [self updateUIDisplay];
    
}

/**
 更新UI显示
 */
-(void)updateUIDisplay{
    // 1.设置距离
    _distanceLabel.text = [NSString stringWithFormat:@"%.02f",_sportTracking.totalDistance];
    
    // 2.设置时间
    
    _timeLable.text = _sportTracking.totalTimeStr;
    
    
}


    
// 需要实现MAMapViewDelegate的-mapView:rendererForOverlay:
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    // 1.判断 overlay 类型
    if (![overlay isKindOfClass:[MAPolyline class]]){
        
        return nil;
    }
    
    // 2.实例化折现渲染器
    CCQSportPolyline *polyline = (CCQSportPolyline *)overlay;
    MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:polyline];
    
    // 3.设置显示属性
    renderer.lineWidth = 5;
    renderer.strokeColor = [UIColor greenColor];
    

    return renderer;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    // 0.判断大头针的类型
    if (![annotation isKindOfClass:[MAPointAnnotation class]]) {
        return nil;
    }
    
    // 1.查询可重用大头针视图
    static NSString *annotaionId = @"annotaionId";
    MAAnnotationView *annotaionView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotaionId];
    
    // 2.如果没有查到，新建视图
    if (annotaionView == nil){
        
        annotaionView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotaionId];
    }
    
    // 3.设置大头针视图 - 设置图片
    UIImage *image = _sportTracking.sportImage;;

    
    annotaionView.image = image;
    annotaionView.centerOffset = CGPointMake(0,-image.size.height * 0.5);
    
    // 4.返回自定义大头针视图
    return annotaionView;
}

#pragma mark - 设置界面

/// 设置地图视图
- (void)setupMapView{
    
    // 1.实例化地图视图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    // 2.添加到根视图
    [self.view insertSubview:mapView atIndex:0];
    
    // 3.隐藏比例尺
    mapView.showsScale = NO;
    
    // 4.关闭相机旋转 - 能够降低能喊，省电
    mapView.rotateCameraEnabled = NO;
    
    // 5.显示用户位置
    mapView.showsUserLocation = YES;
    
    // 6.跟踪用户位置  - 可以将用户定位在地图中心，并且放大地图
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // 7.允许后台定位
    mapView.allowsBackgroundLocationUpdates = YES;
    
    // 8.不允许系统暂停位置定位
    mapView.pausesLocationUpdatesAutomatically = NO;
    
    // 9.设置代理
    mapView.delegate = self;
    
    // 10.记录地图视图
    _mapView = mapView;
}
@end
