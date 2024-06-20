external parser: HyperTypes.sessionParams => Js.Json.t = "%identity"

@genType
type useHyperReturnType = {
  initPaymentSession: HyperTypes.initPaymentSheetParamTypes => promise<HyperTypes.sessionParams>,
  presentPaymentSheet: HyperTypes.sessionParams => promise<HyperTypes.responseFromNativeModule>,
  getCustomerSavedPaymentMethods: HyperTypes.sessionParams => promise<HyperTypes.sessionParams>,
  getCustomerDefaultSavedPaymentMethodData: HyperTypes.sessionParams => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerLastUsedPaymentMethodData: HyperTypes.sessionParams => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerSavedPaymentMethodData: HyperTypes.sessionParams => promise<
    array<HyperTypes.savedPaymentMethodType>,
  >,
  confirmWithCustomerDefaultPaymentMethod: (
    HyperTypes.sessionParams,
    option<string>,
  ) => promise<HyperTypes.headlessConfirmResponseType>,
  confirmWithCustomerLastUsedPaymentMethod: (
    HyperTypes.sessionParams,
    option<string>,
  ) => promise<HyperTypes.headlessConfirmResponseType>,
  confirmWithCustomerPaymentToken: (
    HyperTypes.sessionParams,
    option<string>,
    string,
  ) => promise<HyperTypes.headlessConfirmResponseType>,
}

@genType
let useHyper = (): useHyperReturnType => {
  let (hyperVal, _) = React.useContext(HyperProvider.hyperProviderContext)

  let initPaymentSession = (initPaymentSheetParams: HyperTypes.initPaymentSheetParamTypes) => {
    let hsSdkParams: HyperTypes.sessionParams = {
      configuration: initPaymentSheetParams.configuration->Option.getOr({}),
      customBackendUrl: hyperVal.customBackendUrl,
      publishableKey: hyperVal.publishableKey,
      clientSecret: initPaymentSheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
    }

    Js.Promise.make((~resolve: HyperTypes.sessionParams => unit, ~reject as _) => {
      let responseResolve = arg => {
        Console.log2("From RN Native module", arg)
        resolve(hsSdkParams)
      }
      HyperNativeModules.initPaymentSession(hsSdkParams->HyperTypes.parser, responseResolve)
    })
  }

  let presentPaymentSheet = (paySheetParams: HyperTypes.sessionParams) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.responseFromNativeModule => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseResponseFromNativeModule
        resolve(val)
      }
      HyperNativeModules.presentPaymentSheet(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerSavedPaymentMethods = (paySheetParams: HyperTypes.sessionParams) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.sessionParams => unit, ~reject as _) => {
      let responseResolve = _ => {
        resolve(paySheetParams)
      }
      HyperNativeModules.getCustomerSavedPaymentMethods(paySheetParamsJson, responseResolve)
    })
  }
  let getCustomerDefaultSavedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
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

  let getCustomerLastUsedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->Js.Dict.get("message")->HyperTypes.savedPMToObj

        resolve(val)
      }
      HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
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

  let confirmWithCustomerDefaultPaymentMethod = (
    paySheetParams: HyperTypes.sessionParams,
    cvc: option<string>,
  ) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(
        paySheetParamsJson,
        cvc,
        responseResolve,
      )
    })
  }

  let confirmWithCustomerLastUsedPaymentMethod = (
    paySheetParams: HyperTypes.sessionParams,
    cvc: option<string>,
  ) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerLastUsedPaymentMethod(
        paySheetParamsJson,
        cvc,
        responseResolve,
      )
    })
  }

  let confirmWithCustomerPaymentToken = (
    paySheetParams: HyperTypes.sessionParams,
    cvc: option<string>,
    paymentToken: string,
  ) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerPaymentToken(
        paySheetParamsJson,
        cvc,
        paymentToken,
        responseResolve,
      )
    })
  }

  {
    initPaymentSession,
    presentPaymentSheet,
    getCustomerSavedPaymentMethods,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
    confirmWithCustomerLastUsedPaymentMethod,
    confirmWithCustomerPaymentToken,
  }
}
