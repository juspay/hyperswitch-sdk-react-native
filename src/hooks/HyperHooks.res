external parser: HyperTypes.sendingToRNSDK => Js.Json.t = "%identity"
type useHyperReturnType = {
  initPaymentSession: HyperTypes.initPaymentSheetParamTypes => HyperTypes.sendingToRNSDK,
  presentPaymentSheet: HyperTypes.sendingToRNSDK => promise<HyperTypes.responseFromNativeModule>,
  paymentMethodParams: unit => unit,
  initHeadless: HyperTypes.sendingToRNSDK => unit,
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
    Console.log2("hello world", hyperVal)

    let x: HyperTypes.sendingToRNSDK = {
      configuration: initPaymentSheetParams.configuration,
      publishableKey: hyperVal.publishableKey,
      clientSecret: initPaymentSheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
      // branding: initPaymentSheetParams.branding,
      // locale: initPaymentSheetParams.locale,
    }
    x
  }

  let presentPaymentSheet = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    Console.log("present payment sheet called!!!!!!!")
    let paySheetParamsJson = paySheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.responseFromNativeModule => unit, ~reject as _) => {
      let responseResolve = arg => {
        // Console.log(arg)
        let val = arg->HyperTypes.parseResponseFromNativeModule
        resolve(val)
      }
      HyperNativeModules.presentPaymentSheet(paySheetParamsJson, responseResolve)
    })
  }

  let initHeadless = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    let paymentSheetParams: HyperTypes.sendingToRNSDK = {
      publishableKey: hyperVal.publishableKey,
      clientSecret: paySheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
      // branding: initPaymentSheetParams.branding,
      // locale: initPaymentSheetParams.locale,
    }
    let paySheetParamsJson = paymentSheetParams->parser
    Console.log2("called at RN", paySheetParamsJson)
    HyperNativeModules.initHeadless(paySheetParamsJson, obj => {
      Console.log2("headless ok!!!!!", obj)
    })
  }
  let paymentMethodParams = () => {
    Console.log("hello world")
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    Console.log2("params test", paySheetParams)
    let paymentSheetParams: HyperTypes.sendingToRNSDK = {
      publishableKey: hyperVal.publishableKey,
      clientSecret: paySheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
      // branding: initPaymentSheetParams.branding,
      // locale: initPaymentSheetParams.locale,
    }
    let paySheetParamsJson = paymentSheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
      let responseResolve = arg => {
        Console.log2("inside promise========", arg)

        let val = arg->HyperTypes.savedPMToObj
        resolve(val)
      }
      HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
    })
  }
  let confirmWithCustomerDefaultPaymentMethod = (paySheetParams: HyperTypes.sendingToRNSDK) => {
    Console.log2("params test", paySheetParams)
    let paymentSheetParams: HyperTypes.sendingToRNSDK = {
      publishableKey: hyperVal.publishableKey,
      clientSecret: paySheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
      // branding: initPaymentSheetParams.branding,
      // locale: initPaymentSheetParams.locale,
    }
    let paySheetParamsJson = paymentSheetParams->parser

    Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
      let responseResolve = arg => {
        Console.log2("inside promise========", arg)

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
    paymentMethodParams,
    initHeadless,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
  }
}
