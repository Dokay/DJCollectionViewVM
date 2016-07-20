//
//  DJCollectionViewVMRow.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class DJCollectionViewVMSection;

#define DJDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

typedef NS_ENUM(NSInteger,DJCellSizeCaculateType){
    DJCellSizeCaculateDefault,//default
    DJCellSizeCaculateAutoFrameLayout,//layout use frame layout
    DJCellSizeCaculateAutoLayout,//layout use autolayout
};

@interface DJCollectionViewVMRow : NSObject

@property (nonatomic, weak) DJCollectionViewVMSection *section;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) NSObject *paramObject;
@property (nonatomic, assign) CGSize rowSize;
@property (nonatomic, assign) CGSize itemSize DJDeprecated(rowSize);

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (nonatomic, assign) DJCellSizeCaculateType sizeCaculateType;
@property (nonatomic, assign) BOOL dj_caculateSizeForceRefresh;

@property (nonatomic, copy) void (^selectionHandler)(id row);
@property (nonatomic, copy) void(^prefetchHander)(id rowVM);
@property (nonatomic, copy) void(^prefetchCancelHander)(id rowVM);

@property (nonatomic, copy) BOOL (^moveCellHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCellCompletionHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRow;
- (void)deleteRow;

@end
