

###### 一. 基本数据类型
1. CFTypeID                 
2. CFIndex                  
3. CFHashCode           
4. CFOptionFlags    
5. CFRange

都属于整形数据

5. Boolean、UInt8、SInt8 
> 都是  `char` 类型的，Boolean 和 UInt8 是 `unsigned char`，SInt8 是 `signed char`。


5. CFTypeRef 
> Base "type" of all "CF objects" 是 ` const void * `指针

###### 二. Foundation 和 Core Foundation 的数据类型是否可以无缝转换
可以搜索一下两个关键字：

`typedef const struct CF_BRIDGED_TYPE(oc_imutable_type)`
`typedef struct CF_BRIDGED_MUTABLE_TYPE(oc_mutable_type)`

如果有的话，就代表可以无缝转换；

例如 `NSString` 和 `CFStringRef` 在 `CFBase.h` 里面有定义如下：
`typedef const struct CF_BRIDGED_TYPE(NSString) __CFString * CFStringRef;`
`typedef struct CF_BRIDGED_MUTABLE_TYPE(NSMutableString) __CFString * CFMutableStringRef;`
以上说明 `NSString` 和 `CFStringRef` ，`NSMutableString` 和  `CFMutableStringRef` 是可以无缝转换的

`typedef const struct CF_BRIDGED_TYPE(NSNull) __CFNull * CFNullRef;`
说明 `NSNull` 和 `CFNullRef` 是可以无缝装换的



###### 功能
1. 定义数据类型
2. CFAllocator 的创建和获取
3. CFRelease、CFRetain、CFGetRetainCount、CFGetTypeID、CFEqual、CFHash
