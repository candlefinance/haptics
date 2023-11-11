#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Haptics, NSObject)

RCT_EXTERN_METHOD(haptic:(NSString *)type)
RCT_EXTERN_METHOD(hapticWithPattern:(NSArray<NSString *> *)pattern)
RCT_EXTERN_METHOD(play:(nonnull NSString *)fileName loop:(nonnull BOOL)loop)
RCT_EXTERN_METHOD(stop)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
