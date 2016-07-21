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

/**
 *  section ViewModel that current row belong to.
 */
@property (nonatomic, weak) DJCollectionViewVMSection *section;

/**
 *  cell reuse identifier.
 */
@property (nonatomic, copy) NSString *cellIdentifier;

/**
 *  param object for custom tmp data cache.
 */
@property (nonatomic, strong) NSObject *paramObject;

/**
 *  size of UICollectionViewCell be mapped.
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 *  backgroundColor of UICollectionViewCell be mapped.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 *  backgroundView of UICollectionViewCell be mapped.
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *  selectedBackgroundView of UICollectionViewCell be mapped.
 */
@property (nonatomic, strong) UIView *selectedBackgroundView;

/**
 *  SizeCaculateType for current UICollectionViewCell.
 */
@property (nonatomic, assign) DJCellSizeCaculateType sizeCaculateType;

/**
 *  whether or not caculate size every time when the cell appears.
 */
@property (nonatomic, assign) BOOL dj_caculateSizeForceRefresh;

/**
 *  response to select cell.
 */
@property (nonatomic, copy) void (^selectionHandler)(id row);
@property (nonatomic, copy) void(^prefetchHander)(id rowVM);
@property (nonatomic, copy) void(^prefetchCancelHander)(id rowVM);

@property (nonatomic, copy) BOOL (^moveCellHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) NS_AVAILABLE_IOS(9_0);
@property (nonatomic, copy) void (^moveCellCompletionHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) NS_AVAILABLE_IOS(9_0);

+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRow;
- (void)deleteRow;

@end
