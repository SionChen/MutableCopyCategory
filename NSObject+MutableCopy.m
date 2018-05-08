//
//  NSObject+MutableCopy.m
//  Project_Dms
//
//  Created by 超级腕电商 on 2018/5/8.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "NSObject+MutableCopy.h"

@implementation NSObject (MutableCopy)
-(id)getMutableCopy{
    NSArray * keys = [self getObjcPropertyWithClass:[self class]];
    id objc = [[[self class] alloc] init];
    for (NSString * key in keys) {
        if ([self valueForKey:key] == nil) continue;
        [objc setValue:[self valueForKey:key] forKey:key];
    }
    return objc;
}

- (NSArray<NSString *> *)getObjcPropertyWithClass:(id )objc{
    //(1)获取类的属性及属性对应的类型
    NSMutableArray * keys = [NSMutableArray array];
    NSMutableArray * attributes = [NSMutableArray array];
    /*
     * 例子
     * name = value3 attribute = T@"NSString",C,N,V_value3
     * name = value4 attribute = T^i,N,V_value4
     */
    unsigned int outCount;
    Class cls = [objc class];
    do {
        objc_property_t * properties = class_copyPropertyList(cls, &outCount);
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过property_getAttributes函数可以获得属性的名字和@encode编码
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        //立即释放properties指向的内存
        free(properties);
        cls = [objc superclass];
        objc = [cls new];
    } while ([NSStringFromClass([objc superclass]) isEqualToString:@"NSObject"]);
    return [keys valueForKeyPath:@"@distinctUnionOfObjects.self"];
}
@end
