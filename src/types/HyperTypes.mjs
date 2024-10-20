// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Core__Option from "@rescript/core/src/Core__Option.mjs";

function parseConfirmResponse(responseDict) {
  var message = Core__Option.getOr(Js_json.decodeString(Core__Option.getOr(Js_dict.get(responseDict, "message"), null)), "");
  var type_ = Core__Option.getOr(Js_json.decodeString(Core__Option.getOr(Js_dict.get(responseDict, "type"), null)), "");
  return {
          message: message,
          type_: type_
        };
}

function getString(dict, key, defaultVal) {
  return Core__Option.getOr(Js_json.decodeString(Core__Option.getOr(dict[key], null)), defaultVal);
}

function getBool(dict, key, defaultVal) {
  return Core__Option.getOr(Js_json.decodeBoolean(Core__Option.getOr(dict[key], null)), defaultVal);
}

function parseSavedPaymentMethod(paymentMethodDict) {
  var paymentMethodType = getString(paymentMethodDict, "type", "");
  var paymentMethodDict$1 = Core__Option.getOr(Js_json.decodeObject(Core__Option.getOr(paymentMethodDict["message"], null)), {});
  return {
          paymentMethodType: paymentMethodType,
          isDefaultPaymentMethod: getBool(paymentMethodDict$1, "isDefaultPaymentMethod", false),
          paymentToken: getString(paymentMethodDict$1, "paymentToken", ""),
          cardScheme: getString(paymentMethodDict$1, "cardScheme", ""),
          name: getString(paymentMethodDict$1, "name", ""),
          expiryDate: getString(paymentMethodDict$1, "expiryDate", ""),
          cardNumber: getString(paymentMethodDict$1, "cardNumber", ""),
          nickName: getString(paymentMethodDict$1, "nickName", ""),
          cardHolderName: getString(paymentMethodDict$1, "cardHolderName", ""),
          requiresCVV: getBool(paymentMethodDict$1, "requiresCVV", false),
          created: getString(paymentMethodDict$1, "created", ""),
          lastUsedAt: getString(paymentMethodDict$1, "lastUsedAt", ""),
          walletType: getString(paymentMethodDict$1, "walletType", "")
        };
}

function parseAllSavedPaymentMethods(paymentMethodsDict) {
  var savedPMJson = Core__Option.getOr(Js_dict.get(paymentMethodsDict, "paymentMethods"), null);
  var savedPMJsonArr = Core__Option.getOr(Js_json.decodeArray(savedPMJson), []);
  return savedPMJsonArr.map(function (item) {
              return parseSavedPaymentMethod(Core__Option.getOr(Js_json.decodeObject(item), {}));
            });
}

export {
  parseConfirmResponse ,
  getString ,
  getBool ,
  parseSavedPaymentMethod ,
  parseAllSavedPaymentMethods ,
}
/* No side effect */
