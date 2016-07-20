//
//  DJCollectionViewVMReusable.h
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCollectionViewVMSection.h"

@interface DJCollectionViewVMReusable : NSObject

@property (nonatomic, copy) NSString *reuseableIdentifier;
@property (nonatomic, strong) NSObject *paramObject;
@property (nonatomic, assign) CGSize   resuableSize;
@property (nonatomic, weak) DJCollectionViewVMSection *section;

@end
