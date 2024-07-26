external parser: HyperTypes.sessionParams => Js.Json.t = "%identity"

type confirmPaymentMethodArgumentType = {
  sessionParams: HyperTypes.sessionParams,
  cvc?: string,
}
type confirmWithCustomerPaymentTokenArgumentType = {
  sessionParams: HyperTypes.sessionParams,
  cvc?: string,
  paymentToken: string,
}

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
  confirmWithCustomerDefaultPaymentMethod: confirmPaymentMethodArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  confirmWithCustomerLastUsedPaymentMethod: confirmPaymentMethodArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  confirmWithCustomerPaymentToken: confirmWithCustomerPaymentTokenArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
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
        /* NOTE: discuss with @Sanskar Atrey about the usage of `arg` from native 
          (can be used to handle the failure cases). */ 
        // Console.log2("From RN Native module", arg)
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
        let val = arg->HyperTypes.parseSavedPaymentMethod

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
        arg->HyperTypes.parseSavedPaymentMethod->ignore
        let val = arg->HyperTypes.parseSavedPaymentMethod

        resolve(val)
      }
      HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: array<HyperTypes.savedPaymentMethodType> => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseAllSavedPaymentMethods
        resolve(val)
      }
      HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let confirmWithCustomerDefaultPaymentMethod = (arguments: confirmPaymentMethodArgumentType) => {
    let paySheetParamsJson = arguments.sessionParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(
        paySheetParamsJson,
        arguments.cvc,
        responseResolve,
      )
    })
  }

  let confirmWithCustomerLastUsedPaymentMethod = (arguments: confirmPaymentMethodArgumentType) => {
    let paySheetParamsJson = arguments.sessionParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerLastUsedPaymentMethod(
        paySheetParamsJson,
        arguments.cvc,
        responseResolve,
      )
    })
  }

  let confirmWithCustomerPaymentToken = (
    arguments: confirmWithCustomerPaymentTokenArgumentType,
  ) => {
    let paySheetParamsJson = arguments.sessionParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.parseConfirmResponse

        resolve(val)
      }
      HyperNativeModules.confirmWithCustomerPaymentToken(
        paySheetParamsJson,
        arguments.cvc,
        arguments.paymentToken,
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
