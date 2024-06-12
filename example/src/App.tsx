import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import {
  HyperProvider,
  presentPaymentSheet,
} from 'hyperswitch-sdk-react-native';

export default function App() {
  const fetchPaymentParams = async () => {
    const response = await fetch(
      Platform.OS == 'ios'
        ? `http://localhost:4242/create-payment-intent`
        : `http://10.0.2.2:4242/create-payment-intent`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ items: [{ id: 'xl-tshirt' }] }),
      }
    );
    const val = await response.json();

    return val;
  };

  const initializePaymentSheet = async () => {
    const { clientSecret, customerId, ephemeralKey } =
      await fetchPaymentParams();

    const publishableKey = 'pk_snd_3b33cd9404234113804aa1accaabe22f';

    console.log('clientSecret', clientSecret);
    const customAppearance = {
      colors: {
        light: {
          // primary: '#00FF00',
          // background: '#00FF00',
          componentBackground: 'grey',
          // componentBorder: '#ff0000',
          // secondaryText: '#00FF00',
          // componentText: '#00FF00',
          // placeholderText: '#0000FF',
        },
      },
      shapes: {
        borderRadius: 5,
        borderWidth: 0,
      },
      primaryButton: {
        shapes: {
          borderRadius: 0,
          borderWidth: 0,
        },
        colors: {
          light: {
            background: '#000',
            text: '#FFF',
            border: '#000',
          },
        },
      },
      locale: 'en',
    };
    const googlePayParams = {
      environment: 'test',
      countryCode: 'US',
      currencyCode: 'USD',
    };
    const obj = {
      paymentIntentClientSecret: clientSecret,
      appearance: customAppearance,
      googlePay: googlePayParams,
      // style: 'AlwaysDark',
      customerId: customerId,
      customerEphemeralKeySecret: ephemeralKey,
    };

    let finalObj = {
      configuration: {
        appearance: customAppearance,
        googlePay: googlePayParams,
        customer: {
          id: customerId,
          ephemeralKeySecret: ephemeralKey,
        },
      },
      publishableKey: publishableKey,
      clientSecret: clientSecret,
      type: 'payment',
      from: 'rn',
      // branding: initState.branding,
      // locale: initState.locale,
    };
    presentPaymentSheet(finalObj, () => {
      console.log('recieved request obj');
    });
  };

  React.useEffect(() => {
    console.log('called');
    // presentPaymentSheet({ h: 'h' }, () => {
    //   console.log('called');
    // });
    initializePaymentSheet();
  }, []);
  return (
    <View style={styles.container}>
      <HyperProvider />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
