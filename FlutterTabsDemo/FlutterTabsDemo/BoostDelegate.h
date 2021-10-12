//
//  BoostDelegate.h
//  FlutterTabsDemo
//
//  Created by yclzone on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import <flutter_boost/FlutterBoostDelegate.h>
NS_ASSUME_NONNULL_BEGIN

@interface BoostDelegate : NSObject<FlutterBoostDelegate>
+ (instancetype)shareInstance;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableDictionary *resultTable;
@end

NS_ASSUME_NONNULL_END
