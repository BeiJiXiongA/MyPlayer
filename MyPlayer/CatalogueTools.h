//
//  CatalogueTools.h
//  MyPlayer
//
//  Created by zw on 17/6/27.
//  Copyright © 2017年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogueTools : NSObject

+(NSString *)getImageDirectoryPath:(NSString *)fileName;

+ (NSString *)getDocumentPathWithName:(NSString *)fileName;

@end
