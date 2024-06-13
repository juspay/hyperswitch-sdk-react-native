type responseFromNativeModule = {
  type_: string,
  code: string,
  message: string,
  status: string,
}
@scope("JSON") external parseResponse: Js.Dict.t<Js.Json.t> => responseFromNativeModule = "parse"

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
  configuration?: option<configurationType>,
  publishableKey: string,
  clientSecret: string,
  \"type": string,
  from: string,
  branding?: string,
  locale?: string,
}

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
  clientSecret: string,
  merchantDisplayName: string,
  customerId: option<string>,
  customerEphemeralKeySecret: option<string>,
  customFlow?: bool,
  style?: paymentSheetTheme,
  returnURL?: string,
  configuration: configurationType,
  // billingDetailsCollectionConfiguration?: BillingDetailsCollectionConfiguration,
  //defaultBillingDetails?: BillingDetails,
  //defaultShippingDetails?: AddressDetails,
  allowsDelayedPaymentMethods?: bool,
  appearance: option<appearanceType>,
  primaryButtonLabel?: string,
  branding?: string,
  locale?: string,
}
