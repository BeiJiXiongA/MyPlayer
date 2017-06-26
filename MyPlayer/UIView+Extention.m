//
//  UIView+Extention.m
//  MyPlayer
//
//  Created by zw on 16/3/26.
//  Copyright © 2016年 zw. All rights reserved.
//

#import "UIView+Extention.h"

@implementation UIView (Extention)
-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGFloat)left
{
    return self.frame.origin.x;
}

-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)top
{
    return self.frame.origin.y;
}

-(CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
@end
