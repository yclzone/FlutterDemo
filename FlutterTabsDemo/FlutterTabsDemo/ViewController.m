//
//  ViewController.m
//  FlutterTabsDemo
//
//  Created by yclzone on 2021/10/11.
//

#import "ViewController.h"
#import <flutter_boost/FBFlutterViewContainer.h>
#import <Masonry/Masonry.h>

#import "NativeAViewController.h"
#import "FlutterAViewController.h"
#import "FlutterBViewController.h"

@interface ViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) NativeAViewController *nativeA;
@property (nonatomic, strong) FBFlutterViewContainer *flutterA;
@property (nonatomic, strong) FBFlutterViewContainer *flutterB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *vcArray;
@end

@implementation ViewController


- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<UIPageViewControllerOptionsKey,id> *)options {
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.vcArray = @[].mutableCopy;
    
    self.nativeA = [NativeAViewController new];
    self.flutterA = [self flutterWithPage:@"flutterA"];
    self.flutterB = [self flutterWithPage:@"flutterB"];
    
//    [self addVC:self.nativeA];
//    [self addVC:self.flutterA];
//    [self addVC:self.flutterB];
    
    [self.vcArray addObject:self.nativeA];
    [self.vcArray addObject:self.flutterA];
    [self.vcArray addObject:self.flutterB];
    
    
    self.dataSource = self;
    self.delegate = self;
    [self setViewControllers:@[self.nativeA] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
//    self.segment.selectedSegmentIndex = 0;
//    [self.segment sendActionsForControlEvents:UIControlEventValueChanged];
}

- (FBFlutterViewContainer *)flutterWithPage:(NSString *)pageName {
    FBFlutterViewContainer *vc = [FBFlutterViewContainer new];
    [vc setName:pageName uniqueId:nil params:nil opaque:YES];
    return vc;
}

- (void)addVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.hidden = YES;
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [vc didMoveToParentViewController:self];
    [self.vcArray addObject:vc];
}

- (IBAction)semgentOnChangd:(UISegmentedControl *)sender {
//    [self.vcArray enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
//        vc.view.hidden = (idx != sender.selectedSegmentIndex);
//    }];
    
    [self setViewControllers:@[self.vcArray[sender.selectedSegmentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger idx = [self.vcArray indexOfObject:viewController];
    if (idx == 0 || idx == NSNotFound) {
        return nil;
    }
    idx--;
    return [self vcAtIndex:idx];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger idx = [self.vcArray indexOfObject:viewController];
    if (idx == 0 || idx == NSNotFound) {
        return nil;
    }
    idx++;
    return [self vcAtIndex:idx];
}

- (UIViewController *)vcAtIndex:(NSUInteger)idx {
    return self.vcArray[idx];
}

@end
