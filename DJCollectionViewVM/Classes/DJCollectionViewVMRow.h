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

@interface DJCollectionViewVMRow : NSObject

@property (weak, nonatomic) DJCollectionViewVMSection *section;
@property (copy, nonatomic  ) NSString *cellIdentifier;
@property (nonatomic, strong) NSObject *paramObject;
@property (nonatomic, assign) CGSize   itemSize;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (copy, nonatomic) void (^selectionHandler)(id row);
@property (nonatomic, copy) void(^prefetchHander)(id rowVM);
@property (nonatomic, copy) void(^prefetchCancelHander)(id rowVM);

+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRow;
- (void)deleteRow;

@end
