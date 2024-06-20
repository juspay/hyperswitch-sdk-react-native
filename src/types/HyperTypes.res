@genType
type savedPaymentMethodType = {
  paymentMethodType: string,
  isDefaultPaymentMethod: bool,
  paymentToken: string,
  cardScheme: string,
  name: string,
  expiryDate: string,
  cardNumber: string,
  nickName: string,
  cardHolderName: string,
  requiresCVV: bool,
  created: string,
  lastUsedAt: string,
  walletType?: string,
}

@genType
type responseFromNativeModule = {
  type_: string,
  code: string,
  message: string,
  status: string,
}

@genType
type headlessConfirmResponseType = {
  message: string,
  type_: string,
}
@scope("JSON")
external parseResponseFromNativeModule: Js.Dict.t<Js.Json.t> => responseFromNativeModule = "parse"

external parseConfirmResponse: Js.Dict.t<Js.Json.t> => headlessConfirmResponseType = "%identity"

external parseJson: Js.Dict.t<Js.Json.t> => JSON.t = "%identity"

external toJsonArray: 'a => array<Js.Json.t> = "%identity"

// external cardDictToObj: Js.Dict.t<Js.Json.t> => savedCard = "%identity"
external savedPMToObj: option<Js.Json.t> => savedPaymentMethodType = "%identity"

external savedPMToArrObj: array<option<Js.Json.t>> => array<savedPaymentMethodType> = "%identity"

// let paymentMethodItemToObjMapper = pmItem => {
//   let val = pmItem->parseJson
//   let pmDict = val->JSON.Decode.object->Option.getOr(Dict.make())
//   let pMType =
//     pmDict->Dict.get("paymentMethodType")->Option.getExn->JSON.Decode.string->Option.getOr("")

//   let pmObj = {...pmDict->savedPMToObj, paymentMethodType: pMType}
//   pmObj
// }
@genType
type customerConfiguration = {
  id: option<string>,
  ephemeralKeySecret: option<string>,
}
@genType
type fontConfig = {
  family?: string,
  scale?: float,
}
@genType
type placeholder = {
  cardNumber: string,
  expiryDate: string,
  cvv: string,
}
@genType
type offset = {
  x: float,
  y: float,
}

@genType
type shadowConfig = {
  color: string,
  opacity: float,
  offset: offset,
  blurRadius: float,
}
@genType
type shapes = {
  borderRadius?: float,
  borderWidth?: float,
  shadow?: shadowConfig,
}

@genType
type color = {
  primary?: option<string>,
  background?: option<string>,
  componentBackground?: option<string>,
  componentBorder?: option<string>,
  componentDivider?: option<string>,
  componentText?: option<string>,
  primaryText?: option<string>,
  secondaryText?: option<string>,
  placeholderText?: option<string>,
  icon?: option<string>,
  error?: option<string>,
}
@genType
type colors = {
  light?: color,
  dark?: color,
}
@genType
type primaryButton = {
  font?: fontConfig,
  colors?: colors,
  shapes?: shapes,
}
@genType
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
@genType
type phone = {
  number: option<string>,
  country_code: option<string>,
}
@genType
type addressDetails = {
  address: option<address>,
  email: option<string>,
  name: option<string>,
  phone: option<phone>,
}
@genType
type appearance = {
  font?: fontConfig,
  colors?: colors,
  shapes?: shapes,
  primaryButton?: primaryButton,
  themes?: string,
  locale?: string,
}
@genType
type applePayType = {}
@genType
type googlePayConfiguration = {
  // Making stripe compatible
  environment: string,
  countryCode: string,
  currencyCode: option<string>,
}
@genType
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
@genType
type sessionParams = {
  configuration?: configurationType,
  customBackendUrl?: option<string>,
  publishableKey: string,
  clientSecret: string,
  \"type": string,
  from: string,
  branding?: string,
  locale?: string,
}

external parser: sessionParams => Js.Json.t = "%identity"
type paymentSheetTheme = [
  | #Automatic
  | #AlwaysLight
  | #AlwaysDark
  | #FlatMinimal
  | #Minimal
]
@genType
type hyperProviderTypes = {
  // clientsecret: clientsecret,
  publishableKey: string,
  customBackendUrl?: option<string>,
  // customerId: customerId,
  // appearance: option<AppType.appearanceType>,
  // applePay: option<applePayType>,
  // googlePay: option<googlePayType>,
  // allowsDelayedPaymentMethods: bool,
  // primaryButtonLabel: string,
  // merchantIdentifier: string,
  // stripeAccountId: string,
  // threeDSecureParams: string,
  // urlScheme: string,
  // setReturnUrlSchemeOnAndroid: string,
  // theme: paymentSheetTheme,
  // customerEphemeralKeySecret: customerEphemeralKeySecret,
}
@genType
type initPaymentSheetParamTypes = {
  clientSecret: string,
  merchantDisplayName?: string,
  customerId?: option<string>,
  customerEphemeralKeySecret?: option<string>,
  customFlow?: bool,
  style?: paymentSheetTheme,
  returnURL?: string,
  configuration?: configurationType,
  // billingDetailsCollectionConfiguration?: BillingDetailsCollectionConfiguration,
  //defaultBillingDetails?: BillingDetails,
  //defaultShippingDetails?: AddressDetails,
  allowsDelayedPaymentMethods?: bool,
  appearance?: appearance,
  primaryButtonLabel?: string,
  branding?: string,
  locale?: string,
}
