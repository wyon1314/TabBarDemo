//
//  TabBarViewController.m
//  TabbarDemo
//
//  Created by 王永刚 on 2020/7/28.
//  Copyright © 2020 wyon. All rights reserved.
//

#import "TabBarViewController.h"


@interface QYTabBar : UITabBar

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation QYTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        //设置tabbar背景
        self.backgroundImage = [UIImage imageNamed:@"tabbar_icon_bg"];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
     
    Class class = NSClassFromString(@"UITabBarButton");
    int index = 0;
    for (UIView *subView in self.subviews){
        if ([subView isKindOfClass:class]) {
            if (index == 2) {
                //index=2时为中间按钮，添加
                self.imageView.frame = CGRectMake(0, -13.5, subView.frame.size.width, subView.frame.size.height + 13.5);
                [subView insertSubview:self.imageView atIndex:0];
            }
            index ++;
        }
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_icon_addbg"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end







#import "ViewController.h"

@interface TabBarViewController () <UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setInterfaceCfg];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //移除tabbar自带的黑色线条
    for (UIView *subView in self.tabBar.subviews) {
        
        if (subView && [subView isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            for (UIView *obj in subView.subviews) {
                if (obj && obj.frame.size.height <= 1.0) {
                    obj.hidden = YES;
                }
            }
        }
        
    }
    
}


- (void)setInterfaceCfg {

    //设置代理
    self.delegate = self;
    //设置Tabbar
    [self setValue:[[QYTabBar alloc] init] forKey:@"tabBar"];
    
    //添加子控制器
    NSMutableArray *VCAry   = [NSMutableArray array];
    NSArray *VCName  = @[@"ViewController",
                         @"ViewController",
                         @"ViewController",
                         @"ViewController",
                         @"ViewController"];
    NSArray *itemTitles = @[@"发现", @"直播", @"", @"消息", @"我的"];
    NSArray *imgArray   = @[@"tabbar_icon_find",
                            @"tabbar_icon_room",
                            @"",
                            @"tabbar_icon_msg",
                            @"tabbar_icon_mine"];
    NSArray *selectImgArray = @[@"tabbar_icon_findsel",
                                @"tabbar_icon_roomsel",
                                @"",
                                @"tabbar_icon_msgsel",
                                @"tabbar_icon_minesel"];
    
    for (int i = 0; i < VCName.count; i ++) {
        
        NSString *vcNameStr = VCName[i];
        Class VCClass = NSClassFromString(vcNameStr);
        UIViewController *controller = [[VCClass alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:controller];
        
        UIImage *commonImage = [[UIImage imageNamed:imgArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:selectImgArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:itemTitles[i] image:commonImage selectedImage:selectedImage];
        navVC.tabBarItem = item;
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
        //title上调
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2.0)];
        
        [VCAry addObject:navVC];
        
    }
    self.viewControllers = VCAry;
    self.selectedIndex = 0;
    
}

#pragma mark - Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@""]) {
        
        //do something
        NSLog(@"点击发布按钮");
        
        return NO;
    }
    
    return YES;
    
}

@end
