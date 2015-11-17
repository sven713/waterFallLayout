//
//  SVCloseCell.m
//  11.5瀑布流
//
//  Created by sven on 15/11/6.
//  Copyright © 2015年 sven. All rights reserved.
//

#import "SVCloseCell.h"
#import "UIImageView+WebCache.h"

@interface SVCloseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *closeImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end

@implementation SVCloseCell

-(void)setClose:(SVClose *)close {
    _close = close;
//    self.closeImgView.image = [UIImage imageNamed:self.close.img];
    NSURL *url = [NSURL URLWithString:close.img];
//    NSLog(@"url%@",url);
    [self.closeImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLbl.text = self.close.price;
//    NSLog(@"%@",self.closeImgView);
}
@end
