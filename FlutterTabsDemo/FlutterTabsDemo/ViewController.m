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

@interface ViewController ()
@property (nonatomic, strong) NativeAViewController *nativeA;
@property (nonatomic, strong) FBFlutterViewContainer *flutterA;
@property (nonatomic, strong) FBFlutterViewContainer *flutterB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *vcArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.vcArray = @[].mutableCopy;
    
    self.nativeA = [NativeAViewController new];
    self.flutterA = [self flutterWithPage:@"flutterA"];
    self.flutterB = [self flutterWithPage:@"flutterB"];
    
    [self addVC:self.nativeA];
    [self addVC:self.flutterA];
    [self addVC:self.flutterB];
    
    self.segment.selectedSegmentIndex = 0;
    [self.segment sendActionsForControlEvents:UIControlEventValueChanged];
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
    [self.vcArray enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        vc.view.hidden = (idx != sender.selectedSegmentIndex);
    }];
    
}

@end
