#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Haptics, NSObject)

RCT_EXTERN_METHOD(haptic:(NSString *)type)
RCT_EXTERN_METHOD(hapticWithPattern:(NSArray<NSString *> *)pattern delay:(nonnull NSNumber *)delay)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
