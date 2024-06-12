type jsonFunWithCallback = (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit
external jsonToStrFunWithCallback: Js.Json.t => jsonFunWithCallback = "%identity"

let hyperswitchDict =
  Js.Dict.get(ReactNative.NativeModules.nativeModules, "HyperModule")
  ->Belt.Option.flatMap(Js.Json.decodeObject)
  ->Belt.Option.getWithDefault(Js.Dict.empty())

Console.log2("hyperswitch dict------>", hyperswitchDict)

type hyperswitch = {presentPaymentSheet: (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit}

let getStrFunWithCallbackFromKey = key => {
  switch hyperswitchDict->Js.Dict.get(key) {
  | Some(json) => jsonToStrFunWithCallback(json)
  | None =>
    (_, _) => {
      Console.log("flow here-")
      ()
    }
  }
}

let hyperswitch = {
  //   Console.log(getStrFunWithCallbackFromKey("presentPaymentSheet"))
  {
    presentPaymentSheet: getStrFunWithCallbackFromKey("presentPaymentSheet"),
  }
}

let presentPaymentSheet = (requestObj: Js.Json.t, callback) => {
  Console.log2("reaching here------", requestObj)
  hyperswitch.presentPaymentSheet(requestObj, callback)
}
