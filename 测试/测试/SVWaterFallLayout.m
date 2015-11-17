//
//  SVWaterFallLayout.m
//  11.5瀑布流
//
//  Created by sven on 15/11/5.
//  Copyright © 2015年 sven. All rights reserved.
//

#import "SVWaterFallLayout.h"


#define SVScreenWidth self.collectionView.frame.size.width
/**列数*/
static const NSInteger SVDefaultColumCount = 3;
/**列间距*/
static const CGFloat SVDefaultMarginColum = 20;
/**行间距*/
static const CGFloat SVDefaultMarginRow = 10;
/**四边间距*/
static const UIEdgeInsets SVEdge = {10,10,10,10};
@interface SVWaterFallLayout ()
/**每列最大的yz坐标值数组*/
@property (nonatomic, strong) NSMutableArray *columMaxYArr;

@property (nonatomic, strong) NSMutableArray *attsArr;

- (NSInteger)columCount;
- (CGFloat)marginX;
- (CGFloat)marginY;
- (UIEdgeInsets)customEdge;


@property (nonatomic, copy) CGFloat(^block)(NSIndexPath *,CGFloat);



@end

@implementation SVWaterFallLayout

#pragma mark lazy
#warning 1
-(NSMutableArray *)columMaxYArr {
    if (!_columMaxYArr) {
        _columMaxYArr = [NSMutableArray arrayWithCapacity:3];
    }
    return _columMaxYArr;
    
//    <#returnType#>(^<#blockName#>)(<#parameterTypes#>) = ^(<#parameters#>) {
//        <#statements#>
//    };
}

#warning 3
-(NSMutableArray *)attsArr {
    if (!_attsArr) {
        _attsArr = [NSMutableArray array];
    }
    return _attsArr;
}

#warning 2
-(void)prepareLayout { // Tells the layout object to update the current layout.
    [super prepareLayout];
    [self.columMaxYArr removeAllObjects];
    for (int i = 0; i < self.columCount; i ++) {
        [self.columMaxYArr addObject:@(0)];
    }
    
    [self.attsArr removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:idxPath];
        [self.attsArr addObject:atts];
    }
    
}

#warning 4
// 指定某个cell的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *atts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]; // 类方法创建atts
    
    // 计算最短一列的frame     找出最短的列号和y坐标
    CGFloat minY = [self.columMaxYArr[0] doubleValue];
    NSInteger minYColum = 0;
    for (int i = 0; i < self.columMaxYArr.count; i ++) {
        if (minY > [self.columMaxYArr[i] doubleValue]) {
            minY = [self.columMaxYArr[i] doubleValue];
            minYColum = i;
        }
    }
    // 宽度=(View宽度-(列数 - 1)*列间距 - 水平间距 * 2) / 列数
    // 宽度=(vi)
    CGFloat width = (SVScreenWidth - (self.columCount - 1) * self.marginX - self.customEdge.left - self.customEdge.right) / self.columCount;
//    CGFloat height = 50 + arc4random_uniform(100);
    
    // 请代理去获取图片高度
//    CGFloat height = [self.delegate waterFallLayout:self indexPath:indexPath itemWith:width];
    
    
    CGFloat height = self.block(indexPath,width); // 2
//    CGFloat height = self.close.h / (CGFloat)self.close.w * width;
//    CGFloat height = 20;
    
//    NSLog(@"---%f",height); // third
    CGFloat x = (width + self.marginX) * minYColum + self.customEdge.left;
    //
    CGFloat y = minY + self.marginY;
    atts.frame = CGRectMake(x, y, width, height);
    self.columMaxYArr[minYColum] = @(CGRectGetMaxY(atts.frame)); // 数组中保存的cgFloat???
    
    return atts;
}
#pragma mark 使用block
-(void)cellHeighet:(CGFloat (^)(NSIndexPath *, CGFloat))height {
    self.block = height; // 1
}

#warning 5  拖动会调用
-(CGSize)collectionViewContentSize { // Returns the width and height of the collection view’s contents.
    CGFloat minY = [self.columMaxYArr[0] doubleValue];
    for (int i = 0; i < self.columMaxYArr.count; i ++) {
        if (minY < [self.columMaxYArr[i] doubleValue]) {
            minY = [self.columMaxYArr[i] doubleValue];
        }
    }
    return CGSizeMake(SVScreenWidth, minY + self.customEdge.bottom);
}
#warning 调用的先后顺序? 6 拖动会调用
/// 指定所有cell的布局属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSLog(@"xxxx");
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < self.attsArr.count; i ++) {
        UICollectionViewLayoutAttributes *atts = self.attsArr[i];
        if(CGRectIntersectsRect(rect, atts.frame)) {
            [arr addObject:atts];
        }
    }// 普通对象不消耗性能,只添加了屏幕范围内的属性
    return arr; // 19.7M 性能更好
    /*
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:idxPath];
        [arr addObject:atts];
    }
    return arr;*/
    
//    return self.attsArr; // 22.9 ui对象比较占内存
}

#pragma mark 处理代理数据
-(NSInteger)columCount { // 调用顺序?这是重写的get方法,等号右边
    if ([self.delegate respondsToSelector:@selector(columCount:)]) {
        return [self.delegate columCount:self];
    }
    return SVDefaultColumCount;
}
-(CGFloat)marginX {
    if ([self.delegate respondsToSelector:@selector(marginX:)]) {
        return [self.delegate marginX:self];
    }
    return SVDefaultMarginColum;
}
- (CGFloat)marginY {
    if ([self.delegate respondsToSelector:@selector(marginY:)]) {
        return [self.delegate marginY:self];
    }
    return SVDefaultMarginRow;
}
-(UIEdgeInsets)customEdge {
    if ([self.delegate respondsToSelector:@selector(edgeForWaterFall:)]) {
        return [self.delegate edgeForWaterFall:self];
    }
    return SVEdge;
}
@end
// static const UIEdgeInsets SVEdge = {10,10,10,10};
// 数组为空会崩溃,重写perpare方法
