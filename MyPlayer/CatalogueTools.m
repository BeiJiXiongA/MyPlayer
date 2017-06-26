
//
//  CatalogueTools.m
//  MyPlayer
//
//  Created by zw on 17/6/27.
//  Copyright © 2017年 zw. All rights reserved.
//

#import "CatalogueTools.h"

@implementation CatalogueTools

+ (NSString *)getDocumentPathWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    return filePath;
}

+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}


@end
