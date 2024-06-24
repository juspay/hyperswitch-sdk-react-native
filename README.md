# HyperSwitch React Native SDK

[![npm version](https://img.shields.io/npm/v/@juspay-tech/hyperswitch-sdk-react-native
.svg?style=flat-square)](https://www.npmjs.com/package/@juspay-tech/hyperswitch-sdk-react-native
)
[![License](https://img.shields.io/github/license/HyperSwitch/HyperSwitch-react-native)](https://github.com/HyperSwitch/HyperSwitch-react-native/blob/master/LICENSE)

The HyperSwitch React Native SDK allows you to build delightful payment experiences in your native Android and iOS apps using React Native. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details.

## Getting started

Get started with our [📚 integration guides](https://docs.hyperswitch.io/hyperswitch-cloud/integration-guide) and [example project](https://github.com/aashu331998/hyperswitch-sdk-react-native/tree/main/example), or [📘 browse the SDK reference](https://docs.hyperswitch.io/learn-more/sdk-reference).


## Features

**Simplified Security**: We make it simple for you to collect sensitive data such as credit card numbers and remain [PCI compliant](https://docs.hyperswitch.io/hyperswitch-open-source/going-live/pci-compliance#pci-compliance-why-and-what). This means the sensitive data is sent directly to HyperSwitch instead of passing through your server.

**Wallets**: We provide a seamless integration with Apple Pay and Google Pay.

**Payment methods**: Accepting more [payment methods](https://HyperSwitch.com/docs/payments/payment-methods/overview) helps your business expand its global reach and improve checkout conversion.

**SCA-Ready**: The SDK automatically performs [3D Secure authentication](https://docs.hyperswitch.io/features/payment-flows-and-management/external-authentication-for-3ds#why-do-we-need-external-authentication) regulation in Europe.

**Native UI**: We provide native screens and elements to securely collect payment details on Android and iOS.


#### Recommended usage

If you're selling digital products or services within your app, (e.g. subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use the app store's in-app purchase APIs. See [Apple's](https://developer.apple.com/app-store/review/guidelines/#payments) and [Google's](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en&ref_topic=9857752) guidelines for more information. For all other scenarios you can use this SDK to process payments via HyperSwitch.

## Installation

```sh
yarn add @juspay-tech/hyperswitch-sdk-react-native

or
npm install @juspay-tech/hyperswitch-sdk-react-native

```

### Requirements

#### Peer Dependencies

- Please add the following peer dependencies to your app.
 

```tsx
yarn add react-native-code-push
yarn add react-native-gesture-handler
yarn add react-native-inappbrowser-reborn
yarn add react-native-klarna-inapp-sdk
yarn add react-native-safe-area-context
yarn add react-native-svg
yarn add @sentry/react-native

```


## Usage example

For a complete example, [visit our docs](https://docs.hyperswitch.io/hyperswitch-cloud/integration-guide/react-native/react-native-with-node-backend).

```tsx
// App.ts
import { HyperProvider } from '@juspay-tech/hyperswitch-sdk-react-native';

function App() {
  return (
    <HyperProvider
      publishableKey={publishableKey}>
      <PaymentScreen />
    </HyperProvider>
  );
}

// PaymentScreen.ts
import {useHyper } from '@juspay-tech/hyperswitch-sdk-react-native';

export default function PaymentScreen() {
  const { initPaymentSession, presentPaymentSheet } =useHyper();

  const setup = async () => {
    const paymentSheetParams = await initPaymentSession(paymentSheetProps);
  
  };

  useEffect(() => {
    setup();
  }, []);

  const checkout = async () => {
    const paymentSheetResponse = await presentPaymentSheet(paymentSheetParams);
  };

  return (
    <View>
      <Button title="Checkout" onPress={checkout} />
    </View>
  );
}
```

## HyperSwitch initialization

To initialize HyperSwitch in your React Native app, use the `HyperProvider` component in the root component of your application.
`HyperProvider` can accepts props like `publishableKey`, `customBackendUrl`. Only `publishableKey` is required.

```tsx
import { HyperProvider } from '@juspay-tech/hyperswitch-sdk-react-native';

function App() {
  const [publishableKey, setPublishableKey] = useState('');

  const fetchPublishableKey = async () => {
    const key = await fetchKey(); // fetch key from your server here
    setPublishableKey(key);
  };

  useEffect(() => {
    fetchPublishableKey();
  }, []);

  return (
    <HyperProvider
      publishableKey={publishableKey}
      customBackendUrl="YOUR_CUSTOM_BACKEND_URL"
    >
      // Your app code here
    </HyperProvider>
  );
}
```






