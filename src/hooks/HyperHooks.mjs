// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as HyperTypes from "../types/HyperTypes.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Option from "@rescript/core/src/Core__Option.mjs";
import * as HyperProvider from "../context/HyperProvider.mjs";
import * as HyperNativeModules from "../nativeModules/HyperNativeModules.mjs";

function useHyper() {
  var match = React.useContext(HyperProvider.hyperProviderContext);
  var hyperVal = match[0];
  var initPaymentSession = function (initPaymentSheetParams) {
    var hsSdkParams_configuration = Core__Option.getOr(initPaymentSheetParams.configuration, {});
    var hsSdkParams_customBackendUrl = Caml_option.some(hyperVal.customBackendUrl);
    var hsSdkParams_publishableKey = hyperVal.publishableKey;
    var hsSdkParams_clientSecret = initPaymentSheetParams.clientSecret;
    var hsSdkParams = {
      configuration: hsSdkParams_configuration,
      customBackendUrl: hsSdkParams_customBackendUrl,
      publishableKey: hsSdkParams_publishableKey,
      clientSecret: hsSdkParams_clientSecret,
      type: "payment",
      from: "rn"
    };
    return new Promise((function (resolve, param) {
                  var responseResolve = function (param) {
                    resolve(hsSdkParams);
                  };
                  HyperNativeModules.initPaymentSession(hsSdkParams, responseResolve);
                }));
  };
  var presentPaymentSheet = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = JSON.parse(arg);
                    resolve(val);
                  };
                  HyperNativeModules.presentPaymentSheet(paySheetParams, responseResolve);
                }));
  };
  var getCustomerSavedPaymentMethods = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (param) {
                    resolve(paySheetParams);
                  };
                  HyperNativeModules.getCustomerSavedPaymentMethods(paySheetParams, responseResolve);
                }));
  };
  var getCustomerDefaultSavedPaymentMethodData = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = HyperTypes.parseSavedPaymentMethod(arg);
                    resolve(val);
                  };
                  HyperNativeModules.getCustomerDefaultSavedPaymentMethodData(paySheetParams, responseResolve);
                }));
  };
  var getCustomerLastUsedPaymentMethodData = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    HyperTypes.parseSavedPaymentMethod(arg);
                    var val = HyperTypes.parseSavedPaymentMethod(arg);
                    resolve(val);
                  };
                  HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParams, responseResolve);
                }));
  };
  var getCustomerSavedPaymentMethodData = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = HyperTypes.parseAllSavedPaymentMethods(arg);
                    resolve(val);
                  };
                  HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParams, responseResolve);
                }));
  };
  var confirmWithCustomerDefaultPaymentMethod = function ($$arguments) {
    var paySheetParamsJson = $$arguments.sessionParams;
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = HyperTypes.parseConfirmResponse(arg);
                    resolve(val);
                  };
                  HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(paySheetParamsJson, $$arguments.cvc, responseResolve);
                }));
  };
  var confirmWithCustomerLastUsedPaymentMethod = function ($$arguments) {
    var paySheetParamsJson = $$arguments.sessionParams;
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = HyperTypes.parseConfirmResponse(arg);
                    resolve(val);
                  };
                  HyperNativeModules.confirmWithCustomerLastUsedPaymentMethod(paySheetParamsJson, $$arguments.cvc, responseResolve);
                }));
  };
  var confirmWithCustomerPaymentToken = function ($$arguments) {
    var paySheetParamsJson = $$arguments.sessionParams;
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    var val = HyperTypes.parseConfirmResponse(arg);
                    resolve(val);
                  };
                  HyperNativeModules.confirmWithCustomerPaymentToken(paySheetParamsJson, $$arguments.cvc, $$arguments.paymentToken, responseResolve);
                }));
  };
  return {
          initPaymentSession: initPaymentSession,
          presentPaymentSheet: presentPaymentSheet,
          getCustomerSavedPaymentMethods: getCustomerSavedPaymentMethods,
          getCustomerDefaultSavedPaymentMethodData: getCustomerDefaultSavedPaymentMethodData,
          getCustomerLastUsedPaymentMethodData: getCustomerLastUsedPaymentMethodData,
          getCustomerSavedPaymentMethodData: getCustomerSavedPaymentMethodData,
          confirmWithCustomerDefaultPaymentMethod: confirmWithCustomerDefaultPaymentMethod,
          confirmWithCustomerLastUsedPaymentMethod: confirmWithCustomerLastUsedPaymentMethod,
          confirmWithCustomerPaymentToken: confirmWithCustomerPaymentToken
        };
}

export {
  useHyper ,
}
/* react Not a pure module */
