//
//  SVCloseCollectionViewController.m
//  11.5瀑布流
//
//  Created by sven on 15/11/5.
//  Copyright © 2015年 sven. All rights reserved.
//

#import "SVCloseCollectionViewController.h"
#import "SVWaterFallLayout.h"
#import "SVClose.h"
#import "MJExtension.h"
#import "SVCloseCell.h"
#import "MJRefresh.h"

@interface SVCloseCollectionViewController ()<SVWaterFallLayoutDelegate>

@property(nonatomic, strong) NSMutableArray *closesArr;
@property (nonatomic, strong) SVWaterFallLayout *layout;
@end

@implementation SVCloseCollectionViewController

-(NSInteger)columCount:(SVWaterFallLayout *)layout {
    return 4;
}

-(CGFloat)marginX:(SVWaterFallLayout *)layout {
    return 10;
}

-(CGFloat)marginY:(SVWaterFallLayout *)layout {
    return 10;
}

-(UIEdgeInsets)edgeForWaterFall:(SVWaterFallLayout *)layout {
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

#warning second
-(CGFloat)waterFallLayout:(SVWaterFallLayout *)layout indexPath:(NSIndexPath *)path itemWith:(CGFloat)width {
    // ss
    NSLog(@"-");
    SVClose *close = self.closesArr[path.item]; // 在这里用到indexPath参数的!要从懒加载数组中获取数据
    CGFloat hight = close.h / (CGFloat)close.w * width;
    return hight;
}
static NSString * const reuseIdentifier = @"Cell";
#warning first
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SVWaterFallLayout *layout = [[SVWaterFallLayout alloc] init];
    self.collectionView.collectionViewLayout = layout;
    layout.delegate = self;
#warning 添加 的layout属性
    self.layout = layout;
    #pragma mark 使用block
    [layout cellHeighet:^CGFloat(NSIndexPath *path, CGFloat width) {
        SVClose *close = self.closesArr[path.item]; // 3
        CGFloat hight = close.h / (CGFloat)close.w * width;
        return hight;
    }];
    
    // 从网络加载
    NSArray *arr = [SVClose objectArrayWithFilename:@"clothes.plist" error:nil];
    [self.closesArr addObjectsFromArray:arr];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSArray *tempArr = [SVClose objectArrayWithFilename:@"clothes.plist"];
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArr.count)];
        [weakSelf.closesArr insertObjects:tempArr atIndexes:set];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.header endRefreshing];
        NSLog(@"%@",tempArr);
        NSLog(@"%ld",weakSelf.closesArr.count);
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSArray *tempArr = [SVClose objectArrayWithFilename:@"clothes.plist"];
        [weakSelf.closesArr addObjectsFromArray:tempArr];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.footer endRefreshing];
                NSLog(@"%@",tempArr);
                NSLog(@"%ld",weakSelf.closesArr.count);
    }];
//    NSLog(@"%ld",self.closesArr.count);
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",self.closesArr.count);
    return self.closesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SVCloseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    self.layout.close = self.closesArr[indexPath.item];
    cell.close = self.closesArr[indexPath.item];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(NSMutableArray *)closesArr {
    if (!_closesArr) {
        // 加载plist数据
        _closesArr = [[NSMutableArray alloc] init];
    }
    return _closesArr;
}
@end
// collectionView registerClass tableView不哟????
// 目标:加载数据-拖plist,创建模型,字典转模型,从网络加载的数据,在viewDidLoad里面字典转模型
// 自定义cell,设置图片和
// get方法声明
// 先写最核心的协议
// 如果别人设置edge为负值怎么办?判断,报错?