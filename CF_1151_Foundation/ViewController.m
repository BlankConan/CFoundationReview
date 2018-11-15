//
//  ViewController.m
//  CF_1151_Foundation
//
//  Created by liugangyi on 2018/11/13.
//  Copyright © 2018年 liugangyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

void functionA(const void *value, void *context) {
    
}


@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSString *str = @"小朋友";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    CFDataRef ref = (__bridge CFDataRef)data;
//    NSLog(@"%ld", (long)CFDataGetLength(ref));
//    NSLog(@"%ld", (long)CFDataGetTypeID());
//
//    CFBundleRef bundleRef = CFBundleGetBundleWithIdentifier((__bridge CFStringRef)@"com.tianfutong.www.CF-1151-Foundation");
//
//    CFDictionaryRef infoDicRef = CFBundleGetInfoDictionary(bundleRef);
//    NSDictionary *dic = (__bridge NSDictionary *)infoDicRef;
//    NSLog(@"%@", dic);
//
//    CFStringRef iden = CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleDevelopmentRegionKey);
//    NSLog(@"%@", (__bridge NSString *)iden);
//
//
//    CFDictionaryRef localDicRef = CFBundleGetLocalInfoDictionary(CFBundleGetMainBundle());
//    if (localDicRef) {
//
//    }
//
//    CFArrayRef architecturesArrRef = CFBundleCopyExecutableArchitectures(CFBundleGetMainBundle());
//    NSLog(@"%@", (__bridge NSArray *)architecturesArrRef);
//
//    CFURLRef urlRef = CFBundleCopyBundleURL(CFBundleGetMainBundle());
//    NSLog(@"%@", ((__bridge NSURL *)urlRef).absoluteString);
//
//    CFURLRef resoureUrl = CFBundleCopyResourcesDirectoryURL(CFBundleGetMainBundle());
//    NSLog(@"%@", ((__bridge NSURL *)resoureUrl).absoluteString);
//    CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, nil, nil);
    
    NSArray *array = @[@"1", @"2", @"3", @"4", @"3", @"2"];
    CFArrayRef arRef = (__bridge CFArrayRef)array;
    CFIndex count = CFArrayGetCount(arRef);
    NSLog(@"%ld", count);
    CFIndex rangCount = CFArrayGetCountOfValue(arRef, CFRangeMake(0, count-1), @"3");
    NSLog(@"%ld", rangCount);
    
}


@end
