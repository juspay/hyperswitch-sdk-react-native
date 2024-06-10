# Hyperswitch React Native SDK

![NPM Version](https://img.shields.io/npm/v/%40juspay-tech%2Fhyperswitch-sdk-react-native)
![NPM License](https://img.shields.io/npm/l/%40juspay-tech%2Fhyperswitch-sdk-react-native)

The Hyperswitch React Native SDK allows you to build delightful payment experiences in your native Android and iOS apps using React Native. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details.

## Getting started

Get started with our [📚 integration guides](https://docs.hyperswitch.io/hyperswitch-cloud/integration-guide) and [example project](https://github.com/aashu331998/hyperswitch-sdk-react-native/tree/main/example), or [📘 browse the SDK reference](https://docs.hyperswitch.io/learn-more/sdk-reference).

## Features

**Simplified Security**: We make it simple for you to collect sensitive data such as credit card numbers and remain [PCI compliant](https://docs.hyperswitch.io/hyperswitch-open-source/going-live/pci-compliance#pci-compliance-why-and-what). This means the sensitive data is sent directly to Hyperswitch instead of passing through your server.

**Wallets**: We provide a seamless integration with Apple Pay and Google Pay.

**Payment methods**: Accepting more [payment methods](https://Hyperswitch.com/docs/payments/payment-methods/overview) helps your business expand its global reach and improve checkout conversion.

**SCA-Ready**: The SDK automatically performs [3D Secure authentication](https://docs.hyperswitch.io/features/payment-flows-and-management/external-authentication-for-3ds#why-do-we-need-external-authentication) regulation in Europe.

**Native UI**: We provide native screens and elements to securely collect payment details on Android and iOS.

#### Recommended usage

If you're selling digital products or services within your app, (e.g. subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use the app store's in-app purchase APIs. See [Apple's](https://developer.apple.com/app-store/review/guidelines/#payments) and [Google's](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en&ref_topic=9857752) guidelines for more information. For all other scenarios you can use this SDK to process payments via Hyperswitch.

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
yarn add react-native-safe-area-context
yarn add react-native-svg
yarn add @sentry/react-native
yarn add react-native-pager-view
yarn add react-native-screens
yarn add react-native-hyperswitch-kount
yarn add react-native-klarna-inapp-sdk

```

**Note:** If you encounter any issues with `react-native-klarna-inapp-sdk`, please remove it from the dependencies.

## iOS Only

Run pod install in iOS folder

```bash

pod install

```

## Android Only

In the Android Folder inside strings.xml file(android/app/src/main/res/values/strings.xml) add the below line

```xml
<string name="CodePushDeploymentKey">HyperswitchRNDemo</string>
```

In the android/settings.gradle file, add the following line to link react-native-code-push:

```gradle
include(":react-native-code-push");

project(":react-native-code-push").projectDir = new File(
  rootProject.projectDir,
  "../node_modules/react-native-code-push/android/app"
);
```

In the android/settings.gradle file, add the following line to link `react-native-code-push:`

In the Android folder inside main (android/app/src/main/AndroidManifest.xml) add these below lines to the existing code.

```

<manifest xmlns:tools="http://schemas.android.com/tools">
  <application
    tools:replace="android:allowBackup">
    <!-- Other existing elements in the <application> tag -->
  </application>
</manifest>

```

## Usage example

For a complete example, [visit our docs](https://docs.hyperswitch.io/hyperswitch-cloud/integration-guide/react-native/react-native-with-node-backend).

## Setup Server
```
const express = require('express');
const app = express();
// Replace if using a different env file or config
const env = require('dotenv').config({path: './.env'});

const hyper = require('@juspay-tech/hyperswitch-node')(getSecretKey());
// Define a port to listen on
const PORT = process.env.PORT || 4242;

function getSecretKey() {
  return process.env.HYPERSWITCH_SECRET_KEY;
}

function getPublishableKey() {
  return process.env.HYPERSWITCH_PUBLISHABLE_KEY;
}

app.get('/get-config', async (req, res) => {
  try {
    res.send({
      publishableKey: getPublishableKey(),
    });
  } catch (err) {
    return res.status(400).send({
      error: {
        message: err.message,
      },
    });
  }
});

app.post('/create-payment', async (req, res) => {
  try {
    const paymentIntent = await hyper.paymentIntents.create({
      amount: 2999,
      currency: 'USD',
      customer_id: 'shivam',
      profile_id: 'pro_neyxCYTLoxgPBD2pQZYB',
    });

    console.log('-- paymentIntent', paymentIntent);
    // Send publishable key and PaymentIntent details to client
    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (err) {
    return res.status(400).send({
      error: {
        message: err.message,
      },
    });
  }
});

app.listen(PORT, () => {
  console.log(`Hyperswitch Server is running on http://localhost:${PORT}`);
});

```


## 1.1 Add `HyperProvider` to your React Native app

Use `HyperProvider` to ensure that you stay PCI compliant by sending payment details directly to Hyperswitch server.

```tsx
import { HyperProvider } from '@juspay-tech/hyperswitch-sdk-react-native';
```

## 1.2 Use `HyperProvider`

To initialize Hyperswitch in your React Native app, wrap your payment screen with the HyperProvider component. Only the API publishable key in publishableKey is required. The following example shows how to initialize Hyperswitch using the HyperProvider component.

```tsx
import { HyperProvider } from '@juspay-tech/hyperswitch-sdk-react-native';

function App() {
  return (
    <HyperProvider publishableKey="YOUR_PUBLISHABLE_KEY">
      // Your app code here
    </HyperProvider>
  );
}
```

## 2. Complete the checkout on the client

## 2.1 import useHyper to your checkout page

In the checkout of your app, import `useHyper()` hook

```tsx
import { useHyper } from '@juspay-tech/hyperswitch-sdk-react-native';
```

## 2.2 Fetch the PaymentIntent client Secret

Make a network request to the backend endpoint you created in the previous step. The clientSecret returned by your endpoint is used to complete the payment.

```tsx
const fetchPaymentParams = async () => {
  const response = await fetch(`${API_URL}/create-payment`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ items: [{ id: 'xl-tshirt' }], country: 'US' }),
  });
  const val = await response.json();
  return val;
};
```

## 2.3 Collect Payment details

Call initPaymentSession from the useHyper hook to customise paymentsheet, billing or shipping addresses and initialize paymentsheet

```tsx
const { initPaymentSession, presentPaymentSheet } = useHyper();
const [paymentSession,setPaymentSession]=React.useState(null);
const initializePaymentSheet = async () => {
const { clientSecret } = await fetchPaymentParams();

const customAppearance = {
      colors: {
          light: {
          primary: "#00FF00",
          },
      },
    };
const params={
    merchantDisplayName: "Example, Inc.",
    clientSecret: clientSecret,
    appearance: customAppearance,
}
const paymentSession = await initPaymentSession(params);
setPaymentSession(_=>paymentSession)
};

useEffect(() => {
initializePaymentSheet();
}, []);
```

## 2.4 Handle Payment Response

To display the Payment Sheet, integrate a "Pay Now" button within the checkout page, which, when clicked, invokes the `presentPaymentSheet()` function. This function will return an asynchronous payment response with various payment status.

```tsx
  const openPaymentSheet = async () => {
    console.log("Payment Session Params --> ", paymentSession);
    const status = await presentPaymentSheet(paymentSession);
    console.log('presentPaymentSheet response: ', status);
    const {error, paymentOption} = status;
    if (error) {
      switch (error.code) {
        case 'cancelled':
          console.log('cancelled', `PaymentSheet was closed`);
          break;
        case 'failed':
          console.log('failed', `Payment failed`);
          break;
        default:
          console.log('status not captured', 'Please check the integration');
          break;
      }

      console.log(`Error code: ${error.code}`, error.message);
    } else if (paymentOption) {
      switch (paymentOption.label) {
        case 'succeeded':
          console.log('succeeded', `Your order is succeeded`);
          break;
        case 'requires_capture':
          console.log('requires_capture', `Your order is requires_capture`);
          break;
        default:
          console.log('status not captured', 'Please check the integration');
          break;
      }
    } else {
      console.log('Something went wrong', 'Please check the integration');
    }
  };


return (
  <Screen>
    <Button variant="primary" title="Checkout" onPress={openPaymentSheet} />
  </Screen>
);
```

Congratulations! Now that you have integrated the payment sheet.

## Example
To test the example app located in the ./example/ directory of your repository, you can follow these steps:

### 1. Navigate to the Project Directory
Open a terminal and change to the ./example/ directory:


```bash
cd ./example/
```

### 2. Install Dependencies
Ensure you have all necessary dependencies installed. This usually involves running:

```bash
npm install
```
or if you’re using Yarn:

```bash
yarn install
```

4. Run the Application
To test the app, you can start it on an emulator or a physical device.

```bash
npm start
```
or if you’re using Yarn:
```bash
yarn start
```
