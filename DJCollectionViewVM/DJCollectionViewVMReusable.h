//
//  DJCollectionViewVMReusable.h
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCollectionViewVMSection.h"

typedef NS_ENUM(NSInteger,DJReusableSizeCaculateType){
    DJReusableSizeCaculateTypeDefault,//default
//    DJCellSizeCaculateAutoFrameLayout,//layout use frame layout
    DJReusableSizeCaculateTypeAutoLayout,//layout use autolayout
};

@interface DJCollectionViewVMReusable : NSObject

@property (nonatomic, copy) NSString *reuseableIdentifier;
@property (nonatomic, weak) DJCollectionViewVMSection *section;
@property (nonatomic, strong) NSObject *paramObject;
@property (nonatomic, assign) CGSize   resuableSize;
@property (nonatomic, assign) DJReusableSizeCaculateType sizeCaculateType;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
