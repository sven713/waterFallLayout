//
//  SVClose.h
//  11.5瀑布流
//
//  Created by sven on 15/11/6.
//  Copyright © 2015年 sven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVClose : NSObject
/**
 *  图片高度
 */
@property (nonatomic, assign) NSInteger h;
/**
 *  图片strin
 */
@property (nonatomic, copy) NSString *img;
/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  图片宽度
 */
@property (nonatomic, assign) NSInteger w;
@end


/*
 key>h</key>
 <integer>275</integer>
 <key>img</key>
 <string>http://s13.mogujie.cn/b7/bao/131012/vud8_kqywordekfbgo2dwgfjeg5sckzsew_310x426.jpg_200x999.jpg</string>
 <key>price</key>
 <string>¥169</string>
 <key>w</key>
 <integer>200</integer>
 */