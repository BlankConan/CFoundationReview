
##### CFArray
1. 构建
2. 组成
3. API

###### CFArray 本质
在 `CFArray.h` 文件中的 **131** 行有定义：

`typedef const struct CF_BRIDGED_TYPE(NSArray) __CFArray * CFArrayRef;`

在 `CFArray.c` 文件可以看到 ` __CFArray` 的定义：

```
struct __CFArray {
    CFRuntimeBase _base;
    CFIndex _count;        /* number of objects */
    CFIndex _mutations;
    int32_t _mutInProgress;
    __strong void *_store;           /* can be NULL when MutableDeque */
};
```
由此可知 `CFArrayRef` 是一个  `__CFArray` 结构体指针

###### CFArray 对元素的内存管理
在  `CFArray.h` 文件的 **97** 行开始有定义：

```
typedef const void *    (*CFArrayRetainCallBack)(CFAllocatorRef allocator, const void *value);
typedef void        (*CFArrayReleaseCallBack)(CFAllocatorRef allocator, const void *value);
typedef CFStringRef    (*CFArrayCopyDescriptionCallBack)(const void *value);
typedef Boolean        (*CFArrayEqualCallBack)(const void *value1, const void *value2);
typedef struct {
    CFIndex                version;
    CFArrayRetainCallBack        retain;
    CFArrayReleaseCallBack        release;
    CFArrayCopyDescriptionCallBack    copyDescription;
    CFArrayEqualCallBack        equal;
} CFArrayCallBacks;
```
在数组创建的时候创建此结构体，并把指针作为参数传入创建函数中。

###### CFArrayCreate 函数分析

` CFArrayRef CFArrayCreate(CFAllocatorRef allocator, const void **values, CFIndex numValues, const CFArrayCallBacks *callBacks) `

文档中的对此函数的注释如下(摘取):

```
@param allocator The CFAllocator which should be used to allocate
memory for the array and its storage for values.

@param values A C array of the pointer-sized values to be in the
array. 

@param numValues The number of values to copy from the values C array into the CFArray. This number will be the count of the array.

@param callBacks A pointer to a CFArrayCallBacks structure
```

在 `.c` 文件中查看创建方法，发现返回值为：

`return __CFArrayCreate0(allocator, values, numValues, callBacks);`
由此可知有函数 `__CFArrayCreate0` 进行了具体的创建工作


` __CFArrayCreate0 ` 函数的定义如下：

`CF_PRIVATE CFArrayRef __CFArrayCreate0(CFAllocatorRef allocator, const void **values, CFIndex numValues, const CFArrayCallBacks *callBacks) {} `

定义了此函数为 `CF_PRIVATE` 是私有函数，返回值为 `CFArrayRef` 

`__CFArrayCreate0()` 函数内部实现:

```
CF_PRIVATE CFArrayRef __CFArrayCreate0(CFAllocatorRef allocator, const void **values, CFIndex numValues, const CFArrayCallBacks *callBacks) {
    CFArrayRef result;
    const CFArrayCallBacks *cb;
    struct __CFArrayBucket *buckets;
    CFAllocatorRef bucketsAllocator;
    void* bucketsBase;
    CFIndex idx;
    CFAssert2(0 <= numValues, __kCFLogAssertion, "%s(): numValues (%d) cannot be less than zero",       __PRETTY_FUNCTION__, numValues);
    result = __CFArrayInit(allocator, __kCFArrayImmutable, numValues, callBacks);
    cb = __CFArrayGetCallBacks(result);
    buckets = __CFArrayGetBucketsPtr(result);
    bucketsAllocator = isStrongMemory(result) ? allocator : kCFAllocatorNull;
    bucketsBase = CF_IS_COLLECTABLE_ALLOCATOR(bucketsAllocator) ? (void *)auto_zone_base_pointer(objc_collectableZone(), buckets) : NULL;
    if (NULL != cb->retain) {
        for (idx = 0; idx < numValues; idx++) {
            __CFAssignWithWriteBarrier((void **)&buckets->_item, (void *)INVOKE_CALLBACK2(cb->retain, allocator, *values));
            values++;
            buckets++;
        }
    }
    else {
        for (idx = 0; idx < numValues; idx++) {
            __CFAssignWithWriteBarrier((void **)&buckets->_item, (void *)*values);
            values++;
            buckets++;
        }
    }
    __CFArraySetCount(result, numValues);
    return result;
}
```

` result = __CFArrayInit(allocator, __kCFArrayImmutable, numValues, callBacks); `他之前的都是对参数的合法性校验，真正的创建是有 `__CFArrayInit()` 函数来实现的

 `__CFArrayInit()` 内部实现
 1. 首先创建了一个 `__CFArray` 结构体指针
 2. callback 类型设置
 3. size 计算
 4. 返回 对应的指针
 
 
 
 
 
 ```
 CFTypeID CFArrayGetTypeID(void);
 
 # Create
 CFArrayRef CFArrayCreate(CFAllocatorRef allocator, const void **values, CFIndex numValues, const CFArrayCallBacks *callBacks);
 
 CFArrayRef CFArrayCreateCopy(CFAllocatorRef allocator, CFArrayRef theArray);
 
 CFMutableArrayRef CFArrayCreateMutable(CFAllocatorRef allocator, CFIndex capacity, const CFArrayCallBacks *callBacks);
 
 CFMutableArrayRef CFArrayCreateMutableCopy(CFAllocatorRef allocator, CFIndex capacity, CFArrayRef theArray);
 
 # count
 CFIndex CFArrayGetCount(CFArrayRef theArray);
 
 CFIndex CFArrayGetCountOfValue(CFArrayRef theArray, CFRange range, const void *value);
 
 # get value/values
 const void *CFArrayGetValueAtIndex(CFArrayRef theArray, CFIndex idx);
 
 void CFArrayGetValues(CFArrayRef theArray, CFRange range, const void **values);
 
 # set value at index
 void CFArraySetValueAtIndex(CFMutableArrayRef theArray, CFIndex idx, const void *value);
 
 # index of value
 CFIndex CFArrayGetFirstIndexOfValue(CFArrayRef theArray, CFRange range, const void *value);
 
 CFIndex CFArrayGetLastIndexOfValue(CFArrayRef theArray, CFRange range, const void *value);
 
 CFIndex CFArrayBSearchValues(CFArrayRef theArray, CFRange range, const void *value, CFComparatorFunction comparator, void *context);
 
 # insert remove append replace exchange
 void CFArrayInsertValueAtIndex(CFMutableArrayRef theArray, CFIndex idx, const void *value);
 
 void CFArrayRemoveValueAtIndex(CFMutableArrayRef theArray, CFIndex idx);
 void CFArrayRemoveAllValues(CFMutableArrayRef theArray);

 void CFArrayAppendArray(CFMutableArrayRef theArray, CFArrayRef otherArray, CFRange otherRange);

 void CFArrayReplaceValues(CFMutableArrayRef theArray, CFRange range, const void **newValues, CFIndex newCount);
 
 void CFArrayExchangeValuesAtIndices(CFMutableArrayRef theArray, CFIndex idx1, CFIndex idx2);
 
 # sort
 void CFArraySortValues(CFMutableArrayRef theArray, CFRange range, CFComparatorFunction comparator, void *context);
 
 # apply function: Calls a function once for each value in the array.
 void CFArrayApplyFunction(CFArrayRef theArray, CFRange range, CFArrayApplierFunction applier, void *context);
 
 ```
 
