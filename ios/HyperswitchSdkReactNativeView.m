#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(HyperModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initPaymentSession: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
RCT_EXTERN_METHOD(presentPaymentSheet: (NSDictionary) rnMessage :(RCTResponseSenderBlock)rnCallback)
// RCT_EXTERN_METHOD(sendMessageToNative: (NSString)rnMessage)
// RCT_EXTERN_METHOD(launchApplePay: (NSString)rnMessage :(RCTResponseSenderBlock)rnCallback)
// RCT_EXTERN_METHOD(exitCardForm: (NSString)rnMessage)
 RCT_EXTERN_METHOD(exitPaymentsheet: (nonnull NSNumber *)reactTag :(NSString)rnMessage :(BOOL)reset)

// NOTE: Expected methods: 
  // initPaymentSession (request: ReadableMap, callBack: Callback)
  // presentPaymentSheet (request: ReadableMap,callBack: Callback)
  // getCustomerSavedPaymentMethods (request: ReadableMap, callBack: Callback)
  // getCustomerDefaultSavedPaymentMethodData (request: ReadableMap, callBack: Callback)
  // getCustomerLastUsedPaymentMethodData (request: ReadableMap, callBack: Callback) 
  // getCustomerSavedPaymentMethodData (request: ReadableMap, callBack: Callback) 
  // confirmWithCustomerDefaultPaymentMethod (request: ReadableMap,cvc:String?=null, callBack: Callback)
  // confirmWithCustomerLastUsedPaymentMethod (request: ReadableMap,cvc:String?=null, callBack: Callback)
  // confirmWithCustomerPaymentToken (request: ReadableMap,cvc:String?=null, callBack: Callback)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
