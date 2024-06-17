type responseFromNativeModule = {
  type_: string,
  code: string,
  message: string,
  status: string,
}
@scope("JSON") external parseResponse: Js.Dict.t<Js.Json.t> => responseFromNativeModule = "parse"

type customerConfiguration = {
  id: option<string>,
  ephemeralKeySecret: option<string>,
}
type fontConfig = {
  family: string,
  scale: float,
}
type placeholder = {
  cardNumber: string,
  expiryDate: string,
  cvv: string,
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
type address = {
  first_name: option<string>,
  last_name: option<string>,
  city: option<string>,
  country: option<string>,
  line1: option<string>,
  line2: option<string>,
  zip: option<string>,
  state: option<string>,
}
type phone = {
  number: option<string>,
  country_code: option<string>,
}
type addressDetails = {
  address: option<address>,
  email: option<string>,
  name: option<string>,
  phone: option<phone>,
}
type appearance = {
  font?: fontConfig,
  colors?: colors,
  shapes?: shapes,
  primaryButton?: primaryButton,
  themes?: string,
  locale?: string,
}
type applePayType = {}
type googlePayConfiguration = {
  // Making stripe compatible
  environment: string,
  countryCode: string,
  currencyCode: option<string>,
}
type configurationType = {
  allowsDelayedPaymentMethods?: bool,
  appearance?: appearance,
  shippingDetails?: option<addressDetails>,
  primaryButtonLabel?: option<string>,
  paymentSheetHeaderText?: option<string>,
  savedPaymentScreenHeaderText?: option<string>,
  // customer: option<customerConfiguration>,
  merchantDisplayName?: string,
  defaultBillingDetails?: option<addressDetails>,
  primaryButtonColor?: option<string>,
  allowsPaymentMethodsRequiringShippingAddress?: bool,
  displaySavedPaymentMethodsCheckbox?: bool,
  displaySavedPaymentMethods?: bool,
  placeholder?: placeholder,
  customer?: customerConfiguration,
  // themes: string,

  // Android Specific
  googlePay?: googlePayConfiguration,

  // IOS specific
}
type sendingToRNSDK = {
  configuration?: configurationType,
  publishableKey: string,
  clientSecret: string,
  \"type": string,
  from: string,
  branding?: string,
  locale?: string,
}

external parser: sendingToRNSDK => Js.Json.t = "%identity"
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
  appearance: option<appearance>,
  primaryButtonLabel?: string,
  branding?: string,
  locale?: string,
}
