#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#if __has_include("Nimble-Swift.h")
#import "Nimble-Swift.h"
#else
#import <Nimble/Nimble-Swift.h>
#endif

#pragma mark - Method Swizzling

/// Swaps the implementations between two instance methods.
///
/// @param class               The class containing `originalSelector`.
/// @param originalSelector    Original method to replace.
/// @param replacementSelector Replacement method.
void swizzleSelectors(Class class, SEL originalSelector, SEL replacementSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method replacementMethod = class_getInstanceMethod(class, replacementSelector);

    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(replacementMethod),
                    method_getTypeEncoding(replacementMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            replacementSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

#pragma mark - Private

@interface XCTestObservationCenter (Private)
- (void)_addLegacyTestObserver:(id)observer;
@end

@implementation XCTestObservationCenter (Register)

/// Uses objc method swizzling to register `CurrentTestCaseTracker` as a test observer. This is necessary
/// because Xcode 7.3 introduced timing issues where if a custom `XCTestObservation` is registered too early
/// it suppresses all console output (generated by `XCTestLog`), breaking any tools that depend on this output.
/// This approach waits to register our custom test observer until XCTest adds its first "legacy" observer,
/// falling back to registering after the first normal observer if this private method ever changes.
+ (void)load {
    if (class_getInstanceMethod([self class], @selector(_addLegacyTestObserver:))) {
        // Swizzle -_addLegacyTestObserver:
        swizzleSelectors([self class], @selector(_addLegacyTestObserver:), @selector(NMB_original__addLegacyTestObserver:));
    } else {
        // Swizzle -addTestObserver:, only if -_addLegacyTestObserver: is not implemented
        swizzleSelectors([self class], @selector(addTestObserver:), @selector(NMB_original_addTestObserver:));
    }
}

#pragma mark - Replacement Methods

/// Registers `CurrentTestCaseTracker` as a test observer after `XCTestLog` has been added.
- (void)NMB_original__addLegacyTestObserver:(id)observer {
    [self NMB_original__addLegacyTestObserver:observer];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addTestObserver:[CurrentTestCaseTracker sharedInstance]];
    });
}

/// Registers `CurrentTestCaseTracker` as a test observer after `XCTestLog` has been added.
/// This method is only used if `-_addLegacyTestObserver:` is not impelemented. (added in Xcode 7.3)
- (void)NMB_original_addTestObserver:(id<XCTestObservation>)observer {
    [self NMB_original_addTestObserver:observer];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self NMB_original_addTestObserver:[CurrentTestCaseTracker sharedInstance]];
    });
}

@end