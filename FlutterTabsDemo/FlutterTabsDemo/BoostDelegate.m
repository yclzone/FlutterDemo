//
//  BoostDelegate.m
//  FlutterTabsDemo
//
//  Created by yclzone on 2021/10/12.
//

#import "BoostDelegate.h"
#import <flutter_boost/FBFlutterViewContainer.h>

@implementation BoostDelegate

static BoostDelegate *_instance = nil;
typedef void(^onPageFinished)(NSDictionary *arguments);

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}
- (instancetype)init{
    if (self = [super init]) {
        self.resultTable = NSMutableDictionary.new;
    }
    return self;
}
- (void)popRoute:(FlutterBoostRouteOptions *)options {
    BOOL isAnimated = (options.arguments[@"isAnimated"] == nil)?true:((NSNumber *)options.arguments[@"isAnimated"]).boolValue;

    //如果当前被present的vc是container，那么就执行dismiss逻辑
    FBFlutterViewContainer *vc = (FBFlutterViewContainer *)self.navigationController.presentedViewController;
    if ([[vc uniqueIDString] isEqualToString:options.uniqueId]) {
        //这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
        //所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
        if (vc.modalPresentationStyle == UIModalPresentationOverFullScreen) {
            //这里手动beginAppearanceTransition触发页面生命周期
            [self.navigationController.topViewController beginAppearanceTransition:true animated:false];
            [vc dismissViewControllerAnimated:true completion:^{
                [self.navigationController.topViewController endAppearanceTransition];
            }];
        }else{
            //正常场景，直接dismiss
            [vc dismissViewControllerAnimated:true completion:nil];
        }
    }else{
        //否则直接执行pop逻辑
        [self.navigationController popViewControllerAnimated:isAnimated];
    }
    //这里在pop的时候将参数带出,并且从结果表中移除
    onPageFinished oPageFinished = self.resultTable[options.pageName];
    if (oPageFinished) {
        oPageFinished(options.arguments);
        [self.resultTable removeObjectForKey:options.pageName];
    }
}

- (void)pushFlutterRoute:(FlutterBoostRouteOptions *)options {
    
    //用参数来控制是push还是pop
    BOOL isPresent  = ((NSNumber *)options.arguments[@"isPresent"]).boolValue;
    BOOL isAnimated = ((NSNumber *)options.arguments[@"isAnimated"]?:@YES).boolValue;
    
    FBFlutterViewContainer *targetViewController = [[FBFlutterViewContainer alloc] init];
    [targetViewController setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];
    
    //对这个页面设置结果
    self.resultTable[options.pageName] = options.onPageFinished;
    //如果是present模式 ，或者要不透明模式，那么就需要以present模式打开页面
    if(isPresent || !options.opaque){
        [self.navigationController presentViewController:targetViewController animated:isAnimated completion:^{
            if (options.completion) {
                options.completion(YES);
            }
        }];
    }else{
        [self.navigationController pushViewController:targetViewController animated:isAnimated];
        if (options.completion) {
            options.completion(YES);
        }
    }
}

- (void)pushNativeRoute:(NSString *)pageName arguments:(NSDictionary *)arguments {
    //可以用参数来控制是push还是pop
    BOOL isPresent  = ((NSNumber *)arguments[@"isPresent"]).boolValue;
    BOOL isAnimated = ((NSNumber *)arguments[@"isAnimated"]?:@YES).boolValue;
    //这里根据pageName来判断生成哪个vc，这里给个默认的了
    UIViewController *targetViewController = [[UIViewController alloc] init];
    if(isPresent){
        [self.navigationController presentViewController:targetViewController animated:isAnimated completion:^{}];
    }else{
        [self.navigationController pushViewController:targetViewController animated:isAnimated];
    }
}

@end
