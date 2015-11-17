//
//  SVWaterFallLayout.h
//  11.5瀑布流
//
//  Created by sven on 15/11/5.
//  Copyright © 2015年 sven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVClose.h"

@class SVWaterFallLayout;
@protocol SVWaterFallLayoutDelegate <NSObject>

@required

- (CGFloat)waterFallLayout:(SVWaterFallLayout *)layout indexPath:(NSIndexPath *)path itemWith:(CGFloat)width;

@optional

- (NSInteger)columCount:(SVWaterFallLayout *)layout;

- (CGFloat)marginX:(SVWaterFallLayout *)layout;

- (CGFloat)marginY:(SVWaterFallLayout *)layout;

- (UIEdgeInsets)edgeForWaterFall:(SVWaterFallLayout *)layout;

@end



@interface SVWaterFallLayout : UICollectionViewLayout

@property (nonatomic, strong) id<SVWaterFallLayoutDelegate> delegate;
#pragma mark 使用block
- (void)cellHeighet:(CGFloat(^)(NSIndexPath *path,CGFloat width))height;

@property (nonatomic, copy) CGFloat(^newblock)(NSIndexPath *idx,CGFloat w);

@property (nonatomic, strong)  SVClose*close;
@end

// 代理的步骤:1.写协议,2,协议方法 3,协议属性 4,代理调用协议方法,5.控制器遵守协议,完成代理方法6.指定关联代理
// 代理要实现什么功能?根据图片比例,计算图片高度,调用这个方法得到图片高度

// 代理方法第一个参数是自身(设计协议的类),index,控制器的模型要用,和width,设置协议的
// + (void)loadNewsWithURLString:(NSString *)urlString finished:(void (^)(NSArray *))finished {