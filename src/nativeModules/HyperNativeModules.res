type jsonFunWithCallback = (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit
type strFunWithCallback = (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit
external jsonToJsonFunWithCallback: Js.Json.t => jsonFunWithCallback = "%identity"
external jsonToStrFunWithCallback: Js.Json.t => strFunWithCallback = "%identity"

let hyperswitchDict =
  Js.Dict.get(ReactNative.NativeModules.nativeModules, "HyperModule")
  ->Belt.Option.flatMap(Js.Json.decodeObject)
  ->Belt.Option.getWithDefault(Js.Dict.empty())

Console.log2("hyperswitch dict------>", hyperswitchDict)

type hyperswitch = {
  initPaymentSession: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  presentPaymentSheet: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerDefaultSavedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerLastUsedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerSavedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  confirmWithCustomerDefaultPaymentMethod: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  confirmWithCustomerLastUsedPaymentMethod: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  confirmWithCustomerPaymentToken: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
}

let getJsonFunWithCallbackFromKey = key => {
  switch hyperswitchDict->Js.Dict.get(key) {
  | Some(json) => jsonToJsonFunWithCallback(json)
  | None =>
    (_, _) => {
      Console.log("flow here-")
      ()
    }
  }
}
let getStrFunWithCallbackFromKey = key => {
  switch hyperswitchDict->Dict.get(key) {
  | Some(json) => jsonToStrFunWithCallback(json)
  | None => (_, _) => ()
  }
}

let hyperswitch = {
  initPaymentSession: getJsonFunWithCallbackFromKey("initPaymentSession"),
  presentPaymentSheet: getJsonFunWithCallbackFromKey("presentPaymentSheet"),
  getCustomerDefaultSavedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerDefaultSavedPaymentMethodData",
  ),
  getCustomerLastUsedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerLastUsedPaymentMethodData",
  ),
  getCustomerSavedPaymentMethodData: getJsonFunWithCallbackFromKey(
    "getCustomerSavedPaymentMethodData",
  ),
  confirmWithCustomerDefaultPaymentMethod: getJsonFunWithCallbackFromKey(
    "confirmWithCustomerDefaultPaymentMethod",
  ),
  confirmWithCustomerLastUsedPaymentMethod: getJsonFunWithCallbackFromKey(
    "confirmWithCustomerLastUsedPaymentMethod",
  ),
  confirmWithCustomerPaymentToken: getJsonFunWithCallbackFromKey("confirmWithCustomerPaymentToken"),
}

let initPaymentSession = (requestObj: Js.Json.t, callback) => {
  Console.log("init payment Session Native module rn wrapper ")
  hyperswitch.initPaymentSession(requestObj, callback)
}
let presentPaymentSheet = (requestObj: Js.Json.t, callback) => {
  Console.log2("reaching here------", requestObj)
  // Console.log2("present fn==", hyperswitch.presentPaymentSheet)
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

let confirmWithCustomerDefaultPaymentMethod = (requestObj: Js.Json.t, callback) => {
  hyperswitch.confirmWithCustomerDefaultPaymentMethod(requestObj, callback)
}

let confirmWithCustomerLastUsedPaymentMethod = (requestObj: Js.Json.t, callback) => {
  hyperswitch.confirmWithCustomerLastUsedPaymentMethod(requestObj, callback)
}
