type jsonFunWithCallback = (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit
type strFunWithCallback = (Js.Json.t, option<string>, Js.Dict.t<Js.Json.t> => unit) => unit
type strFun2WithCallback = (Js.Json.t, option<string>, string, Js.Dict.t<Js.Json.t> => unit) => unit
external jsonToJsonFunWithCallback: Js.Json.t => jsonFunWithCallback = "%identity"
external jsonToStrFunWithCallback: Js.Json.t => strFunWithCallback = "%identity"
external jsonToStr2FunWithCallback: Js.Json.t => strFun2WithCallback = "%identity"

let hyperswitchDict =
  Js.Dict.get(ReactNative.NativeModules.nativeModules, "HyperModule")
  ->Belt.Option.flatMap(Js.Json.decodeObject)
  ->Belt.Option.getWithDefault(Js.Dict.empty())

type hyperswitch = {
  initPaymentSession: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  presentPaymentSheet: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerSavedPaymentMethods: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerDefaultSavedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerLastUsedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerSavedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  confirmWithCustomerDefaultPaymentMethod: (
    Js.Json.t,
    option<string>,
    Js.Dict.t<Js.Json.t> => unit,
  ) => unit,
  confirmWithCustomerLastUsedPaymentMethod: (
    Js.Json.t,
    option<string>,
    Js.Dict.t<Js.Json.t> => unit,
  ) => unit,
  confirmWithCustomerPaymentToken: (
    Js.Json.t,
    option<string>,
    string,
    Js.Dict.t<Js.Json.t> => unit,
  ) => unit,
}

let getJsonFunWithCallbackFromKey = key => {
  switch hyperswitchDict->Js.Dict.get(key) {
  | Some(json) => jsonToJsonFunWithCallback(json)
  | None =>
    (_, _) => {
      ()
    }
  }
}
let getStrFunWithCallbackFromKey = key => {
  switch hyperswitchDict->Dict.get(key) {
  | Some(json) => jsonToStrFunWithCallback(json)
  | None => (_, _, _) => ()
  }
}

let getStr2FunWithCallbackFromKey = key => {
  switch hyperswitchDict->Dict.get(key) {
  | Some(json) => jsonToStr2FunWithCallback(json)
  | None => (_, _, _, _) => ()
  }
}
let hyperswitch = {
  initPaymentSession: getJsonFunWithCallbackFromKey("initPaymentSession"),
  presentPaymentSheet: getJsonFunWithCallbackFromKey("presentPaymentSheet"),
  getCustomerSavedPaymentMethods: getJsonFunWithCallbackFromKey("getCustomerSavedPaymentMethods"),
  getCustomerDefaultSavedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerDefaultSavedPaymentMethodData",
  ),
  getCustomerLastUsedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerLastUsedPaymentMethodData",
  ),
  getCustomerSavedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerSavedPaymentMethodData",
  ),
  confirmWithCustomerDefaultPaymentMethod: getStrFunWithCallbackFromKey(
    "confirmWithCustomerDefaultPaymentMethod",
  ),
  confirmWithCustomerLastUsedPaymentMethod: getStrFunWithCallbackFromKey(
    "confirmWithCustomerLastUsedPaymentMethod",
  ),
  confirmWithCustomerPaymentToken: getStr2FunWithCallbackFromKey("confirmWithCustomerPaymentToken"),
}

let initPaymentSession = (requestObj: Js.Json.t, callback) => {
  hyperswitch.initPaymentSession(requestObj, callback)
}

let getCustomerSavedPaymentMethods = (requestObj: Js.Json.t, callback) => {
  hyperswitch.getCustomerSavedPaymentMethods(requestObj, callback)
}
let presentPaymentSheet = (requestObj: Js.Json.t, callback) => {
  hyperswitch.presentPaymentSheet(requestObj, callback)
}

let getCustomerDefaultSavedPaymentMethodData = (requestObj: Js.Json.t, callback) => {
  hyperswitch.getCustomerDefaultSavedPaymentMethodData(requestObj, callback)
}

let getCustomerLastUsedPaymentMethodData = (requestObj: Js.Json.t, callback) => {
  hyperswitch.getCustomerLastUsedPaymentMethodData(requestObj, callback)
}

let getCustomerSavedPaymentMethodData = (requestObj: Js.Json.t, callback) => {
  hyperswitch.getCustomerSavedPaymentMethodData(requestObj, callback)
}

let confirmWithCustomerDefaultPaymentMethod = (
  requestObj: Js.Json.t,
  cvc: option<string>,
  callback,
) => {
  hyperswitch.confirmWithCustomerDefaultPaymentMethod(requestObj, cvc, callback)
}

let confirmWithCustomerLastUsedPaymentMethod = (
  requestObj: Js.Json.t,
  cvc: option<string>,
  callback,
) => {
  hyperswitch.confirmWithCustomerLastUsedPaymentMethod(requestObj, cvc, callback)
}

let confirmWithCustomerPaymentToken = (
  requestObj: Js.Json.t,
  cvc: option<string>,
  paymentToken: string,
  callback,
) => {
  hyperswitch.confirmWithCustomerPaymentToken(requestObj, cvc, paymentToken, callback)
}
