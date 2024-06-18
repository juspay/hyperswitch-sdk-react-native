// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as HyperProvider from "../context/HyperProvider.res.js";
import * as HyperNativeModules from "../nativeModules/HyperNativeModules.res.js";

function useHyper() {
  var match = React.useContext(HyperProvider.hyperProviderContext);
  var hyperVal = match[0];
  var initPaymentSession = function (initPaymentSheetParams) {
    console.log("initPaymentSession--------", hyperVal.customBackendUrl);
    return {
            configuration: initPaymentSheetParams.configuration,
            customBackendUrl: Caml_option.some(hyperVal.customBackendUrl),
            publishableKey: hyperVal.publishableKey,
            clientSecret: initPaymentSheetParams.clientSecret,
            type: "payment",
            from: "rn"
          };
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
  var getCustomerSavedPaymentMethodData = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    resolve(arg);
                  };
                  HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParams, responseResolve);
                }));
  };
  var confirmWithCustomerDefaultPaymentMethod = function (paySheetParams) {
    return new Promise((function (resolve, param) {
                  var responseResolve = function (arg) {
                    resolve(arg);
                  };
                  HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(paySheetParams, responseResolve);
                }));
  };
  return {
          initPaymentSession: initPaymentSession,
          presentPaymentSheet: presentPaymentSheet,
          getCustomerSavedPaymentMethodData: getCustomerSavedPaymentMethodData,
          confirmWithCustomerDefaultPaymentMethod: confirmWithCustomerDefaultPaymentMethod
        };
}

export {
  useHyper ,
}
/* react Not a pure module */
