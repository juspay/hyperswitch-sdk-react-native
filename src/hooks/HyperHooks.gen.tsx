/* TypeScript file generated from HyperHooks.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as HyperHooksJS from './HyperHooks.res.js';

import type {headlessConfirmResponseType as HyperTypes_headlessConfirmResponseType} from '../../src/types/HyperTypes.gen';

import type {initPaymentSheetParamTypes as HyperTypes_initPaymentSheetParamTypes} from '../../src/types/HyperTypes.gen';

import type {responseFromNativeModule as HyperTypes_responseFromNativeModule} from '../../src/types/HyperTypes.gen';

import type {savedPaymentMethodType as HyperTypes_savedPaymentMethodType} from '../../src/types/HyperTypes.gen';

import type {sendingToRNSDK as HyperTypes_sendingToRNSDK} from '../../src/types/HyperTypes.gen';

export type useHyperReturnType = {
  readonly initPaymentSession: (_1:HyperTypes_initPaymentSheetParamTypes) => Promise<HyperTypes_sendingToRNSDK>; 
  readonly presentPaymentSheet: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_responseFromNativeModule>; 
  readonly getCustomerDefaultSavedPaymentMethodData: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_savedPaymentMethodType>; 
  readonly getCustomerLastUsedPaymentMethodData: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_savedPaymentMethodType>; 
  readonly getCustomerSavedPaymentMethodData: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_savedPaymentMethodType[]>; 
  readonly confirmWithCustomerDefaultPaymentMethod: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_headlessConfirmResponseType>; 
  readonly confirmWithCustomerLastUsedPaymentMethod: (_1:HyperTypes_sendingToRNSDK) => Promise<HyperTypes_headlessConfirmResponseType>
};

export const useHyper: () => useHyperReturnType = HyperHooksJS.useHyper as any;
