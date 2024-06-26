//
//  MLNViewController.m
//  MLNCore
//
//  Created by MoMo on 07/23/2019.
//  Copyright (c) 2019 MoMo. All rights reserved.
//

#import "MLNLuaGalleryViewController.h"
#import "MLNTestMe.h"
#import "MLNStaticTest.h"
#import "MLNGlobalVarTest.h"
#import "MLNGlobalFuncTest.h"
#import "MLNKitInstance.h"
#import "MLNKitInstanceHandlersManager.h"
#import "MLNHotReloadViewController.h"
#import "MLNOfflineViewController.h"
#import "MLNFloatingMenu.h"
#import "MLNGalleryViewController.h"
#import "MLNKitViewController.h"
#import "MLNFPSLabel.h"
#import "MLNLoadTimeStatistics.h"
#import "MLNGalleryNative.h"
#import "MLNLuaPageViewController.h"
#import "MLNGalleryMainViewController.h"

@interface MLNLuaGalleryViewController () <MLNViewControllerProtocol, MLNKitInstanceDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) MLNKitInstance *kitInstance;

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIButton *galleryButton;
@property (nonatomic, strong) MLNFPSLabel *fpsLabel;
@property (nonatomic, strong) UILabel *loadTimeLabel;
@property (nonatomic, strong) MLNLoadTimeStatistics *loadTimeStatistics;

@end

@implementation MLNLuaGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubController];
    
    if (!kMemoryTest) {
        [self setupSubviews];
    }
}

- (void)setupSubController
{
    [[MLNLoadTimeStatistics sharedInstance] recordStartTime];
    
    if (kLuaPage) {
        NSString *entryFile = @"meilishuo.lua";
        MLNLuaBundle *bundle = [MLNLuaBundle mainBundleWithPath:@"gallery.bundle"];
        MLNLuaPageViewController *viewController = [[MLNLuaPageViewController alloc] initWithEntryFilePath:entryFile];
        viewController.kitInstance.delegate = self;
        [viewController regClasses:@[[MLNTestMe class],
                          [MLNStaticTest class],
                          [MLNGlobalVarTest class],
                          [MLNGlobalFuncTest class]]];
        [viewController changeCurrentBundle:bundle];
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        self.contentViewController = viewController;
    } else {
        MLNGalleryMainViewController *mainVc = [[MLNGalleryMainViewController alloc] init];
        [self addChildViewController:mainVc];
        [self.view addSubview:mainVc.view];
        self.contentViewController = mainVc;
    }
}

- (void)setupSubviews
{
    CGFloat galleryButtonW = 80;
    CGFloat galleryButtonH = 30;
    CGFloat galleryButtonX = kScreenWidth - galleryButtonW - 10;
    CGFloat galleryButtonY = 22;
    self.galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.galleryButton.frame = CGRectMake(galleryButtonX, galleryButtonY, galleryButtonW, galleryButtonH);
    [self.galleryButton setTitle:@"调试点我" forState:UIControlStateNormal];
    self.galleryButton.backgroundColor = [UIColor orangeColor];
    [self.galleryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.galleryButton addTarget:self action:@selector(galleryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.galleryButton];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.fpsLabel = [[MLNFPSLabel alloc] initWithFrame:CGRectMake(10, screenHeight * 0.8, 50, 20)];
    self.fpsLabel.hidden = YES;
    [self.contentViewController.view addSubview:self.fpsLabel];
}

- (void)galleryButtonClicked:(id)sender
{
    MLNGalleryViewController *galleryVc = [[MLNGalleryViewController alloc] init];
    [self.navigationController pushViewController:galleryVc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!kMemoryTest) {
        [self showLuaScriptLoadTime];
    }
}

#pragma mark - Private method

- (void)showLuaScriptLoadTime
{
//    [self.contentViewController.view addSubview:self.loadTimeLabel];
    self.loadTimeLabel.text = [NSString stringWithFormat:@"%.0f ms", [self.loadTimeStatistics luaCoreCreateTime] * 1000];
    CGSize loadTimeLabelSize = [self.loadTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat loadTimeLabelY = [UIScreen mainScreen].bounds.size.height * 0.75;
    self.loadTimeLabel.frame = CGRectMake(10, loadTimeLabelY, loadTimeLabelSize.width + 10, loadTimeLabelSize.height + 10);
}

- (void)hideLuaScriptLoadTime
{
    self.loadTimeLabel.hidden = YES;
}

- (UILabel *)loadTimeLabel
{
    if (!_loadTimeLabel) {
        _loadTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadTimeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _loadTimeLabel.textColor = [UIColor whiteColor];
        _loadTimeLabel.font = [UIFont systemFontOfSize:12];
        _loadTimeLabel.textAlignment = NSTextAlignmentCenter;
        _loadTimeLabel.adjustsFontSizeToFitWidth = YES;
        _loadTimeLabel.numberOfLines = 0;
    }
    return _loadTimeLabel;
}


@end
