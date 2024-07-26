#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(HyperModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initPaymentSession: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(presentPaymentSheet: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(exitPaymentsheet: (nonnull NSNumber *)reactTag :(NSString)rnMessage :(BOOL)reset)
RCT_EXTERN_METHOD(exitCardForm: (NSString)rnMessage)
RCT_EXTERN_METHOD(getCustomerSavedPaymentMethods: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(getCustomerDefaultSavedPaymentMethodData: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(getCustomerLastUsedPaymentMethodData: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(getCustomerSavedPaymentMethodData: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(confirmWithCustomerDefaultPaymentMethod: (NSDictionary) rnMessage :(NSString)cvc :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(confirmWithCustomerLastUsedPaymentMethod: (NSDictionary) rnMessage :(NSString)cvc :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(confirmWithCustomerPaymentToken: (NSDictionary) rnMessage :(NSString)cvc :(NSString)paymentToken :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(launchApplePay: (NSString)rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(sendMessageToNative: (NSString)rnMessage)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end
