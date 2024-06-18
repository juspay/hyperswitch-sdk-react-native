external parser: HyperTypes.sendingToRNSDK => Js.Json.t = "%identity"
type useHyperReturnType = {
  initPaymentSession: HyperTypes.initPaymentSheetParamTypes => HyperTypes.sendingToRNSDK,
  presentPaymentSheet: HyperTypes.sendingToRNSDK => promise<HyperTypes.responseFromNativeModule>,
  getCustomerSavedPaymentMethodData: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  confirmWithCustomerDefaultPaymentMethod: HyperTypes.sendingToRNSDK => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
}

let useHyper = () => {
  let (hyperVal, _) = React.useContext(HyperProvider.hyperProviderContext)

  let initPaymentSession = (initPaymentSheetParams: HyperTypes.initPaymentSheetParamTypes) => {
    Console.log2("initPaymentSession--------", hyperVal.customBackendUrl)
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

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        let val = arg->HyperTypes.savedPMToObj
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
  {
    initPaymentSession,
    presentPaymentSheet,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
  }
}
