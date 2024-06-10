#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(HyperHeadless, RCTEventEmitter)

RCT_EXTERN_METHOD(initialisePaymentSession: (RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(getPaymentSession: (NSDictionary)rnMessage :(NSDictionary)rnMessage2 :(NSArray)rnMessage3 :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(exitHeadless: (NSString)rnMessage)

@end
