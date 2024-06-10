/* TypeScript file generated from HyperTypes.res by genType. */

/* eslint-disable */
/* tslint:disable */

export type savedPaymentMethodType = {
  readonly paymentMethodType: string; 
  readonly isDefaultPaymentMethod: boolean; 
  readonly paymentToken: string; 
  readonly cardScheme: string; 
  readonly name: string; 
  readonly expiryDate: string; 
  readonly cardNumber: string; 
  readonly nickName: string; 
  readonly cardHolderName: string; 
  readonly requiresCVV: boolean; 
  readonly created: string; 
  readonly lastUsedAt: string; 
  readonly walletType?: string
};

export type responseFromNativeModule = {
  readonly type_: string; 
  readonly code: string; 
  readonly message: string; 
  readonly status: string
};

export type headlessConfirmResponseType = { readonly message: string; readonly type_: string };

export type customerConfiguration = { readonly id: (undefined | string); readonly ephemeralKeySecret: (undefined | string) };

export type fontConfig = { readonly family?: string; readonly scale?: number };

export type placeholder = {
  readonly cardNumber: string; 
  readonly expiryDate: string; 
  readonly cvv: string
};

export type offset = { readonly x: number; readonly y: number };

export type shadowConfig = {
  readonly color: string; 
  readonly opacity: number; 
  readonly offset: offset; 
  readonly blurRadius: number
};

export type shapes = {
  readonly borderRadius?: number; 
  readonly borderWidth?: number; 
  readonly shadow?: shadowConfig
};

export type color = {
  readonly primary?: (undefined | string); 
  readonly background?: (undefined | string); 
  readonly componentBackground?: (undefined | string); 
  readonly componentBorder?: (undefined | string); 
  readonly componentDivider?: (undefined | string); 
  readonly componentText?: (undefined | string); 
  readonly primaryText?: (undefined | string); 
  readonly secondaryText?: (undefined | string); 
  readonly placeholderText?: (undefined | string); 
  readonly icon?: (undefined | string); 
  readonly error?: (undefined | string)
};

export type colors = { readonly light?: color; readonly dark?: color };

export type primaryButton = {
  readonly font?: fontConfig; 
  readonly colors?: colors; 
  readonly shapes?: shapes
};

export type address = {
  readonly first_name: (undefined | string); 
  readonly last_name: (undefined | string); 
  readonly city: (undefined | string); 
  readonly country: (undefined | string); 
  readonly line1: (undefined | string); 
  readonly line2: (undefined | string); 
  readonly zip: (undefined | string); 
  readonly state: (undefined | string)
};

export type phone = { readonly number: (undefined | string); readonly country_code: (undefined | string) };

export type addressDetails = {
  readonly address: (undefined | address); 
  readonly email: (undefined | string); 
  readonly name: (undefined | string); 
  readonly phone: (undefined | phone)
};

export type appearance = {
  readonly font?: fontConfig; 
  readonly colors?: colors; 
  readonly shapes?: shapes; 
  readonly primaryButton?: primaryButton; 
  readonly themes?: string; 
  readonly locale?: string
};

export type applePayType = {};

export type googlePayConfiguration = {
  readonly environment: string; 
  readonly countryCode: string; 
  readonly currencyCode: (undefined | string)
};

export type configurationType = {
  readonly allowsDelayedPaymentMethods?: boolean; 
  readonly appearance?: appearance; 
  readonly shippingDetails?: (undefined | addressDetails); 
  readonly primaryButtonLabel?: (undefined | string); 
  readonly paymentSheetHeaderText?: (undefined | string); 
  readonly savedPaymentScreenHeaderText?: (undefined | string); 
  readonly merchantDisplayName?: string; 
  readonly defaultBillingDetails?: (undefined | addressDetails); 
  readonly primaryButtonColor?: (undefined | string); 
  readonly allowsPaymentMethodsRequiringShippingAddress?: boolean; 
  readonly displaySavedPaymentMethodsCheckbox?: boolean; 
  readonly displaySavedPaymentMethods?: boolean; 
  readonly placeholder?: placeholder; 
  readonly customer?: customerConfiguration; 
  readonly googlePay?: googlePayConfiguration
};

export type sessionParams = {
  readonly configuration?: configurationType; 
  readonly customBackendUrl?: (undefined | string); 
  readonly publishableKey: string; 
  readonly clientSecret: string; 
  readonly type: string; 
  readonly from: string; 
  readonly branding?: string; 
  readonly locale?: string
};

export type paymentSheetTheme = 
    "Automatic"
  | "AlwaysLight"
  | "AlwaysDark"
  | "FlatMinimal"
  | "Minimal";

export type hyperProviderTypes = { readonly publishableKey: string; readonly customBackendUrl?: (undefined | string) };

export type initPaymentSheetParamTypes = {
  readonly clientSecret: string; 
  readonly merchantDisplayName?: string; 
  readonly customerId?: (undefined | string); 
  readonly customerEphemeralKeySecret?: (undefined | string); 
  readonly customFlow?: boolean; 
  readonly style?: paymentSheetTheme; 
  readonly returnURL?: string; 
  readonly configuration?: configurationType; 
  readonly allowsDelayedPaymentMethods?: boolean; 
  readonly appearance?: appearance; 
  readonly primaryButtonLabel?: string; 
  readonly branding?: string; 
  readonly locale?: string
};
