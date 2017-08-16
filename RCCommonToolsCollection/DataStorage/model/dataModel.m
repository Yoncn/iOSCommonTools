//
//  dataModel.m
//  RCCommonToolsCollection
//
//  Created by rongchen on 2017/5/27.
//  Copyright © 2017年 Yoncn. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.modelName forKey:@"modelName"];
    [aCoder encodeObject:self.modelId forKey:@"modelId"];
    [aCoder encodeInt:self.modelNumber forKey:@"modelNumber"];
}


//解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.modelName = [aDecoder decodeObjectForKey:@"modelName"];
        self.modelId = [aDecoder decodeObjectForKey:@"modelId"];
        self.modelNumber = [aDecoder decodeIntForKey:@"modelNumber"];
    }
    return self;
}

- (NSDictionary *)changeModelToDictionary {
    NSDictionary *dic = @{@"modelName":self.modelName,@"modelId":self.modelId,@"modelNumber":[NSNumber numberWithInt:self.modelNumber]};
    return dic;
}










@end
