////////////////----open RN Code----//////////////////
type customer = {
  id: option<string>,
  ephemeralKeySecret: option<string>,
}
type fontConfig = {
  family: string,
  scale: float,
}

type offset = {
  x: float,
  y: float,
}
type globalColorConfig = {}
type indirectColorType = {
  light: globalColorConfig,
  dark: globalColorConfig,
}
type shadowConfig = {
  color: string,
  opacity: float,
  offset: offset,
  blurRadius: float,
}
type shapes = {
  borderRadius: float,
  borderWidth: float,
  shadow: shadowConfig,
}
type colors = DirectColor(globalColorConfig) | IndirectColor(indirectColorType)
type primaryButton = {
  font: fontConfig,
  colors: colors,
  shapes: shapes,
}
type appearanceType = {
  font?: fontConfig,
  colors?: colors,
  shapes?: shapes,
  primaryButton?: primaryButton,
  themes?: string,
  locale?: string,
}
type applePayType = {}
type googlePayType = {
  // Making stripe compatible
  testEnv: bool,
  merchantCountryCode: string,
  currencyCode: string,
}
type configurationType = {
  appearance?: appearanceType,
  googlePay?: googlePayType,
  customer?: customer,
}
type sendingToOrca = {
  configuration: option<configurationType>,
  publishableKey: string,
  clientSecret: string,
  \"type": string,
  from: string,
  branding: option<string>,
  locale: option<string>,
}

type responseFromOrca = {
  type_: string,
  code: string,
  message: string,
  status: string,
}

@scope("JSON") external parseResponse: Js.Dict.t<Js.Json.t> => responseFromOrca = "parse"

external parser: sendingToOrca => Js.Json.t = "%identity"
type paymentSheetTheme = [
  | #Automatic
  | #AlwaysLight
  | #AlwaysDark
  | #FlatMinimal
  | #Minimal
]

type hyperProviderTypes = {
  // clientsecret: clientsecret,
  publishableKey: string,
  // customerId: customerId,
  // appearance: option<AppType.appearanceType>,
  // applePay: option<applePayType>,
  // googlePay: option<googlePayType>,
  // allowsDelayedPaymentMethods: bool,
  // primaryButtonLabel: string,
  merchantIdentifier: string,
  stripeAccountId: string,
  threeDSecureParams: string,
  urlScheme: string,
  setReturnUrlSchemeOnAndroid: string,
  // theme: paymentSheetTheme,
  // customerEphemeralKeySecret: customerEphemeralKeySecret,
}
type initPaymentSheetParamTypes = {
  paymentIntentClientSecret: string,
  merchantDisplayName: string,
  customerId: option<string>,
  customerEphemeralKeySecret: option<string>,
  customFlow?: bool,
  googlePay: option<googlePayType>,
  applePay: option<applePayType>,
  style?: paymentSheetTheme,
  returnURL?: string,
  // billingDetailsCollectionConfiguration?: BillingDetailsCollectionConfiguration,
  //defaultBillingDetails?: BillingDetails,
  //defaultShippingDetails?: AddressDetails,
  allowsDelayedPaymentMethods?: bool,
  appearance: option<appearanceType>,
  primaryButtonLabel?: string,
  branding?: string,
  locale?: string,
}
let setData = (~providerState: hyperProviderTypes, ~initState: initPaymentSheetParamTypes) => {
  let themes = switch initState.style {
  | Some(style) =>
    switch style {
    | #Automatic => ""
    | #AlwaysLight => "Light"
    | #AlwaysDark => "Dark"
    | #FlatMinimal => "FlatMinimal"
    | #Minimal => "Minimal"
    }
  | None => ""
  }

  let appearance = initState.appearance->Belt.Option.getWithDefault({})
  {
    configuration: Some({
      appearance: {...appearance, themes},
      googlePay: ?initState.googlePay,
      customer: {
        id: initState.customerId,
        ephemeralKeySecret: initState.customerEphemeralKeySecret,
      },
    }),
    publishableKey: providerState.publishableKey,
    clientSecret: initState.paymentIntentClientSecret,
    \"type": "payment",
    from: "rn",
    branding: initState.branding,
    locale: initState.locale,
  }->parser
}

// let failedPaymentSheetRes: responseFromOrca => FunctionTypes.presentPaymentSheetReturnType = error => {
//   error: {
//     code: error.code == "" ? error.status : error.code,
//     message: error.message == "" ? error.status : error.message,
//   },
// }

// let successPaymentSheetRes: responseFromOrca => FunctionTypes.presentPaymentSheetReturnType = val => {
//   paymentOption: {
//     label: val.status,
//     image: val.status,
//   },
// }
