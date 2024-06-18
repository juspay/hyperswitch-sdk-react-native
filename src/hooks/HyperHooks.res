external parser: HyperTypes.sendingToRNSDK => Js.Json.t = "%identity"
type useHyperReturnType = {
  initPaymentSession: HyperTypes.initPaymentSheetParamTypes => HyperTypes.sendingToRNSDK,
  presentPaymentSheet: HyperTypes.sendingToRNSDK => promise<HyperTypes.responseFromNativeModule>,
  registerHeadless: HyperTypes.sendingToRNSDK => unit,
  confirmWithCustomerDefaultPaymentMethod: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  getCustomerDefaultSavedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerLastUsedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerSavedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    array<HyperTypes.savedPaymentMethodType>,
  >,
}

let useHyper = () => {
  let (hyperVal, _) = React.useContext(HyperProvider.hyperProviderContext)

  let registerHeadless = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    Console.log("Flow here------------>")
    HyperNativeModules.registerHeadless(paySheetParams->HyperTypes.parser, obj => {
      Console.log("called>>>>>>>.")
    })
  }

  let initPaymentSession = (initPaymentSheetParams: HyperTypes.initPaymentSheetParamTypes) => {
    let hsSdkParams: HyperTypes.sendingToRNSDK = {
      configuration: initPaymentSheetParams.configuration,
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

  // let initHeadless = (paySheetParams: HyperTypes.sendingToRNSDK) => {
  //   let paymentSheetParams: HyperTypes.sendingToRNSDK = {
  //     publishableKey: hyperVal.publishableKey,
  //     clientSecret: paySheetParams.clientSecret,
  //     \"type": "payment",
  //     from: "rn",
  //     // branding: initPaymentSheetParams.branding,
  //     // locale: initPaymentSheetParams.locale,
  //   }
  //   let paySheetParamsJson = paymentSheetParams->parser
  //   Console.log2("called at RN", paySheetParamsJson)
  //   HyperNativeModules.initHeadless(paySheetParamsJson, obj => {
  //     Console.log2("headless ok!!!!!", obj)
  //   })
  // }
  // let paymentMethodParams = () => {
  //   Console.log("hello world")
  // }

  // let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
  //   let paySheetParamsJson = paySheetParams->parser

  //   Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
  //     let responseResolve = arg => {
  //       let val = arg->HyperTypes.savedPMToObj
  //       resolve(val)
  //     }
  //     HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
  //   })
  // }
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

  let getCustomerDefaultSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.savedPMToObj
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
        let val = arg->HyperTypes.savedPMToObj
        resolve(val)
      }
      HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: array<HyperTypes.savedPaymentMethodType> => unit, ~reject as _) => {
      let responseResolve = arg => {
        Console.log(arg)

        let x = arg->Js.Dict.get("paymentMethods")
        let val = x->HyperTypes.savedPMToArrObj
        Console.log2("val-------", val)

        resolve(val)
      }
      HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }

  {
    initPaymentSession,
    presentPaymentSheet,
    registerHeadless,
    confirmWithCustomerDefaultPaymentMethod,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
  }
}
