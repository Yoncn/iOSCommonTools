//
//  dataModel.h
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/5/27.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject <NSCoding>

@property (nonatomic,copy)NSString *modelName;
@property (nonatomic,copy)NSString *modelId;
@property (nonatomic,assign)int modelNumber;

- (NSDictionary *)changeModelToDictionary;
@end
