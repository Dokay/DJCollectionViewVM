//
//  DJCollectionViewReusableTitleView.h
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMReusableView.h"
#import "DJCollectionViewVMReusable.h"

@interface DJCollectionViewReusableTitle : DJCollectionViewVMReusable

@property (nonatomic, strong) NSString *title;

@end

@interface DJCollectionViewReusableTitleView : DJCollectionViewVMReusableView

@property (nonatomic, strong) DJCollectionViewReusableTitle *reusableVM;


@end
