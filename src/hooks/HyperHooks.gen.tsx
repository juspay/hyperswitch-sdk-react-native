/* TypeScript file generated from HyperHooks.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as HyperHooksJS from './HyperHooks.bs.js';

import type {headlessConfirmResponseType as HyperTypes_headlessConfirmResponseType} from '../../src/types/HyperTypes.gen';

import type {initPaymentSheetParamTypes as HyperTypes_initPaymentSheetParamTypes} from '../../src/types/HyperTypes.gen';

import type {responseFromNativeModule as HyperTypes_responseFromNativeModule} from '../../src/types/HyperTypes.gen';

import type {savedPaymentMethodType as HyperTypes_savedPaymentMethodType} from '../../src/types/HyperTypes.gen';

import type {sessionParams as HyperTypes_sessionParams} from '../../src/types/HyperTypes.gen';

export type confirmPaymentMethodArgumentType = { readonly sessionParams: HyperTypes_sessionParams; readonly cvc?: string };

export type confirmWithCustomerPaymentTokenArgumentType = {
  readonly sessionParams: HyperTypes_sessionParams; 
  readonly cvc?: string; 
  readonly paymentToken: string
};

export type useHyperReturnType = {
  readonly initPaymentSession: (_1:HyperTypes_initPaymentSheetParamTypes) => Promise<HyperTypes_sessionParams>; 
  readonly presentPaymentSheet: (_1:HyperTypes_sessionParams) => Promise<HyperTypes_responseFromNativeModule>; 
  readonly getCustomerSavedPaymentMethods: (_1:HyperTypes_sessionParams) => Promise<HyperTypes_sessionParams>; 
  readonly getCustomerDefaultSavedPaymentMethodData: (_1:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType>; 
  readonly getCustomerLastUsedPaymentMethodData: (_1:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType>; 
  readonly getCustomerSavedPaymentMethodData: (_1:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType[]>; 
  readonly confirmWithCustomerDefaultPaymentMethod: (_1:confirmPaymentMethodArgumentType) => Promise<HyperTypes_headlessConfirmResponseType>; 
  readonly confirmWithCustomerLastUsedPaymentMethod: (_1:confirmPaymentMethodArgumentType) => Promise<HyperTypes_headlessConfirmResponseType>; 
  readonly confirmWithCustomerPaymentToken: (_1:confirmWithCustomerPaymentTokenArgumentType) => Promise<HyperTypes_headlessConfirmResponseType>
};

export const useHyper: () => useHyperReturnType = HyperHooksJS.useHyper as any;
