external parser: HyperTypes.sendingToRNSDK => Js.Json.t = "%identity"

@genType
type useHyperReturnType = {
  initPaymentSession: HyperTypes.initPaymentSheetParamTypes => HyperTypes.sendingToRNSDK,
  presentPaymentSheet: HyperTypes.sendingToRNSDK => promise<HyperTypes.responseFromNativeModule>,
  registerHeadless: HyperTypes.sendingToRNSDK => unit,
  getCustomerDefaultSavedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerLastUsedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerSavedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    array<HyperTypes.savedPaymentMethodType>,
  >,
  confirmWithCustomerDefaultPaymentMethod: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  confirmWithCustomerLastUsedPaymentMethod: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
}

@genType
let useHyper = (): useHyperReturnType => {
  let (hyperVal, _) = React.useContext(HyperProvider.hyperProviderContext)

  let registerHeadless = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    HyperNativeModules.registerHeadless(paySheetParams->HyperTypes.parser, obj => {
      Console.log("called>>>>>>>.")
    })
  }

  let initPaymentSession = (initPaymentSheetParams: HyperTypes.initPaymentSheetParamTypes) => {
    let hsSdkParams: HyperTypes.sendingToRNSDK = {
      configuration: initPaymentSheetParams.configuration->Option.getOr({}),
      customBackendUrl: hyperVal.customBackendUrl,
      publishableKey: hyperVal.publishableKey,
      clientSecret: initPaymentSheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
    }
    hsSdkParams
  }

  let presentPaymentSheet = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.responseFromNativeModule => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseResponseFromNativeModule
        resolve(val)
      }
      HyperNativeModules.presentPaymentSheet(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerDefaultSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->Js.Dict.get("message")->HyperTypes.savedPMToObj

        resolve(val)
      }
      HyperNativeModules.getCustomerDefaultSavedPaymentMethodData(
        paySheetParamsJson,
        responseResolve,
      )
    })
  }

  let getCustomerLastUsedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->Js.Dict.get("message")->HyperTypes.savedPMToObj

        resolve(val)
      }
      HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: array<HyperTypes.savedPaymentMethodType> => unit, ~reject as _) => {
      let responseResolve = arg => {
        let savedPMJsonArr =
          arg
          ->Js.Dict.get("paymentMethods")
          ->HyperTypes.toJsonArray
          ->Array.map(item => {
            item
            ->Js.Json.decodeObject
            ->Option.getOr(Js.Dict.empty())
            ->Js.Dict.get("message")
          })

        let val = savedPMJsonArr->HyperTypes.savedPMToArrObj
        resolve(val)
      }
      HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let confirmWithCustomerDefaultPaymentMethod = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(
        paySheetParamsJson,
        responseResolve,
      )
    })
  }

  let confirmWithCustomerLastUsedPaymentMethod = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerLastUsedPaymentMethod(
        paySheetParamsJson,
        responseResolve,
      )
    })
  }

  {
    initPaymentSession,
    presentPaymentSheet,
    registerHeadless,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
    confirmWithCustomerLastUsedPaymentMethod,
  }
}
