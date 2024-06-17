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
  presentPaymentSheet: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  initHeadless: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  getCustomerSavedPaymentMethodData: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
  confirmWithCustomerDefaultPaymentMethod: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit,
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
  //   Console.log(getStrFunWithCallbackFromKey("presentPaymentSheet"))
  {
    presentPaymentSheet: getJsonFunWithCallbackFromKey("presentPaymentSheet"),
    initHeadless: getJsonFunWithCallbackFromKey("initHeadless"),
    getCustomerSavedPaymentMethodData: getJsonFunWithCallbackFromKey(
      "getCustomerSavedPaymentMethodData",
    ),
    confirmWithCustomerDefaultPaymentMethod: getJsonFunWithCallbackFromKey(
      "confirmWithCustomerDefaultPaymentMethod",
    ),
  }
}

let presentPaymentSheet = (requestObj: Js.Json.t, callback) => {
  Console.log2("reaching here------", requestObj)
  // Console.log2("present fn==", hyperswitch.presentPaymentSheet)
  hyperswitch.presentPaymentSheet(requestObj, callback)
}

let initHeadless = (requestObj: Js.Json.t, callback) => {
  hyperswitch.initHeadless(requestObj, callback)
}

let getCustomerSavedPaymentMethodData = (requestObj: Js.Json.t, callback) => {
  hyperswitch.getCustomerSavedPaymentMethodData(requestObj, callback)
}

let confirmWithCustomerDefaultPaymentMethod = (requestObj: Js.Json.t, callback) => {
  hyperswitch.confirmWithCustomerDefaultPaymentMethod(requestObj, callback)
}
