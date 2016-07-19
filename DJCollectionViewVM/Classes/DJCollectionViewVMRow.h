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

typedef NS_ENUM(NSInteger,DJCellHeightCaculateType){
    DJCellHeightCaculateDefault,//default
    DJCellHeightCaculateAutoFrameLayout,//layout use frame layout
    DJCellHeightCaculateAutoLayout,//layout use autolayout
};

@interface DJCollectionViewVMRow : NSObject

@property (weak, nonatomic) DJCollectionViewVMSection *section;
@property (copy, nonatomic  ) NSString *cellIdentifier;
@property (nonatomic, strong) NSObject *paramObject;
@property (nonatomic, assign) CGSize   itemSize;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (nonatomic, assign) DJCellHeightCaculateType heightCaculateType;
@property (nonatomic, assign) BOOL dj_caculateHeightForceRefresh;

@property (copy, nonatomic) void (^selectionHandler)(id row);

+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRow;
- (void)deleteRow;

@end
